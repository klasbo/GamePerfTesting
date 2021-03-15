function out = consecutive(array, fn, n)

    out = all(cell2mat(arrayfun(@(nn) fn(circshift(array,nn)), -1*(0:n), 'un',0)), 2);

end
