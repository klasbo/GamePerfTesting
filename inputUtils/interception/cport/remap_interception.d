// rdmd -m64 .\remap_interception.d

pragma(lib, "interception.lib");
import interceptiond;
import std;
import core.memory;


enum Scancode {
    F7 = 65,
}

enum RemapAction {xMove,
    leftClick,
}

enum action = RemapAction.leftClick;

void main(){
    writeln("started");
    GC.disable;
    InterceptionContext context = interception_create_context();
    scope(exit) interception_destroy_context(context);
    
    interception_set_filter(context, &interception_is_keyboard, InterceptionFilterKeyState.up | InterceptionFilterKeyState.down);
    interception_set_filter(context, &interception_is_mouse, InterceptionFilterMouseState.move);
    
    
    InterceptionDevice  unknownDevice;
    InterceptionStroke  stroke;
    InterceptionDevice  mouse;
    while(interception_receive(context, unknownDevice = interception_wait(context), &stroke, 1) > 0){
        interception_send(context, unknownDevice, &stroke, 1);
        if(interception_is_mouse(unknownDevice)){writefln("Mouse set to device %s", unknownDevice);
            mouse = unknownDevice;
            interception_set_filter(context, &interception_is_mouse, InterceptionFilterMouseState.none);
        }
        
        if(interception_is_keyboard(unknownDevice)){
            auto keyStroke = *cast(InterceptionKeyStroke*)&stroke;
            
            static if(action == RemapAction.xMove){
                if(keyStroke.code == Scancode.F7){
                    InterceptionMouseStroke mouseStroke = {
                        flags:  InterceptionMouseFlag.moveRelative,
                        x:      (keyStroke.state == InterceptionKeyState.down) ? -200 : 200,
                    };
                    interception_send(context, mouse, cast(InterceptionStroke*)&mouseStroke, 1);
                }
            } else static if(action == RemapAction.leftClick){
                if(keyStroke.code == Scancode.F7  &&  keyStroke.state == InterceptionKeyState.down){
                    InterceptionMouseStroke[2] mouseStroke = [
                        {state: InterceptionMouseState.leftButtonDown,  },
                        {state: InterceptionMouseState.leftButtonUp,    },
                    ];
                    interception_send(context, mouse, cast(InterceptionStroke*)mouseStroke.ptr, 2);
                }
            }
        }
    }
}