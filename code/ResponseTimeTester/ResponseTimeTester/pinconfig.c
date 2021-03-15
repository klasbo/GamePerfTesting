#include "pinconfig.h"

void pin_init(uint8_t button, BtnIO io){
    switch(io){
    case B_write:
        PORTD   &= ~(1<<button);
        return;
    case B_read:
        DDRD    |=  (1<<button);
        PORTD   |=  (1<<button);
        return;
    }
}

uint8_t diodeThresh    = 16;
uint8_t keyboardThresh = 16;