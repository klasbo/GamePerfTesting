function saveOpenFigs(folder, resolution)
    figures = findall(groot, 'type','figure');
    for fig_idx = 1:length(figures)
        f = figures(fig_idx);
        saveFig(f, sprintf('%s%03d-%s', folder, f.Number, filenameify(f.Name)), resolution);
    end
end