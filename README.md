# Mouse Jiggler - Arduino Pro Micro

A simple Arduino project that prevents your computer from going to sleep by automatically moving the mouse cursor in small, subtle movements.

## Hardware Requirements

- **Arduino Pro Micro** (or compatible board with USB HID support)
- USB cable for programming and power

## Features

- Moves mouse cursor in a small circular pattern every 30 seconds
- Configurable jiggle interval
- LED indicator (if available on your board)
- Minimal movement that won't interfere with normal computer use

## Installation

1. **Install Arduino IDE**
   - Download from [arduino.cc](https://www.arduino.cc/en/software)
   - Install the IDE on your computer

2. **Install Board Support**
   - Open Arduino IDE
   - Go to `Tools` → `Board` → `Boards Manager`
   - Search for "SparkFun AVR Boards" or "Arduino Leonardo"
   - Install the board support package

3. **Select Board**
   - Connect your Arduino Pro Micro via USB
   - Go to `Tools` → `Board` → Select "SparkFun Pro Micro" (or "Arduino Leonardo")
   - Select the correct processor: `Tools` → `Processor` → `ATmega32U4 (5V, 16 MHz)` or `ATmega32U4 (3.3V, 8 MHz)` depending on your board
   - Select the correct port: `Tools` → `Port` → Select your Pro Micro's COM port

4. **Upload Sketch**
   - Open `mouse-jiggler.ino` in Arduino IDE
   - Click the Upload button (→) or press `Ctrl+U`
   - Wait for the upload to complete

## Configuration

You can customize the behavior by modifying these constants in the sketch:

```cpp
const unsigned long JIGGLE_INTERVAL = 30000; // Time between movements (milliseconds)
const int MOVEMENT_DISTANCE = 1; // Pixels to move (1-2 recommended)
```

### Example Configurations

- **More frequent jiggling**: Change `JIGGLE_INTERVAL` to `15000` (15 seconds)
- **Larger movement**: Change `MOVEMENT_DISTANCE` to `2` (not recommended, may be noticeable)
- **Less frequent**: Change `JIGGLE_INTERVAL` to `60000` (1 minute)

## Usage

1. Upload the sketch to your Arduino Pro Micro
2. Connect the Pro Micro to your computer via USB
3. The device will automatically start jiggling the mouse cursor
4. The built-in LED (if available) will blink briefly each time it jiggles

## Safety Notes

⚠️ **Important**: 
- This device will act as a USB HID mouse. Make sure you can physically access your computer to unplug it if needed.
- The mouse movements are very small (1 pixel) and shouldn't interfere with normal use, but be aware that the mouse will move automatically.
- Some systems may require administrator privileges or may have security software that blocks USB HID devices.

## Troubleshooting

**Device not recognized:**
- Make sure you've selected the correct board and processor in Arduino IDE
- Try a different USB cable (some cables are power-only)
- Check that the Pro Micro has the correct drivers installed

**Mouse not moving:**
- Verify the sketch uploaded successfully
- Check that the device is recognized by your operating system
- Some operating systems may require additional permissions for USB HID devices

**LED not blinking:**
- The Pro Micro may not have a built-in LED
- This is normal and doesn't affect functionality

## License

This project is provided as-is for educational and personal use.

