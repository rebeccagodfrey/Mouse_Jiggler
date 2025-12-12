#!/bin/bash
# Arduino Pro Micro Upload Preparation Script
# This script helps prepare your device for upload

echo "=========================================="
echo "Arduino Pro Micro Upload Preparation"
echo "=========================================="
echo ""

# Check if device is connected
USB_DEVICE=$(lsusb | grep -iE "arduino|sparkfun|2341|1b4f|03eb")
if [ -z "$USB_DEVICE" ]; then
    echo "❌ No Arduino/SparkFun device found!"
    echo ""
    echo "Please connect your Arduino Pro Micro and try again."
    exit 1
fi

echo "✅ Device found:"
echo "   $USB_DEVICE"
echo ""

# Check if in bootloader mode
if echo "$USB_DEVICE" | grep -qi "bootloader"; then
    echo "✅ Device is in BOOTLOADER mode"
    BOOTLOADER_MODE=true
else
    echo "⚠️  Device is NOT in bootloader mode"
    echo "   (This is OK - you'll enter it before uploading)"
    BOOTLOADER_MODE=false
fi
echo ""

# Check serial port
SERIAL_PORT=$(ls /dev/ttyACM* 2>/dev/null | head -1)
if [ -z "$SERIAL_PORT" ]; then
    echo "❌ No serial port found (/dev/ttyACM*)"
    echo "   Try double-tapping the RESET button"
    exit 1
fi

echo "✅ Serial port found: $SERIAL_PORT"
echo ""

# Check permissions
if [ -r "$SERIAL_PORT" ] && [ -w "$SERIAL_PORT" ]; then
    echo "✅ Serial port is readable/writable"
else
    echo "⚠️  Serial port permissions issue"
    echo "   Run: sudo chmod 666 $SERIAL_PORT"
    echo "   Or add yourself to dialout group: sudo usermod -a -G dialout \$USER"
fi
echo ""

# Check if anything is using the port
PORT_IN_USE=$(lsof "$SERIAL_PORT" 2>/dev/null)
if [ -z "$PORT_IN_USE" ]; then
    echo "✅ Serial port is available (not in use)"
else
    echo "⚠️  Serial port is in use:"
    echo "$PORT_IN_USE"
    echo ""
    echo "   Close any programs using the port (Arduino Serial Monitor, etc.)"
fi
echo ""

# Detect board type
BOARD_TYPE="Unknown"
BOARD_PROCESSOR="Unknown"

if echo "$USB_DEVICE" | grep -qi "sparkfun"; then
    BOARD_TYPE="SparkFun Pro Micro"
    echo "📌 Detected: SparkFun Pro Micro"
    echo ""
    echo "   Arduino IDE Settings:"
    echo "   - Board: SparkFun Pro Micro"
    echo "   - Processor: ATmega32U4 (5V, 16 MHz) OR ATmega32U4 (3.3V, 8 MHz)"
    echo "     (Check your board - it should say 5V or 3.3V on it)"
    echo "   - Port: $SERIAL_PORT"
elif echo "$USB_DEVICE" | grep -qi "arduino.*leonardo\|2341:0036"; then
    BOARD_TYPE="Arduino Leonardo/Pro Micro"
    echo "📌 Detected: Arduino Leonardo/Pro Micro"
    echo ""
    echo "   Arduino IDE Settings:"
    echo "   - Board: Arduino Leonardo (or Arduino Pro Micro)"
    echo "   - Processor: ATmega32U4"
    echo "   - Port: $SERIAL_PORT"
fi
echo ""

# Instructions
echo "=========================================="
echo "UPLOAD INSTRUCTIONS"
echo "=========================================="
echo ""
echo "1. Open Arduino IDE"
echo "2. Select the correct board settings (see above)"
echo "3. Select port: $SERIAL_PORT"
echo "4. Open your sketch (mouse-jiggler.ino)"
echo "5. **DOUBLE-TAP the RESET button** on the board"
echo "   (Press it twice quickly within 500ms)"
echo "6. **IMMEDIATELY click Upload** in Arduino IDE"
echo "   (You have about 8 seconds - be quick!)"
echo ""
echo "⚠️  TIMING IS CRITICAL!"
echo "   The bootloader only stays active for ~8 seconds."
echo "   You must click Upload within 2-3 seconds of double-tapping reset."
echo ""

if [ "$BOOTLOADER_MODE" = true ]; then
    echo "✅ Device is already in bootloader mode!"
    echo "   Click Upload in Arduino IDE NOW!"
    echo ""
    echo "   (Bootloader will timeout in ~8 seconds)"
else
    echo "📝 Device is in normal mode."
    echo "   Remember to double-tap reset before uploading!"
fi

echo ""
echo "For detailed troubleshooting, see: UPLOAD-TROUBLESHOOTING.md"
echo ""

