import core.sys.windows.winbase;
import core.sys.windows.windef;
import core.sys.windows.winuser;
import std;
import core.thread;

enum Hotkey : ushort {
    frameRateUp,
    frameRateUpNoInput,
    frameRateReset,
    frameRateDefault,
}

__gshared Duration menuLoadTime     = 800.msecs;
__gshared Duration escMenuOpenTime  = 500.msecs;
__gshared Duration tick             = 17.msecs;

enum Coordinates {
    videoMenu = POINT(3330, 3640),
}

POINT cursorPos(){
    POINT p;
    GetCursorPos(&p);
    p.x = p.x*ushort.max/2560;
    p.y = p.y*ushort.max/1440;
    return p;
}

void main(string[] args){
    ushort  key                 = VK_F8;
    int     defaultFramerate    = 144;
    int     tick_ms             = 17;
    
    getopt(args, 
        "k|key",                &key,
        "f|defaultframerate",   &defaultFramerate,
        "t|tick",               &tick_ms,
    );
    tick = tick_ms.msecs;
    
    RegisterHotKey(null, Hotkey.frameRateUp,        0x4000, key);
    RegisterHotKey(null, Hotkey.frameRateUpNoInput, 0x4002, key);   // Ctrl + <key>
    RegisterHotKey(null, Hotkey.frameRateReset,     0x4003, key);   // Ctrl + Alt + <key>
    RegisterHotKey(null, Hotkey.frameRateDefault,   0x4007, key);   // Ctrl + Alt + Shift + <key>
    
    auto frameRates = [400, 346, 300, 260, 225, 195, 169, 146, 128, 110, 95, 82, 71, 62, 53, 46, 40, 35, 30];
    size_t frameRateIdx = 0;
    
    void frameRateCycleUp(){
        frameRateIdx++;
        if(frameRateIdx >= frameRates.length){
            frameRateIdx = 0;
        }
        writefln("%3d fps loaded", frameRates[frameRateIdx]);
    }
    
    INPUT[] inputs;
    
    auto msg = MSG();
    while(GetMessage(&msg, null, 0, 0) != 0){
        if(msg.message == WM_HOTKEY){
            final switch(msg.wParam) with(Hotkey){
            case frameRateUp:
                inputs.inputFrameRateCap(frameRates[frameRateIdx]);
                inputs.doInputSequence();
                frameRateCycleUp();
                break;
            case frameRateUpNoInput:
                frameRateCycleUp();
                break;
            case frameRateReset:
                Thread.sleep(800.msecs);
                inputs.inputFrameRateCap(frameRates[0]);
                inputs.doInputSequence();
                frameRateIdx = 1;
                break;
            case frameRateDefault:
                Thread.sleep(800.msecs);
                inputs.inputFrameRateCap(defaultFramerate);
                inputs.doInputSequence();
                import core.stdc.stdlib;
                exit(0);
                return;
            }
        }
    }
}


void doInputSequence(ref INPUT[] inputs){
    for(size_t idx; idx < inputs.length; idx++){
        SendInput(1, &inputs[idx], INPUT.sizeof);
        Thread.sleep(tick);
    }
    inputs = null;
}

void inputOpenVideoMenu(ref INPUT[] inputs){
    inputs.inputVKey(VK_ESCAPE);
    inputs.inputNop((escMenuOpenTime/tick + 1).to!uint);
    inputs.inputVKey(VK_DOWN, 2);
    inputs.inputVKey(VK_SPACE);
    inputs.inputNop((menuLoadTime/tick + 1).to!uint);
    inputs.inputClickOn(Coordinates.videoMenu);
    inputs.inputNop((menuLoadTime/tick + 1).to!uint);
    inputs.inputVKey(VK_TAB);
}

void inputFrameRateCap(ref INPUT[] inputs, int fps){
    inputs.inputOpenVideoMenu();
    
    // toggle-reset reduce buffering
    inputs.inputVKey(VK_DOWN, 7);
    inputs.inputVKey(VK_RIGHT, 1);
    inputs.inputVKey(VK_RETURN);
    inputs.inputVKey(VK_RIGHT, 1);
    inputs.inputVKey(VK_RETURN);
    
    // set new fps cap    
    inputs.inputVKey(VK_DOWN, 7);
    foreach(ch; fps.to!string){
        inputs.inputVKey(cast(ushort)ch);
    }
    inputs.inputVKey(VK_RETURN);
    
    // close menu
    inputs.inputNop(1);
    inputs.inputVKey(VK_ESCAPE);
    inputs.inputNop(1);
    inputs.inputVKey(VK_ESCAPE);
}


void inputNop(ref INPUT[] inputs, uint count){
    foreach(i; 0 .. count){
        inputs ~= INPUT(INPUT_MOUSE, MOUSEINPUT(0, 0, 0, 0, 0, 0));
    }
}

void inputMove(ref INPUT[] inputs, POINT p){
    inputs ~= INPUT(INPUT_MOUSE, MOUSEINPUT(p.x, p.y, 0, MOUSEEVENTF_MOVE | MOUSEEVENTF_ABSOLUTE, 0, 0));
}

void inputClickOn(ref INPUT[] inputs, POINT p){
    inputs.inputMove(p);
    inputs ~= INPUT(INPUT_MOUSE, MOUSEINPUT(0, 0, 0, MOUSEEVENTF_LEFTDOWN, 0, 0));
    inputs ~= INPUT(INPUT_MOUSE, MOUSEINPUT(0, 0, 0, MOUSEEVENTF_LEFTUP, 0, 0));
}

void inputScroll(ref INPUT[] inputs, int n){
    // n>0 : up   |   n<0 : down
    INPUT input;
    int dir     = (n>0) ? 1 : -1;
    int count   = abs(n);
    foreach(i; 0 .. count){
        inputs ~= INPUT(INPUT_MOUSE, MOUSEINPUT(0, 0, dir, MOUSEEVENTF_WHEEL, 0, 0));
    }
}

void inputVKey(ref INPUT[] inputs, ushort vk, uint repeat = 1){
    foreach(i; 0 .. repeat){
        inputs ~= INPUTk(KEYBDINPUT(vk, 0, 0, 0, 0));
        inputs ~= INPUTk(KEYBDINPUT(vk, 0, KEYEVENTF_KEYUP, 0, 0));
    }
}

INPUT INPUTk(KEYBDINPUT ki){
    INPUT input;
    input.type = INPUT_KEYBOARD;
    input.ki = ki;
    return input;
}