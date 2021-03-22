

import std.stdio : writeln, writefln;
import std.getopt;
import interception.interceptiond;
import std.concurrency : spawn;
import core.thread;



void main(string[] args){

    Devices devices = createDevices();
    scope(exit) destroyDevices(devices);
    
    setFilter(devices, KeyboardStateFilter(KSF.down));
    scope(exit) setFilter(devices, KeyboardStateFilter(KSF.none));
    setFilter(devices, MouseStateFilter(MSF.move));
    scope(exit) setFilter(devices, MouseStateFilter(MSF.none));
    

    int x;
    int y;

    while(true){
        devices.receive.visit!(
            (MouseEvent e){
                e.device.write(e.stroke);
                x += e.stroke.x;
                y += e.stroke.y;
            },
            (KeyboardEvent e){
                e.device.write(e.stroke);
                if(e.stroke.code == 65){
                    writefln!("%+6d  %+6d")(x, y);
                    x = 0;
                    y = 0;
                }
            }
        );
    }
}

