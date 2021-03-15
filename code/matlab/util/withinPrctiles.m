function out = withinPrctiles(range, prctiles)
    out = range(ceil(prctiles(1)*length(range)/100):floor(prctiles(2)*length(range)/100), :);
end