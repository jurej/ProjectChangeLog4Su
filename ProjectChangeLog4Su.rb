require 'sketchup.rb'
require 'extensions.rb'

module  ProjectChangeLog4Su
  module ProjectChangeLog
    unless file_loaded?(__FILE__)
      ex = SketchupExtension.new('Project Change Log', 'ProjectChangeLog/main')
      ex.description = 'Prompts for a commit message on save and stores it in a text file.'
      ex.version     = '1.0.0'
      ex.copyright   = 'Jure Judež, 2025'
      ex.creator     = 'Jure Judež'
      Sketchup.register_extension(ex, true)
      file_loaded(__FILE__)
    end
  end
end