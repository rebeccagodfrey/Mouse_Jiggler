# Mouse Movement Recommendations

## Is 20 Pixels Enough?

**Short answer: Yes, 20 pixels is more than enough for both Windows 10 and macOS.**

However, you might want to use less to make it more subtle.

## Operating System Requirements

### Windows 10
- **Minimum**: 1-2 pixels is usually sufficient
- **Recommended**: 2-5 pixels for reliability
- **Your setting (20px)**: Definitely works, but may be noticeable
- **Frequency**: Every 10-30 seconds is typically enough

### macOS (Apple OS)
- **Minimum**: 1-2 pixels is usually sufficient
- **Recommended**: 2-5 pixels for reliability
- **Your setting (20px)**: Definitely works, but may be noticeable
- **Frequency**: Every 10-30 seconds is typically enough

## Current Settings Analysis

Your current configuration:
- **Movement**: 20 pixels (horizontal only, alternates left/right)
- **Interval**: 10 seconds
- **Pattern**: Moves right 20px, then left 20px (net movement = 0)

### Pros of 20 pixels:
- ✅ **Very reliable** - Will definitely prevent sleep on both OSes
- ✅ **Works even with strict power management settings**
- ✅ **Safe margin** - Won't fail due to system variations

### Cons of 20 pixels:
- ⚠️ **May be noticeable** - If you're watching the cursor, you might see it move
- ⚠️ **Could interfere** - If you're working near the edge of the screen, cursor might move into view

## Recommendations

### Option 1: Keep 20 pixels (Current)
**Best for**: Maximum reliability, don't care about subtlety
- Works 100% reliably
- May be slightly noticeable if watching cursor

### Option 2: Reduce to 5-10 pixels (Recommended)
**Best for**: Balance between reliability and subtlety
```cpp
const int MOVEMENT_DISTANCE = 5; // More subtle, still very reliable
```
- Still very reliable (99%+)
- Much less noticeable
- Won't interfere with normal use

### Option 3: Reduce to 1-2 pixels (Most Subtle)
**Best for**: Maximum subtlety, willing to test
```cpp
const int MOVEMENT_DISTANCE = 2; // Very subtle
```
- Usually works fine
- Almost completely invisible
- Might need testing on your specific system

## Testing Your Settings

To test if your current settings work:

1. **Windows 10**:
   - Set power settings to sleep after 1 minute (for testing)
   - Connect your mouse jiggler
   - Wait and see if computer stays awake
   - Check if cursor movement is noticeable

2. **macOS**:
   - System Preferences → Energy Saver → Set display sleep to 1 minute
   - Connect your mouse jiggler
   - Wait and see if display stays on
   - Check if cursor movement is noticeable

## Frequency vs Distance

**Important**: The frequency (interval) is often more important than distance!

- **Distance**: 1-2 pixels is usually enough
- **Frequency**: Every 10-30 seconds is ideal
  - Too frequent (every 1-2 seconds): May cause issues, wastes resources
  - Too infrequent (every 60+ seconds): May miss the idle detection window

Your current **10-second interval is perfect** for both OSes.

## Best Practice Configuration

For maximum reliability with minimal noticeability:

```cpp
const unsigned long JIGGLE_INTERVAL = 10000; // 10 seconds (good)
const int MOVEMENT_DISTANCE = 3; // 3 pixels (subtle but reliable)
```

This gives you:
- ✅ Works on Windows 10 and macOS
- ✅ Almost invisible movement
- ✅ Reliable sleep prevention
- ✅ Won't interfere with normal use

## Summary

| Distance | Reliability | Noticeability | Recommendation |
|----------|-------------|---------------|----------------|
| 1-2 px   | Good        | Invisible     | Test first     |
| 3-5 px   | Excellent   | Very subtle   | **Recommended** |
| 10 px    | Excellent   | Slightly visible | Good choice |
| 20 px    | Excellent   | Noticeable    | Works but may be too much |

**Your 20 pixels will definitely work**, but consider reducing to 3-5 pixels for a better balance of reliability and subtlety.

