//Pin connected to ST_CP of 74HC595
int latchPin = 8;
//Pin connected to SH_CP of 74HC595
int clockPin = 12;
////Pin connected to DS of 74HC595
int dataPin = 11;
int greenMode = 4;
int redMode = 5;
int pot10k = A2;

int whichColour = 0;     // 0 for Red and 1 for Green
int showRed = 1;
int showGreen = 1;
byte my8x8[8];
byte c8x8[8], n8x8[8];
int shift = 8;
int doingLetter = 0;
char Message[] = "ARE YOU IMPRESSED DAVID? ";
int messageLength = 10;
int scrollSpeed = 100;

void setup() {
  //set pins to output so you can control the shift register
  pinMode(latchPin, OUTPUT);
  pinMode(clockPin, OUTPUT);
  pinMode(dataPin, OUTPUT);
  
  pinMode(greenMode, INPUT);
  pinMode(redMode, INPUT);
  pinMode(pot10k, INPUT);
  
  loadLetter(' ', my8x8);
  loadLetter(Message[doingLetter++], n8x8);

  messageLength = 100;
  for (int i = 0; i < 100; i++) {
    if (Message[i] == '\0') {
     messageLength = i;
     break;
    }
  }
}

void loop() {
  // count from 0 to 255 and display the number 
  // on the LEDs
  byte numberToDisplay = 0;
  byte redDisplay = 0;
  byte grnDisplay = 0;
  
  unsigned long currentMillis = millis();
  unsigned long previousMillis = currentMillis;
  
  scrollSpeed = map(analogRead(pot10k), 0, 1023, 25, 1000);
  showGreen = digitalRead(greenMode);
  showRed = digitalRead(redMode);
  
 
  while (millis() - previousMillis < scrollSpeed) {
  for (int rowLoop = 0; rowLoop < 8; rowLoop++) {
    
    if (whichColour == 0) { // Show Red
      grnDisplay = 0; // Make sure we don't show any green LEDs
      redDisplay = (1 << rowLoop) * showRed;
      numberToDisplay = my8x8[rowLoop];
    } else {
      grnDisplay = (1 << rowLoop) * showGreen;
      redDisplay = 0; // Make sure we don't show any red LEDs
      numberToDisplay = ~my8x8[rowLoop];
    }
    
    digitalWrite(latchPin, LOW);
    // shift out the bits:
    shiftOut(dataPin, clockPin, MSBFIRST, grnDisplay);
    shiftOut(dataPin, clockPin, MSBFIRST, redDisplay);
    shiftOut(dataPin, clockPin, MSBFIRST, numberToDisplay);  

    //take the latch pin high so the LEDs will light up:
    digitalWrite(latchPin, HIGH);
    delay(1);
  }
  whichColour = ~whichColour;
  }
  for (int i = 0; i < 8; my8x8[i] = my8x8[i++] & (255 << (8-shift)));
  for (int i = 0; i < 8; my8x8[i] = my8x8[i++] << 1);
  shift--;
  for (int i = 0; i < 8; my8x8[i] = my8x8[i] | n8x8[i++] >> shift);

  if (shift == 2) {
    shift = 8;
    loadLetter(Message[doingLetter++], n8x8);
    if (doingLetter >= messageLength) doingLetter = 0;
  }
}

void loadLetter(char whichLetter, byte w8x8[]) {
  switch (whichLetter) {
    case ' ': {
        w8x8[0] = B00000000;
        w8x8[1] = B00000000;
        w8x8[2] = B00000000;
        w8x8[3] = B00000000;
        w8x8[4] = B00000000;
        w8x8[5] = B00000000;
        w8x8[6] = B00000000;
        w8x8[7] = B00000000; 
        break;
    }
    case '0': {
        w8x8[0] = B01110000;
        w8x8[1] = B10001000;
        w8x8[2] = B10011000;
        w8x8[3] = B10101000;
        w8x8[4] = B11001000;
        w8x8[5] = B10001000;
        w8x8[6] = B01110000;
        w8x8[7] = B00000000; 
        break;
    }
    case '1': {
        w8x8[0] = B00100000;
        w8x8[1] = B01100000;
        w8x8[2] = B10100000;
        w8x8[3] = B00100000;
        w8x8[4] = B00100000;
        w8x8[5] = B00100000;
        w8x8[6] = B11111000;
        w8x8[7] = B00000000; 
        break;
    }
    case '2': {
        w8x8[0] = B01110000;
        w8x8[1] = B10001000;
        w8x8[2] = B00001000;
        w8x8[3] = B01110000;
        w8x8[4] = B10000000;
        w8x8[5] = B10000000;
        w8x8[6] = B11111000;
        w8x8[7] = B00000000; 
        break;
    }
    case '3': {
        w8x8[0] = B11111000;
        w8x8[1] = B00001000;
        w8x8[2] = B00010000;
        w8x8[3] = B00110000;
        w8x8[4] = B00001000;
        w8x8[5] = B10001000;
        w8x8[6] = B01110000;
        w8x8[7] = B00000000; 
        break;
    }
    case '4': {
        w8x8[0] = B00010000;
        w8x8[1] = B00110000;
        w8x8[2] = B01010000;
        w8x8[3] = B10010000;
        w8x8[4] = B11111000;
        w8x8[5] = B00010000;
        w8x8[6] = B00010000;
        w8x8[7] = B00000000; 
        break;
    }
    case '5': {
        w8x8[0] = B11111000;
        w8x8[1] = B10000000;
        w8x8[2] = B10000000;
        w8x8[3] = B11110000;
        w8x8[4] = B00001000;
        w8x8[5] = B10001000;
        w8x8[6] = B01110000;
        w8x8[7] = B00000000; 
        break;
    }
    case '6': {
        w8x8[0] = B00010000;
        w8x8[1] = B00100000;
        w8x8[2] = B01000000;
        w8x8[3] = B11110000;
        w8x8[4] = B10001000;
        w8x8[5] = B10001000;
        w8x8[6] = B01110000;
        w8x8[7] = B00000000; 
        break;
    }
    case '7': {
        w8x8[0] = B11111000;
        w8x8[1] = B10001000;
        w8x8[2] = B00010000;
        w8x8[3] = B00100000;
        w8x8[4] = B00100000;
        w8x8[5] = B01000000;
        w8x8[6] = B01000000;
        w8x8[7] = B00000000; 
        break;
    }
    case '8': {
        w8x8[0] = B01110000;
        w8x8[1] = B10001000;
        w8x8[2] = B10001000;
        w8x8[3] = B01110000;
        w8x8[4] = B10001000;
        w8x8[5] = B10001000;
        w8x8[6] = B01110000;
        w8x8[7] = B00000000; 
        break;
    }
    case '9': {
        w8x8[0] = B01110000;
        w8x8[1] = B10001000;
        w8x8[2] = B10001000;
        w8x8[3] = B01111000;
        w8x8[4] = B00010000;
        w8x8[5] = B00100000;
        w8x8[6] = B01000000;
        w8x8[7] = B00000000; 
        break;
    }
    case ':': {
        w8x8[0] = B00000000;
        w8x8[1] = B01100000;
        w8x8[2] = B01100000;
        w8x8[3] = B00000000;
        w8x8[4] = B01100000;
        w8x8[5] = B01100000;
        w8x8[6] = B00000000;
        w8x8[7] = B00000000; 
        break;
    }
    case '?': {
        w8x8[0] = B01110000;
        w8x8[1] = B10001000;
        w8x8[2] = B00001000;
        w8x8[3] = B00010000;
        w8x8[4] = B00100000;
        w8x8[5] = B00000000;
        w8x8[6] = B00100000;
        w8x8[7] = B00000000; 
        break;
    }
    case '.': {
        w8x8[0] = B00000000;
        w8x8[1] = B00000000;
        w8x8[2] = B00000000;
        w8x8[3] = B00000000;
        w8x8[4] = B00000000;
        w8x8[5] = B01100000;
        w8x8[6] = B01100000;
        w8x8[7] = B00000000; 
        break;
    }
    case ',': {
        w8x8[0] = B00000000;
        w8x8[1] = B00000000;
        w8x8[2] = B00000000;
        w8x8[3] = B00000000;
        w8x8[4] = B01100000;
        w8x8[5] = B01100000;
        w8x8[6] = B00100000;
        w8x8[7] = B00000000; 
        break;
    }
    case '-': {
        w8x8[0] = B00000000;
        w8x8[1] = B00000000;
        w8x8[2] = B00000000;
        w8x8[3] = B01110000;
        w8x8[4] = B00000000;
        w8x8[5] = B00000000;
        w8x8[6] = B00000000;
        w8x8[7] = B00000000; 
        break;
    }
    case 'A': {
        w8x8[0] = B00100000;
        w8x8[1] = B01010000;
        w8x8[2] = B10001000;
        w8x8[3] = B10001000;
        w8x8[4] = B11111000;
        w8x8[5] = B10001000;
        w8x8[6] = B10001000;
        w8x8[7] = B00000000; 
        break;
    }
    case 'B': {
        w8x8[0] = B11110000;
        w8x8[1] = B10001000;
        w8x8[2] = B10001000;
        w8x8[3] = B11110000;
        w8x8[4] = B10001000;
        w8x8[5] = B10001000;
        w8x8[6] = B11110000;
        w8x8[7] = B00000000; 
        break;
    }
    case 'C': {
        w8x8[0] = B01110000;
        w8x8[1] = B10001000;
        w8x8[2] = B10000000;
        w8x8[3] = B10000000;
        w8x8[4] = B10000000;
        w8x8[5] = B10001000;
        w8x8[6] = B01110000;
        w8x8[7] = B00000000; 
        break;
    }
    case 'D': {
        w8x8[0] = B11110000;
        w8x8[1] = B10001000;
        w8x8[2] = B10001000;
        w8x8[3] = B10001000;
        w8x8[4] = B10001000;
        w8x8[5] = B10001000;
        w8x8[6] = B11110000;
        w8x8[7] = B00000000; 
        break;
    }
    case 'E': {
        w8x8[0] = B11111000;
        w8x8[1] = B10000000;
        w8x8[2] = B10000000;
        w8x8[3] = B11110000;
        w8x8[4] = B10000000;
        w8x8[5] = B10000000;
        w8x8[6] = B11111000;
        w8x8[7] = B00000000; 
        break;
    }
    case 'F': {
        w8x8[0] = B11111000;
        w8x8[1] = B10000000;
        w8x8[2] = B10000000;
        w8x8[3] = B11110000;
        w8x8[4] = B10000000;
        w8x8[5] = B10000000;
        w8x8[6] = B10000000;
        w8x8[7] = B00000000; 
        break;
    }
    case 'G': {
        w8x8[0] = B01110000;
        w8x8[1] = B10001000;
        w8x8[2] = B10000000;
        w8x8[3] = B10111000;
        w8x8[4] = B10001000;
        w8x8[5] = B10001000;
        w8x8[6] = B01110000;
        w8x8[7] = B00000000; 
        break;
    }
    case 'H': {
        w8x8[0] = B10001000;
        w8x8[1] = B10001000;
        w8x8[2] = B10001000;
        w8x8[3] = B11111000;
        w8x8[4] = B10001000;
        w8x8[5] = B10001000;
        w8x8[6] = B10001000;
        w8x8[7] = B00000000; 
        break;
    }
    case 'I': {
        w8x8[0] = B11111000;
        w8x8[1] = B00100000;
        w8x8[2] = B00100000;
        w8x8[3] = B00100000;
        w8x8[4] = B00100000;
        w8x8[5] = B00100000;
        w8x8[6] = B11111000;
        w8x8[7] = B00000000; 
        break;
    }
    case 'J': {
        w8x8[0] = B11111000;
        w8x8[1] = B00010000;
        w8x8[2] = B00010000;
        w8x8[3] = B00010000;
        w8x8[4] = B10010000;
        w8x8[5] = B10010000;
        w8x8[6] = B01100000;
        w8x8[7] = B00000000; 
        break;
    }
    case 'K': {
        w8x8[0] = B10001000;
        w8x8[1] = B10010000;
        w8x8[2] = B10100000;
        w8x8[3] = B11000000;
        w8x8[4] = B10100000;
        w8x8[5] = B10010000;
        w8x8[6] = B10001000;
        w8x8[7] = B00000000; 
        break;
    }
    case 'L': {
        w8x8[0] = B10000000;
        w8x8[1] = B10000000;
        w8x8[2] = B10000000;
        w8x8[3] = B10000000;
        w8x8[4] = B10000000;
        w8x8[5] = B10000000;
        w8x8[6] = B11111000;
        w8x8[7] = B00000000; 
        break;
    }
    case 'M': {
        w8x8[0] = B10001000;
        w8x8[1] = B11011000;
        w8x8[2] = B10101000;
        w8x8[3] = B10101000;
        w8x8[4] = B10001000;
        w8x8[5] = B10001000;
        w8x8[6] = B10001000;
        w8x8[7] = B00000000; 
        break;
    }
    case 'N': {
        w8x8[0] = B10001000;
        w8x8[1] = B11001000;
        w8x8[2] = B10101000;
        w8x8[3] = B10101000;
        w8x8[4] = B10101000;
        w8x8[5] = B10011000;
        w8x8[6] = B10001000;
        w8x8[7] = B00000000; 
        break;
    }
    case 'O': {
        w8x8[0] = B01110000;
        w8x8[1] = B10001000;
        w8x8[2] = B10001000;
        w8x8[3] = B10001000;
        w8x8[4] = B10001000;
        w8x8[5] = B10001000;
        w8x8[6] = B01110000;
        w8x8[7] = B00000000; 
        break;
    }
    case 'P': {
        w8x8[0] = B11110000;
        w8x8[1] = B10001000;
        w8x8[2] = B10001000;
        w8x8[3] = B11110000;
        w8x8[4] = B10000000;
        w8x8[5] = B10000000;
        w8x8[6] = B10000000;
        w8x8[7] = B00000000; 
        break;
    }
    case 'Q': {
        w8x8[0] = B01110000;
        w8x8[1] = B10001000;
        w8x8[2] = B10001000;
        w8x8[3] = B10001000;
        w8x8[4] = B10101000;
        w8x8[5] = B10010000;
        w8x8[6] = B01101000;
        w8x8[7] = B00000000; 
        break;
    }
    case 'R': {
        w8x8[0] = B11110000;
        w8x8[1] = B10001000;
        w8x8[2] = B10001000;
        w8x8[3] = B11110000;
        w8x8[4] = B10010000;
        w8x8[5] = B10001000;
        w8x8[6] = B10001000;
        w8x8[7] = B00000000; 
        break;
    }
    case 'S': {
        w8x8[0] = B01110000;
        w8x8[1] = B10001000;
        w8x8[2] = B10000000;
        w8x8[3] = B01110000;
        w8x8[4] = B00001000;
        w8x8[5] = B10001000;
        w8x8[6] = B01110000;
        w8x8[7] = B00000000; 
        break;
    }
    case 'T': {
        w8x8[0] = B11111000;
        w8x8[1] = B00100000;
        w8x8[2] = B00100000;
        w8x8[3] = B00100000;
        w8x8[4] = B00100000;
        w8x8[5] = B00100000;
        w8x8[6] = B00100000;
        w8x8[7] = B00000000; 
        break;
    }
    case 'U': {
        w8x8[0] = B10001000;
        w8x8[1] = B10001000;
        w8x8[2] = B10001000;
        w8x8[3] = B10001000;
        w8x8[4] = B10001000;
        w8x8[5] = B10001000;
        w8x8[6] = B01110000;
        w8x8[7] = B00000000; 
        break;
    }
    case 'V': {
        w8x8[0] = B10001000;
        w8x8[1] = B10001000;
        w8x8[2] = B10001000;
        w8x8[3] = B10001000;
        w8x8[4] = B10001000;
        w8x8[5] = B01010000;
        w8x8[6] = B00100000;
        w8x8[7] = B00000000; 
        break;
    }
    case 'W': {
        w8x8[0] = B10001000;
        w8x8[1] = B10001000;
        w8x8[2] = B10001000;
        w8x8[3] = B10001000;
        w8x8[4] = B10101000;
        w8x8[5] = B10101000;
        w8x8[6] = B01010000;
        w8x8[7] = B00000000; 
        break;
    }
    case 'X': {
        w8x8[0] = B10001000;
        w8x8[1] = B10001000;
        w8x8[2] = B01010000;
        w8x8[3] = B00100000;
        w8x8[4] = B01010000;
        w8x8[5] = B10001000;
        w8x8[6] = B10001000;
        w8x8[7] = B00000000; 
        break;
    }
    case 'Y': {
        w8x8[0] = B10001000;
        w8x8[1] = B10001000;
        w8x8[2] = B01010000;
        w8x8[3] = B00100000;
        w8x8[4] = B00100000;
        w8x8[5] = B00100000;
        w8x8[6] = B00100000;
        w8x8[7] = B00000000; 
        break;
    }
    case 'Z': {
        w8x8[0] = B11111000;
        w8x8[1] = B00001000;
        w8x8[2] = B00010000;
        w8x8[3] = B00100000;
        w8x8[4] = B01000000;
        w8x8[5] = B10000000;
        w8x8[6] = B11111000;
        w8x8[7] = B00000000; 
        break;
    }
  }
}
  
