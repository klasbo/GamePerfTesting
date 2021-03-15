#pragma once

#include <avr/io.h>

// Mouse buttons and photodiodes are on PORT D
// Buttons can be triggered by the controller (write), or triggered by hand and read by the controller (read)
// Keyboard button must be RC-filtered and read with ADC

#define DIODE1          4
#define DIODE1_READ     (PIND & (1<<DIODE1))

#define DIODE2          5
#define DIODE2_READ     (PIND & (1<<DIODE2))

#define MOUSE4          7
#define MOUSE4_DOWN     DDRD |= (1<<MOUSE4)
#define MOUSE4_UP       DDRD &= ~(1<<MOUSE4)
#define MOUSE4_READ     (!(PIND & (1<<MOUSE4)))

#define MOUSE5          6
#define MOUSE5_DOWN     DDRD |= (1<<MOUSE5)
#define MOUSE5_UP       DDRD &= ~(1<<MOUSE5)
#define MOUSE5_READ     (!(PIND & (1<<MOUSE5)))

#define ADC_KEYBOARD    0
#define ADC_DIODE1      2
#define ADC_DIODE2      1

extern uint8_t diodeThresh;
extern uint8_t keyboardThresh;

typedef enum BtnIO BtnIO;
enum BtnIO {
    B_write,
    B_read,
};



void pin_init(uint8_t button, BtnIO io);