% Neuroengineering
% Laboratory 4

% Rigazio Sofia - 282247
% Roccaro Lucia - 289423
% Romano Anastasio - 289707
% Ruzzante Elena - 292194


% DESCRIZIONE SCRIPT: in questo script vengono analizzati le varie features
% separatamente per ogni canale tramite test statistico MANOVA, al fine di
% valutare la differenza statistica dell'insieme di features tra le due
% classi (L) e (R), per cercare di interpretare al meglio i risultati della
% classificazione. 

clear variables
close all
clc

%% Caricamento dei dati
addpath Results
addpath Functions

load('NM_subject.mat')
subject_NM = subject; clear subject

load('M_subject.mat')
subject_M = subject; clear subject

load params.mat
load green_red_cmap.mat    % usato per p-value colormap

%% effettuazione del test statistico MANOVA
ch = 1:n_ch;
num_tasks = 30;

[d_temp_NM_HHb, p_temp_NM_HHb, d_stat_NM_HHb, p_stat_NM_HHb] = MANOVA_calc(subject_NM, num_tasks, n_subjects, ch);
[d_temp_M_HHb, p_temp_M_HHb, d_stat_M_HHb, p_stat_M_HHb] = MANOVA_calc(subject_M, 1, n_subjects, ch);

[d_temp_NM_O2Hb, p_temp_NM_O2Hb, d_stat_NM_O2Hb, p_stat_NM_O2Hb] = MANOVA_calc(subject_NM, num_tasks, n_subjects, ch+n_ch);
[d_temp_M_O2Hb, p_temp_M_O2Hb, d_stat_M_O2Hb, p_stat_M_O2Hb] = MANOVA_calc(subject_M, 1, n_subjects, ch+n_ch);

%% bar plot del p-value 

% p-value calcolato per le due tipologie di features sui segnali O2Hb e HHb
figure('Position',[10, 10, 2000, 300])
sgtitle('MANOVA - HHb statistical differences between Left and Right signals')
subplot(2,1,1)
bar(ch, [p_temp_NM_HHb,p_temp_M_HHb, p_temp_NM_O2Hb,p_temp_M_O2Hb])
title('evaluation of Temporal features')
legend('HHb - NM', 'HHb - M','O2Hb - NM', 'O2Hb - M','AutoUpdate', 'off','Location','eastoutside')
ylim([0,1])
yline(0.05, ':k')
ylabel('p-value')
xlabel('Channel evaluated')
xticks(ch)
xticklabels(ch_name)

subplot(2,1,2)
bar(ch, [p_stat_NM_HHb,p_stat_M_HHb,p_stat_NM_O2Hb,p_stat_M_O2Hb])
title('evaluation of Statistical features')
legend('HHb - NM', 'HHb - M','O2Hb - NM', 'O2Hb - M','AutoUpdate', 'off','Location','eastoutside')
ylim([0,1])
yline(0.05, ':k')
ylabel('p-value')
xlabel('Channel evaluated')
xticks(ch)
xticklabels(ch_name)

% p-value calcolato per le due tipologie di features solo sui segnali O2Hb
figure('Position',[10, 10, 2000, 300])
sgtitle('MANOVA - O2Hb statistical differences between Left and Right signals')
subplot(2,1,1)
bar(ch, [p_temp_NM_O2Hb,p_temp_M_O2Hb])
title('evaluation of Temporal features')
legend('O2Hb - NM', 'O2Hb - M','AutoUpdate', 'off','Location','eastoutside')
ylim([0,1])
yline(0.05, ':k')
ylabel('p-value')
xlabel('Channel evaluated')
xticks(ch)
xticklabels(ch_name)

subplot(2,1,2)
bar(ch, [p_stat_NM_O2Hb,p_stat_M_O2Hb])
title('evaluation of Statistical features')
legend('O2Hb - NM', 'O2Hb - M','AutoUpdate', 'off','Location','eastoutside')
ylim([0,1])
yline(0.05, ':k')
ylabel('p-value')
xlabel('Channel evaluated')
xticks(ch)
xticklabels(ch_name)

%% PLOT TOPOGRAPHY - Creazione tabella parametri di posizione

% calcolo della posizione degli elettrodi in coordinate dei canali
[theta_rad,rho] = cart2pol(subject_M(1).MNT.pos_3d(2,:)*0.5,subject_M(1).MNT.pos_3d(1,:)*0.5);  % lo 0.5 è per avere valori ben plottabili da plot_topography
theta = rad2deg(theta_rad); % conversione da radianti a gradi

% creazione della tabella da passare alla funzione
locations = table(upper(subject_M(1).MNT.clab)',theta',rho');
locations.Properties.VariableNames{1} = 'labels';
locations.Properties.VariableNames{2} = 'theta';
locations.Properties.VariableNames{3} = 'radius';
ch_list = locations.labels; % utilizzo gli stessi label presenti in tabella (! sono in uppercase) 

%% PLOT TOPOGRAPHY - p-value, Features temporali
figure('Name', 'Plot signal topography - TEMP','Position',[10, 10, 1700, 300])
sgtitle('P-value visualization - temporal features')

subplot(1,4,1)
plot_topography(ch_list, p_temp_M_HHb, 0, locations, true, false, 500)
title(sprintf('Mediated HHb'))
colormap(Green_Red_cmap)
% c = colorbar;
colorbar('off') 
caxis([0,1])  % setta i limiti della colorbar
% hold on
% source = scatter(subject_M(1).MNT.source.pos_3d(1,:)*0.5,subject_M(1).MNT.source.pos_3d(2,:)*0.5,25,"red","filled");
% hold on
% detector = scatter(subject_M(1).MNT.detector.pos_3d(1,:)*0.5,subject_M(1).MNT.detector.pos_3d(2,:)*0.5,25,"green","filled");
% channel = scatter(subject_M(1).MNT.pos_3d(1,:)*0.5,subject_M(1).MNT.pos_3d(2,:)*0.5,14,"magenta","filled");
% legend([source,detector,channel],{'source','detector','channels'})

subplot(1,4,2)
plot_topography(ch_list, p_temp_NM_HHb, 0, locations, true, false, 500)
title(sprintf('Non Mediated HHb'))
colormap(Green_Red_cmap)
% c = colorbar;
colorbar('off') 
caxis([0,1])  % setta i limiti della colorbar

subplot(1,4,3)
plot_topography(ch_list, p_temp_M_O2Hb, 0, locations, true, false, 500)
title(sprintf('Mediated O2Hb'))
colormap(Green_Red_cmap)
% c = colorbar;
colorbar("off")
caxis([0,1])  % setta i limiti della colorbar

subplot(1,4,4)
plot_topography(ch_list, p_temp_NM_O2Hb, 0, locations, true, false, 500)
title(sprintf('Non Mediated O2Hb'))
colormap(Green_Red_cmap)
% c = colorbar
caxis([0,1])  % setta i limiti della colorbar

%% PLOT TOPOGRAPHY - p-value, Features statistiche
figure('Name', 'Plot signal topography - STAT','Position',[10, 10, 1700, 300])
sgtitle('P-value visualization - statistical features')

subplot(1,4,1)
plot_topography(ch_list, p_stat_M_HHb, 0, locations, true, false, 500)
title(sprintf('Mediated HHb'))
colormap(Green_Red_cmap)
% c = colorbar;
colorbar('off') 
caxis([0,1])  % setta i limiti della colorbar
% hold on
% source = scatter(subject_M(1).MNT.source.pos_3d(1,:)*0.5,subject_M(1).MNT.source.pos_3d(2,:)*0.5,25,"red","filled");
% hold on
% detector = scatter(subject_M(1).MNT.detector.pos_3d(1,:)*0.5,subject_M(1).MNT.detector.pos_3d(2,:)*0.5,25,"green","filled");
% channel = scatter(subject_M(1).MNT.pos_3d(1,:)*0.5,subject_M(1).MNT.pos_3d(2,:)*0.5,14,"magenta","filled");
% legend([source,detector,channel],{'source','detector','channels'})

subplot(1,4,2)
plot_topography(ch_list, p_stat_NM_HHb, 0, locations, true, false, 500)
title(sprintf('Non Mediated HHb'))
colormap(Green_Red_cmap)
% c = colorbar;
colorbar('off') 
caxis([0,1])  % setta i limiti della colorbar

subplot(1,4,3)
plot_topography(ch_list, p_stat_M_O2Hb, 0, locations, true, false, 500)
title(sprintf('Mediated O2Hb'))
colormap(Green_Red_cmap)
% c = colorbar;
colorbar("off")
caxis([0,1])  % setta i limiti della colorbar

subplot(1,4,4)
plot_topography(ch_list, p_stat_NM_O2Hb, 0, locations, true, false, 500)
title(sprintf('Non Mediated O2Hb'))
colormap(Green_Red_cmap)
% c = colorbar
colormap(Green_Red_cmap)
caxis([0,1])  % setta i limiti della colorbar
