#include "boardtest.h"

#include <avr/io.h>
#include <util/delay.h>

#include "io/uart.h"
#include "io/buttons.h"
#include "io/adc.h"

#include "pinconfig.h"

void doTestADCChans(){
    led_set(0, 1);
    adc_init_single();
    TCCR3B = 1;
    while(1){
        _delay_ms(50);
        uart_printf("\n");
        for(uint8_t chan = 0; chan <= 2; chan++){
            uint8_t thresh = (chan == 0) ? keyboardThresh : diodeThresh;
            TCNT3 = 0;
            uint8_t v = adc_read_single(chan);
            uint8_t t = TCNT3;
            uart_printf("%d %3d %3d %s: ", chan, t, v, (v > thresh) ? "#" : "-");
            for(uint8_t i = 1; i < v/4; i++){
                uart_printf("#");
            }
            uart_printf("\n");
        }
        if(switch_read(2)){
            diodeThresh *= 2;
            if(diodeThresh == 0){ diodeThresh = 1; }
            uart_printf("diode threshold: %d\n", diodeThresh);
            while(switch_read(2)){}
        }
        if(switch_read(1)){
            keyboardThresh *= 2;
            if(keyboardThresh == 0){ keyboardThresh = 1; }
            uart_printf("keyboard threshold: %d\n", keyboardThresh);
            while(switch_read(1)){}
        }
        if(switch_read(0)){
            while(switch_read(0)){}
            led_set(0, 0);
            return;
        }
    }
}

void doTestMouseButton(uint8_t btn){
    led_set(0, 1);
    uint8_t prettyBtn = (btn == MOUSE4) ? 4 : 5;
    uart_printf(
        "Mouse button test:\n"
        "  2: Mouse%d down\n"
        "  1: Mouse%d up\n"
        "  0: return\n", prettyBtn, prettyBtn);
    while(1){
        switch(switch_wait()){
        case 3:
            break;
        case 2:
            DDRD |= (1 << btn);
            break;
        case 1:
            DDRD &= ~(1 << btn);
            break;
        case 0:
            led_set(0, 0);
            return;
        }
    }
}

void doBoardTestMode(){
    while(1){
        uart_printf(
            "Test mode:\n"
            "  3: Read ADC channels\n"
            "  2: Mouse5\n"
            "  1: Mouse4\n"
            "  0: return\n");
        switch(switch_wait()){
        case 3:
            doTestADCChans();
            break;
        case 2:
            doTestMouseButton(MOUSE5);
            break;
        case 1:
            doTestMouseButton(MOUSE4);
            break;
        case 0:
            return;
        }
    }
}