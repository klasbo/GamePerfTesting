#pragma once

#include <stdint.h>

uint8_t switch_read(uint8_t switch_id);
void led_set(uint8_t led_id, uint8_t value);
uint8_t switch_wait();