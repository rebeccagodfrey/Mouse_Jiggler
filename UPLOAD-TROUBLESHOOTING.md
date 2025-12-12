# Upload Troubleshooting: Arduino Pro Micro

## Device Recognized But Upload Fails

If your device shows up in `lsusb` and `/dev/ttyACM*` but upload still fails, follow these steps:

## Critical: Upload Timing

The Arduino Pro Micro bootloader only stays active for **~8 seconds**. You must upload **immediately** after entering bootloader mode.

### Correct Upload Procedure:

1. **Open Arduino IDE** and prepare your sketch
2. **Select correct board settings** (see below)
3. **Double-tap the RESET button** on the board (quickly, within 500ms)
4. **IMMEDIATELY** click the Upload button (within 2-3 seconds)
5. The IDE should detect the bootloader and start uploading

**Timing is critical!** If you wait too long, the bootloader times out and upload fails.

## Step 1: Verify Board Settings

In Arduino IDE, check these settings **exactly**:

### For SparkFun Pro Micro:
- **Board**: `SparkFun Pro Micro`
- **Processor**: 
  - `ATmega32U4 (5V, 16 MHz)` for 5V boards
  - `ATmega32U4 (3.3V, 8 MHz)` for 3.3V boards
- **Port**: `/dev/ttyACM0` (or `/dev/ttyACM1` if multiple devices)

### For Arduino Pro Micro:
- **Board**: `Arduino Leonardo` (or `Arduino Pro Micro` if available)
- **Processor**: `ATmega32U4`
- **Port**: `/dev/ttyACM0`

**How to check your board voltage:**
- Look for a label on the board
- 5V boards usually have "5V" printed on them
- 3.3V boards usually have "3.3V" printed on them
- If unsure, try 5V first (most common)

## Step 2: Check Arduino IDE Error Messages

When upload fails, Arduino IDE shows specific errors. Common ones:

### "avrdude: Error: Could not find USBtiny device"
- **Cause**: Wrong board selected or device not in bootloader mode
- **Solution**: 
  - Double-tap reset button
  - Immediately click Upload
  - Verify correct board is selected

### "avrdude: Error: programmer did not respond"
- **Cause**: Bootloader timed out or device not responding
- **Solution**: 
  - Double-tap reset RIGHT before clicking Upload
  - Try a different USB port
  - Try a different USB cable

### "avrdude: Error: bootloader not responding"
- **Cause**: Device not in bootloader mode
- **Solution**: Double-tap reset button immediately before upload

### "Permission denied" or "Cannot open /dev/ttyACM0"
- **Cause**: Permission issues
- **Solution**: 
  ```bash
  sudo usermod -a -G dialout $USER
  # Then log out and log back in
  ```

### "Port /dev/ttyACM0 not found"
- **Cause**: Device not connected or not in bootloader mode
- **Solution**: 
  - Double-tap reset button
  - Check `ls -la /dev/ttyACM*` to see available ports

### "stk500_getsync() timeout"
- **Cause**: Communication timeout with bootloader
- **Solution**: 
  - Double-tap reset immediately before upload
  - Try different USB port/cable
  - Check if another program is using the serial port

## Step 3: Manual Bootloader Entry Method

If double-tap reset isn't working, try this:

1. **Close Arduino IDE** (if open)
2. **Double-tap the RESET button** on the board
3. **Wait 1 second** - you should see the device in bootloader mode
4. **Open Arduino IDE**
5. **Select the correct port** (`/dev/ttyACM0`)
6. **Click Upload** immediately

## Step 4: Check for Conflicting Programs

Other programs might be using the serial port:

```bash
# Check what's using the serial port
lsof /dev/ttyACM0

# Kill any processes using it (if safe to do so)
sudo fuser -k /dev/ttyACM0
```

Common culprits:
- Serial monitor in Arduino IDE (close it before uploading)
- Other Arduino IDE windows
- Screen/minicom/other serial terminal programs
- USB device monitoring tools

## Step 5: Try Different Upload Methods

### Method 1: Using avrdude directly

You can try uploading manually with avrdude to see detailed error messages:

```bash
# First, compile in Arduino IDE to get the .hex file location
# Then use avrdude (adjust paths as needed)
avrdude -p atmega32u4 -c avr109 -P /dev/ttyACM0 -b 57600 -U flash:w:mouse-jiggler.ino.hex
```

### Method 2: Use Arduino CLI

If Arduino IDE isn't working, try Arduino CLI:

```bash
# Install arduino-cli if not installed
# Then upload:
arduino-cli upload -p /dev/ttyACM0 --fqbn sparkfun:avr:promicro mouse-jiggler.ino
```

## Step 6: Verify Bootloader

The bootloader might be corrupted. Check if device enters bootloader mode:

1. **Double-tap reset button**
2. **Run**: `lsusb | grep -i "arduino\|sparkfun"`
3. You should see the device with "Bootloader" in the name

If it doesn't show "Bootloader", the bootloader might be damaged and needs reflashing (requires ISP programmer).

## Step 7: USB Port and Cable Issues

Even if the device is recognized, upload can fail due to:

- **USB 3.0 ports**: Try USB 2.0 port instead
- **USB hubs**: Connect directly to computer
- **Cable quality**: Try a different, high-quality USB cable
- **Power issues**: Some boards need more power during upload

## Step 8: Arduino IDE Settings

Check these Arduino IDE settings:

1. **File → Preferences → Show verbose output during: upload**
   - Enable this to see detailed error messages

2. **Tools → Programmer**
   - Should be set to "AVRISP mkII" or "Arduino as ISP" (not critical for most cases)

3. **Tools → Upload Speed**
   - Try different speeds if available (usually 57600 is default)

## Step 9: Alternative: Use PlatformIO

If Arduino IDE continues to fail, try PlatformIO:

```bash
# Install PlatformIO
pip install platformio

# Create platformio.ini in your project directory
# Then upload
pio run -t upload
```

## Common Upload Error Patterns

### Pattern 1: Upload starts but fails halfway
- **Cause**: USB communication interrupted
- **Solution**: Better USB cable, different port, shorter cable

### Pattern 2: "Device not found" after clicking Upload
- **Cause**: Bootloader timed out
- **Solution**: Click Upload faster after double-tap reset

### Pattern 3: Upload succeeds but device doesn't work
- **Cause**: Wrong processor/board selected
- **Solution**: Verify board voltage (5V vs 3.3V) and select correct processor

### Pattern 4: Works sometimes but not always
- **Cause**: Timing issue
- **Solution**: Use the manual bootloader entry method (Step 3)

## Still Not Working?

1. **Try on a different computer** - rules out OS/driver issues
2. **Check board voltage** - make sure you selected the correct processor
3. **Try a different Arduino Pro Micro** - rules out hardware failure
4. **Check bootloader** - may need to be reflashed with ISP programmer
5. **Use Arduino CLI or PlatformIO** - alternative tools might work better

## Quick Reference: Upload Checklist

- [ ] Device shows in `lsusb` (with or without "Bootloader")
- [ ] Device shows as `/dev/ttyACM0` (or similar)
- [ ] User is in `dialout` group
- [ ] Correct board selected in Arduino IDE
- [ ] Correct processor selected (5V vs 3.3V)
- [ ] Correct port selected (`/dev/ttyACM0`)
- [ ] No other programs using the serial port
- [ ] Double-tap reset button
- [ ] Click Upload **immediately** (within 2-3 seconds)
- [ ] Good quality USB cable (data-capable)
- [ ] USB 2.0 port (if available)

