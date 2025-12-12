# Troubleshooting: Arduino Pro Micro Not Recognized

## Problem: Device Not Recognized by OS

If your Arduino Pro Micro is not showing up in `lsusb` or as a serial device (`/dev/ttyACM*`), follow these steps:

## Step 1: Enter Bootloader Mode

The Arduino Pro Micro needs to be in **bootloader mode** to be recognized by the OS. Here's how:

### Method 1: Double-Tap Reset (Recommended)
1. **Quickly double-tap the RESET button** on the board (within 500ms)
2. The board should enter bootloader mode
3. You should see it appear in `lsusb` as:
   - `Bus XXX Device XXX: ID 2341:0036 Arduino SA` (Arduino branded)
   - `Bus XXX Device XXX: ID 1b4f:9203 SparkFun Electronics` (SparkFun branded)

### Method 2: Short Reset Pin
1. **Short the RST pin to GND twice quickly** (within 500ms)
2. This simulates the double-tap reset

### Method 3: Physical Reset Button
1. Press and release the RESET button once
2. Immediately press and hold it again
3. Release after 1-2 seconds

## Step 2: Verify USB Cable

**Critical**: Many USB cables are **power-only** and don't have data lines. 

- ✅ Use a **data-capable USB cable** (not a charging-only cable)
- ✅ Try a different USB cable
- ✅ Try a different USB port (preferably USB 2.0, not USB 3.0)

## Step 3: Check USB Port

- Try a different USB port on your computer
- Avoid USB hubs if possible (connect directly to computer)
- USB 2.0 ports are often more reliable than USB 3.0 for Arduino devices

## Step 4: Verify Device Detection

After entering bootloader mode, check if the device is recognized:

```bash
# Check USB devices
lsusb

# Check serial devices
ls -la /dev/ttyACM* /dev/ttyUSB* 2>/dev/null

# Monitor USB events (in another terminal)
watch -n 1 'lsusb | grep -i "arduino\|sparkfun\|atmega"'
```

You should see something like:
- `ID 2341:0036` (Arduino Pro Micro)
- `ID 1b4f:9203` (SparkFun Pro Micro)
- `/dev/ttyACM0` or `/dev/ttyACM1` (serial device)

## Step 5: Check System Logs

Monitor system logs while plugging in the device:

```bash
# Watch kernel messages
sudo journalctl -k -f

# Or check recent USB errors
journalctl -k --since "5 minutes ago" | grep -i "usb\|error"
```

## Step 6: Install udev Rules (If Needed)

If the device appears in `lsusb` but not as `/dev/ttyACM*`, you may need udev rules.

Create `/etc/udev/rules.d/99-arduino.rules`:

```bash
sudo nano /etc/udev/rules.d/99-arduino.rules
```

Add these lines:

```
# Arduino Pro Micro / Leonardo
SUBSYSTEM=="tty", ATTRS{idVendor}=="2341", ATTRS{idProduct}=="0036", MODE="0666", GROUP="dialout"
SUBSYSTEM=="tty", ATTRS{idVendor}=="2341", ATTRS{idProduct}=="0037", MODE="0666", GROUP="dialout"
SUBSYSTEM=="tty", ATTRS{idVendor}=="2341", ATTRS{idProduct}=="0242", MODE="0666", GROUP="dialout"

# SparkFun Pro Micro
SUBSYSTEM=="tty", ATTRS{idVendor}=="1b4f", ATTRS{idProduct}=="9203", MODE="0666", GROUP="dialout"
SUBSYSTEM=="tty", ATTRS{idVendor}=="1b4f", ATTRS{idProduct}=="9205", MODE="0666", GROUP="dialout"
SUBSYSTEM=="tty", ATTRS{idVendor}=="1b4f", ATTRS{idProduct}=="9206", MODE="0666", GROUP="dialout"

# Generic ATmega32U4 devices
SUBSYSTEM=="tty", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="204f", MODE="0666", GROUP="dialout"
```

Then reload udev rules:

```bash
sudo udevadm control --reload-rules
sudo udevadm trigger
```

## Step 7: Add User to dialout Group

If you get permission errors:

```bash
sudo usermod -a -G dialout $USER
```

**Log out and log back in** for the group change to take effect.

## Step 8: Common Error Messages

### Error -71: "device descriptor read/64, error -71"
- **Cause**: Device not responding during USB enumeration
- **Solution**: 
  - Enter bootloader mode (double-tap reset)
  - Try a different USB cable
  - Try a different USB port

### "Device not responding to setup address"
- **Cause**: USB communication failure
- **Solution**: Same as above, plus check USB port power (try powered USB hub)

### "unable to enumerate USB device"
- **Cause**: USB enumeration failed
- **Solution**: 
  - Check cable (must be data-capable)
  - Enter bootloader mode
  - Try different USB port

## Step 9: Hardware Issues

If none of the above works:

1. **Check board power**: LED should light up when connected
2. **Check for physical damage**: Look for broken traces, damaged components
3. **Try another Arduino Pro Micro**: Rule out hardware failure
4. **Check bootloader**: Board may need bootloader reflashed (requires ISP programmer)

## Step 10: Upload Timing

When uploading code:
1. Enter bootloader mode (double-tap reset)
2. **Immediately** click Upload in Arduino IDE
3. The IDE will automatically detect the bootloader and upload

The bootloader mode only lasts about 8 seconds, so you need to upload quickly!

## Still Not Working?

1. Try on a different computer to rule out OS/driver issues
2. Check if the board works in Windows/Mac (if available)
3. Consider using an ISP programmer to reflash the bootloader
4. The board may be damaged and need replacement

