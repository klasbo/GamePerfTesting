classdef LagData
    properties (Access = private)
        data
        propDefault
        propValid
    end
    methods
        function this = LagData(dataFile, propertyFile)
            decoded = jsondecode(fileread(dataFile));
            idx = 1;
            for item_idx = 1:length(decoded)
                if ischar(decoded{item_idx})
                    continue    % string elements are comments
                end
                if isempty(decoded{item_idx}.values)
                    continue
                end
                this.data(idx).properties = reshape(decoded{item_idx}.properties, 2, [])';
                this.data(idx).values = {decoded{item_idx}.values.fps; decoded{item_idx}.values.samples}';
                idx = idx+1;
            end
            
            decoded = jsondecode(fileread(propertyFile));
            this.propDefault = containers.Map();
            this.propValid = containers.Map();
            for prop_idx = 1:length(decoded)
                if ischar(decoded{prop_idx})
                    continue    % string elements are comments
                end
                this.propDefault(decoded{prop_idx}{1})   = decoded{prop_idx}{2};
                validator = decoded{prop_idx}{3};
                if ischar(validator)
                    this.propValid(decoded{prop_idx}{1}) = @(a) ~isempty(regexp(a, validator, 'once'));
                elseif isempty(validator)
                    this.propValid(decoded{prop_idx}{1}) = @(a) true;
                else
                    this.propValid(decoded{prop_idx}{1}) = decoded{prop_idx}{3};
                end
            end
                        
            for idx = 1:length(this.data)
                props = this.data(idx).properties;
                assert(isempty(props) || size(props, 2) == 2, ...
                    sprintf('Item %d: Properties must be n-by-2 cell array', idx));
                for propNum = 1:size(props, 1)
                    % check for valid property name
                    propName = props{propNum, 1};
                    assert(ismember(propName, keys(this.propDefault)), ...
                        sprintf('Item %d: Property ''%s'' is unknown', idx, propName))
                end
                    
                for propNum = 1:size(props, 1)
                    % check for valid property value
                    propName = props{propNum, 1};
                    propValue = props{propNum, 2};
                    propConstraint = this.propValid(propName);
                    if isa(propConstraint, 'function_handle')
                        assert(propConstraint(propValue),...
                            sprintf('Item %d: Property ''%s'': Value ''%s'' does not satisfy the constraint (%s)',...
                            idx, propName, propValue, func2str(propConstraint)))
                    elseif iscellstr(propConstraint) %#ok<ISCLSTR>
                        assert(ismember(propValue, propConstraint),...
                            sprintf('Item %d: Property ''%s'': Value ''%s'' is not one of (%s)',...
                            idx, propName, propValue, char(join(propConstraint, ', '))))
                    end

                    % check for no duplicates
                    for jdx = 1:idx-1
                        [lagData_uniq, ~] = this.uniqueProperties([this.data(idx), this.data(jdx)]);
                        assert(~isempty(lagData_uniq),...
                            sprintf('Item %d: Shares all properties with previous item %d',...
                            idx, jdx));
                    end
                end
            end
            
        end
        
        function items = search(this, searchSpec)
            baseSearchMap = map(searchSpec, false);

            idxs = true(length(this.data),1);    

            for item_idx = 1:length(this.data)
                if isempty(this.data(item_idx).values)
                    idxs(item_idx) = false;
                    continue
                end
                if(isempty(this.data(item_idx).properties))
                    itemMap = map({}, false);
                else
                    itemMap = map(this.data(item_idx).properties, false);
                end
                itemMapKeys = keys(itemMap);
                searchMap = map(baseSearchMap, false);
                searchMapKeys = keys(searchMap);


                sharedProperties = union(itemMapKeys, searchMapKeys);

                for propName_wrap = sharedProperties
                    propName = propName_wrap{1};
                    if ~ismember(propName, itemMapKeys)
                        itemMap(propName) = this.propDefault(propName);
                    end
                    if ~ismember(propName, searchMapKeys)
                        searchMap(propName) = this.propDefault(propName);
                    end
                end


                for propName_wrap = sharedProperties
                    propName        = propName_wrap{1};
                    itemPropValue   = itemMap(propName);
                    searchPropValue = searchMap(propName);



                    r = false;
                    if ischar(searchPropValue)
                        r = strcmp(itemPropValue, searchPropValue);
                    elseif iscellstr(searchPropValue) %#ok<ISCLSTR>
                        r = ismember(itemPropValue, searchPropValue);
                    elseif isempty(searchPropValue)
                        r = true;
                    elseif isa(searchPropValue, 'function_handle')
                        r = searchPropValue(itemPropValue);
                    end

                    if r == false
                        idxs(item_idx) = false;
                        break
                    end
                end
            end
            if ~any(idxs)
                assert(false, 'No results found for search');
            end
            items = this.data(idxs);
            items = this.addDefaultProperties(items);
            items = this.sortItems(items, searchSpec);
        end
        
        function plot(this, items, varargin)
            
            if isa(items, 'cell')
                items = this.search(items);
            end
            
            if length(items) == 1 
                props = items.properties(:,1);
                if isempty(props); props = {}; end
                ax = this.plotMakeAxes(items, props, '        ', varargin{:});
                colors = qual_seq(1, 'flat',true, varargin{:});
                this.plotItem(ax, items(1), varargin{:}, ...
                    'name','Baseline', ...
                    'color', colors(1,:));
                return
            end

            % GENERATE TITLES
            [uniq, shared] = this.uniqueProperties(items);
            [propsStrs, valsStrs] = this.plotMakeLegendContents(items, uniq);
            lgdTitle = char(join(cell(propsStrs), ' | '));

            % GENERATE COLORS
            propValues = cellfun(@(prop) arrayfun(@(item) {this.propertyValue(item, prop)}, items), uniq, 'un',0);    
            numColorVariants = cellfun(@(a) sum(strcmp(propValues{1}, a)), unique(propValues{1}, 'stable'));
            colors = qual_seq(numColorVariants, 'flat',true, varargin{:});

            % PER-ITEM PLOT
            ax = this.plotMakeAxes(items, shared, lgdTitle, varargin{:});
            for idx = 1:length(items)
                name = char(join(cell(valsStrs{idx}), ' | '));

                color = colors(idx,:);

                this.plotItem(ax, items(idx), varargin{:}, 'name',name, 'color',color);
            end
        end
        
        function plotMaxLimit(this, items, varargin)

            if isa(items, 'cell')  &&  length(items) > 1  &&  isa(items{1}, 'char')
                items = this.search(items);
            end
            
            [uniq, shared] = this.uniqueProperties(items);
            assert(any(ismember(uniq, 'Hardware max FPS')));
            uniq(ismember(uniq, 'Hardware max FPS')) = [];
            
            [propsStrs, valsStrs] = this.plotMakeLegendContents(items, uniq);
            lgdTitle = char(join(cell(propsStrs), ' | '));
            
            hwfl = ismember(shared, 'Hardware FPS limit');
            assert(sum(hwfl == 1), 'Items must have a shared value for ''Hardware FPS limit''');
            shared = shared(~hwfl);

            fps_str = arrayfun(@(a) {this.propertyValue(a, 'Hardware max FPS')}, items);
            fps = cellfun(@str2double, fps_str);

            % GENERATE COLORS
            propValues = cellfun(@(prop) arrayfun(@(item) {this.propertyValue(item, prop)}, items), uniq, 'un',0);    
            if isempty(propValues)
                groupIds = ones(size(items));
                groupOffsets = 1;
                numGroups = 1;
                subGroupIdxs = 1:length(items);
                colors = qual_seq(1, varargin{:});
                colors = {cellfun(@(a)a(1), colors)};
            else
                [~, groupOffsets, groupIds] = unique(propValues{1}, 'stable');
                numGroups = max(groupIds);
                subGroupIdxs = (1:length(items))' - (groupOffsets(groupIds(1:length(items))))+1;
                numColorVariants = cellfun(@(a) sum(strcmp(propValues{1}, a))+1, unique(propValues{1}, 'stable'));
                colors = qual_seq(numColorVariants, varargin{:});
            end
            
            % PER-ITEM PLOT
            titleItems = {lgdTitle 'Max FPS at location'};
            titleItems = titleItems(~cellfun(@isempty, titleItems));
            ax = this.plotMakeAxes(items, shared, char(join(titleItems, ' | ')), varargin{:});
            for idx = 1:length(items)
                color = colors{groupIds(idx)}{subGroupIdxs(idx)};

                nameItems = [valsStrs{idx}; sprintf('%19s', fps_str{idx})];
                nameItems = nameItems(~arrayfun(@isempty, nameItems));
                this.plotItem(ax, items(idx), varargin{:}, ...
                    'name',char(join(nameItems, ' | ')), ...
                    'color',color, ...
                    'fit_xlim',[1001/fps(idx), 35]);    % fit should exclude lowest fps value; abusing division
            end


            % LIMIT ITEMS (lowest-fps point from each item)
            [~, limitValsStrs] = this.plotMakeLegendContents(items(groupOffsets), uniq);
            for g = 1:numGroups
                groupItems = items(groupIds == g);
                limitItemVals = cell(length(groupItems), 2);
                for idx = 1:length(groupItems)
                    fps = str2double(fps_str(groupOffsets(g)+idx-1));
                    limitItemVals{idx,1} = fps;
                    limitItemVals{idx,2} = groupItems(idx).values{ ([groupItems(idx).values{:,1}] == fps), 2 };
                end

                limitItem = struct(...
                    'properties', {{
                    }},...
                    'values', {limitItemVals}...
                );
            
                if numGroups == 1
                    color = [0.5 0.5 0.5];
                else
                    color = colors{g}{end};
                end

                nameItems = [
                    limitValsStrs{g}; 
                    sprintf('%4s lim. locs only', ...
                        this.propertyValue(groupItems(1), 'Hardware FPS limit'))
                    ];
                nameItems = nameItems(~arrayfun(@isempty, nameItems));
                this.plotItem(ax, limitItem, varargin{:}, ...
                    'name', char(join(nameItems, ' | ')), ...
                    'color',color,...
                    'marker', 'o');
            end
            

        end
        
        function val = propertyValue(this, item, prop)
            if isempty(item.properties) || ~ismember(prop, item.properties(:,1))
                val = this.propDefault(prop);
            else
                val = item.properties{strcmp(item.properties(:,1), prop), 2};
            end
        end
        
        function items = sortItems(this, items, searchSpec)
            assert(isempty(searchSpec) | size(searchSpec,2) == 2);
            if length(items) == 1
                return
            end
            items = this.applySort(items, searchSpec);

            props = searchSpec(:,1);
            [~, order] = sort(props);
            [~, idxorder] = sort(order);
            for idx = 1:length(items)
                sorted = sortrows(items(idx).properties);
                items(idx).properties = sorted(idxorder,:);
            end
        end
        
        function items = addDefaultProperties(this, items)
            sharedProperties = this.propertiesUnion(items);

            for item_idx = 1:length(items)
                for prop_idx = 1:length(sharedProperties)
                    propName = sharedProperties{prop_idx};
                    if isempty(items(item_idx).properties) || ...
                        ~ismember(propName, items(item_idx).properties(:,1))

                        items(item_idx).properties = ...
                            [items(item_idx).properties; {propName, this.propDefault(propName)}];
                    end
                end
            end
        end
        
        function [propsStrs, valsStrs] = plotMakeLegendContents(this, items, props)
            colWidths = cellfun(@(u){max(strlength([arrayfun(@(item){this.propertyValue(item, u)}, items)'; u]))}, props);
            propsStrs = arrayfun(@(u, width) ...
                    {sprintf('%1$*2$s', u{1}, width{1})}, ...
                    props, colWidths);
            valsStrs = arrayfun(@(item) ...
                {arrayfun(@(uniqProp, width) ...
                    {sprintf('%1$*2$s', this.propertyValue(item, uniqProp{1}), width{1})}, ...
                    props, colWidths)},...
                items);
        end
        

    end
    
    methods (Static)
        
        % export
        function item = selectFPS(item, selection)
            idxs = arrayfun(selection, [item.values{:,1}]);
            item.values = item.values( idxs, :);
            [~, matches] = regexp(char(selection), '@\(\w+\)(.+)', 'match', 'tokens');
            item.properties = [item.properties; {'FPS selection', matches{1}{1}}];
        end
        
        % export
        function str = toString(items)
            str = '';
            for item_idx = 1:length(items)
                % item number
                str = append(str, ...
                    sprintf('%d:\n', item_idx));

                % item properties
                if isempty(items(item_idx).properties)
                    str = append(str, '  (no properties)', newline);
                else
                    maxKeyLen = max(cellfun(@length, items(item_idx).properties(:,1)));
                    fmtSpec = ['   %-' int2str(maxKeyLen) 's : %s\n'];
                    props = items(item_idx).properties';
                    str = append(str, ...
                        sprintf(fmtSpec, props{:}));
                end

                % item framerates
                str = append(str, ...
                    '      [', num2str([items(item_idx).values{:,1}]), ']', newline);
            end
        end
    end
    
    methods (Access = private)
        
        function [unique, shared] = uniqueProperties(this, items)
            unique = {};
            shared = {};

            props = this.propertiesUnion(items);
            if length(items) == 1
                unique = props;
                if all(size(unique) == 0)
                    unique = cell(1, 0);
                end
                return;
            end

            for idx = 1:length(props)
                valueOfProp = @(item) {this.propertyValue(item, props{idx})};
                vals = arrayfun(valueOfProp, items);
                if all(strcmp(vals, vals{1}))
                    shared = vertcat(shared, props{idx});
                else
                    unique = vertcat(unique, props{idx});
                end
            end
        end
        

        
        function sharedPropertyNames = propertiesUnion(~, items)
            props = {items.properties};
            nonEmptyProps = props(~cellfun(@isempty, props));
            propNames = cellfun(@(a) {a(:,1)'}, nonEmptyProps);
            if isempty(propNames)
                sharedPropertyNames = {};
            else
                sharedPropertyNames = unique(horzcat(propNames{:}), 'stable');
            end
        end
        
        function items = applySort(this, items, searchSpec)
            prop = searchSpec{1,1};
            searchVals = searchSpec{1,2};

            valueOfProp = @(item) {this.propertyValue(item, prop)};

            if iscellstr(searchVals) %#ok<ISCLSTR>
                [~, temp] = ismember(arrayfun(valueOfProp, items), searchVals);
                [~, order] = sort(temp);
            elseif iscellstr(this.propValid(prop)) %#ok<ISCLSTR>
                [~, temp] = ismember(arrayfun(valueOfProp, items), this.propValid(prop));
                [~, order] = sort(temp);
            elseif isa(this.propValid(prop), 'function_handle')
                [~, order] = natsort(arrayfun(valueOfProp, items));
            end
            items = items(order);

            if size(searchSpec,1) == 1
                return
            else
                [~,~,group] = unique(arrayfun(valueOfProp, items), 'stable');
                for subGroup = 1:max(group)
                    if length(items(group == subGroup)) > 1
                        items(group == subGroup) = this.applySort(items(group == subGroup), searchSpec(2:end,:));
                    end
                end
            end
        end
        

        
        function ax = plotMakeAxes(this, items, sharedPropNames, legendTitle, varargin)

            p = inputParser;
            p.KeepUnmatched = true;
            addParameter(p, 'ax',           []);
            addParameter(p, 'cla',          true,           @islogical);
            addParameter(p, 'title',        '',             @ischar);
            addParameter(p, 'xlim',         [1.5 35],       @(a) isvector(a) & length(a)==2);
            addParameter(p, 'ymax',         80,             @(a) isscalar(a) & isreal(a));
            addParameter(p, 'xscale',       'log',          @(a) ismember(a, {'linear','log'}));
            parse(p, varargin{:});

            % AXES
            ax = p.Results.ax;
            assert(isempty(ax) || isa(ax, 'matlab.graphics.axis.Axes'));
            if isempty(ax)
                ax = gca();
            end
            if p.Results.cla
                cla(ax);
                ax.UserData = [];
            end
            hold(ax, 'on');
            ax.XScale = p.Results.xscale;


            % GRIDS
            grid(ax, 'on');
            ax.XLim = p.Results.xlim;
            ax.YLim = [0, p.Results.ymax];

            fpsGrid = geometricBracket(300, [16, 10], 2:-1:-16);
            ax.XTick = 1000./fpsGrid;
            ax.XTickLabel = arrayfun(@num2str, fpsGrid, 'UniformOutput',false);
            ax.XTickLabelRotation = 90;
            ax.XMinorGrid = 'off';
            ax.XMinorTick = 'off';

            ax.XLabel.String = 'frames per second';
            ax.YLabel.String = 'response time (ms)';

            refreshRateGrid = [60 144 165 240];
            arrayfun(@(a) line(ax, [1000/a, 1000/a], [0, p.Results.ymax], 'linestyle','--', 'color',[0.8,0.8,0.9]), refreshRateGrid);


            % TITLE
            sharedPropVals = cellfun(@(a) {[a, ': ', char(this.propertyValue(items(1), a))]}, sharedPropNames );
            if isempty(sharedPropVals)
                groupName = '';
            else
                groupName = char(join(sharedPropVals, ' | '));
            end 
            title(ax, {p.Results.title, ['\fontsize{12}', groupName]});

            % LEGEND (HEADER)
            p_name = patch(ax, NaN,NaN,NaN, 'FaceAlpha',0, 'EdgeColor','none',...
                'DisplayName', ['\bf', legendTitle, '\rm | objs | slope | base']);
            legend(p_name, 'Location','northwest', 'AutoUpdate','off');

        end
        
        function plotItem(~, ax, item, varargin)

            p = inputParser;
            p.KeepUnmatched = true;
            addParameter(p, 'xlim',         [1.5 35],       @(a) isvector(a) & length(a)==2);
            addParameter(p, 'fit_xlim',     [1.5 35],       @(a) isvector(a) & length(a)==2);
            addParameter(p, 'ymax',         80,             @(a) isscalar(a) & isreal(a));
            addParameter(p, 'xscale',       'log',          @(a) ismember(a, {'linear','log'}));
            addParameter(p, 'color',        [0.5 0.5 0.5],  @(a) isreal(a) & all(size(a)==[1,3]));
            addParameter(p, 'trendline',    true,           @islogical);
            addParameter(p, 'minmax',       true,           @islogical);
            addParameter(p, 'points',       false,          @islogical);
            addParameter(p, 'hist',         false,          @islogical);
            addParameter(p, 'histbinsz',    1,              @(a) isscalar(a) & isreal(a) & a>0);
            addParameter(p, 'marker',       'x',            @ischar);
            addParameter(p, 'name',         '(undefined)',  @ischar);
            parse(p, varargin{:});

            xmin        = p.Results.xlim(1);
            xmax        = p.Results.xlim(2);
            ymax        = p.Results.ymax;
            fit_xmin    = p.Results.fit_xlim(1);
            fit_xmax    = p.Results.fit_xlim(2);
            histbinsz   = p.Results.histbinsz;
            name        = p.Results.name;
            color       = p.Results.color;


            n = size(item.values, 1);
            frameIntervals      = 1000./cell2mat(item.values(:,1));
            medians             = cellfun(@(a) median(a), item.values(:,2));
            minmaxs             = cell2mat(cellfun(@(a) {[min(a) max(a)]}, item.values(:,2)));


            if p.Results.points
                for idx = 1:n
                    pts = item.values{idx,2};
                    npts = length(pts);
                    plot(ax, frameIntervals(idx)*ones(npts,1), pts, '.', 'color',color, 'markersize',1);
                end
            end
            if p.Results.hist
                ys = 0 : histbinsz : ymax;
                y = [ys(1:end-1); ys(2:end); ys(2:end); ys(1:end-1)];

                if length(frameIntervals) == 1
                    frameIntervalSizes = xmax/40;
                else
                    frameIntervalSizes  = diff(interp1(1:n, frameIntervals, 1:(n+1), 'pchip', 'extrap'));
                end

                for idx = 1:n
                    counts = histcounts(item.values{idx,2}, ys)';
                    counts = counts ./max(counts) .* frameIntervalSizes(idx) .* 0.8;

                    x = [frameIntervals(idx)*ones(2,(ymax/histbinsz)); (frameIntervals(idx)+counts').*[1;1]];

                    patch(ax, x(:,counts~=0), y(:,counts~=0), color, 'FaceAlpha',0.15, 'EdgeColor','none');            
                end
            end

            name = sprintf('%s \\color{gray}| %4d', name,...
                min(cellfun(@(a)size(a,1), item.values(:,2))));

            if length(medians) > 1
                fitSelection = frameIntervals > fit_xmin  &  frameIntervals < fit_xmax;
                [coeff, ~] = polyfit(frameIntervals(fitSelection), medians(fitSelection), 1);
                name = sprintf('%s \\color{gray}| %5.2f | %5.2f', name, coeff(1), coeff(2));

                if p.Results.trendline
                    plot(ax, 0:0.1:fit_xmax, polyval(coeff, 0:0.1:fit_xmax), '--', 'color',color, 'linewidth',0.5);
                end
            end

            plot(ax, frameIntervals, medians, p.Results.marker,	'color',color, 'markersize',10,'linewidth',2);
            plot(ax, frameIntervals, medians, ':',            	'color',color, 'linewidth',0.5);

            if p.Results.minmax
                plot(ax, frameIntervals, minmaxs,	':+', 'color',color, 'markersize',4);
            end

            legendColorItem(ax, color, name);

        end
        
    end
    

end