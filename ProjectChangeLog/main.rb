# Copyright:: Copyright 2024
# License:: The MIT License (MIT)

module ProjectChangeLog4Su
  module ProjectChangeLog

    # ------------------------------------------------------------------------
    # OBSERVERS
    # ------------------------------------------------------------------------

    # We use the AppObserver to attach our ModelObserver to every model 
    # that is created or opened[cite: 102, 106].
    class MyAppObserver < Sketchup::AppObserver
      def onNewModel(model)
        model.add_observer(MyModelObserver.new)
      end

      def onOpenModel(model)
        model.add_observer(MyModelObserver.new)
      end
    end

    # The ModelObserver reacts to model events. We specifically want onPostSaveModel
    # so we know the file has been written to disk successfully[cite: 1, 30].
    class MyModelObserver < Sketchup::ModelObserver
      def onPostSaveModel(model)
        # Trigger the log prompt
        ProjectChangeLog4Su::ProjectChangeLog.prompt_for_log(model)
      end
    end

    # ------------------------------------------------------------------------
    # CORE FUNCTIONALITY
    # ------------------------------------------------------------------------

    def self.get_log_path(model)
      skp_path = model.path
      return nil if skp_path.empty? # Model hasn't been saved yet
      
      # Create a .txt path based on the .skp path
      return skp_path.gsub(".skp", "_changelog.txt")
    end

    # Pop up the dialog to ask what changed
    def self.prompt_for_log(model)
      log_path = get_log_path(model)
      return unless log_path # Safety check

      dialog = UI::HtmlDialog.new(
        {
          :dialog_title => "Commit Changes",
          :preferences_key => "com.projectchangelog4su.commit_log_input",
          :scrollable => false,
          :resizable => true,
          :width => 400,
          :height => 350,
          :style => UI::HtmlDialog::STYLE_DIALOG
        })

      html = <<-HTML
        <!DOCTYPE html>
        <html>
        <head>
          <style>
            body { font-family: sans-serif; padding: 10px; }
            textarea { width: 100%; height: 150px; margin-bottom: 10px; box-sizing: border-box; }
            button { padding: 8px 15px; cursor: pointer; background: #0078d7; color: white; border: none; border-radius: 3px;}
            button:hover { background: #005a9e; }
            .cancel { background: #ddd; color: #333; margin-right: 10px; }
            .cancel:hover { background: #ccc; }
          </style>
        </head>
        <body>
          <h3>What changed in this version?</h3>
          <textarea id="msg" placeholder="- Added roof details&#10;- Fixed layer organization"></textarea>
          <div style="text-align: right;">
            <button class="cancel" onclick="window.location='skp:cancel'">Skip</button>
            <button onclick="submitLog()">Log Change</button>
          </div>
          <script>
            function submitLog() {
              var txt = document.getElementById('msg').value;
              window.location = 'skp:submit_log@' + encodeURIComponent(txt);
            }
          </script>
        </body>
        </html>
      HTML

      dialog.set_html(html)
      
      dialog.add_action_callback("submit_log") do |action_context, msg|
        timestamp = Time.now.strftime("%Y-%m-%d %H:%M:%S")
        username = ENV['USERNAME'] || ENV['USER'] || 'Unknown'
        entry = "\n[#{timestamp}] User: #{username} - Save Commit:\n#{msg}\n----------------------------------------"
        
        # Append to file
        File.open(log_path, 'a') { |file| file.write(entry) }
        puts "Log updated at #{log_path}"
        dialog.close
      end

      dialog.add_action_callback("cancel") do |action_context|
        dialog.close
      end

      dialog.center
      dialog.show
    end

    # Viewer/Editor for the log
    def self.open_log_viewer
      model = Sketchup.active_model
      log_path = get_log_path(model)

      unless log_path && File.exist?(log_path)
        UI.messagebox("No log file found. Save the model to start a log.")
        return
      end

      content = File.read(log_path)

      dialog = UI::HtmlDialog.new(
        {
          :dialog_title => "Project Change Log",
          :preferences_key => "com.genai.commit_log_viewer",
          :resizable => true,
          :width => 600,
          :height => 500,
          :style => UI::HtmlDialog::STYLE_WINDOW
        })

      # Escape backslashes for JS string safety
      safe_content = content.gsub("\\", "\\\\").gsub("`", "\\`").gsub("$", "\\$")

      html = <<-HTML
        <!DOCTYPE html>
        <html>
        <head>
          <style>
            body { font-family: monospace; padding: 10px; display: flex; flex-direction: column; height: 90vh; }
            textarea { flex: 1; width: 100%; box-sizing: border-box; padding: 10px; font-family: monospace; }
            button { margin-top: 10px; padding: 10px; background: #28a745; color: white; border: none; cursor: pointer; align-self: flex-end; }
          </style>
        </head>
        <body>
          <h3>Project History (#{File.basename(model.path)})</h3>
          <textarea id="full_log">#{safe_content}</textarea>
          <button onclick="saveChanges()">Save Edits</button>
          <script>
            function saveChanges() {
              var txt = document.getElementById('full_log').value;
              sketchup.save_full_log(txt);
            }
          </script>
        </body>
        </html>
      HTML

      dialog.set_html(html)

      dialog.add_action_callback("save_full_log") do |action_context, new_content|
        File.open(log_path, 'w') { |file| file.write(new_content) }
        UI.messagebox("Log updated successfully.")
      end

      dialog.center
      dialog.show
    end

    # ------------------------------------------------------------------------
    # INITIALIZATION
    # ------------------------------------------------------------------------
    unless file_loaded?(__FILE__)
      # Add Menu Item
      menu = UI.menu('Plugins')
      menu.add_item('View Project Change Log') {
        self.open_log_viewer
      }

      # Attach the AppObserver to watch for application events
      Sketchup.add_observer(MyAppObserver.new)

      # Attach ModelObserver to the currently active model immediately
      # (Because onNewModel/onOpenModel won't fire for the model already open when SketchUp starts)
      Sketchup.active_model.add_observer(MyModelObserver.new)

      file_loaded(__FILE__)
    end

  end
end