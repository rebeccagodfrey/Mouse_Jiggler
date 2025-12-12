# Arduino IDE Settings for Pro Micro

## Correct Settings for SparkFun Pro Micro

When uploading to Arduino Pro Micro, use these **exact** settings in Arduino IDE:

### Board Settings

1. **Tools → Board**
   - Select: `SparkFun Pro Micro`
   - (If not available, install "SparkFun AVR Boards" from Boards Manager)

2. **Tools → Processor**
   - For 5V boards: `ATmega32U4 (5V, 16 MHz)`
   - For 3.3V boards: `ATmega32U4 (3.3V, 8 MHz)`
   - ⚠️ **Check your board** - it should say "5V" or "3.3V" printed on it

3. **Tools → Port**
   - Select: `/dev/ttyACM0` (or `/dev/ttyACM1` if you have multiple devices)

4. **Tools → Programmer**
   - Select: `AVRISP mkII` or `Arduino as ISP`
   - ⚠️ **IMPORTANT**: For Pro Micro, Arduino IDE should use the bootloader (avr109 protocol) automatically
   - You should NOT need to manually select a programmer for normal uploads

5. **Tools → Upload Speed**
   - Usually: `57600` (default)
   - If upload fails, try: `115200` or `19200`

## ⚠️ Common Mistake: Wrong Programmer Selected

If you see errors like:
- "Could not find USBtiny device"
- "Programmer not responding"
- "CATERIN" bootloader detected but upload fails

**The issue**: Arduino IDE might be trying to use the wrong upload method.

### Solution 1: Use Correct Board Selection

Make sure you selected **"SparkFun Pro Micro"** (not "Arduino Leonardo" or generic board).

The board selection automatically sets:
- Correct bootloader protocol (avr109)
- Correct upload method
- Correct fuse settings

### Solution 2: Check Upload Method

Arduino IDE should use **bootloader upload** (not ISP programmer) for Pro Micro.

The upload process should:
1. Detect the bootloader on the device
2. Use `avr109` protocol automatically
3. Upload through the serial port

### Solution 3: If Using Arduino Leonardo Board

If you're using "Arduino Leonardo" instead of "SparkFun Pro Micro":

1. **Tools → Board**: `Arduino Leonardo`
2. **Tools → Processor**: `ATmega32U4`
3. **Tools → Programmer**: Leave as default (should be automatic)
4. **Tools → Port**: `/dev/ttyACM0`

## Upload Process

The correct upload process for Pro Micro:

1. **Select correct board** (SparkFun Pro Micro)
2. **Select correct port** (/dev/ttyACM0)
3. **Double-tap RESET button** on the board
4. **Immediately click Upload** (within 2-3 seconds)
5. Arduino IDE should automatically:
   - Detect bootloader
   - Use avr109 protocol
   - Upload the sketch

## If Upload Still Fails

### Enable Verbose Output

1. **File → Preferences**
2. Check: **"Show verbose output during: upload"**
3. Try uploading again
4. Look for error messages in the output

### Check What Arduino IDE is Trying to Use

In verbose output, you should see something like:

```
avrdude: Version ...
avrdude: Using Port                    : /dev/ttyACM0
avrdude: Using Programmer              : avr109
avrdude: AVR Part                      : ATmega32U4
```

If you see a different programmer (like `usbtiny`), that's the problem!

### Force Correct Upload Method

If Arduino IDE is using the wrong method, you can try:

1. **Tools → Programmer**: Try different options:
   - `AVRISP mkII` (usually works)
   - `Arduino as ISP` (sometimes needed)
   - `USBtinyISP` (usually WRONG for Pro Micro)

2. Or manually upload using command line (see `upload-manual.sh`)

## Summary

**For SparkFun Pro Micro:**
- ✅ Board: `SparkFun Pro Micro`
- ✅ Processor: `ATmega32U4 (5V, 16 MHz)` or `ATmega32U4 (3.3V, 8 MHz)`
- ✅ Port: `/dev/ttyACM0`
- ✅ Programmer: `AVRISP mkII` (or leave default)
- ✅ Upload method: Bootloader (avr109) - automatic

**The key**: Select the correct board type, and Arduino IDE should handle the rest automatically!

