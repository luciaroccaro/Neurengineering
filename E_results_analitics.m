% Neuroengineering
% Laboratory 4

% Rigazio Sofia - 282247
% Roccaro Lucia - 289423
% Romano Anastasio - 289707
% Ruzzante Elena - 292194


% DESCRIZIONE SCRIPT: in questo script vengono visualizzati i risultati
% della classificazione, in modo da poterli agevolmente confrontare con i
% risultati ottenuti in letteratura.

clear variables
close all
clc

%% Load dei dati
addpath("Results")
% load dei dati mediati
    % a: temporali
load M_T_HHb.mat
load M_T_O2Hb.mat
    % b: features statistiche
load M_S_HHb.mat
load M_S_O2Hb.mat

% load dei dati NON mediati
    % a: temporali
load NM_T_HHb.mat
load NM_T_O2Hb.mat
    % b: features statistiche
load NM_S_HHb.mat
load NM_S_O2Hb.mat

%% Accuratezza di classificazione - task mano destra e sinistra
red = hot(6);
blue = winter(6);

figure('Name', 'Accuracy values', 'Position', [100 100 2000 300])
sgtitle('Classification accuracy')
data = categorical({'Frontal'; 'Occipital'; 'Motor'; 'All'});

% Total (Training + Test set) - Non Mediated
subplot(1,3,1) 
acc_NM_total = [NM_S_O2Hb.accuracy.frontal_total, NM_S_O2Hb.accuracy.occipital_total, NM_S_O2Hb.accuracy.motor_total, NM_S_O2Hb.accuracy.all_total;...
        NM_S_HHb.accuracy.frontal_total, NM_S_HHb.accuracy.occipital_total, NM_S_HHb.accuracy.motor_total, NM_S_HHb.accuracy.all_total; ...
        NM_T_O2Hb.accuracy.frontal_total, NM_T_O2Hb.accuracy.occipital_total, NM_T_O2Hb.accuracy.motor_total, NM_T_O2Hb.accuracy.all_total;...
        NM_T_HHb.accuracy.frontal_total, NM_T_HHb.accuracy.occipital_total, NM_T_HHb.accuracy.motor_total, NM_T_HHb.accuracy.all_total];

err_std_graph_NM_total = [NM_S_O2Hb.err_std.frontal_total, NM_S_O2Hb.err_std.occipital_total, NM_S_O2Hb.err_std.motor_total, NM_S_O2Hb.err_std.all_total;...
                NM_S_HHb.err_std.frontal_total, NM_S_HHb.err_std.occipital_total, NM_S_HHb.err_std.motor_total, NM_S_HHb.err_std.all_total;...
                NM_T_O2Hb.err_std.frontal_total, NM_T_O2Hb.err_std.occipital_total, NM_T_O2Hb.err_std.motor_total, NM_T_O2Hb.err_std.all_total;...
                NM_T_HHb.err_std.frontal_total, NM_T_HHb.err_std.occipital_total, NM_T_HHb.err_std.motor_total, NM_T_HHb.err_std.all_total];


hBar = bar(double(1:length(data)),acc_NM_total');         % plot against the underlying value 
legend('O2Hb - Statistical (NM)', 'HHb - Statistical (NM)', ...
        'O2Hb - Temporal (NM)', 'HHb - Temporal (NM)', ...
        'AutoUpdate', 'off', 'Location', 'southoutside','NumColumns',2)
title('Non Mediated - Training+Test set')
hAx = gca;                       % handle to the axes object
hAx.XTickLabel = data;  % label by categories
hold on
X = cell2mat(get(hBar,'XData')).'+[hBar.XOffset];  % compute bar locations
hEB = errorbar(X',acc_NM_total,err_std_graph_NM_total,'.k');  % add the errorbar
% change color for the bars
hBar(1).FaceColor = red(2,:);    hBar(2).FaceColor = blue(2,:);
hBar(3).FaceColor = red(3,:);    hBar(4).FaceColor = blue(4,:);
ylabel('Accuratezza (%)')
ylim([0,100])
yline(50, ':k')

% Test Set - Mediated
subplot(1,3,2) 
acc_NM_Test = [NM_S_O2Hb.accuracy.frontal_test, NM_S_O2Hb.accuracy.occipital_test, NM_S_O2Hb.accuracy.motor_test, NM_S_O2Hb.accuracy.all_test;...
        NM_S_HHb.accuracy.frontal_test, NM_S_HHb.accuracy.occipital_test, NM_S_HHb.accuracy.motor_test, NM_S_HHb.accuracy.all_test; ...
        NM_T_O2Hb.accuracy.frontal_test, NM_T_O2Hb.accuracy.occipital_test, NM_T_O2Hb.accuracy.motor_test, NM_T_O2Hb.accuracy.all_test;...
        NM_T_HHb.accuracy.frontal_test, NM_T_HHb.accuracy.occipital_test, NM_T_HHb.accuracy.motor_test, NM_T_HHb.accuracy.all_test];
        
err_std_graph_NM_Test = [NM_S_O2Hb.err_std.frontal_test, NM_S_O2Hb.err_std.occipital_test, NM_S_O2Hb.err_std.motor_test, NM_S_O2Hb.err_std.all_test;...
                NM_S_HHb.err_std.frontal_test, NM_S_HHb.err_std.occipital_test, NM_S_HHb.err_std.motor_test, NM_S_HHb.err_std.all_test;...
                NM_T_O2Hb.err_std.frontal_test, NM_T_O2Hb.err_std.occipital_test, NM_T_O2Hb.err_std.motor_test, NM_T_O2Hb.err_std.all_test;...
                NM_T_HHb.err_std.frontal_test, NM_T_HHb.err_std.occipital_test, NM_T_HHb.err_std.motor_test, NM_T_HHb.err_std.all_test];

hBar=bar(double(1:length(data)),acc_NM_Test');         % plot against the underlying value 
legend('O2Hb - Statistical (NM)', 'HHb - Statistical (NM)', ...
        'O2Hb - Temporal (NM)', 'HHb - Temporal (NM)', ...
        'AutoUpdate', 'off', 'Location', 'southoutside','NumColumns',2)

title('Non Mediated - Test set')
hAx = gca;                       % handle to the axes object
hAx.XTickLabel = data;  % label by categories
hold on
X = cell2mat(get(hBar,'XData')).'+[hBar.XOffset];  % compute bar locations
hEB = errorbar(X',acc_NM_Test,err_std_graph_NM_Test,'.k');  % add the errorbar

% change color for the bars
hBar(1).FaceColor = red(2,:);    hBar(2).FaceColor = blue(2,:);
hBar(3).FaceColor = red(3,:);    hBar(4).FaceColor = blue(4,:);

ylabel('Accuratezza (%)')
ylim([0,100])
yline(50, ':k')

% Test set - Mediated
subplot(1,3,3)
acc_M = [M_S_O2Hb.accuracy.frontal, M_S_O2Hb.accuracy.occipital, M_S_O2Hb.accuracy.motor, M_S_O2Hb.accuracy.all;...
        M_S_HHb.accuracy.frontal, M_S_HHb.accuracy.occipital, M_S_HHb.accuracy.motor, M_S_HHb.accuracy.all; ...
        M_T_O2Hb.accuracy.frontal, M_T_O2Hb.accuracy.occipital, M_T_O2Hb.accuracy.motor, M_T_O2Hb.accuracy.all;...
        M_T_HHb.accuracy.frontal, M_T_HHb.accuracy.occipital, M_T_HHb.accuracy.motor, M_T_HHb.accuracy.all];

err_std_graph_M = [M_S_O2Hb.err_std.frontal, M_S_O2Hb.err_std.occipital, M_S_O2Hb.err_std.motor, M_S_O2Hb.err_std.all;...
                M_S_HHb.err_std.frontal, M_S_HHb.err_std.occipital, M_S_HHb.err_std.motor, M_S_HHb.err_std.all;...
                M_T_O2Hb.err_std.frontal, M_T_O2Hb.err_std.occipital, M_T_O2Hb.err_std.motor, M_T_O2Hb.err_std.all;...
                M_T_HHb.err_std.frontal, M_T_HHb.err_std.occipital, M_T_HHb.err_std.motor, M_T_HHb.err_std.all];


hBar = bar(double(1:length(data)),acc_M');         % plot against the underlying value 
legend('O2Hb - Statistical (M)', 'HHb - Statistical (M)', ...
        'O2Hb - Temporal (M)', 'HHb - Temporal (M)', ...
        'AutoUpdate', 'off', 'Location', 'southoutside','NumColumns',2)
title('Mediated - Test set')
hAx = gca;                       % handle to the axes object
hAx.XTickLabel = data;  % label by categories
hold on
X = cell2mat(get(hBar,'XData')).'+[hBar.XOffset];  % compute bar locations
hEB = errorbar(X',acc_M,err_std_graph_M,'.k');  % add the errorbar

% change color for the bars
hBar(1).FaceColor = red(2,:);    hBar(2).FaceColor = blue(2,:);
hBar(3).FaceColor = red(3,:);    hBar(4).FaceColor = blue(4,:);

ylabel('Accuratezza (%)')
ylim([0,100])
yline(50, ':k')

%% Accuratezza di classificazione - task mano sinistra
figure('Name', 'Accuracy values', 'Position', [100 100 2000 300])
sgtitle('Classification accuracy - Left')
data = categorical({'Frontal'; 'Occipital'; 'Motor'; 'All'});

% Total (Training + Test set) - Non Mediated
subplot(1,3,1)
acc_NM_L_total = [NM_S_O2Hb.accuracy.L.frontal_total, NM_S_O2Hb.accuracy.L.occipital_total, NM_S_O2Hb.accuracy.L.motor_total, NM_S_O2Hb.accuracy.L.all_total;...
        NM_S_HHb.accuracy.L.frontal_total, NM_S_HHb.accuracy.L.occipital_total, NM_S_HHb.accuracy.L.motor_total, NM_S_HHb.accuracy.L.all_total; ...
        NM_T_O2Hb.accuracy.L.frontal_total, NM_T_O2Hb.accuracy.L.occipital_total, NM_T_O2Hb.accuracy.L.motor_total, NM_T_O2Hb.accuracy.L.all_total;...
        NM_T_HHb.accuracy.L.frontal_total, NM_T_HHb.accuracy.L.occipital_total, NM_T_HHb.accuracy.L.motor_total, NM_T_HHb.accuracy.L.all_total];

err_std_graph_NM_L_total = [NM_S_O2Hb.err_std.L.frontal_total, NM_S_O2Hb.err_std.L.occipital_total, NM_S_O2Hb.err_std.L.motor_total, NM_S_O2Hb.err_std.L.all_total;...
                NM_S_HHb.err_std.L.frontal_total, NM_S_HHb.err_std.L.occipital_total, NM_S_HHb.err_std.L.motor_total, NM_S_HHb.err_std.L.all_total;...
                NM_T_O2Hb.err_std.L.frontal_total, NM_T_O2Hb.err_std.L.occipital_total, NM_T_O2Hb.err_std.L.motor_total, NM_T_O2Hb.err_std.L.all_total;...
                NM_T_HHb.err_std.L.frontal_total, NM_T_HHb.err_std.L.occipital_total, NM_T_HHb.err_std.L.motor_total, NM_T_HHb.err_std.L.all_total];

hBar = bar(double(1:length(data)),acc_NM_L_total');         % plot against the underlying value 
legend('O2Hb - Stat L (NM)', 'HHb - Stat L (NM)', ...
        'O2Hb - Temp L (NM)', 'HHb - Temp L (NM)', ...
        'AutoUpdate', 'off', 'Location', 'southoutside','NumColumns',2)
title('Non Mediated - Training+Test Set')
hAx = gca;                       % handle to the axes object
hAx.XTickLabel = data;  % label by categories
hold on
X = cell2mat(get(hBar,'XData')).'+[hBar.XOffset];  % compute bar locations
hEB = errorbar(X',acc_NM_L_total, err_std_graph_NM_L_total,'.k');  % add the errorbar
% change color for the bars
hBar(1).FaceColor = red(2,:);    hBar(2).FaceColor = blue(2,:);
hBar(3).FaceColor = red(3,:);    hBar(4).FaceColor = blue(4,:);
ylim([0,100])
yline(50, ':k')

% Test set - Non Mediated
subplot(1,3,2)
acc_NM_L_test = [NM_S_O2Hb.accuracy.L.frontal_test, NM_S_O2Hb.accuracy.L.occipital_test, NM_S_O2Hb.accuracy.L.motor_test, NM_S_O2Hb.accuracy.L.all_test;...
        NM_S_HHb.accuracy.L.frontal_test, NM_S_HHb.accuracy.L.occipital_test, NM_S_HHb.accuracy.L.motor_test, NM_S_HHb.accuracy.L.all_test; ...
        NM_T_O2Hb.accuracy.L.frontal_test, NM_T_O2Hb.accuracy.L.occipital_test, NM_T_O2Hb.accuracy.L.motor_test, NM_T_O2Hb.accuracy.L.all_test;...
        NM_T_HHb.accuracy.L.frontal_test, NM_T_HHb.accuracy.L.occipital_test, NM_T_HHb.accuracy.L.motor_test, NM_T_HHb.accuracy.L.all_test];

err_std_graph_NM_L_test = [NM_S_O2Hb.err_std.L.frontal_test, NM_S_O2Hb.err_std.L.occipital_test, NM_S_O2Hb.err_std.L.motor_test, NM_S_O2Hb.err_std.L.all_test;...
                NM_S_HHb.err_std.L.frontal_test, NM_S_HHb.err_std.L.occipital_test, NM_S_HHb.err_std.L.motor_test, NM_S_HHb.err_std.L.all_test;...
                NM_T_O2Hb.err_std.L.frontal_test, NM_T_O2Hb.err_std.L.occipital_test, NM_T_O2Hb.err_std.L.motor_test, NM_T_O2Hb.err_std.L.all_test;...
                NM_T_HHb.err_std.L.frontal_test, NM_T_HHb.err_std.L.occipital_test, NM_T_HHb.err_std.L.motor_test, NM_T_HHb.err_std.L.all_test];

hBar = bar(double(1:length(data)),acc_NM_L_test');         % plot against the underlying value 
legend('O2Hb - Stat L (NM)', 'HHb - Stat L (NM)', ...
        'O2Hb - Temp L (NM)', 'HHb - Temp L (NM)', ...
        'AutoUpdate', 'off', 'Location', 'southoutside','NumColumns',2)
title('Non Mediated - Test set')
hAx = gca;                       % handle to the axes object
hAx.XTickLabel = data;  % label by categories
hold on
X = cell2mat(get(hBar,'XData')).'+[hBar.XOffset];  % compute bar locations
hEB = errorbar(X',acc_NM_L_test, err_std_graph_NM_L_test,'.k');  % add the errorbar% change color for the bars
hBar(1).FaceColor = red(2,:);    hBar(2).FaceColor = blue(2,:);
hBar(3).FaceColor = red(3,:);    hBar(4).FaceColor = blue(4,:);
ylim([0,100])
yline(50, ':k')

% Test set - Mediated
subplot(1,3,3)
acc_M_L = [M_S_O2Hb.accuracy.L.frontal, M_S_O2Hb.accuracy.L.occipital, M_S_O2Hb.accuracy.L.motor, M_S_O2Hb.accuracy.L.all;...
        M_S_HHb.accuracy.L.frontal, M_S_HHb.accuracy.L.occipital, M_S_HHb.accuracy.L.motor, M_S_HHb.accuracy.L.all; ...
        M_T_O2Hb.accuracy.L.frontal, M_T_O2Hb.accuracy.L.occipital, M_T_O2Hb.accuracy.L.motor, M_T_O2Hb.accuracy.L.all;...
        M_T_HHb.accuracy.L.frontal, M_T_HHb.accuracy.L.occipital, M_T_HHb.accuracy.L.motor, M_T_HHb.accuracy.L.all];

err_std_graph_M_L = [M_S_O2Hb.err_std.L.frontal, M_S_O2Hb.err_std.L.occipital, M_S_O2Hb.err_std.L.motor, M_S_O2Hb.err_std.L.all;...
                M_S_HHb.err_std.L.frontal, M_S_HHb.err_std.L.occipital, M_S_HHb.err_std.L.motor, M_S_HHb.err_std.L.all;...
                M_T_O2Hb.err_std.L.frontal, M_T_O2Hb.err_std.L.occipital, M_T_O2Hb.err_std.L.motor, M_T_O2Hb.err_std.L.all;...
                M_T_HHb.err_std.L.frontal, M_T_HHb.err_std.L.occipital, M_T_HHb.err_std.L.motor, M_T_HHb.err_std.L.all];

hBar = bar(double(1:length(data)),acc_M_L');         % plot against the underlying value 
legend('O2Hb - Stat L (M)', 'HHb - Stat L (M)', ...
        'O2Hb - Temp L (M)', 'HHb - Temp L (M)', ...
        'AutoUpdate', 'off', 'Location', 'southoutside','NumColumns',2)
title('Mediated - Test set')
hAx = gca;                       % handle to the axes object
hAx.XTickLabel = data;  % label by categories
hold on
X = cell2mat(get(hBar,'XData')).'+[hBar.XOffset];  % compute bar locations
hEB = errorbar(X',acc_M_L, err_std_graph_M_L,'.k');  % add the errorbar
% change color for the bars
hBar(1).FaceColor = red(2,:);    hBar(2).FaceColor = blue(2,:);
hBar(3).FaceColor = red(3,:);    hBar(4).FaceColor = blue(4,:);
ylim([0,100])
yline(50, ':k')

%% Accuratezza di classificazione - task mano destra
figure('Name', 'Accuracy values', 'Position', [100 100 2000 300])
sgtitle('Classification accuracy - Right')
data = categorical({'Frontal'; 'Occipital'; 'Motor'; 'All'});

% Total (Training + Test set) - Non Mediated
subplot(1,3,1)
acc_NM_R_total = [NM_S_O2Hb.accuracy.R.frontal_total, NM_S_O2Hb.accuracy.R.occipital_total, NM_S_O2Hb.accuracy.R.motor_total, NM_S_O2Hb.accuracy.R.all_total;...
        NM_S_HHb.accuracy.R.frontal_total, NM_S_HHb.accuracy.R.occipital_total, NM_S_HHb.accuracy.R.motor_total, NM_S_HHb.accuracy.R.all_total; ...
        NM_T_O2Hb.accuracy.R.frontal_total, NM_T_O2Hb.accuracy.R.occipital_total, NM_T_O2Hb.accuracy.R.motor_total, NM_T_O2Hb.accuracy.R.all_total;...
        NM_T_HHb.accuracy.R.frontal_total, NM_T_HHb.accuracy.R.occipital_total, NM_T_HHb.accuracy.R.motor_total, NM_T_HHb.accuracy.R.all_total];

err_std_graph_NM_R_total = [NM_S_O2Hb.err_std.R.frontal_total, NM_S_O2Hb.err_std.R.occipital_total, NM_S_O2Hb.err_std.R.motor_total, NM_S_O2Hb.err_std.R.all_total;...
                NM_S_HHb.err_std.R.frontal_total, NM_S_HHb.err_std.R.occipital_total, NM_S_HHb.err_std.R.motor_total, NM_S_HHb.err_std.R.all_total;...
                NM_T_O2Hb.err_std.R.frontal_total, NM_T_O2Hb.err_std.R.occipital_total, NM_T_O2Hb.err_std.R.motor_total, NM_T_O2Hb.err_std.R.all_total;...
                NM_T_HHb.err_std.R.frontal_total, NM_T_HHb.err_std.R.occipital_total, NM_T_HHb.err_std.R.motor_total, NM_T_HHb.err_std.R.all_total];

hBar = bar(double(1:length(data)),acc_NM_R_total');         % plot against the underlying value 
legend('O2Hb - Stat R (NM)', 'HHb - Stat R (NM)', ...
        'O2Hb - Temp R (NM)', 'HHb - Temp R (NM)', ...
        'AutoUpdate', 'off', 'Location', 'southoutside','NumColumns',2)
title('Non Mediated - Training+Test Set')
hAx = gca;                       % handle to the axes object
hAx.XTickLabel = data;  % label by categories
hold on
X = cell2mat(get(hBar,'XData')).'+[hBar.XOffset];  % compute bar locations
hEB = errorbar(X',acc_NM_R_total, err_std_graph_NM_R_total,'.k');  % add the errorbar
% change color for the bars
hBar(1).FaceColor = red(2,:);    hBar(2).FaceColor = blue(2,:);
hBar(3).FaceColor = red(3,:);    hBar(4).FaceColor = blue(4,:);
ylim([0,100])
yline(50, ':k')

% Test set - Non Mediated
subplot(1,3,2)
acc_NM_R_test = [NM_S_O2Hb.accuracy.R.frontal_test, NM_S_O2Hb.accuracy.R.occipital_test, NM_S_O2Hb.accuracy.R.motor_test, NM_S_O2Hb.accuracy.R.all_test;...
        NM_S_HHb.accuracy.R.frontal_test, NM_S_HHb.accuracy.R.occipital_test, NM_S_HHb.accuracy.R.motor_test, NM_S_HHb.accuracy.R.all_test; ...
        NM_T_O2Hb.accuracy.R.frontal_test, NM_T_O2Hb.accuracy.R.occipital_test, NM_T_O2Hb.accuracy.R.motor_test, NM_T_O2Hb.accuracy.R.all_test;...
        NM_T_HHb.accuracy.R.frontal_test, NM_T_HHb.accuracy.R.occipital_test, NM_T_HHb.accuracy.R.motor_test, NM_T_HHb.accuracy.R.all_test];

err_std_graph_NM_R_test = [NM_S_O2Hb.err_std.R.frontal_test, NM_S_O2Hb.err_std.R.occipital_test, NM_S_O2Hb.err_std.R.motor_test, NM_S_O2Hb.err_std.R.all_test;...
                NM_S_HHb.err_std.R.frontal_test, NM_S_HHb.err_std.R.occipital_test, NM_S_HHb.err_std.R.motor_test, NM_S_HHb.err_std.R.all_test;...
                NM_T_O2Hb.err_std.R.frontal_test, NM_T_O2Hb.err_std.R.occipital_test, NM_T_O2Hb.err_std.R.motor_test, NM_T_O2Hb.err_std.R.all_test;...
                NM_T_HHb.err_std.R.frontal_test, NM_T_HHb.err_std.R.occipital_test, NM_T_HHb.err_std.R.motor_test, NM_T_HHb.err_std.R.all_test];

hBar = bar(double(1:length(data)),acc_NM_R_test');         % plot against the underlying value 
legend('O2Hb - Stat R (NM)', 'HHb - Stat R (NM)', ...
        'O2Hb - Temp R (NM)', 'HHb - Temp R (NM)', ...
        'AutoUpdate', 'off', 'Location', 'southoutside','NumColumns',2)
title('Non Mediated - Test set')
hAx = gca;                       % handle to the axes object
hAx.XTickLabel = data;  % label by categories
hold on
X = cell2mat(get(hBar,'XData')).'+[hBar.XOffset];  % compute bar locations
hEB = errorbar(X',acc_NM_R_test, err_std_graph_NM_R_test,'.k');  % add the errorbar% change color for the bars
hBar(1).FaceColor = red(2,:);    hBar(2).FaceColor = blue(2,:);
hBar(3).FaceColor = red(3,:);    hBar(4).FaceColor = blue(4,:);
ylim([0,100])
yline(50, ':k')

% Test set - Mediated
subplot(1,3,3)
acc_M_R = [M_S_O2Hb.accuracy.R.frontal, M_S_O2Hb.accuracy.R.occipital, M_S_O2Hb.accuracy.R.motor, M_S_O2Hb.accuracy.R.all;...
        M_S_HHb.accuracy.R.frontal, M_S_HHb.accuracy.R.occipital, M_S_HHb.accuracy.R.motor, M_S_HHb.accuracy.R.all; ...
        M_T_O2Hb.accuracy.R.frontal, M_T_O2Hb.accuracy.R.occipital, M_T_O2Hb.accuracy.R.motor, M_T_O2Hb.accuracy.R.all;...
        M_T_HHb.accuracy.R.frontal, M_T_HHb.accuracy.R.occipital, M_T_HHb.accuracy.R.motor, M_T_HHb.accuracy.R.all];

err_std_graph_M_R = [M_S_O2Hb.err_std.R.frontal, M_S_O2Hb.err_std.R.occipital, M_S_O2Hb.err_std.R.motor, M_S_O2Hb.err_std.R.all;...
                M_S_HHb.err_std.R.frontal, M_S_HHb.err_std.R.occipital, M_S_HHb.err_std.R.motor, M_S_HHb.err_std.R.all;...
                M_T_O2Hb.err_std.R.frontal, M_T_O2Hb.err_std.R.occipital, M_T_O2Hb.err_std.R.motor, M_T_O2Hb.err_std.R.all;...
                M_T_HHb.err_std.R.frontal, M_T_HHb.err_std.R.occipital, M_T_HHb.err_std.R.motor, M_T_HHb.err_std.R.all];

hBar = bar(double(1:length(data)),acc_M_R');         % plot against the underlying value 
legend('O2Hb - Stat R (M)', 'HHb - Stat R (M)', ...
        'O2Hb - Temp R (M)', 'HHb - Temp R (M)', ...
        'AutoUpdate', 'off', 'Location', 'southoutside','NumColumns',2)
title('Mediated - Test set')
hAx = gca;                       % handle to the axes object
hAx.XTickLabel = data;  % label by categories
hold on
X = cell2mat(get(hBar,'XData')).'+[hBar.XOffset];  % compute bar locations
hEB = errorbar(X',acc_M_R, err_std_graph_M_R,'.k');  % add the errorbar
% change color for the bars
hBar(1).FaceColor = red(2,:);    hBar(2).FaceColor = blue(2,:);
hBar(3).FaceColor = red(3,:);    hBar(4).FaceColor = blue(4,:);
ylim([0,100])
yline(50, ':k')