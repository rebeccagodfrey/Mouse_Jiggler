#!/bin/bash
# Manual upload script for Arduino Pro Micro
# This can help diagnose upload issues

SKETCH_FILE="mouse-jiggler.ino"
PORT="/dev/ttyACM0"
BAUD_RATE="57600"
MCU="atmega32u4"
PROGRAMMER="avr109"

echo "=========================================="
echo "Manual Arduino Pro Micro Upload"
echo "=========================================="
echo ""

# Check if device is connected
if [ ! -e "$PORT" ]; then
    echo "❌ Serial port $PORT not found!"
    echo "   Make sure device is connected and double-tap reset button"
    exit 1
fi

echo "✅ Serial port found: $PORT"
echo ""

# Check if Arduino IDE compiled the sketch
HEX_FILE=""
if [ -d "/tmp/arduino*" ]; then
    HEX_FILE=$(find /tmp/arduino* -name "*.hex" -type f 2>/dev/null | head -1)
fi

if [ -z "$HEX_FILE" ]; then
    echo "⚠️  No compiled .hex file found in /tmp"
    echo ""
    echo "   Please compile the sketch in Arduino IDE first, then run this script"
    echo "   Or we can try to compile it now..."
    echo ""
    read -p "Try to compile with arduino-cli? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        if command -v arduino-cli &> /dev/null; then
            echo "Compiling with arduino-cli..."
            arduino-cli compile --fqbn sparkfun:avr:promicro:processor=atmega32u4,clock=16MHz_mhz "$SKETCH_FILE"
            if [ $? -eq 0 ]; then
                HEX_FILE=$(find . -name "*.hex" -type f | head -1)
            fi
        else
            echo "arduino-cli not found. Please compile in Arduino IDE first."
            exit 1
        fi
    else
        echo "Please compile the sketch in Arduino IDE first, then run this script again."
        exit 1
    fi
fi

if [ -z "$HEX_FILE" ]; then
    echo "❌ No .hex file found. Cannot upload."
    exit 1
fi

echo "✅ Found compiled file: $HEX_FILE"
echo ""

# Instructions
echo "=========================================="
echo "READY TO UPLOAD"
echo "=========================================="
echo ""
echo "1. Make sure Arduino IDE Serial Monitor is CLOSED"
echo "2. **DOUBLE-TAP the RESET button** on your board"
echo "3. Wait 1 second"
echo "4. Press Enter here to start upload..."
echo ""
read -p "Press Enter when ready (or Ctrl+C to cancel)..."

# Try to upload
echo ""
echo "Uploading to $PORT..."
echo ""

# Use avrdude with verbose output
avrdude -v -p "$MCU" -c "$PROGRAMMER" -P "$PORT" -b "$BAUD_RATE" \
    -U flash:w:"$HEX_FILE":i 2>&1 | tee upload.log

UPLOAD_RESULT=$?

echo ""
if [ $UPLOAD_RESULT -eq 0 ]; then
    echo "✅ Upload successful!"
else
    echo "❌ Upload failed with exit code: $UPLOAD_RESULT"
    echo ""
    echo "Common issues:"
    echo "- Bootloader timed out (double-tap reset and try again)"
    echo "- Wrong port selected"
    echo "- Device not in bootloader mode"
    echo "- USB communication issue"
    echo ""
    echo "Check upload.log for detailed error messages"
fi

