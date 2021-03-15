

%%
cd(fileparts(matlab.desktop.editor.getActive().Filename));
d = dir(pwd);
paths = cellfun(@genpath, {d([d.isdir] & ~cellfun(@(s) startsWith(s, '.'), {d.name})).name}, 'un',0);
addpath(paths{:});

clear variables;
close all;
font_mono = 'Space Mono';
set(0, 'defaultFigureWindowStyle',              'docked');
set(0, 'defaultAxesFontName',                   font_mono);
set(0, 'defaultAxesFontSize',                   12);
set(0, 'defaultAxesTitleFontWeight',            'normal');
set(0, 'defaultAxesTitleFontSizeMultiplier',    1.6);
set(0, 'defaultTextFontName',                   font_mono);
%set(0, 'defaultLegendFontName',                 font_mono);



    

%% DARK MODE?
%{
f = gcf();
ax = gca();
set(ax, 'color','k')
set(ax, 'xcolor','w')
set(ax, 'ycolor','w')
set(ax, 'gridcolor','w')
set(f, 'color','k')
set(ax.Legend, 'color','k')
set(ax.Legend, 'textcolor','w')
%}





    
    
    
    
    
























