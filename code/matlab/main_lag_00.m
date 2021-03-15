main_lag_init;

%%
folder = '..\..\assets\00-cables-and-inputs\';
lagData = LagData([folder 'data.json'], [folder 'properties.json']);
figureRes = [1280 720];


%% INPUT REMAPPING
%%
f = figure; clf;
f.Name = 'Input: Keyboard click remapping';
lagData.plot({...
        'Input device'          'Keyboard'
        'Input from hardware'   []
        'Input remapping'       []
        'Input to game'         {'Key click', 'Mouse click'}
    }, ...
    'title',f.Name);

%%
f = figure; clf;
f.Name = 'Input: Mouse click remapping';
lagData.plot({...
        'Input device'          'Mouse'
        'Input remapping'       []
        'Input from hardware'   {'Key click', 'Mouse click'}
        'Input to game'         {'Key click', 'Mouse click'}
    }, ...
    'title',f.Name)

%%
f = figure; clf;
f.Name = 'Input: Mouse move';
lagData.plot({...
        'Input device'          []
        'Input remapping'       []
        'Input from hardware'   []
        'Input to game'         'Mouse move'
    }, ...
    'title',f.Name);

%%
f = figure; clf;
f.Name = 'Input: Move vs. Click';
lagData.plot({...
        'Input device'          'Mouse'
        'Input to game'         []
        'Input from hardware'   @(a) ~strcmp(a, '(undefined)')
        'Input remapping'       {'None' 'Winuser' 'Interception'}
    }, ...
    'title',f.Name);

%%
f = figure; clf;
f.Name = 'All input types';
lagData.plot({...
    'Input to game'         []
    'Input device'          []
    'Input from hardware' 	@(a) ~strcmp(a, '(undefined)')
    'Input remapping'       []
}, ...
'title',f.Name);
%{
    10-15   :   mouse       -> remap        -> move
    15-20   :   keyboard    -> icue         -> move
    20-25   :   mouse       -> remap/none   -> click
    25-30   :   keyboard    -> remap/none   -> click
    30-40   :   keyboard    -> icue         -> click
%}

%% EXTENDED CABLES
f = figure; clf;
f.Name = 'Cable extension';
lagData.plot({...
        '15m extended cables' @(a) ~strcmp(a, '(undefined)')
}, ...
'title',f.Name, 'ymax',40, 'hist',true);

%% NUM SAMPLES NEEDED
name = 'Response time median vs. num samples';
item = lagData.search({'15m extended cables', 'None'}); % currently the largest sample count
vals = cell2mat(item.values(:,2)');
[n, m] = size(vals);
medians = zeros(n,m);
for i = 1:n
    medians(i,:) = median(vals(1:i, :));
end
f = figure; clf; hold on;
    plot(medians);
    ylabel('cumulative median');
    xlabel('num samples');
    title(name);
saveFig(f, sprintf('%s%03d-%s', folder, f.Number, filenameify(name)), figureRes);

%%
saveOpenFigs(folder, figureRes);






