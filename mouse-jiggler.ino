/* Mouse Jiggler for Arduino Pro Micro
 * 
 * This sketch moves the mouse cursor slightly every few seconds to prevent
 * the computer from going to sleep or showing an idle screen.
 * 
 * Features:
 * - Moves mouse cursor only on X axis (horizontal)
 * - Alternates left/right to stay in place
 * - Configurable jiggle interval
 * - LED indicator (if available)
 */

#include <Mouse.h>

// Configuration
const unsigned long JIGGLE_INTERVAL = 10000; // 10 seconds in milliseconds
const int MOVEMENT_DISTANCE = 20; // Pixels to move (horizontal only)
const int LED_PIN = LED_BUILTIN; // Built-in LED pin

unsigned long lastJiggleTime = 0;
bool moveRight = true; // Toggle between right and left movement

void setup() {
  // Initialize mouse control
  Mouse.begin();
  
  // Initialize LED pin if available
  if (LED_PIN != -1) {
    pinMode(LED_PIN, OUTPUT);
    digitalWrite(LED_PIN, LOW);
  }
  
  // Small delay to allow system to recognize the device
  delay(1000);
}

void loop() {
  unsigned long currentTime = millis();
  
  // Check if it's time to jiggle
  if (currentTime - lastJiggleTime >= JIGGLE_INTERVAL) {
    jiggleMouse();
    lastJiggleTime = currentTime;
    
    // Blink LED to indicate activity
    if (LED_PIN != -1) {
      digitalWrite(LED_PIN, HIGH);
      delay(50);
      digitalWrite(LED_PIN, LOW);
    }
  }
  
  // Small delay to prevent excessive CPU usage
  delay(100);
}

void jiggleMouse() {
  // Move mouse only on X axis (horizontal movement)
  // Alternates between right and left to keep cursor in place
  // This prevents screen drift and keeps the cursor on the current screen
  
  if (moveRight) {
    Mouse.move(MOVEMENT_DISTANCE, 0, 0);  // Move right
  } else {
    Mouse.move(-MOVEMENT_DISTANCE, 0, 0); // Move left (back to start)
  }
  
  // Toggle direction for next jiggle
  moveRight = !moveRight;
}

