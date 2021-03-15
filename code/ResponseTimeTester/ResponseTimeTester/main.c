#include <avr/io.h>
#include <avr/eeprom.h>
#include <util/delay.h>
#include <stdlib.h>

#include "io/uart.h"
#include "io/buttons.h"
#include "io/adc.h"

#include "pinconfig.h"
#include "sample.h"
#include "boardtest.h"





EEMEM uint32_t seed;
uint32_t unpredictableSeed(void){
    uint32_t i;
    eeprom_read_block(&i, &seed, sizeof(seed));
    i = rand_r(&i);
    eeprom_write_block(&i, &seed, sizeof(seed));
    return i;
}




int main(void){
    uart_init();
    uart_printf("\nstarted\n");
    srand(unpredictableSeed());

    uint16_t fpsRange[19] = {400, 346, 300, 260, 225, 195, 169, 146, 128, 110, 95, 82, 71, 62, 53, 46, 40, 35, 30};
    uint8_t fpsRangeStart   = 0;
    uint8_t fpsRangeEnd     = 12;

    while(1){
        uart_printf(
            "Main:\n"
            "  3: Auto input\n"
            "  2: Auto input fps range\n"
            "  1: Manual input\n"
            "  0: Board test mode\n");
        switch(switch_wait()){
        case 3:{
            AutoSampleSettings s = doMakeAutoSampleSettings();
            led_set(3, 1);
            doSampleAuto(&s);
            led_set(3, 0);
            break;
        }
        case 2:{
            AutoSampleSettings s = doMakeAutoSampleSettings();
            doMakeFPSRange(fpsRange, sizeof(fpsRange)/sizeof(fpsRange[0]), &fpsRangeStart, &fpsRangeEnd);

            led_set(2, 1);
            doSampleFPSRangeAuto(s, &fpsRange[fpsRangeStart], fpsRangeEnd-fpsRangeStart);
            led_set(2, 0);
            break;
        }
        case 1:{
            ManualSampleSettings s = doMakeManualSampleSettings();
            doMakeFPSRange(fpsRange, sizeof(fpsRange)/sizeof(fpsRange[0]), &fpsRangeStart, &fpsRangeEnd);

            led_set(1, 1);
            doSampleFPSRangeManual(s, &fpsRange[fpsRangeStart], fpsRangeEnd-fpsRangeStart);
            led_set(1, 0);
            break;
        }
        case 0:
            doBoardTestMode();
            break;
        }
    }
    while(1){}
}

