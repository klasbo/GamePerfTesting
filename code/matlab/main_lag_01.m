main_lag_init;

%%
folder = '..\..\assets\01-nvidia-reflex\';
lagData = LagData([folder, 'data.json'], [folder, 'properties.json']);
close all;
xlim = [2 20];
figureRes = [1280 720];




%%
f = figure; clf;
f.Name = 'Baseline';
lagData.plot({}, ...
    'title',f.Name, 'hist',true, 'ymax',45, 'xlim',xlim);


%%
f = figure; clf;
f.Name = 'Different locations';
lagData.plot({...
        'In-game location'      @(a) ~isempty(a)
    }, ...
    'title',f.Name, 'ymax',45, 'xlim',xlim);


%%
f = figure; clf;
f.Name = 'Different sessions';
lagData.plot({'misc', {'old 150 sample baseline', 'example mismatching baseline', ''}}, ...
    'title',f.Name, 'hist',true, 'ymax',45, 'xlim',xlim);


%%
f = figure; clf;
f.Name = 'GPU overclock';
lagData.plot({...
        'GPU Core clock'        []
        'GPU Memory clock'      []
    }, ...
    'title',f.Name, 'ymax',45, 'xlim',xlim);


%%
f = figure; clf;
f.Name = 'GSync';
lagData.plot({...
        'GSync'      	[]
    }, ...
    'title',f.Name, 'hist',true, 'ymax',45, 'xlim',xlim);


%%
f = figure; clf;
f.Name = 'GSync - Split FPS range';
items = lagData.search({});
itemsSub165 = lagData.selectFPS(items, @(fps)fps<165);
itemsSup165 = lagData.selectFPS(items, @(fps)fps>165);
items = lagData.addDefaultProperties([itemsSub165, itemsSup165, lagData.search({'GSync','Off'})]);
items = lagData.sortItems(items, {'GSync',[];'FPS selection',[]});
lagData.plot(items, ...
    'title',f.Name, 'hist',true, 'ymax',45, 'xlim',xlim);


%% 
f = figure; clf;
f.Name = 'Reduce Buffering';
lagData.plot({...
        'Reduce buffering'      []
    }, ...
    'title',f.Name, 'hist',true, 'ymax',45, 'xlim',xlim);




%%
f = figure; clf;
f.Name = 'Nvidia Reflex - CPU limited';
lagData.plot({...
        'Nvidia reflex'     {'Enabled', 'Disabled'}
        'Reduce buffering'  {'Off', 'On'}
    }, ...
    'title',f.Name, 'ymax',45, 'xlim',xlim);


%%
f = figure; clf;
f.Name = 'Nvidia Reflex - CPU limited - Boost?';
lagData.plot({...
        'Nvidia reflex'     []
    }, ...
    'title',f.Name, 'ymax',45, 'xlim',xlim);



%%
f = figure; clf;
f.Name = 'Nvidia Reflex - CPU limited - No GPU OC - Boost?';
lagData.plot({...
        'Nvidia reflex'     []
        'GPU Core clock'  	'Auto'
        'GPU Memory clock' 	'5000 MHz'
    }, ...
    'title',f.Name, 'ymax',45, 'xlim',xlim);


%%
f = figure; clf;
f.Name = 'CPU limited - Boost vs OC';
items = [lagData.search({...
        'Nvidia reflex'         {'Enabled + Boost'}
        'GPU Core clock'        'Auto'
        'GPU Memory clock'      '5000 MHz'
    }), lagData.search({ ...
        'Nvidia reflex'         {'Enabled'}
    })];
lagData.plot(items, ...
    'title',f.Name, 'ymax',45, 'xlim',xlim);



%%
f = figure; clf;
f.Name = 'GPU limited';
lagData.plotMaxLimit({...
        'Hardware FPS limit'    'GPU' 
        'Hardware max FPS'      []
        'Render scale'          '200%'
    }, ...
    'title',f.Name, 'minmax',false, 'xlim',xlim);


%%
f = figure; clf;
f.Name = 'GPU limited - Nvidia Reflex Enabled';
lagData.plotMaxLimit({...
        'Nvidia reflex'         'Enabled'
        'Hardware FPS limit'    'GPU' 
        'Hardware max FPS'      []
        'Render scale'          '200%'
    }, ...
    'title',f.Name, 'minmax',false, 'xlim',xlim);


%%
f = figure; clf;
name = 'GPU limited - Nvidia Reflex';
lagData.plotMaxLimit({...
        'Nvidia reflex'         []
        'Hardware FPS limit'    'GPU' 
        'Hardware max FPS'      []
        'Render scale'          '200%'
    }, ...
    'title',name, 'minmax',false, 'xlim',xlim);


%%
f = figure; clf;
f.Name = 'GPU limited - Nvidia Reflex - No OC';
lagData.plotMaxLimit({...
        'Nvidia reflex'         []
        'GPU Core clock'        'Auto'
        'GPU Memory clock'      '5000 MHz'
        'Hardware FPS limit'    'GPU' 
        'Hardware max FPS'      []
        'Render scale'          '200%'
    }, ...
    'title',f.Name, 'minmax',false, 'xlim',xlim);


%%
f = figure; clf;
f.Name = 'GPU limited - Nvidia Reflex - Boost vs OC';
items = [lagData.search({...
        'Nvidia reflex'         {'Enabled + Boost'}
        'GPU Core clock'        'Auto'
        'GPU Memory clock'      '5000 MHz'
        'Hardware FPS limit'    'GPU' 
        'Hardware max FPS'      []
        'Render scale'          '200%'
    }), lagData.search({ ...
        'Nvidia reflex'         {'Enabled'}
        'Hardware FPS limit'    'GPU' 
        'Hardware max FPS'      []
        'Render scale'          '200%'
    })];
lagData.plotMaxLimit(items, ...
    'title',f.Name, 'minmax',false, 'xlim',xlim);


%%
f = figure; clf;
f.Name = 'GPU limited - Reduce Buffering Off - Nvidia Reflex';
lagData.plotMaxLimit({...
        'Nvidia reflex'         []
        'Reduce buffering'      'Off'
        'Hardware FPS limit'    'GPU' 
        'Hardware max FPS'      []
        'Render scale'          '200%'
    }, ...
    'title',f.Name, 'minmax',false, 'xlim',xlim);


%%
f = figure; clf;
f.Name = 'GPU limited - Nvidia Reflex Enabled - Reduce Buffering';
lagData.plotMaxLimit({...
        'Nvidia reflex'         'Enabled'
        'Reduce buffering'      []
        'Hardware FPS limit'    'GPU' 
        'Hardware max FPS'      []
        'Render scale'          '200%'
    }, ...
    'title',f.Name, 'minmax',false, 'xlim',xlim);



%%
f = figure; clf;
f.Name = 'Low latency mode - Reflex enabled';
lagData.plot({...
        'Nvidia reflex'      	[]
        'Low latency mode'      []
    }, ...
    'title',f.Name, 'ymax',45, 'xlim',xlim);


%%
f = figure; clf;
f.Name = 'Nvidia Reflex - CPU limited - Measurement 2';
lagData.plot({...
        'misc',                 '1K re-sample'
        'Nvidia reflex'         []
        'Reduce buffering'      []
    }, ...
    'title',f.Name, 'ymax',45, 'xlim',xlim);

%%
f = figure; clf;
f.Name = 'Nvidia Reflex - GPU limited - Measurement 2';
lagData.plot({...
        'misc'                  '1K re-sample'
        'Nvidia reflex'         'Enabled'
        'Hardware FPS limit'    'GPU'
        'Render scale'          '200%'
        'Reduce buffering'      []
    }, ...
    'title',f.Name, 'ymax',45, 'xlim',xlim);

%%
f = figure; clf;
f.Name = 'Reflex mis-prediction';
lagData.plot({...
        'Nvidia reflex'      	'Enabled'
        'In-game location'      @(a) ~isempty(a)
    }, ...
    'title',f.Name, 'hist',true, 'minmax',false, 'ymax',45, 'xlim',xlim);




%%

saveOpenFigs(folder, figureRes);






