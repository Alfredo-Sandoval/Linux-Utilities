# Linux Utilities

Simple shell scripts to add useful features to Linux.


### Copy as Path

Adds Windows-style "Copy as Path" functionality to Ubuntu:
- Right-click on files in Nautilus to copy their path
- Use Shift+Ctrl+C keyboard shortcut
- Use `copypath` command in terminal

## Installation

```bash
git clone https://github.com/Alfredo-Sandoval/Linux-Utilities.git
cd Linux-Utilities
./ubuntu-copy-as-path.sh
```

## Usage

### Copy as Path

- **File Manager**: Right-click → "Copy as Path"
- **Keyboard**: Select file(s) → Shift+Ctrl+C
- **Terminal**: `copypath [file1] [file2] ...` or just `copypath` for current directory

To uninstall:
```bash
./uninstall-copy-as-path.sh
```

## License

[MIT License](LICENSE)
