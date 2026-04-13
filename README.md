# zerospace

A native macOS app that creates empty, transparent, resizable windows. Intended for use with tiling window managers as a way to adjust the size and layout of other windows.

## Features

- Transparent windows that show your desktop wallpaper
- Multiple windows supported
- Single-instance: re-running the binary signals the existing instance to create a new window without stealing focus
- Quits automatically when the last window is closed

## Keyboard shortcuts

| Shortcut | Action |
|----------|--------|
| Cmd+N | New window |
| Cmd+T | New window |
| Cmd+W | Close current window |

## Build

Requires Xcode command line tools.

```
make        # build → build/zerospace.app
make run    # build and open
make clean  # remove build artifacts
```

## Usage

Run the binary directly to avoid macOS activating the existing instance (which can interfere with tiling window managers):

```
./build/zerospace.app/Contents/MacOS/zerospace
```

