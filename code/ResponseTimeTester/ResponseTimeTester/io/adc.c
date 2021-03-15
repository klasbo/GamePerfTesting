#include "adc.h"

// ADCFreq = CPUFreq / 2^prescalerbits
// prescaler bits range: [1..7]
// eg: 16MHz / 2^5  =  16MHz/32  =  500KHz
#define ADCPrescalerBits 7

#ifndef ADHSM 
    #define ADHSM 7
#endif

void adc_init_freerun(uint8_t channelSelection){
    ADCSRA = (1<<ADEN) | (1<<ADSC) | (1<<ADATE) | ADCPrescalerBits;
    ADCSRB = (1<<ADHSM);
    ADMUX  = (1<<ADLAR) | channelSelection;
}
uint8_t adc_read_freerun(void){
    //while( (ADCSRA & (1<<ADIF)) == 0 ){}
    //ADCSRA |= (1<<ADIF);
    return ADCH;
}
void adc_init_single(void){
    ADCSRA = (1<<ADEN) | ADCPrescalerBits;
    ADCSRB = (1<<ADHSM);
    ADMUX =  (1<<ADLAR);
}
uint8_t adc_read_single(uint8_t channelSelection){
    ADMUX = (1<<ADLAR) | channelSelection;
    ADCSRA |= (1<<ADSC);
    while( (ADCSRA & (1<<ADSC)) ){}
    return ADCH;
}