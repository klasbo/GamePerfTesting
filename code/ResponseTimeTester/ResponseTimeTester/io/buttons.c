
#include "buttons.h"
#include "uart.h"

#include <avr/io.h>
#include <util/delay.h>
#include <avr/sleep.h>
#include <avr/interrupt.h>


__attribute__((constructor)) void buttons_init(void){
    DDRB  = (1<<DDB0) | (1<<DDB2) | (1<<DDB4) | (1<<DDB6);
    PORTB = (1<<PB0)  | (1<<PB2)  | (1<<PB4)  | (1<<PB6);
}

uint8_t switch_read(uint8_t switch_id){
    if(switch_id > 3){
        return 0;
    }
    
    return !( PINB & (1 << (switch_id*2 + 1)) );
}

void led_set(uint8_t led_id, uint8_t value){
    if(led_id > 3){
        return;
    }
    
    if(value){
        PORTB &= ~(1 << (led_id*2));
    } else {
        PORTB |= (1 << (led_id*2));
    }
}


//ISR(PCINT0_vect){
//    sleep_disable();
//}


uint8_t switch_wait(){

    //PCICR = 1;
    //PCMSK0 = 0xaa;
    //sei();
    //_delay_ms(1);

    while(1){
        //set_sleep_mode(SLEEP_MODE_PWR_DOWN);
        //sleep_enable();
        //sleep_cpu();

        for(uint8_t i = 0; i < 4; i++){
            if(switch_read(i)){
                _delay_ms(5);
                while(switch_read(i)){}
                _delay_ms(5);
                //cli();
                return i;
            }
        }
    }
}