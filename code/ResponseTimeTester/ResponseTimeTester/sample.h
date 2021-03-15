#pragma once

#include <stdint.h>

#include "pinconfig.h"


void doMakeFPSRange(uint16_t* fpsRange, uint8_t fpsRangeSize, uint8_t* idxLow, uint8_t* idxLen);

typedef struct AutoSampleSettings AutoSampleSettings;
struct AutoSampleSettings {
    uint8_t     mouseBtn;
    uint8_t     adcChan;
    uint16_t    samples;
    uint16_t    delay_ms;
};

AutoSampleSettings doMakeAutoSampleSettings();
void doSampleAuto(AutoSampleSettings* s);
void doSampleFPSRangeAuto(AutoSampleSettings s, uint16_t* fpsRange, uint8_t fpsRangeSize);

typedef enum ManualClickType ManualClickType;
enum ManualClickType {
    MCT_keyboard = 0,
    MCT_mouse4 = MOUSE4,
    MCT_mouse5 = MOUSE5,
};

typedef struct ManualSampleSettings ManualSampleSettings;
struct ManualSampleSettings {
    ManualClickType clickType;
    uint8_t         adcChan;
    uint8_t         samples;
    uint16_t        delay_ms;
};

ManualSampleSettings doMakeManualSampleSettings();
void doSampleManual(ManualSampleSettings* s);
void doSampleFPSRangeManual(ManualSampleSettings s, uint16_t* fpsRange, uint8_t fpsRangeSize);