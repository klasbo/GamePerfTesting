function filename = filenameify(string)

    src = {'<' '>' ':' '"' '/' '\' '|' '?' '*' ' '};
    dst = {'(' ')' '-' ''  '-' '-' '-' ''  '-' '-'};

    filename = '';
    for i = 1:length(string)
        [ismem, idx] = ismember(string(i), src);
        if ismem
            filename = [filename, dst{idx}];
        else
            filename = [filename, lower(string(i))];
        end
    end
    
    filename = regexprep(filename, '-+', '-');
    
end