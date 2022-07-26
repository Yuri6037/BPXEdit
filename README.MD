# BPXEdit (macOS)

macOS editor and viewer for the [BPX container format](https://gitlab.com/bp3d/bpx).

## Features

- Supports large sections.
- Hex view.
- Data view (decode C-like structures).
- BPXSD view.
- String view.

## Build

- Use Xcode 13 or later.
- Builds and runs under macOS 12+.
- Use an Intel Mac as currently the bpxc library shipped with the project 
is only available for the target tripples x86_64-apple-macos and 
aarch64-apple-ios.
