#include "uart.h"

#include <stdio.h>
#include <avr/io.h>

#define ubrr (F_CPU/16/UART_BAUD - 1)

static FILE uart_stdout = FDEV_SETUP_STREAM((int(*)(char, struct __file *))uart_putchar, NULL, _FDEV_SETUP_WRITE);

void uart_init(void){
    UBRR1 = (unsigned long)(ubrr);
    
    UCSR1B  |=  (1<<TXEN1);         // transmit enable
    
    UCSR1C  |=  (0b11 << UCSZ10);   // char size to 8
    
    stdout = &uart_stdout;
}


int uart_putchar(char c){
    while( !(UCSR1A & (1<<UDRE1)) ){}
    
    UDR1 = c;
    
    return 0;
}

__attribute__((format(printf, 1, 2)))
void uart_printf(char const * fmt, ...){
    va_list v;
    va_start(v, fmt);
    vfprintf(&uart_stdout, fmt, v);
    va_end(v);
}