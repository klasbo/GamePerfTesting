#pragma once

void uart_init(void);
int uart_putchar(char c);
void uart_printf(char const * fmt, ...);