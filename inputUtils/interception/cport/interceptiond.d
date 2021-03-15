

enum interceptionMaxKeyboard    = 10;
enum interceptionMaxMouse       = 10;
enum interceptionMaxDevice      = interceptionMaxKeyboard + interceptionMaxMouse;

int interceptionKeyboard(int index){
    return index + 1;
}

int interceptionMouse(int index){
    return interceptionMaxKeyboard + index + 1;
}

alias InterceptionContext       = void*;
alias InterceptionDevice        = int;
alias InterceptionPrecedence    = int;
alias InterceptionFilter        = ushort;

alias InterceptionPredicate = extern(C) int function(InterceptionDevice);

enum InterceptionKeyState : ushort {
    down                = 0x00,
    up                  = 0x01,
    e0                  = 0x02,
    e1                  = 0x04,
    termsrvSetLed       = 0x08,
    termsrvShadow       = 0x10,
    termsrvVKPacket     = 0x20,
}

enum InterceptionFilterKeyState : ushort {
    none                = 0x0000,
    all                 = 0xffff,
    down                = InterceptionKeyState.up,
    up                  = InterceptionKeyState.up << 1,
    e0                  = InterceptionKeyState.e0 << 1,
    e1                  = InterceptionKeyState.e1 << 1,
    termsrvSetLed       = InterceptionKeyState.termsrvSetLed << 1,
    termsrvShadow       = InterceptionKeyState.termsrvShadow << 1,
    termsrvVKPacket     = InterceptionKeyState.termsrvVKPacket << 1,
}

enum InterceptionMouseState : ushort {
    none                = 0,
    leftButtonDown      = 0x001,
    leftButtonUp        = 0x002,
    rightButtonDown     = 0x004,
    rightButtonUp       = 0x008,
    middleButtonDown    = 0x010,
    middleButtonUp      = 0x020,
    button1Down         = InterceptionMouseState.leftButtonDown,
    button1Up           = InterceptionMouseState.leftButtonUp,
    button2Down         = InterceptionMouseState.rightButtonDown,
    button2Up           = InterceptionMouseState.rightButtonUp,
    button3Down         = InterceptionMouseState.middleButtonDown,
    button3Up           = InterceptionMouseState.middleButtonUp,
    button4Down         = 0x040,
    button4Up           = 0x080,
    button5Down         = 0x100,
    button5Up           = 0x200,    
    wheel               = 0x400,
    hwheel              = 0x800,
}

enum InterceptionFilterMouseState : ushort {
    none                = 0x0000,
    all                 = 0xffff,
    leftButtonDown      = InterceptionMouseState.leftButtonDown,
    leftButtonUp        = InterceptionMouseState.leftButtonUp,
    rightButtonDown     = InterceptionMouseState.rightButtonDown,
    rightButtonUp       = InterceptionMouseState.rightButtonUp,
    middleButtonDown    = InterceptionMouseState.middleButtonDown,
    middleButtonUp      = InterceptionMouseState.middleButtonUp,
    button1Down         = InterceptionMouseState.button1Down,
    button1Up           = InterceptionMouseState.button1Up,
    button2Down         = InterceptionMouseState.button2Down,
    button2Up           = InterceptionMouseState.button2Up,
    button3Down         = InterceptionMouseState.button3Down,
    button3Up           = InterceptionMouseState.button3Up,
    button4Down         = InterceptionMouseState.button4Down,
    button4Up           = InterceptionMouseState.button4Up,
    button5Down         = InterceptionMouseState.button5Down,
    button5Up           = InterceptionMouseState.button5Up,
    wheel               = InterceptionMouseState.wheel,
    hwheel              = InterceptionMouseState.hwheel,
    move                = 0x1000,
}

enum InterceptionMouseFlag : ushort {
    moveRelative        = 0x000,
    moveAbsolute        = 0x001,
    virtualDesktop      = 0x002,
    attributesChanged   = 0x004,
    moveNocoalesce      = 0x008,
    termsrvSrcShadow    = 0x100,
}

struct InterceptionMouseStroke {
    InterceptionMouseState  state;
    InterceptionMouseFlag   flags;
    short                   rolling;
    int                     x;
    int                     y;
    uint                    information;
}

struct InterceptionKeyStroke {
    ushort                  code;
    InterceptionKeyState    state;
    uint                    information;
}


alias InterceptionStroke = char[InterceptionMouseStroke.sizeof];


extern(C){
    InterceptionContext interception_create_context();
    void interception_destroy_context(InterceptionContext context);
    
    InterceptionPrecedence interception_get_precedence(InterceptionContext context, InterceptionDevice device);
    void interception_set_precedence(InterceptionContext context, InterceptionDevice device, InterceptionPrecedence precedence);
    
    InterceptionFilter interception_get_filter(InterceptionContext context, InterceptionDevice device);
    void interception_set_filter(InterceptionContext context, InterceptionPredicate predicate, InterceptionFilter filter);
    
    InterceptionDevice interception_wait(InterceptionContext context);
    InterceptionDevice interception_wait_with_timeout(InterceptionContext context, ulong milliseconds);
    
    int interception_send(InterceptionContext context, InterceptionDevice device, const InterceptionStroke* stroke, uint nstroke);
    int interception_receive(InterceptionContext context, InterceptionDevice device, InterceptionStroke* stroke, uint nstroke);
    
    uint interception_get_hardware_id(InterceptionContext context, InterceptionDevice device, void* hardware_id_buffer, uint buffer_size);
    
    int interception_is_invalid(InterceptionDevice device);
    int interception_is_keyboard(InterceptionDevice device);
    int interception_is_mouse(InterceptionDevice device);
    
}


