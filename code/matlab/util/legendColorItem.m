function legendColorItem(axes, color, text, varargin)


        p = inputParser;
        p.KeepUnmatched = true;
        addParameter(p, 'Marker',           's',            @ischar);
        addParameter(p, 'MarkerSize',       20,             @(a) isscalar(a) & isreal(a) & a>0);
        addParameter(p, 'MarkerFaceColor',  []);
        addParameter(p, 'Location',         'northwest',    @ischar);
        parse(p, varargin{:});

        markerFaceColor = p.Results.MarkerFaceColor;
        if isempty(markerFaceColor)
            markerFaceColor = color;
        end
            
        p_name = plot(axes, NaN, NaN, p.Results.Marker, ...
            'MarkerFaceColor', markerFaceColor, 'Color', color, ...
            'MarkerSize',p.Results.MarkerSize, ...
            'DisplayName',text);
        
        if isempty(axes.Legend)
            legend(axes, p_name, 'Location',p.Results.Location, 'AutoUpdate','off');
        else
            axes.Legend.PlotChildren(end+1) = p_name;
        end
end