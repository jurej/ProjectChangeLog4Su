# ProjectChangeLog4Su

A SketchUp plugin that automatically prompts you to log changes every time you save your model, creating a comprehensive project history with timestamps and usernames.

## Features

- 📝 **Automatic Change Prompts** - Dialog appears automatically after each save
- 👤 **User Tracking** - Logs username with each commit for multi-user projects
- ⏰ **Timestamped Entries** - Every change is recorded with date and time
- 🚀 **Push to Master** - Save working versions to a master file (like git push) for Layout compatibility
- ⚙️ **Settings Dialog** - Configure master file path and preferences
- 📖 **Change Log Viewer** - View and edit your entire project history
- 💾 **Persistent Storage** - Logs saved as `.txt` files alongside your `.skp` files
- ✏️ **Editable History** - Modify past entries through the built-in viewer

## Installation

### Method 1: Extension Warehouse (Recommended)
*Coming soon*

### Method 2: Manual Installation

1. **Download the plugin**
   - Download the latest release from the [Releases](../../releases) page
   - Or clone this repository

2. **Locate SketchUp Plugins folder**
   - Windows: `C:\Users\[YourUsername]\AppData\Roaming\SketchUp\SketchUp [Version]\SketchUp\Plugins\`
   - macOS: `~/Library/Application Support/SketchUp [Version]/SketchUp/Plugins/`

3. **Install files**
   - Copy the entire `ProjectChangeLog4Su` folder to your Plugins directory
   - Copy `ProjectChangeLog4Su.rb` to your Plugins directory

4. **Restart SketchUp**
   - The plugin will load automatically on startup

## Usage

### Logging Changes

1. **Work on your model** as usual
2. **Save your model** (File > Save or Ctrl+S / Cmd+S)
3. **Change log dialog appears** automatically
4. **Enter your changes** in the text area
   ```
   - Added roof structure
   - Updated materials on walls
   - Fixed layer organization
   ```
5. **Click "Log Change"** to save the entry
   - Or click "Skip" if you don't want to log this save

> [!NOTE]
> If you have **autosave enabled** in SketchUp's preferences, the commit log dialog will also appear after each autosave event. You can click "Skip" for autosaves and only log intentional save points, or you can use it to create automatic checkpoints at regular intervals.

### Log Entry Format

Each entry includes:
```
[2025-11-25 11:53:03] User: JohnDoe - Save Commit:
- Added new windows to facade
- Updated door placements
----------------------------------------
```

## Example Log

```
[2025-11-20 09:15:23] User: Alice - Save Commit:
- Initial model setup
- Created basic floor plan
----------------------------------------

[2025-11-20 14:32:10] User: Alice - Save Commit:
- Added exterior walls
- Placed windows and doors
----------------------------------------

[2025-11-21 10:05:45] User: Bob - Save Commit:
- Added roof structure
- Created chimney detail
----------------------------------------

[2025-11-21 15:20:33] User: Alice - Save Commit:
- Applied materials to walls
- Fixed alignment issues
----------------------------------------
```

## Benefits

- **Track Progress** - See exactly what was done and when
- **Team Collaboration** - Know who made which changes in shared projects
- **Project Documentation** - Automatic documentation of your modeling process
- **Version Context** - Understand the evolution of your design
- **Client Communication** - Share progress updates easily

## Compatibility

- **SketchUp Version**: 2017 and later
- **Operating System**: Windows and macOS
- **Ruby Version**: 2.x and later

## Support

Having issues? Please [open an issue](../../issues) on GitHub with:
- SketchUp version
- Operating system
- Description of the problem
- Steps to reproduce

## License

Copyright © 2024

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## Changelog

### Version 1.1.0 (2025-11-25)
- Added Push to Master feature
- Added Settings dialog for master file configuration
- Refactored dialogs with Trimble Modus design system
- Fixed duplicate dialog issue with singleton observers
- Improved UI consistency and styling

### Version 1.0.0 (2025-11-25)
- Initial release
- Automatic change log prompts on save
- Username tracking in log entries
- Project history viewer and editor
- Timestamped entries

## Author

Created with ❤️ for the SketchUp community

---

**Star this repository** if you find it useful! ⭐
