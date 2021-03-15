#include "sample.h"

#include "io/buttons.h"
#include "io/uart.h"
#include "io/adc.h"

#include "pinconfig.h"

#include <avr/io.h>
#include <util/delay.h>
#include <stdlib.h>
#include <math.h>

float timerPrescalerToResolutionMs(uint8_t prescaler){
    return pow(2, 2*prescaler) / (F_CPU/1000);
}

void doMakeFPSRange(uint16_t* fpsRange, uint8_t fpsRangeSize, uint8_t* low, uint8_t* high){
    #define set_low 0
    #define set_high 1
    uint8_t setting = 0;
    led_set(0, 1);
    while(1){
        uart_printf("Range: %3d%s%3d\n", fpsRange[*low], (setting == set_low) ? ".- " : " -.", fpsRange[*high]);
        switch(switch_wait()){
        case 3:
            if(setting == set_low){
                (*low)--;
                if(*low == 0xff){
                    *low = 0;
                }
            } else {
                (*high)--;
                if(*high < *low){
                    (*high)++;
                }
            }
            break;
        case 2:
            if(setting == set_low){
                (*low)++;
                if(*low > fpsRangeSize){
                    *low = 0;
                }
                if(*low > *high){
                    (*low)--;
                }
            } else {
                (*high)++;
                if(*high >= fpsRangeSize){
                    (*high)--;
                }
            }
            break;
        case 1:
            setting = (setting == set_low) ? set_high : set_low;
            break;
        case 0:
            led_set(0, 0);
            return;
        }
    }
}

void doSampleFPSRange(void* settings, uint16_t* fpsRange, uint8_t fpsRangeSize, void doBetween(void*), void doSample(void*)){
    uart_printf("    {\n        \"properties\": [\n        ],\n        \"values\": [\n");
    for(uint8_t f = 0; f <= fpsRangeSize; f++){
        if(f != 0){
            doBetween(settings);
        }

        uart_printf("            {\"fps\": %3d, \"samples\": [", fpsRange[f]);
        doSample(settings);
        uart_printf("]}%s\n", f==fpsRangeSize ? "" : ",");
    }
    uart_printf("        ]\n    },\n");
}


ManualSampleSettings doMakeManualSampleSettings(){
    static ManualClickType  clickType   = MCT_keyboard;
    uint16_t                samples[4]  = {5, 20, 50, 100};
    static uint8_t          samples_idx = 1;
    uint16_t                delays[6]   = {1, 17, 70, 250, 600, 1100};
    static uint8_t          delays_idx  = 4;
    ManualSampleSettings s = (ManualSampleSettings){
        .clickType  = clickType,
        .adcChan    = ADC_DIODE1,
        .samples    = samples[samples_idx],
        .delay_ms   = delays[delays_idx],
    };
    uart_printf("Manual sample settings: \n key:     %s \n samples: %d \n delay:   %d\n",
        (s.clickType == MCT_keyboard) ? "keyboard" : (s.clickType == MCT_mouse4) ? "mouse4" : "mouse5",
        s.samples, s.delay_ms);
    led_set(0, 1);
    while(1){
        switch(switch_wait()){
        case 3:
            clickType = (s.clickType == MCT_keyboard) ? MCT_mouse4 :
                        (s.clickType == MCT_mouse4)   ? MCT_mouse5 :
                                                        MCT_keyboard;
            s.clickType = clickType;
            uart_printf("key: %\n", (s.clickType == MCT_keyboard) ? "keyboard" : (s.clickType == MCT_mouse4) ? "mouse4" : "mouse5");
            break;
        case 2:
            samples_idx = (++samples_idx == sizeof(samples)/sizeof(samples[0])) ? 0 : samples_idx;
            s.samples = samples[samples_idx];
            uart_printf("samples: %d\n", s.samples);
            break;
        case 1:
            delays_idx = (++delays_idx == sizeof(delays)/sizeof(delays[0])) ? 0 : delays_idx;
            s.delay_ms = delays[delays_idx];
            uart_printf("delay: %d\n", s.delay_ms);
            break;
        case 0:
            led_set(0, 0);
            return s;
        }
    }
}

void doBetweenManual(ManualSampleSettings* s __attribute__((unused))){
    led_set(0, 1);
    while(!switch_read(0)){}
    led_set(0, 0);
}

void doSampleManual(ManualSampleSettings* s){
    if(s->clickType == MCT_keyboard){
        TCCR3B = 3;
        for(uint8_t iter = 0; iter < s->samples; iter++){
            adc_init_freerun(ADC_KEYBOARD);
            _delay_ms(5);
            while(adc_read_freerun() > keyboardThresh){}
            while(adc_read_freerun() < keyboardThresh){}
            TCNT3 = 0;
            adc_init_freerun(s->adcChan & 0x03);
            
            while(adc_read_freerun() < diodeThresh){}
            uint16_t t = TCNT3;
            
            uart_printf("%s%.3f", iter ? ", " : "", t*timerPrescalerToResolutionMs(TCCR3B));
            for(uint16_t i = 0; i < s->delay_ms; i++){
                _delay_ms(1);
            }
        }
    } else {
        adc_init_freerun(s->adcChan & 0x03);
        pin_init(s->clickType, B_read);
        TCCR3B = 3;
        
        for(uint8_t iter = 0; iter < s->samples; iter++){
            while(PIND & (1 << s->clickType)){}
            TCNT3 = 0;
            
            while(adc_read_freerun() < diodeThresh){}
            uint16_t t = TCNT3;
            
            uart_printf("%s%.3f", iter ? ", " : "", t*timerPrescalerToResolutionMs(TCCR3B));
            while(!(PIND & (1 << s->clickType))){}
            for(uint16_t i = 0; i < s->delay_ms; i++){
                _delay_ms(1);
            }
        }
    }
}

void doSampleFPSRangeManual(ManualSampleSettings s, uint16_t* fpsRange, uint8_t fpsRangeSize){
    doSampleFPSRange(&s, fpsRange, fpsRangeSize, (void(*)(void*))&doBetweenManual, (void(*)(void*))&doSampleManual);
}



AutoSampleSettings doMakeAutoSampleSettings(){
    static uint8_t  btn         = MOUSE5;
    uint16_t        samples[6]  = {5, 50, 100, 150, 300, 1000};
    static uint8_t  samples_idx = 1;
    uint16_t        delays[7]   = {1, 10, 30, 80, 150, 300, 1100};
    static uint8_t  delays_idx  = 0;
    AutoSampleSettings s = (AutoSampleSettings){
        .mouseBtn   = btn,
        .adcChan    = ADC_DIODE1,
        .samples    = samples[samples_idx],
        .delay_ms   = delays[delays_idx],
    };
    led_set(0, 1);
    uart_printf("Auto sample settings: \n mouse button: %s\n samples:      %d\n min. delay:   %d\n",
        (s.mouseBtn == MOUSE4) ? "mouse4" : "mouse5", s.samples, s.delay_ms);
    while(1){
        switch(switch_wait()){
        case 3:
            btn = (s.mouseBtn == MOUSE4) ? MOUSE5 : MOUSE4;
            s.mouseBtn = btn;
            uart_printf("button: %s\n", (s.mouseBtn == MOUSE4) ? "mouse4" : "mouse5");
            break;
        case 2:
            samples_idx = (++samples_idx == sizeof(samples)/sizeof(samples[0])) ? 0 : samples_idx;
            s.samples = samples[samples_idx];
            uart_printf("samples: %d\n", s.samples);
            break;
        case 1:
            delays_idx = (++delays_idx == sizeof(delays)/sizeof(delays[0])) ? 0 : delays_idx;
            s.delay_ms = delays[delays_idx];
            uart_printf("delay: %d\n", s.delay_ms);
            break;
        case 0:
            led_set(0, 0);
            return s;
        }
    }
}

void doBetweenAuto(AutoSampleSettings* s){
    uint8_t fpsChangeButton = (s->mouseBtn == MOUSE4) ? MOUSE5 : MOUSE4;
    pin_init(fpsChangeButton, B_write);

    _delay_ms(150);
    DDRD |= (1 << fpsChangeButton);
    _delay_ms(50);
    DDRD &= ~(1 << fpsChangeButton);
    _delay_ms(3600);
}

void doSampleAuto(AutoSampleSettings* s){
    adc_init_freerun(s->adcChan & 0x03);
    pin_init(s->mouseBtn, B_write);

    TCCR3B = 3;

    for(uint16_t iter = 0; iter < s->samples; iter++){
        // wait
        while(adc_read_freerun() > diodeThresh){}
        for(uint16_t i = 0; i < s->delay_ms; i++){
            _delay_ms(1);
        }
        uint16_t r = rand();
        for(uint16_t d = 0; d < r; d++){
            _delay_us(1);
        }
        
        // sample
        DDRD |= (1 << s->mouseBtn);
        TCNT3 = 0;
        while(adc_read_freerun() < diodeThresh){}
        uint16_t t = TCNT3;
        DDRD &= ~(1 << s->mouseBtn);
        
        if(t*timerPrescalerToResolutionMs(TCCR3B) < 5.0){
            iter--;
            continue;
        }            

        // print
        uart_printf("%s%.3f", iter ? ", " : "", t*timerPrescalerToResolutionMs(TCCR3B));
    }
}

void doSampleFPSRangeAuto(AutoSampleSettings s, uint16_t* fpsRange, uint8_t fpsRangeSize){
    doSampleFPSRange(&s, fpsRange, fpsRangeSize, (void(*)(void*))&doBetweenAuto, (void(*)(void*))&doSampleAuto);
}