# auto-clicker-95

A high-performance, lightweight automation tool written in Lua for Windows environments. Designed for efficiency and minimal system footprint, this utility allows users to simulate rapid mouse clicks with customizable intervals.

## Features

*   **Configurable CPS:** Precisely control your clicks per second with a real-time adjustment engine.
*   **Low Latency:** Built on a streamlined Lua core to ensure minimal input delay during high-speed operations.
*   **Toggle Hotkeys:** Easily enable or disable the clicker mid-task using customizable keyboard shortcuts.
*   **Smart Jitter:** Includes an optional randomization feature to simulate human behavior and bypass basic anti-bot detections.

## Installation

Ensure you have a Lua interpreter (such as LuaJIT) installed on your system. Clone the repository and install the required dependencies:

```bash
git clone https://github.com/Developer/auto-clicker-95.git
cd auto-clicker-95
luarocks install luacom
```

## Usage

You can launch the clicker directly from your terminal. Modify the `config.lua` file to set your preferred toggle key and delay parameters.

```bash
# Start the auto-clicker with the default configuration
lua main.lua --config=config.lua
```

### Example Config (`config.lua`)
```lua
return {
    cps = 15,
    toggle_key = "F6",
    random_jitter = true,
    button = "left"
}
```

## License

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Distributed under the MIT License. See `LICENSE` for more information.