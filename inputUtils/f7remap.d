

import std.stdio : writeln, writefln;
import std.getopt;
import interception.interceptiond;

enum Scancode : ushort {
    E  = 18,
    F7 = 65,
    F9 = 67,
}

enum Action {
    move,
    click,
}

void main(string[] args){
    Action action;
    int x = 200;
    int y = 0;
    ushort remapSourceScancode = Scancode.F7;
    getopt(args,
        "a|action", &action,
        "x",        &x,
        "y",        &y,
        "s|source", &remapSourceScancode,
    );

    Devices devices = createDevices();
    scope(exit) destroyDevices(devices);
    
    setFilter(devices, KeyboardStateFilter(KSF.up, KSF.down));
    scope(exit) setFilter(devices, KeyboardStateFilter(KSF.none));
    setFilter(devices, MouseStateFilter(MSF.move));
    scope(exit) setFilter(devices, MouseStateFilter(MSF.none));
    
    MouseDevice mouse;
    
    writefln("Move the mouse that should send the remapped action (%s)...", action);

    auto loop = true;
    while(loop){
        devices.receive.visit!(
            (MouseEvent e){
                e.device.write(e.stroke);
                mouse = e.device;
                setFilter(devices, MouseStateFilter(MSF.none));
                writefln("Mouse set to device %s", e.stroke.id);
            },
            (KeyboardEvent e){
                //writeln(e);
                e.device.write(e.stroke);
                if(e.stroke.code == remapSourceScancode){
                    final switch(action) with(Action){
                    case click:
                        MouseStroke click = {
                            state: (e.stroke.state == KeyboardState(KS.down)) 
                                ? MouseState(MS.leftButtonDown) 
                                : MouseState(MS.leftButtonUp),
                        };
                        mouse.write(click);
                        break;
                    case move:
                        MouseStroke move = {
                            settings:   MouseSettings(MSt.moveRelative),
                            x:          (e.stroke.state == KeyboardState(KS.down)) ? -x : x,
                            y:          (e.stroke.state == KeyboardState(KS.down)) ? -y : y,
                        };
                        mouse.write(move);
                        break;
                    }
                }
                //if(e.stroke.code == Scancode.F9){
                //    writeln("quit");
                //    loop = false;
                //}
            }
        );
    }
}

