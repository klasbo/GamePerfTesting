function m = map(initializer, isUniform)

    if nargin < 2
        isUniform = true;
    end

    if isa(initializer, 'cell')
        if isempty(initializer)
            m = containers.Map('UniformValues',isUniform);
        else
            if size(initializer,1) == 1  &&  mod(size(initializer,2), 2) == 0  &&  size(initializer,2) > 2
                initializer = reshape(initializer, 2, [])';
            end
            m = containers.Map(initializer(:,1), initializer(:,2), 'UniformValues',isUniform);
        end
    elseif isa(initializer, 'containers.Map')
        if initializer.Count == 0
            m = containers.Map();
        else
            m = containers.Map(keys(initializer), values(initializer), 'UniformValues',isUniform);
        end
    end
end