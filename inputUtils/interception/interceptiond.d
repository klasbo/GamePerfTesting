
module interception.interceptiond;

import std;
import core.sys.windows.winbase;
import core.sys.windows.windef;
import core.sys.windows.winuser;
import core.sys.windows.winioctl;
import core.sys.windows.windows;
public import std.variant : visit;



alias KeyboardState = BitFlags!KS;
enum KS : ushort {
    down                = 0x00,
    up                  = 0x01,
    e0                  = 0x02,
    e1                  = 0x04,
    termsrvSetLed       = 0x08,
    termsrvShadow       = 0x10,
    termsrvVKPacket     = 0x20,
}

alias KeyboardStateFilter = BitFlags!(KSF, Yes.unsafe);
enum KSF : ushort  {
    none                = 0x0000,
    all                 = 0xffff,
    down                = KS.up,
    up                  = KS.up << 1,
    e0                  = KS.e0 << 1,
    e1                  = KS.e1 << 1,
    termsrvSetLed       = KS.termsrvSetLed << 1,
    termsrvShadow       = KS.termsrvShadow << 1,
    termsrvVKPacket     = KS.termsrvVKPacket << 1,
}

alias MouseState = BitFlags!MS;
enum MS : ushort {
    none                = 0,
    leftButtonDown      = 0x001,
    leftButtonUp        = 0x002,
    rightButtonDown     = 0x004,
    rightButtonUp       = 0x008,
    middleButtonDown    = 0x010,
    middleButtonUp      = 0x020,
    button1Down         = MS.leftButtonDown,
    button1Up           = MS.leftButtonUp,
    button2Down         = MS.rightButtonDown,
    button2Up           = MS.rightButtonUp,
    button3Down         = MS.middleButtonDown,
    button3Up           = MS.middleButtonUp,
    button4Down         = 0x040,
    button4Up           = 0x080,
    button5Down         = 0x100,
    button5Up           = 0x200,    
    wheel               = 0x400,
    hwheel              = 0x800,
}

alias MouseStateFilter = BitFlags!(MSF, Yes.unsafe);
enum MSF : ushort {
    none                = 0x0000,
    all                 = 0xffff,
    leftButtonDown      = MS.leftButtonDown,
    leftButtonUp        = MS.leftButtonUp,
    rightButtonDown     = MS.rightButtonDown,
    rightButtonUp       = MS.rightButtonUp,
    middleButtonDown    = MS.middleButtonDown,
    middleButtonUp      = MS.middleButtonUp,
    button1Down         = MS.button1Down,
    button1Up           = MS.button1Up,
    button2Down         = MS.button2Down,
    button2Up           = MS.button2Up,
    button3Down         = MS.button3Down,
    button3Up           = MS.button3Up,
    button4Down         = MS.button4Down,
    button4Up           = MS.button4Up,
    button5Down         = MS.button5Down,
    button5Up           = MS.button5Up,
    wheel               = MS.wheel,
    hwheel              = MS.hwheel,
    move                = 0x1000,
}

alias MouseSettings = BitFlags!MSt;
enum MSt : ushort {
    moveRelative        = 0x000,
    moveAbsolute        = 0x001,
    virtualDesktop      = 0x002,
    attributesChanged   = 0x004,
    moveNocoalesce      = 0x008,
    termsrvSrcShadow    = 0x100,
}

struct KeyboardStroke {
    ushort          id;
    ushort          code;
    KeyboardState   state;
    private ushort  reserved;
    uint            information;
}

struct MouseStroke {
    ushort          id;
    MouseSettings   settings;
    MouseState      state;
    short           rolling;
    private int     rawButtons;
    int             x;
    int             y;
    uint            information;
}

alias Stroke = Algebraic!(KeyboardStroke, MouseStroke);


struct KeyboardDevice {
    void* file;
    void* event;
}
    
struct MouseDevice {
    void* file;
    void* event;
}

alias Device = Algebraic!(KeyboardDevice, MouseDevice);

struct KeyboardEvent {
    KeyboardDevice device;
    KeyboardStroke stroke;
}

struct MouseEvent {
    MouseDevice device;
    MouseStroke stroke;
}

alias Event = Algebraic!(KeyboardEvent, MouseEvent);


enum numKeyboards   = 10;
enum numMice        = 10;
enum numDevices     = numKeyboards + numMice;

struct Devices {
    KeyboardDevice[numKeyboards]    keyboards;
    MouseDevice[numMice]            mice;
    string toString(){
        return format("Keyboards: \n%(  %s\n%)\nMice: \n%(  %s\n%)\n", keyboards, mice);
    }
}


private {
    enum IOCTL_SET_PRECEDENCE   = CTL_CODE_T!(FILE_DEVICE_UNKNOWN, 0x801, METHOD_BUFFERED, FILE_ANY_ACCESS);
    enum IOCTL_GET_PRECEDENCE   = CTL_CODE_T!(FILE_DEVICE_UNKNOWN, 0x802, METHOD_BUFFERED, FILE_ANY_ACCESS);
    enum IOCTL_SET_FILTER       = CTL_CODE_T!(FILE_DEVICE_UNKNOWN, 0x804, METHOD_BUFFERED, FILE_ANY_ACCESS);
    enum IOCTL_GET_FILTER       = CTL_CODE_T!(FILE_DEVICE_UNKNOWN, 0x808, METHOD_BUFFERED, FILE_ANY_ACCESS);
    enum IOCTL_SET_EVENT        = CTL_CODE_T!(FILE_DEVICE_UNKNOWN, 0x810, METHOD_BUFFERED, FILE_ANY_ACCESS);
    enum IOCTL_WRITE            = CTL_CODE_T!(FILE_DEVICE_UNKNOWN, 0x820, METHOD_BUFFERED, FILE_ANY_ACCESS);
    enum IOCTL_READ             = CTL_CODE_T!(FILE_DEVICE_UNKNOWN, 0x840, METHOD_BUFFERED, FILE_ANY_ACCESS);
    enum IOCTL_GET_HARDWARE_ID  = CTL_CODE_T!(FILE_DEVICE_UNKNOWN, 0x880, METHOD_BUFFERED, FILE_ANY_ACCESS);
}



Devices createDevices(){
    Devices devices;
    scope(failure){
        destroyDevices(devices);
    }
    
    size_t deviceIdx = 0;
    
    foreach(ref deviceType; devices.tupleof){
        foreach(ref dev; deviceType){
            auto deviceName = format("\\\\.\\interception%02d", deviceIdx++).toStringz;

            dev.file = CreateFileA(deviceName, GENERIC_READ, 0, null, OPEN_EXISTING, 0, null);
            if (dev.file == INVALID_HANDLE_VALUE){
                throw new Exception(format("Cannot open Interception device %s", deviceName.fromStringz));
            }

            dev.event = CreateEventA(null, TRUE, FALSE, null);
            if(dev.event == null){
                throw new Exception(format("Cannot create event for Interception device %s", deviceName.fromStringz));
            }
            
            DWORD bytesReturned;
            HANDLE[2] zeroPaddedHandle = [dev.event, null];
            if(!DeviceIoControl(dev.file, IOCTL_SET_EVENT, zeroPaddedHandle.ptr, zeroPaddedHandle.sizeof, null, 0, &bytesReturned, null)){
                throw new Exception(format("Cannot set event for Interception device %s", deviceName.fromStringz));
            }
        }
    }
    return devices;
}


void destroyDevices(ref Devices devices){
    foreach(ref deviceType; devices.tupleof){
        foreach(ref dev; deviceType){
            
            if(dev.file != INVALID_HANDLE_VALUE){
                CloseHandle(dev.file);
                dev.file = null;
            }

            if(dev.event != null){
                CloseHandle(dev.event);
                dev.event = null;
            }
        }
    }
}






version(none){
void setPrecedence(ref KeyboardDevice device, int precedence){
    DWORD bytesReturned;
    DeviceIoControl(device.file, IOCTL_SET_PRECEDENCE, &precedence, int.sizeof, null, 0, &bytesReturned, null);
}
void setPrecedence(ref MouseDevice device, int precedence){
    DWORD bytesReturned;
    DeviceIoControl(device.file, IOCTL_SET_PRECEDENCE, &precedence, int.sizeof, null, 0, &bytesReturned, null);
}
int getPrecedence(ref KeyboardDevice device){
    int precedence;
    DWORD bytesReturned;
    DeviceIoControl(device.file, IOCTL_GET_PRECEDENCE, null, 0, &precedence, int.sizeof, &bytesReturned, null);
    return precedence;
}
int getPrecedence(ref MouseDevice device){
    int precedence;
    DWORD bytesReturned;
    DeviceIoControl(device.file, IOCTL_GET_PRECEDENCE, null, 0, &precedence, int.sizeof, &bytesReturned, null);
    return precedence;
}
}

void setFilter(ref Devices devices, KeyboardStateFilter filter){
    DWORD bytesReturned;
    foreach(ref dev; devices.keyboards){
        DeviceIoControl(dev.file, IOCTL_SET_FILTER, &filter, filter.sizeof, null, 0, &bytesReturned, null);
    }
}
void setFilter(ref Devices devices, MouseStateFilter filter){
    DWORD bytesReturned;
    foreach(ref dev; devices.mice){
        DeviceIoControl(dev.file, IOCTL_SET_FILTER, &filter, filter.sizeof, null, 0, &bytesReturned, null);
    }
}

KeyboardStateFilter getFilter(KeyboardDevice device){
    DWORD bytesReturned;
    KeyboardStateFilter filter;
    DeviceIoControl(device.file, IOCTL_GET_FILTER, null, 0, &filter, filter.sizeof, &bytesReturned, null);
    return filter;
}
MouseStateFilter getFilter(MouseDevice device){
    DWORD bytesReturned;
    MouseStateFilter filter;
    DeviceIoControl(device.file, IOCTL_GET_FILTER, null, 0, &filter, filter.sizeof, &bytesReturned, null);
    return filter;
}



KeyboardStroke read(ref KeyboardDevice device){
    DWORD strokesread = 0;
    KeyboardStroke stroke;
    DeviceIoControl(device.file, IOCTL_READ, null, 0, &stroke, stroke.sizeof, &strokesread, null);
    return stroke;
}
MouseStroke read(ref MouseDevice device){
    DWORD strokesread = 0;
    MouseStroke stroke;
    DeviceIoControl(device.file, IOCTL_READ, null, 0, &stroke, stroke.sizeof, &strokesread, null);
    return stroke;
}

Device waitForEvent(ref Devices devices, uint wait_ms = uint.max){
    HANDLE[numDevices] waitHandles;
    uint deviceIdx;
    
    foreach(ref deviceType; devices.tupleof){
        foreach(ref dev; deviceType){
            waitHandles[deviceIdx++] = dev.event;
        }
    }
    
    auto k = WaitForMultipleObjects(deviceIdx, waitHandles.ptr, false, wait_ms);

    if(k == WAIT_FAILED  ||  k == WAIT_TIMEOUT){
        return Device.init;
    }

    foreach(ref deviceType; devices.tupleof){
        if(k > deviceType.length){
            k -= deviceType.length;
        } else {
            return Device(deviceType[k]);
        }
    }
    return Device.init;
}

Event receive(ref Devices devices, uint wait_ms = uint.max){
    Event ret;
    Device d = devices.waitForEvent(wait_ms);
    d.visit!(
        (KeyboardDevice a){
            ret = KeyboardEvent(d.get!KeyboardDevice, a.read());
        },
        (MouseDevice a){
            ret = MouseEvent(d.get!MouseDevice, a.read());
        },
        (){
            // no event
        },
    );
    return ret;
}

void write(ref KeyboardDevice device, KeyboardStroke[] strokes){
    DWORD strokesWritten;
    DeviceIoControl(device.file, IOCTL_WRITE, cast(void*)strokes.ptr, cast(uint)(strokes.length * KeyboardStroke.sizeof), null, 0, &strokesWritten, null);
}
void write(ref KeyboardDevice device, KeyboardStroke stroke){
    DWORD strokesWritten;
    DeviceIoControl(device.file, IOCTL_WRITE, &stroke, cast(uint)(KeyboardStroke.sizeof), null, 0, &strokesWritten, null);
}

void write(ref MouseDevice device, MouseStroke[] strokes){
    DWORD strokesWritten;
    DeviceIoControl(device.file, IOCTL_WRITE, cast(void*)strokes.ptr, cast(uint)(strokes.length * MouseStroke.sizeof), null, 0, &strokesWritten, null);
}
void write(ref MouseDevice device, MouseStroke stroke){
    DWORD strokesWritten;
    DeviceIoControl(device.file, IOCTL_WRITE, &stroke, cast(uint)(MouseStroke.sizeof), null, 0, &strokesWritten, null);
}

enum MAX_DEVICE_ID_LEN = 200;

uint getHWID(ref KeyboardDevice device, wchar[] buf){
    uint bytesReturned;
    DeviceIoControl(device.file, IOCTL_GET_HARDWARE_ID, null, 0, buf.ptr, cast(uint)(buf.length * wchar.sizeof), &bytesReturned, null);
    return bytesReturned/wchar.sizeof;
}
uint getHWID(ref MouseDevice device, wchar[] buf){
    uint bytesReturned;
    DeviceIoControl(device.file, IOCTL_GET_HARDWARE_ID, null, 0, buf.ptr, cast(uint)(buf.length * wchar.sizeof), &bytesReturned, null);
    return bytesReturned/wchar.sizeof;
}



























