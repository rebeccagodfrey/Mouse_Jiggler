#!/bin/bash
# Arduino Pro Micro Device Checker
# This script helps diagnose why your Arduino Pro Micro isn't being recognized

echo "=========================================="
echo "Arduino Pro Micro Device Checker"
echo "=========================================="
echo ""

# Check for USB devices
echo "1. Checking USB devices..."
echo "----------------------------------------"
USB_DEVICES=$(lsusb | grep -iE "arduino|sparkfun|2341|1b4f|03eb")
if [ -z "$USB_DEVICES" ]; then
    echo "❌ No Arduino/SparkFun devices found in USB list"
    echo ""
    echo "   This means the device is NOT being recognized by the OS."
    echo "   Common causes:"
    echo "   - Device not in bootloader mode"
    echo "   - USB cable is power-only (no data lines)"
    echo "   - USB port issue"
    echo ""
    echo "   SOLUTION:"
    echo "   1. Double-tap the RESET button on the board quickly (within 500ms)"
    echo "   2. Try a different USB cable (must be data-capable)"
    echo "   3. Try a different USB port"
    echo ""
else
    echo "✅ Found USB device(s):"
    echo "$USB_DEVICES"
    echo ""
fi

# Check for serial devices
echo "2. Checking serial devices..."
echo "----------------------------------------"
SERIAL_DEVICES=$(ls -la /dev/ttyACM* /dev/ttyUSB* 2>/dev/null)
if [ -z "$SERIAL_DEVICES" ]; then
    echo "❌ No serial devices found (/dev/ttyACM* or /dev/ttyUSB*)"
    echo ""
    if [ ! -z "$USB_DEVICES" ]; then
        echo "   Device is recognized as USB but not as serial device."
        echo "   This might be a permissions or udev rules issue."
        echo ""
        echo "   SOLUTION:"
        echo "   1. Check if you're in the 'dialout' group:"
        echo "      groups | grep dialout"
        echo "   2. If not, add yourself: sudo usermod -a -G dialout \$USER"
        echo "   3. Check udev rules: ls -la /etc/udev/rules.d/*arduino*"
    fi
    echo ""
else
    echo "✅ Found serial device(s):"
    echo "$SERIAL_DEVICES"
    echo ""
    
    # Check permissions
    shopt -s nullglob
    for dev in /dev/ttyACM* /dev/ttyUSB*; do
        PERMS=$(stat -c "%a" "$dev" 2>/dev/null)
        echo "   $dev: permissions $PERMS"
    done
    shopt -u nullglob
    echo ""
fi

# Check user groups
echo "3. Checking user permissions..."
echo "----------------------------------------"
if groups | grep -q dialout; then
    echo "✅ User is in 'dialout' group"
else
    echo "❌ User is NOT in 'dialout' group"
    echo "   Run: sudo usermod -a -G dialout \$USER"
    echo "   Then log out and log back in"
fi
echo ""

# Check udev rules
echo "4. Checking udev rules..."
echo "----------------------------------------"
UDEV_RULES=$(ls /etc/udev/rules.d/*arduino* /etc/udev/rules.d/*99-arduino* 2>/dev/null)
if [ -z "$UDEV_RULES" ]; then
    echo "⚠️  No Arduino-specific udev rules found"
    echo "   (This may not be necessary, but can help with permissions)"
else
    echo "✅ Found udev rules:"
    echo "$UDEV_RULES"
fi
echo ""

# Check recent USB errors
echo "5. Recent USB errors (last 5 minutes)..."
echo "----------------------------------------"
RECENT_ERRORS=$(journalctl -k --since "5 minutes ago" 2>/dev/null | grep -iE "usb.*error|error.*71|unable to enumerate" | tail -5)
if [ -z "$RECENT_ERRORS" ]; then
    echo "✅ No recent USB errors found"
else
    echo "⚠️  Recent USB errors detected:"
    echo "$RECENT_ERRORS"
    echo ""
    echo "   Error -71 typically means:"
    echo "   - Device not responding during USB enumeration"
    echo "   - Device needs to be in bootloader mode"
    echo "   - USB cable or port issue"
fi
echo ""

# Summary and recommendations
echo "=========================================="
echo "RECOMMENDATIONS"
echo "=========================================="
echo ""

if [ -z "$USB_DEVICES" ]; then
    echo "🔧 IMMEDIATE ACTIONS:"
    echo "   1. Double-tap the RESET button on your Arduino Pro Micro"
    echo "      (Press it twice quickly within 500ms)"
    echo "   2. Run this script again: ./check-device.sh"
    echo "   3. If still not found, try a different USB cable"
    echo "   4. Try a different USB port (preferably USB 2.0)"
    echo ""
    echo "   The bootloader mode only lasts ~8 seconds, so you need to"
    echo "   upload code quickly after entering bootloader mode!"
else
    if [ -z "$SERIAL_DEVICES" ]; then
        echo "🔧 IMMEDIATE ACTIONS:"
        echo "   1. Add yourself to dialout group:"
        echo "      sudo usermod -a -G dialout \$USER"
        echo "      (Then log out and back in)"
        echo "   2. Check device permissions: ls -la /dev/ttyACM*"
    else
        echo "✅ Device appears to be recognized!"
        echo "   You should be able to upload code now."
        echo ""
        echo "   In Arduino IDE:"
        echo "   - Select Tools → Board → SparkFun Pro Micro"
        echo "   - Select Tools → Port → /dev/ttyACM0 (or similar)"
        echo "   - Click Upload"
    fi
fi

echo ""
echo "For detailed troubleshooting, see: TROUBLESHOOTING.md"
echo ""

