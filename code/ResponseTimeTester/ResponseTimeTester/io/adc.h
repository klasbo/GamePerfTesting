#pragma once

#include <avr/io.h>

void adc_init_freerun(uint8_t channelSelection);
uint8_t adc_read_freerun(void);
void adc_init_single(void);
uint8_t adc_read_single(uint8_t channelSelection);