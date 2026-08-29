# auto-clicker-95

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A lightweight Lua auto-clicker for precise mouse input automation. It uses LuaJIT and the Windows API for low-latency clicking without external dependencies.

## Features
- Click rates configurable from 1 to 500 per second with millisecond precision
- Toggle via customizable hotkeys with support for left and right buttons
- Optional delay randomization to reduce pattern detection
- Session click counter and basic logging to file

## Installation

```bash
git clone https://github.com/Developer/auto-clicker-95.git
cd auto-clicker-95
```

Requires LuaJIT. Install via your system package manager (e.g., `winget install LuaJIT` on Windows).

## Basic Usage

Run the script:

```bash
luajit auto-clicker.lua
```

Edit the configuration block at the top of `auto-clicker.lua`:

```lua
config = {
  cps = 25,
  button = "left",
  hotkey = "F8",
  randomize = true
}
```

Press the hotkey to start or stop clicking.

## License

MIT License.