function addLabel(ax, color, name)

    p = plot(NaN,NaN,'s', 'markersize',10, 'markerfacecolor',color, 'color',color, ...
        'displayname',name);
    
    if isempty(ax.Legend)
        legend(p, 'location','northeast','autoupdate','off');
    else
        lgd = ax.Legend;
        if strcmp(lgd.String{end}, name) == 0
            lgd.PlotChildren(end+1) = p;
        end
    end
end