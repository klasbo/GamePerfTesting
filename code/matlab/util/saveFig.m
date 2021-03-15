function saveFig(fig, name, resolution)
    assert(isa(fig, 'matlab.ui.Figure'));
    assert(ischar(name));
    assert(isvector(resolution) & length(resolution)==2);

    style       = fig.WindowStyle;
    resize      = fig.Resize;
    innerPos    = fig.InnerPosition;
    
    res = [15 70 resolution(1) resolution(2)];
    fig.WindowStyle = 'normal';
    pause(0.15); % wait for the figure to properly undock
    fig.InnerPosition = res;
    
    hgexport(fig, [name '.png'], hgexport('factorystyle'), 'Format','png');
    
    fig.InnerPosition   = innerPos;
    fig.Resize          = resize;
    fig.WindowStyle     = style;
end