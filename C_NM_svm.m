% Neuroengineering
% Laboratory 4

% Rigazio Sofia - 282247
% Roccaro Lucia - 289423
% Romano Anastasio - 289707
% Ruzzante Elena - 292194


% DESCRIZIONE SCRIPT: in questo script vengono creati i vari classificatori
% tramite le apposite funzioni (svm_statistical, svm_temp), utilizzando i
% segnali ricavati SENZA media temporale sui vari trial (30 vettori per
% task R e 30 vettori per task L per ogni canale di ogni soggetto)

% Al termine dello script, si avrà a disposizione una serie di struct, al
% cui interno sono contenuti i vari classificatori SVM allenati, le varie
% classificazioni ottenute dalle medesime, ed i relativi valori di
% accuratezza e errore standard per ogni casistica. Per completezza, sono
% state anche ricavate le relative confusion matrix.

clear variables
close all
clc

%% Caricamento dei dati
fprintf('Non Mediated ephochs - SVM Calculation\n')
fprintf('Data loading and initial definitions\n')

addpath Results
addpath Functions

load('NM_subject.mat');
load('params.mat');

num_L = 30;
num_R = 30;

%% Definizione dei canali e inizializzazione strutture
NM_SVM = struct();

frontal_ch = 1:9;
occipital_ch = 10:12;
motor_ch_sx = 13:24;
motor_ch_dx = 25:36;
all_ch = 1:n_ch;

%% Divisione in Training e Test Set
inx_all_subject = 1:1:n_subjects; % vettore che contiene tutti i soggetti
% suddivisione training e test con funzione apposita
NM_c = cvpartition(n_subjects,'Holdout',0.20);
set = training(NM_c);

idx_subj_train = inx_all_subject(set);
idx_subj_test = inx_all_subject(~set);
n_subj_train = length(idx_subj_train);      % numero di soggetti per allenare la rete (training set)
n_subj_test = n_subjects - n_subj_train;    % numero di soggetti per il test

%% Classificazione
%% +++++++++++++ STATISTICAL DATA ++++++++++++++++++++++++++++
%% SVM - HHb
fprintf('SVM - Statistical HHb calculation\n')
NM_S_HHb = struct();
% CORTECCIA MOTORIA
[NM_SVM.stat_HHb_net.motor, NM_S_HHb.correct_stat.motor, NM_S_HHb.correct_stat_R.motor, NM_S_HHb.correct_stat_L.motor, ...
    NM_S_HHb.CM_stat.Train_motor, NM_S_HHb.CM_stat.Test_motor, NM_S_HHb.MANOVA.d_motor, NM_S_HHb.MANOVA.p_motor] = ...
    svm_statistical(subject, idx_subj_train, idx_subj_test, num_L, [motor_ch_dx, motor_ch_sx]);
% CORTECCIA FRONTALE
[NM_SVM.stat_HHb_net.frontal, NM_S_HHb.correct_stat.frontal, NM_S_HHb.correct_stat_R.frontal, NM_S_HHb.correct_stat_L.frontal,...
    NM_S_HHb.CM_stat.Train_frontal, NM_S_HHb.CM_stat.Test_frontal, NM_S_HHb.MANOVA.d_frontal, NM_S_HHb.MANOVA.p_frontal] = ...
    svm_statistical(subject, idx_subj_train, idx_subj_test, num_L, frontal_ch);
% CORTECCIA OCCIPITALE
[NM_SVM.stat_HHb_net.occipital, NM_S_HHb.correct_stat.occipital, NM_S_HHb.correct_stat_R.occipital, NM_S_HHb.correct_stat_L.occipital,...
    NM_S_HHb.CM_stat.Train_occipital,NM_S_HHb.CM_stat.Test_occipital, NM_S_HHb.MANOVA.d_occipital, NM_S_HHb.MANOVA.p_occipital] = ...
    svm_statistical(subject, idx_subj_train, idx_subj_test, num_L, occipital_ch);
% TUTTI I CANALI
[NM_SVM.stat_HHb_net.all, NM_S_HHb.correct_stat.all, NM_S_HHb.correct_stat_R.all, NM_S_HHb.correct_stat_L.all,...
    NM_S_HHb.CM_stat.Train_all, NM_S_HHb.CM_stat.Test_all, NM_S_HHb.MANOVA.d_all, NM_S_HHb.MANOVA.p_all] = ...
    svm_statistical(subject, idx_subj_train, idx_subj_test, num_L, all_ch);

% Valutazione delle performance
NM_S_HHb.err_std.motor_train = std(NM_S_HHb.correct_stat.motor(idx_subj_train),[])/sqrt(n_subjects);
NM_S_HHb.accuracy.motor_train = mean(NM_S_HHb.correct_stat.motor(idx_subj_train));
NM_S_HHb.err_std.frontal_train = std(NM_S_HHb.correct_stat.frontal(idx_subj_train),[])/sqrt(n_subjects);
NM_S_HHb.accuracy.frontal_train = mean(NM_S_HHb.correct_stat.frontal(idx_subj_train));
NM_S_HHb.err_std.occipital_train = std(NM_S_HHb.correct_stat.occipital(idx_subj_train),[])/sqrt(n_subjects);
NM_S_HHb.accuracy.occipital_train = mean(NM_S_HHb.correct_stat.occipital(idx_subj_train));
NM_S_HHb.err_std.all_train = std(NM_S_HHb.correct_stat.all(idx_subj_train),[])/sqrt(n_subjects);
NM_S_HHb.accuracy.all_train = mean(NM_S_HHb.correct_stat.all(idx_subj_train));

NM_S_HHb.err_std.motor_test = std(NM_S_HHb.correct_stat.motor(idx_subj_test),[])/sqrt(n_subjects);
NM_S_HHb.accuracy.motor_test = mean(NM_S_HHb.correct_stat.motor(idx_subj_test));
NM_S_HHb.err_std.frontal_test = std(NM_S_HHb.correct_stat.frontal(idx_subj_test),[])/sqrt(n_subjects);
NM_S_HHb.accuracy.frontal_test = mean(NM_S_HHb.correct_stat.frontal(idx_subj_test));
NM_S_HHb.err_std.occipital_test = std(NM_S_HHb.correct_stat.occipital(idx_subj_test),[])/sqrt(n_subjects);
NM_S_HHb.accuracy.occipital_test = mean(NM_S_HHb.correct_stat.occipital(idx_subj_test));
NM_S_HHb.err_std.all_test = std(NM_S_HHb.correct_stat.all(idx_subj_test),[])/sqrt(n_subjects);
NM_S_HHb.accuracy.all_test = mean(NM_S_HHb.correct_stat.all(idx_subj_test));

% totale (Training+Test)
NM_S_HHb.err_std.motor_total = std(NM_S_HHb.correct_stat.motor,[])/sqrt(n_subjects);
NM_S_HHb.accuracy.motor_total = mean(NM_S_HHb.correct_stat.motor);
NM_S_HHb.err_std.frontal_total = std(NM_S_HHb.correct_stat.frontal,[])/sqrt(n_subjects);
NM_S_HHb.accuracy.frontal_total = mean(NM_S_HHb.correct_stat.frontal);
NM_S_HHb.err_std.occipital_total = std(NM_S_HHb.correct_stat.occipital,[])/sqrt(n_subjects);
NM_S_HHb.accuracy.occipital_total = mean(NM_S_HHb.correct_stat.occipital);
NM_S_HHb.err_std.all_total = std(NM_S_HHb.correct_stat.all,[])/sqrt(n_subjects);
NM_S_HHb.accuracy.all_total = mean(NM_S_HHb.correct_stat.all);


% Sinistra
NM_S_HHb.err_std.L.motor_train = std(NM_S_HHb.correct_stat_L.motor(idx_subj_train),[])/sqrt(n_subjects);
NM_S_HHb.accuracy.L.motor_train = mean(NM_S_HHb.correct_stat_L.motor(idx_subj_train));
NM_S_HHb.err_std.L.frontal_train = std(NM_S_HHb.correct_stat_L.frontal(idx_subj_train),[])/sqrt(n_subjects);
NM_S_HHb.accuracy.L.frontal_train = mean(NM_S_HHb.correct_stat_L.frontal(idx_subj_train));
NM_S_HHb.err_std.L.occipital_train = std(NM_S_HHb.correct_stat_L.occipital(idx_subj_train),[])/sqrt(n_subjects);
NM_S_HHb.accuracy.L.occipital_train = mean(NM_S_HHb.correct_stat_L.occipital(idx_subj_train));
NM_S_HHb.err_std.L.all_train = std(NM_S_HHb.correct_stat_L.all(idx_subj_train),[])/sqrt(n_subjects);
NM_S_HHb.accuracy.L.all_train = mean(NM_S_HHb.correct_stat_L.all(idx_subj_train));

NM_S_HHb.err_std.L.motor_test = std(NM_S_HHb.correct_stat_L.motor(idx_subj_test),[])/sqrt(n_subjects);
NM_S_HHb.accuracy.L.motor_test = mean(NM_S_HHb.correct_stat_L.motor(idx_subj_test));
NM_S_HHb.err_std.L.frontal_test = std(NM_S_HHb.correct_stat_L.frontal(idx_subj_test),[])/sqrt(n_subjects);
NM_S_HHb.accuracy.L.frontal_test = mean(NM_S_HHb.correct_stat_L.frontal(idx_subj_test));
NM_S_HHb.err_std.L.occipital_test = std(NM_S_HHb.correct_stat_L.occipital(idx_subj_test),[])/sqrt(n_subjects);
NM_S_HHb.accuracy.L.occipital_test = mean(NM_S_HHb.correct_stat_L.occipital(idx_subj_test));
NM_S_HHb.err_std.L.all_test = std(NM_S_HHb.correct_stat_L.all(idx_subj_test),[])/sqrt(n_subjects);
NM_S_HHb.accuracy.L.all_test = mean(NM_S_HHb.correct_stat_L.all(idx_subj_test));

NM_S_HHb.err_std.L.motor_total = std(NM_S_HHb.correct_stat_L.motor,[])/sqrt(n_subjects);
NM_S_HHb.accuracy.L.motor_total = mean(NM_S_HHb.correct_stat_L.motor);
NM_S_HHb.err_std.L.frontal_total = std(NM_S_HHb.correct_stat_L.frontal,[])/sqrt(n_subjects);
NM_S_HHb.accuracy.L.frontal_total = mean(NM_S_HHb.correct_stat_L.frontal);
NM_S_HHb.err_std.L.occipital_total = std(NM_S_HHb.correct_stat_L.occipital,[])/sqrt(n_subjects);
NM_S_HHb.accuracy.L.occipital_total = mean(NM_S_HHb.correct_stat_L.occipital);
NM_S_HHb.err_std.L.all_total = std(NM_S_HHb.correct_stat_L.all,[])/sqrt(n_subjects);
NM_S_HHb.accuracy.L.all_total = mean(NM_S_HHb.correct_stat_L.all);

% Destra
NM_S_HHb.err_std.R.motor_train = std(NM_S_HHb.correct_stat_R.motor(idx_subj_train),[])/sqrt(n_subjects);
NM_S_HHb.accuracy.R.motor_train = mean(NM_S_HHb.correct_stat_R.motor(idx_subj_train));
NM_S_HHb.err_std.R.frontal_train = std(NM_S_HHb.correct_stat_R.frontal(idx_subj_train),[])/sqrt(n_subjects);
NM_S_HHb.accuracy.R.frontal_train = mean(NM_S_HHb.correct_stat_R.frontal(idx_subj_train));
NM_S_HHb.err_std.R.occipital_train = std(NM_S_HHb.correct_stat_R.occipital(idx_subj_train),[])/sqrt(n_subjects);
NM_S_HHb.accuracy.R.occipital_train = mean(NM_S_HHb.correct_stat_R.occipital(idx_subj_train));
NM_S_HHb.err_std.R.all_train = std(NM_S_HHb.correct_stat_R.all(idx_subj_train),[])/sqrt(n_subjects);
NM_S_HHb.accuracy.R.all_train = mean(NM_S_HHb.correct_stat_R.all(idx_subj_train));

NM_S_HHb.err_std.R.motor_test = std(NM_S_HHb.correct_stat_R.motor(idx_subj_test),[])/sqrt(n_subjects);
NM_S_HHb.accuracy.R.motor_test = mean(NM_S_HHb.correct_stat_R.motor(idx_subj_test));
NM_S_HHb.err_std.R.frontal_test = std(NM_S_HHb.correct_stat_R.frontal(idx_subj_test),[])/sqrt(n_subjects);
NM_S_HHb.accuracy.R.frontal_test = mean(NM_S_HHb.correct_stat_R.frontal(idx_subj_test));
NM_S_HHb.err_std.R.occipital_test = std(NM_S_HHb.correct_stat_R.occipital(idx_subj_test),[])/sqrt(n_subjects);
NM_S_HHb.accuracy.R.occipital_test = mean(NM_S_HHb.correct_stat_R.occipital(idx_subj_test));
NM_S_HHb.err_std.R.all_test = std(NM_S_HHb.correct_stat_R.all(idx_subj_test),[])/sqrt(n_subjects);
NM_S_HHb.accuracy.R.all_test = mean(NM_S_HHb.correct_stat_R.all(idx_subj_test));

NM_S_HHb.err_std.R.motor_total = std(NM_S_HHb.correct_stat_R.motor,[])/sqrt(n_subjects);
NM_S_HHb.accuracy.R.motor_total = mean(NM_S_HHb.correct_stat_R.motor);
NM_S_HHb.err_std.R.frontal_total = std(NM_S_HHb.correct_stat_R.frontal,[])/sqrt(n_subjects);
NM_S_HHb.accuracy.R.frontal_total = mean(NM_S_HHb.correct_stat_R.frontal);
NM_S_HHb.err_std.R.occipital_total = std(NM_S_HHb.correct_stat_R.occipital,[])/sqrt(n_subjects);
NM_S_HHb.accuracy.R.occipital_total = mean(NM_S_HHb.correct_stat_R.occipital);
NM_S_HHb.err_std.R.all_total = std(NM_S_HHb.correct_stat_R.all,[])/sqrt(n_subjects);
NM_S_HHb.accuracy.R.all_total = mean(NM_S_HHb.correct_stat_R.all);

%% SVM - O2Hb
fprintf('SVM - Statistical O2Hb calculation\n')

NM_S_O2Hb = struct();
% CORTECCIA MOTORIA
[NM_SVM.stat_O2Hb_net.motor, NM_S_O2Hb.correct_stat.motor, NM_S_O2Hb.correct_stat_R.motor, NM_S_O2Hb.correct_stat_L.motor, ...
    NM_S_O2Hb.CM_stat.Train_motor, NM_S_O2Hb.CM_stat.Test_motor, NM_S_O2Hb.MANOVA.d_motor, NM_S_O2Hb.MANOVA.p_motor] = ...
    svm_statistical(subject, idx_subj_train, idx_subj_test, num_L, [motor_ch_dx, motor_ch_sx]+n_ch);
% CORTECCIA FRONTALE
[NM_SVM.stat_O2Hb_net.frontal, NM_S_O2Hb.correct_stat.frontal, NM_S_O2Hb.correct_stat_R.frontal, NM_S_O2Hb.correct_stat_L.frontal,...
    NM_S_O2Hb.CM_stat.Train_frontal, NM_S_O2Hb.CM_stat.Test_frontal, NM_S_O2Hb.MANOVA.d_frontal, NM_S_O2Hb.MANOVA.p_frontal] = ...
    svm_statistical(subject, idx_subj_train, idx_subj_test, num_L, frontal_ch+n_ch);
% CORTECCIA OCCIPITALE
[NM_SVM.stat_O2Hb_net.occipital, NM_S_O2Hb.correct_stat.occipital, NM_S_O2Hb.correct_stat_R.occipital, NM_S_O2Hb.correct_stat_L.occipital,...
    NM_S_O2Hb.CM_stat.Train_occipital,NM_S_O2Hb.CM_stat.Test_occipital, NM_S_O2Hb.MANOVA.d_occipital, NM_S_O2Hb.MANOVA.p_occipital] = ...
    svm_statistical(subject, idx_subj_train, idx_subj_test, num_L, occipital_ch+n_ch);
% TUTTI I CANALI
[NM_SVM.stat_O2Hb_net.all, NM_S_O2Hb.correct_stat.all, NM_S_O2Hb.correct_stat_R.all, NM_S_O2Hb.correct_stat_L.all,...
    NM_S_O2Hb.CM_stat.Train_all, NM_S_O2Hb.CM_stat.Test_all, NM_S_O2Hb.MANOVA.d_all, NM_S_O2Hb.MANOVA.p_all] = ...
    svm_statistical(subject, idx_subj_train, idx_subj_test, num_L, all_ch+n_ch);

% Valutazione delle performances
NM_S_O2Hb.err_std.motor_train = std(NM_S_O2Hb.correct_stat.motor(idx_subj_train),[])/sqrt(n_subjects);
NM_S_O2Hb.accuracy.motor_train = mean(NM_S_O2Hb.correct_stat.motor(idx_subj_train));
NM_S_O2Hb.err_std.frontal_train = std(NM_S_O2Hb.correct_stat.frontal(idx_subj_train),[])/sqrt(n_subjects);
NM_S_O2Hb.accuracy.frontal_train = mean(NM_S_O2Hb.correct_stat.frontal(idx_subj_train));
NM_S_O2Hb.err_std.occipital_train = std(NM_S_O2Hb.correct_stat.occipital(idx_subj_train),[])/sqrt(n_subjects);
NM_S_O2Hb.accuracy.occipital_train = mean(NM_S_O2Hb.correct_stat.occipital(idx_subj_train));
NM_S_O2Hb.err_std.all_train = std(NM_S_O2Hb.correct_stat.all(idx_subj_train),[])/sqrt(n_subjects);
NM_S_O2Hb.accuracy.all_train = mean(NM_S_O2Hb.correct_stat.all(idx_subj_train));

NM_S_O2Hb.err_std.motor_test = std(NM_S_O2Hb.correct_stat.motor(idx_subj_test),[])/sqrt(n_subjects);
NM_S_O2Hb.accuracy.motor_test = mean(NM_S_O2Hb.correct_stat.motor(idx_subj_test));
NM_S_O2Hb.err_std.frontal_test = std(NM_S_O2Hb.correct_stat.frontal(idx_subj_test),[])/sqrt(n_subjects);
NM_S_O2Hb.accuracy.frontal_test = mean(NM_S_O2Hb.correct_stat.frontal(idx_subj_test));
NM_S_O2Hb.err_std.occipital_test = std(NM_S_O2Hb.correct_stat.occipital(idx_subj_test),[])/sqrt(n_subjects);
NM_S_O2Hb.accuracy.occipital_test = mean(NM_S_O2Hb.correct_stat.occipital(idx_subj_test));
NM_S_O2Hb.err_std.all_test = std(NM_S_O2Hb.correct_stat.all(idx_subj_test),[])/sqrt(n_subjects);
NM_S_O2Hb.accuracy.all_test = mean(NM_S_O2Hb.correct_stat.all(idx_subj_test));

% totale (Training+Test)
NM_S_O2Hb.err_std.motor_total = std(NM_S_O2Hb.correct_stat.motor,[])/sqrt(n_subjects);
NM_S_O2Hb.accuracy.motor_total = mean(NM_S_O2Hb.correct_stat.motor);
NM_S_O2Hb.err_std.frontal_total = std(NM_S_O2Hb.correct_stat.frontal,[])/sqrt(n_subjects);
NM_S_O2Hb.accuracy.frontal_total = mean(NM_S_O2Hb.correct_stat.frontal);
NM_S_O2Hb.err_std.occipital_total = std(NM_S_O2Hb.correct_stat.occipital,[])/sqrt(n_subjects);
NM_S_O2Hb.accuracy.occipital_total = mean(NM_S_O2Hb.correct_stat.occipital);
NM_S_O2Hb.err_std.all_total = std(NM_S_O2Hb.correct_stat.all,[])/sqrt(n_subjects);
NM_S_O2Hb.accuracy.all_total = mean(NM_S_O2Hb.correct_stat.all);

% Sinistra
NM_S_O2Hb.err_std.L.motor_train = std(NM_S_O2Hb.correct_stat_L.motor(idx_subj_train),[])/sqrt(n_subjects);
NM_S_O2Hb.accuracy.L.motor_train = mean(NM_S_O2Hb.correct_stat_L.motor(idx_subj_train));
NM_S_O2Hb.err_std.L.frontal_train = std(NM_S_O2Hb.correct_stat_L.frontal(idx_subj_train),[])/sqrt(n_subjects);
NM_S_O2Hb.accuracy.L.frontal_train = mean(NM_S_O2Hb.correct_stat_L.frontal(idx_subj_train));
NM_S_O2Hb.err_std.L.occipital_train = std(NM_S_O2Hb.correct_stat_L.occipital(idx_subj_train),[])/sqrt(n_subjects);
NM_S_O2Hb.accuracy.L.occipital_train = mean(NM_S_O2Hb.correct_stat_L.occipital(idx_subj_train));
NM_S_O2Hb.err_std.L.all_train = std(NM_S_O2Hb.correct_stat_L.all(idx_subj_train),[])/sqrt(n_subjects);
NM_S_O2Hb.accuracy.L.all_train = mean(NM_S_O2Hb.correct_stat_L.all(idx_subj_train));

NM_S_O2Hb.err_std.L.motor_test = std(NM_S_O2Hb.correct_stat_L.motor(idx_subj_test),[])/sqrt(n_subjects);
NM_S_O2Hb.accuracy.L.motor_test = mean(NM_S_O2Hb.correct_stat_L.motor(idx_subj_test));
NM_S_O2Hb.err_std.L.frontal_test = std(NM_S_O2Hb.correct_stat_L.frontal(idx_subj_test),[])/sqrt(n_subjects);
NM_S_O2Hb.accuracy.L.frontal_test = mean(NM_S_O2Hb.correct_stat_L.frontal(idx_subj_test));
NM_S_O2Hb.err_std.L.occipital_test = std(NM_S_O2Hb.correct_stat_L.occipital(idx_subj_test),[])/sqrt(n_subjects);
NM_S_O2Hb.accuracy.L.occipital_test = mean(NM_S_O2Hb.correct_stat_L.occipital(idx_subj_test));
NM_S_O2Hb.err_std.L.all_test = std(NM_S_O2Hb.correct_stat_L.all(idx_subj_test),[])/sqrt(n_subjects);
NM_S_O2Hb.accuracy.L.all_test = mean(NM_S_O2Hb.correct_stat_L.all(idx_subj_test));

NM_S_O2Hb.err_std.L.motor_total = std(NM_S_O2Hb.correct_stat_L.motor,[])/sqrt(n_subjects);
NM_S_O2Hb.accuracy.L.motor_total = mean(NM_S_O2Hb.correct_stat_L.motor);
NM_S_O2Hb.err_std.L.frontal_total = std(NM_S_O2Hb.correct_stat_L.frontal,[])/sqrt(n_subjects);
NM_S_O2Hb.accuracy.L.frontal_total = mean(NM_S_O2Hb.correct_stat_L.frontal);
NM_S_O2Hb.err_std.L.occipital_total = std(NM_S_O2Hb.correct_stat_L.occipital,[])/sqrt(n_subjects);
NM_S_O2Hb.accuracy.L.occipital_total = mean(NM_S_O2Hb.correct_stat_L.occipital);
NM_S_O2Hb.err_std.L.all_total = std(NM_S_O2Hb.correct_stat_L.all,[])/sqrt(n_subjects);
NM_S_O2Hb.accuracy.L.all_total = mean(NM_S_O2Hb.correct_stat_L.all);

% Destra
NM_S_O2Hb.err_std.R.motor_train = std(NM_S_O2Hb.correct_stat_R.motor(idx_subj_train),[])/sqrt(n_subjects);
NM_S_O2Hb.accuracy.R.motor_train = mean(NM_S_O2Hb.correct_stat_R.motor(idx_subj_train));
NM_S_O2Hb.err_std.R.frontal_train = std(NM_S_O2Hb.correct_stat_R.frontal(idx_subj_train),[])/sqrt(n_subjects);
NM_S_O2Hb.accuracy.R.frontal_train = mean(NM_S_O2Hb.correct_stat_R.frontal(idx_subj_train));
NM_S_O2Hb.err_std.R.occipital_train = std(NM_S_O2Hb.correct_stat_R.occipital(idx_subj_train),[])/sqrt(n_subjects);
NM_S_O2Hb.accuracy.R.occipital_train = mean(NM_S_O2Hb.correct_stat_R.occipital(idx_subj_train));
NM_S_O2Hb.err_std.R.all_train = std(NM_S_O2Hb.correct_stat_R.all(idx_subj_train),[])/sqrt(n_subjects);
NM_S_O2Hb.accuracy.R.all_train = mean(NM_S_O2Hb.correct_stat_R.all(idx_subj_train));

NM_S_O2Hb.err_std.R.motor_test = std(NM_S_O2Hb.correct_stat_R.motor(idx_subj_test),[])/sqrt(n_subjects);
NM_S_O2Hb.accuracy.R.motor_test = mean(NM_S_O2Hb.correct_stat_R.motor(idx_subj_test));
NM_S_O2Hb.err_std.R.frontal_test = std(NM_S_O2Hb.correct_stat_R.frontal(idx_subj_test),[])/sqrt(n_subjects);
NM_S_O2Hb.accuracy.R.frontal_test = mean(NM_S_O2Hb.correct_stat_R.frontal(idx_subj_test));
NM_S_O2Hb.err_std.R.occipital_test = std(NM_S_O2Hb.correct_stat_R.occipital(idx_subj_test),[])/sqrt(n_subjects);
NM_S_O2Hb.accuracy.R.occipital_test = mean(NM_S_O2Hb.correct_stat_R.occipital(idx_subj_test));
NM_S_O2Hb.err_std.R.all_test = std(NM_S_O2Hb.correct_stat_R.all(idx_subj_test),[])/sqrt(n_subjects);
NM_S_O2Hb.accuracy.R.all_test = mean(NM_S_O2Hb.correct_stat_R.all(idx_subj_test));

NM_S_O2Hb.err_std.R.motor_total = std(NM_S_O2Hb.correct_stat_R.motor,[])/sqrt(n_subjects);
NM_S_O2Hb.accuracy.R.motor_total = mean(NM_S_O2Hb.correct_stat_R.motor);
NM_S_O2Hb.err_std.R.frontal_total = std(NM_S_O2Hb.correct_stat_R.frontal,[])/sqrt(n_subjects);
NM_S_O2Hb.accuracy.R.frontal_total = mean(NM_S_O2Hb.correct_stat_R.frontal);
NM_S_O2Hb.err_std.R.occipital_total = std(NM_S_O2Hb.correct_stat_R.occipital,[])/sqrt(n_subjects);
NM_S_O2Hb.accuracy.R.occipital_total = mean(NM_S_O2Hb.correct_stat_R.occipital);
NM_S_O2Hb.err_std.R.all_total = std(NM_S_O2Hb.correct_stat_R.all,[])/sqrt(n_subjects);
NM_S_O2Hb.accuracy.R.all_total = mean(NM_S_O2Hb.correct_stat_R.all);

%% +++++++++++++ TEMPORAL DATA ++++++++++++++++++++++++++++
%% SVM - HHb
fprintf('SVM - Temporal HHb calculation\n')
NM_T_HHb = struct();

% CORTECCIA MOTORIA
[NM_SVM.stat_HHb_net.motor, NM_T_HHb.correct_stat.motor, NM_T_HHb.correct_stat_R.motor, NM_T_HHb.correct_stat_L.motor, ...
    NM_T_HHb.CM_stat.Train_motor, NM_T_HHb.CM_stat.Test_motor, NM_T_HHb.MANOVA.d_motor, NM_T_HHb.MANOVA.p_motor] = ...
    svm_temp(subject, idx_subj_train, idx_subj_test, num_L, [motor_ch_dx, motor_ch_sx]);
% CORTECCIA FRONTALE
[NM_SVM.stat_HHb_net.frontal, NM_T_HHb.correct_stat.frontal, NM_T_HHb.correct_stat_R.frontal, NM_T_HHb.correct_stat_L.frontal,...
    NM_T_HHb.CM_stat.Train_frontal, NM_T_HHb.CM_stat.Test_frontal, NM_T_HHb.MANOVA.d_frontal, NM_T_HHb.MANOVA.p_frontal] = ...
    svm_temp(subject, idx_subj_train, idx_subj_test, num_L, frontal_ch);
% CORTECCIA OCCIPITALE
[NM_SVM.stat_HHb_net.occipital, NM_T_HHb.correct_stat.occipital, NM_T_HHb.correct_stat_R.occipital, NM_T_HHb.correct_stat_L.occipital,...
    NM_T_HHb.CM_stat.Train_occipital,NM_T_HHb.CM_stat.Test_occipital, NM_T_HHb.MANOVA.d_occipital, NM_T_HHb.MANOVA.p_occipital] = ...
    svm_temp(subject, idx_subj_train, idx_subj_test, num_L, occipital_ch);
% TUTTI I CANALI
[NM_SVM.stat_HHb_net.all, NM_T_HHb.correct_stat.all, NM_T_HHb.correct_stat_R.all, NM_T_HHb.correct_stat_L.all,...
    NM_T_HHb.CM_stat.Train_all, NM_T_HHb.CM_stat.Test_all, NM_T_HHb.MANOVA.d_all, NM_T_HHb.MANOVA.p_all] = ...
    svm_temp(subject, idx_subj_train, idx_subj_test, num_L, all_ch);

% Valutazione delle performances
NM_T_HHb.err_std.motor_train = std(NM_T_HHb.correct_stat.motor(idx_subj_train),[])/sqrt(n_subjects);
NM_T_HHb.accuracy.motor_train = mean(NM_T_HHb.correct_stat.motor(idx_subj_train));
NM_T_HHb.err_std.frontal_train = std(NM_T_HHb.correct_stat.frontal(idx_subj_train),[])/sqrt(n_subjects);
NM_T_HHb.accuracy.frontal_train = mean(NM_T_HHb.correct_stat.frontal(idx_subj_train));
NM_T_HHb.err_std.occipital_train = std(NM_T_HHb.correct_stat.occipital(idx_subj_train),[])/sqrt(n_subjects);
NM_T_HHb.accuracy.occipital_train = mean(NM_T_HHb.correct_stat.occipital(idx_subj_train));
NM_T_HHb.err_std.all_train = std(NM_T_HHb.correct_stat.all(idx_subj_train),[])/sqrt(n_subjects);
NM_T_HHb.accuracy.all_train = mean(NM_T_HHb.correct_stat.all(idx_subj_train));

NM_T_HHb.err_std.motor_test = std(NM_T_HHb.correct_stat.motor(idx_subj_test),[])/sqrt(n_subjects);
NM_T_HHb.accuracy.motor_test = mean(NM_T_HHb.correct_stat.motor(idx_subj_test));
NM_T_HHb.err_std.frontal_test = std(NM_T_HHb.correct_stat.frontal(idx_subj_test),[])/sqrt(n_subjects);
NM_T_HHb.accuracy.frontal_test = mean(NM_T_HHb.correct_stat.frontal(idx_subj_test));
NM_T_HHb.err_std.occipital_test = std(NM_T_HHb.correct_stat.occipital(idx_subj_test),[])/sqrt(n_subjects);
NM_T_HHb.accuracy.occipital_test = mean(NM_T_HHb.correct_stat.occipital(idx_subj_test));
NM_T_HHb.err_std.all_test = std(NM_T_HHb.correct_stat.all(idx_subj_test),[])/sqrt(n_subjects);
NM_T_HHb.accuracy.all_test = mean(NM_T_HHb.correct_stat.all(idx_subj_test));

% totale (Training+Test)
NM_T_HHb.err_std.motor_total = std(NM_T_HHb.correct_stat.motor,[])/sqrt(n_subjects);
NM_T_HHb.accuracy.motor_total = mean(NM_T_HHb.correct_stat.motor);
NM_T_HHb.err_std.frontal_total = std(NM_T_HHb.correct_stat.frontal,[])/sqrt(n_subjects);
NM_T_HHb.accuracy.frontal_total = mean(NM_T_HHb.correct_stat.frontal);
NM_T_HHb.err_std.occipital_total = std(NM_T_HHb.correct_stat.occipital,[])/sqrt(n_subjects);
NM_T_HHb.accuracy.occipital_total = mean(NM_T_HHb.correct_stat.occipital);
NM_T_HHb.err_std.all_total = std(NM_T_HHb.correct_stat.all,[])/sqrt(n_subjects);
NM_T_HHb.accuracy.all_total = mean(NM_T_HHb.correct_stat.all);

% Sinistra
NM_T_HHb.err_std.L.motor_train = std(NM_T_HHb.correct_stat_L.motor(idx_subj_train),[])/sqrt(n_subjects);
NM_T_HHb.accuracy.L.motor_train = mean(NM_T_HHb.correct_stat_L.motor(idx_subj_train));
NM_T_HHb.err_std.L.frontal_train = std(NM_T_HHb.correct_stat_L.frontal(idx_subj_train),[])/sqrt(n_subjects);
NM_T_HHb.accuracy.L.frontal_train = mean(NM_T_HHb.correct_stat_L.frontal(idx_subj_train));
NM_T_HHb.err_std.L.occipital_train = std(NM_T_HHb.correct_stat_L.occipital(idx_subj_train),[])/sqrt(n_subjects);
NM_T_HHb.accuracy.L.occipital_train = mean(NM_T_HHb.correct_stat_L.occipital(idx_subj_train));
NM_T_HHb.err_std.L.all_train = std(NM_T_HHb.correct_stat_L.all(idx_subj_train),[])/sqrt(n_subjects);
NM_T_HHb.accuracy.L.all_train = mean(NM_T_HHb.correct_stat_L.all(idx_subj_train));

NM_T_HHb.err_std.L.motor_test = std(NM_T_HHb.correct_stat_L.motor(idx_subj_test),[])/sqrt(n_subjects);
NM_T_HHb.accuracy.L.motor_test = mean(NM_T_HHb.correct_stat_L.motor(idx_subj_test));
NM_T_HHb.err_std.L.frontal_test = std(NM_T_HHb.correct_stat_L.frontal(idx_subj_test),[])/sqrt(n_subjects);
NM_T_HHb.accuracy.L.frontal_test = mean(NM_T_HHb.correct_stat_L.frontal(idx_subj_test));
NM_T_HHb.err_std.L.occipital_test = std(NM_T_HHb.correct_stat_L.occipital(idx_subj_test),[])/sqrt(n_subjects);
NM_T_HHb.accuracy.L.occipital_test = mean(NM_T_HHb.correct_stat_L.occipital(idx_subj_test));
NM_T_HHb.err_std.L.all_test = std(NM_T_HHb.correct_stat_L.all(idx_subj_test),[])/sqrt(n_subjects);
NM_T_HHb.accuracy.L.all_test = mean(NM_T_HHb.correct_stat_L.all(idx_subj_test));

NM_T_HHb.err_std.L.motor_total = std(NM_T_HHb.correct_stat_L.motor,[])/sqrt(n_subjects);
NM_T_HHb.accuracy.L.motor_total = mean(NM_T_HHb.correct_stat_L.motor);
NM_T_HHb.err_std.L.frontal_total = std(NM_T_HHb.correct_stat_L.frontal,[])/sqrt(n_subjects);
NM_T_HHb.accuracy.L.frontal_total = mean(NM_T_HHb.correct_stat_L.frontal);
NM_T_HHb.err_std.L.occipital_total = std(NM_T_HHb.correct_stat_L.occipital,[])/sqrt(n_subjects);
NM_T_HHb.accuracy.L.occipital_total = mean(NM_T_HHb.correct_stat_L.occipital);
NM_T_HHb.err_std.L.all_total = std(NM_T_HHb.correct_stat_L.all,[])/sqrt(n_subjects);
NM_T_HHb.accuracy.L.all_total = mean(NM_T_HHb.correct_stat_L.all);

% Destra
NM_T_HHb.err_std.R.motor_train = std(NM_T_HHb.correct_stat_R.motor(idx_subj_train),[])/sqrt(n_subjects);
NM_T_HHb.accuracy.R.motor_train = mean(NM_T_HHb.correct_stat_R.motor(idx_subj_train));
NM_T_HHb.err_std.R.frontal_train = std(NM_T_HHb.correct_stat_R.frontal(idx_subj_train),[])/sqrt(n_subjects);
NM_T_HHb.accuracy.R.frontal_train = mean(NM_T_HHb.correct_stat_R.frontal(idx_subj_train));
NM_T_HHb.err_std.R.occipital_train = std(NM_T_HHb.correct_stat_R.occipital(idx_subj_train),[])/sqrt(n_subjects);
NM_T_HHb.accuracy.R.occipital_train = mean(NM_T_HHb.correct_stat_R.occipital(idx_subj_train));
NM_T_HHb.err_std.R.all_train = std(NM_T_HHb.correct_stat_R.all(idx_subj_train),[])/sqrt(n_subjects);
NM_T_HHb.accuracy.R.all_train = mean(NM_T_HHb.correct_stat_R.all(idx_subj_train));

NM_T_HHb.err_std.R.motor_test = std(NM_T_HHb.correct_stat_R.motor(idx_subj_test),[])/sqrt(n_subjects);
NM_T_HHb.accuracy.R.motor_test = mean(NM_T_HHb.correct_stat_R.motor(idx_subj_test));
NM_T_HHb.err_std.R.frontal_test = std(NM_T_HHb.correct_stat_R.frontal(idx_subj_test),[])/sqrt(n_subjects);
NM_T_HHb.accuracy.R.frontal_test = mean(NM_T_HHb.correct_stat_R.frontal(idx_subj_test));
NM_T_HHb.err_std.R.occipital_test = std(NM_T_HHb.correct_stat_R.occipital(idx_subj_test),[])/sqrt(n_subjects);
NM_T_HHb.accuracy.R.occipital_test = mean(NM_T_HHb.correct_stat_R.occipital(idx_subj_test));
NM_T_HHb.err_std.R.all_test = std(NM_T_HHb.correct_stat_R.all(idx_subj_test),[])/sqrt(n_subjects);
NM_T_HHb.accuracy.R.all_test = mean(NM_T_HHb.correct_stat_R.all(idx_subj_test));

NM_T_HHb.err_std.R.motor_total = std(NM_T_HHb.correct_stat_R.motor,[])/sqrt(n_subjects);
NM_T_HHb.accuracy.R.motor_total = mean(NM_T_HHb.correct_stat_R.motor);
NM_T_HHb.err_std.R.frontal_total = std(NM_T_HHb.correct_stat_R.frontal,[])/sqrt(n_subjects);
NM_T_HHb.accuracy.R.frontal_total = mean(NM_T_HHb.correct_stat_R.frontal);
NM_T_HHb.err_std.R.occipital_total = std(NM_T_HHb.correct_stat_R.occipital,[])/sqrt(n_subjects);
NM_T_HHb.accuracy.R.occipital_total = mean(NM_T_HHb.correct_stat_R.occipital);
NM_T_HHb.err_std.R.all_total = std(NM_T_HHb.correct_stat_R.all,[])/sqrt(n_subjects);
NM_T_HHb.accuracy.R.all_total = mean(NM_T_HHb.correct_stat_R.all);

%% SVM - O2Hb
fprintf('SVM - Statistical O2Hb calculation\n')
NM_T_O2Hb = struct();

% CORTECCIA MOTORIA
[NM_SVM.stat_O2Hb_net.motor, NM_T_O2Hb.correct_stat.motor, NM_T_O2Hb.correct_stat_R.motor, NM_T_O2Hb.correct_stat_L.motor, ...
    NM_T_O2Hb.CM_stat.Train_motor, NM_T_O2Hb.CM_stat.Test_motor, NM_T_O2Hb.MANOVA.d_motor, NM_T_O2Hb.MANOVA.p_motor] = ...
    svm_temp(subject, idx_subj_train, idx_subj_test, num_L, [motor_ch_dx, motor_ch_sx]+n_ch);
% CORTECCIA FRONTALE
[NM_SVM.stat_O2Hb_net.frontal, NM_T_O2Hb.correct_stat.frontal, NM_T_O2Hb.correct_stat_R.frontal, NM_T_O2Hb.correct_stat_L.frontal,...
    NM_T_O2Hb.CM_stat.Train_frontal, NM_T_O2Hb.CM_stat.Test_frontal, NM_T_O2Hb.MANOVA.d_frontal, NM_T_O2Hb.MANOVA.p_frontal] = ...
    svm_temp(subject, idx_subj_train, idx_subj_test, num_L, frontal_ch+n_ch);
% CORTECCIA OCCIPITALE
[NM_SVM.stat_O2Hb_net.occipital, NM_T_O2Hb.correct_stat.occipital, NM_T_O2Hb.correct_stat_R.occipital, NM_T_O2Hb.correct_stat_L.occipital,...
    NM_T_O2Hb.CM_stat.Train_occipital,NM_T_O2Hb.CM_stat.Test_occipital, NM_T_O2Hb.MANOVA.d_occipital, NM_T_O2Hb.MANOVA.p_occipital] = ...
    svm_temp(subject, idx_subj_train, idx_subj_test, num_L, occipital_ch+n_ch);
% ALL
[NM_SVM.stat_O2Hb_net.all, NM_T_O2Hb.correct_stat.all, NM_T_O2Hb.correct_stat_R.all, NM_T_O2Hb.correct_stat_L.all,...
    NM_T_O2Hb.CM_stat.Train_all, NM_T_O2Hb.CM_stat.Test_all, NM_T_O2Hb.MANOVA.d_all, NM_T_O2Hb.MANOVA.p_all] = ...
    svm_temp(subject, idx_subj_train, idx_subj_test, num_L, all_ch+n_ch);

% Valutazione delle performances
NM_T_O2Hb.err_std.motor_train = std(NM_T_O2Hb.correct_stat.motor(idx_subj_train),[])/sqrt(n_subjects);
NM_T_O2Hb.accuracy.motor_train = mean(NM_T_O2Hb.correct_stat.motor(idx_subj_train));
NM_T_O2Hb.err_std.frontal_train = std(NM_T_O2Hb.correct_stat.frontal(idx_subj_train),[])/sqrt(n_subjects);
NM_T_O2Hb.accuracy.frontal_train = mean(NM_T_O2Hb.correct_stat.frontal(idx_subj_train));
NM_T_O2Hb.err_std.occipital_train = std(NM_T_O2Hb.correct_stat.occipital(idx_subj_train),[])/sqrt(n_subjects);
NM_T_O2Hb.accuracy.occipital_train = mean(NM_T_O2Hb.correct_stat.occipital(idx_subj_train));
NM_T_O2Hb.err_std.all_train = std(NM_T_O2Hb.correct_stat.all(idx_subj_train),[])/sqrt(n_subjects);
NM_T_O2Hb.accuracy.all_train = mean(NM_T_O2Hb.correct_stat.all(idx_subj_train));

NM_T_O2Hb.err_std.motor_test = std(NM_T_O2Hb.correct_stat.motor(idx_subj_test),[])/sqrt(n_subjects);
NM_T_O2Hb.accuracy.motor_test = mean(NM_T_O2Hb.correct_stat.motor(idx_subj_test));
NM_T_O2Hb.err_std.frontal_test = std(NM_T_O2Hb.correct_stat.frontal(idx_subj_test),[])/sqrt(n_subjects);
NM_T_O2Hb.accuracy.frontal_test = mean(NM_T_O2Hb.correct_stat.frontal(idx_subj_test));
NM_T_O2Hb.err_std.occipital_test = std(NM_T_O2Hb.correct_stat.occipital(idx_subj_test),[])/sqrt(n_subjects);
NM_T_O2Hb.accuracy.occipital_test = mean(NM_T_O2Hb.correct_stat.occipital(idx_subj_test));
NM_T_O2Hb.err_std.all_test = std(NM_T_O2Hb.correct_stat.all(idx_subj_test),[])/sqrt(n_subjects);
NM_T_O2Hb.accuracy.all_test = mean(NM_T_O2Hb.correct_stat.all(idx_subj_test));

% totale (Training+Test)
NM_T_O2Hb.err_std.motor_total = std(NM_T_O2Hb.correct_stat.motor,[])/sqrt(n_subjects);
NM_T_O2Hb.accuracy.motor_total = mean(NM_T_O2Hb.correct_stat.motor);
NM_T_O2Hb.err_std.frontal_total = std(NM_T_O2Hb.correct_stat.frontal,[])/sqrt(n_subjects);
NM_T_O2Hb.accuracy.frontal_total = mean(NM_T_O2Hb.correct_stat.frontal);
NM_T_O2Hb.err_std.occipital_total = std(NM_T_O2Hb.correct_stat.occipital,[])/sqrt(n_subjects);
NM_T_O2Hb.accuracy.occipital_total = mean(NM_T_O2Hb.correct_stat.occipital);
NM_T_O2Hb.err_std.all_total = std(NM_T_O2Hb.correct_stat.all,[])/sqrt(n_subjects);
NM_T_O2Hb.accuracy.all_total = mean(NM_T_O2Hb.correct_stat.all);

% Sinistra
NM_T_O2Hb.err_std.L.motor_train = std(NM_T_O2Hb.correct_stat_L.motor(idx_subj_train),[])/sqrt(n_subjects);
NM_T_O2Hb.accuracy.L.motor_train = mean(NM_T_O2Hb.correct_stat_L.motor(idx_subj_train));
NM_T_O2Hb.err_std.L.frontal_train = std(NM_T_O2Hb.correct_stat_L.frontal(idx_subj_train),[])/sqrt(n_subjects);
NM_T_O2Hb.accuracy.L.frontal_train = mean(NM_T_O2Hb.correct_stat_L.frontal(idx_subj_train));
NM_T_O2Hb.err_std.L.occipital_train = std(NM_T_O2Hb.correct_stat_L.occipital(idx_subj_train),[])/sqrt(n_subjects);
NM_T_O2Hb.accuracy.L.occipital_train = mean(NM_T_O2Hb.correct_stat_L.occipital(idx_subj_train));
NM_T_O2Hb.err_std.L.all_train = std(NM_T_O2Hb.correct_stat_L.all(idx_subj_train),[])/sqrt(n_subjects);
NM_T_O2Hb.accuracy.L.all_train = mean(NM_T_O2Hb.correct_stat_L.all(idx_subj_train));

NM_T_O2Hb.err_std.L.motor_test = std(NM_T_O2Hb.correct_stat_L.motor(idx_subj_test),[])/sqrt(n_subjects);
NM_T_O2Hb.accuracy.L.motor_test = mean(NM_T_O2Hb.correct_stat_L.motor(idx_subj_test));
NM_T_O2Hb.err_std.L.frontal_test = std(NM_T_O2Hb.correct_stat_L.frontal(idx_subj_test),[])/sqrt(n_subjects);
NM_T_O2Hb.accuracy.L.frontal_test = mean(NM_T_O2Hb.correct_stat_L.frontal(idx_subj_test));
NM_T_O2Hb.err_std.L.occipital_test = std(NM_T_O2Hb.correct_stat_L.occipital(idx_subj_test),[])/sqrt(n_subjects);
NM_T_O2Hb.accuracy.L.occipital_test = mean(NM_T_O2Hb.correct_stat_L.occipital(idx_subj_test));
NM_T_O2Hb.err_std.L.all_test = std(NM_T_O2Hb.correct_stat_L.all(idx_subj_test),[])/sqrt(n_subjects);
NM_T_O2Hb.accuracy.L.all_test = mean(NM_T_O2Hb.correct_stat_L.all(idx_subj_test));

NM_T_O2Hb.err_std.L.motor_total = std(NM_T_O2Hb.correct_stat_L.motor,[])/sqrt(n_subjects);
NM_T_O2Hb.accuracy.L.motor_total = mean(NM_T_O2Hb.correct_stat_L.motor);
NM_T_O2Hb.err_std.L.frontal_total = std(NM_T_O2Hb.correct_stat_L.frontal,[])/sqrt(n_subjects);
NM_T_O2Hb.accuracy.L.frontal_total = mean(NM_T_O2Hb.correct_stat_L.frontal);
NM_T_O2Hb.err_std.L.occipital_total = std(NM_T_O2Hb.correct_stat_L.occipital,[])/sqrt(n_subjects);
NM_T_O2Hb.accuracy.L.occipital_total = mean(NM_T_O2Hb.correct_stat_L.occipital);
NM_T_O2Hb.err_std.L.all_total = std(NM_T_O2Hb.correct_stat_L.all,[])/sqrt(n_subjects);
NM_T_O2Hb.accuracy.L.all_total = mean(NM_T_O2Hb.correct_stat_L.all);

% Destra
NM_T_O2Hb.err_std.R.motor_train = std(NM_T_O2Hb.correct_stat_R.motor(idx_subj_train),[])/sqrt(n_subjects);
NM_T_O2Hb.accuracy.R.motor_train = mean(NM_T_O2Hb.correct_stat_R.motor(idx_subj_train));
NM_T_O2Hb.err_std.R.frontal_train = std(NM_T_O2Hb.correct_stat_R.frontal(idx_subj_train),[])/sqrt(n_subjects);
NM_T_O2Hb.accuracy.R.frontal_train = mean(NM_T_O2Hb.correct_stat_R.frontal(idx_subj_train));
NM_T_O2Hb.err_std.R.occipital_train = std(NM_T_O2Hb.correct_stat_R.occipital(idx_subj_train),[])/sqrt(n_subjects);
NM_T_O2Hb.accuracy.R.occipital_train = mean(NM_T_O2Hb.correct_stat_R.occipital(idx_subj_train));
NM_T_O2Hb.err_std.R.all_train = std(NM_T_O2Hb.correct_stat_R.all(idx_subj_train),[])/sqrt(n_subjects);
NM_T_O2Hb.accuracy.R.all_train = mean(NM_T_O2Hb.correct_stat_R.all(idx_subj_train));

NM_T_O2Hb.err_std.R.motor_test = std(NM_T_O2Hb.correct_stat_R.motor(idx_subj_test),[])/sqrt(n_subjects);
NM_T_O2Hb.accuracy.R.motor_test = mean(NM_T_O2Hb.correct_stat_R.motor(idx_subj_test));
NM_T_O2Hb.err_std.R.frontal_test = std(NM_T_O2Hb.correct_stat_R.frontal(idx_subj_test),[])/sqrt(n_subjects);
NM_T_O2Hb.accuracy.R.frontal_test = mean(NM_T_O2Hb.correct_stat_R.frontal(idx_subj_test));
NM_T_O2Hb.err_std.R.occipital_test = std(NM_T_O2Hb.correct_stat_R.occipital(idx_subj_test),[])/sqrt(n_subjects);
NM_T_O2Hb.accuracy.R.occipital_test = mean(NM_T_O2Hb.correct_stat_R.occipital(idx_subj_test));
NM_T_O2Hb.err_std.R.all_test = std(NM_T_O2Hb.correct_stat_R.all(idx_subj_test),[])/sqrt(n_subjects);
NM_T_O2Hb.accuracy.R.all_test = mean(NM_T_O2Hb.correct_stat_R.all(idx_subj_test));

NM_T_O2Hb.err_std.R.motor_total = std(NM_T_O2Hb.correct_stat_R.motor,[])/sqrt(n_subjects);
NM_T_O2Hb.accuracy.R.motor_total = mean(NM_T_O2Hb.correct_stat_R.motor);
NM_T_O2Hb.err_std.R.frontal_total = std(NM_T_O2Hb.correct_stat_R.frontal,[])/sqrt(n_subjects);
NM_T_O2Hb.accuracy.R.frontal_total = mean(NM_T_O2Hb.correct_stat_R.frontal);
NM_T_O2Hb.err_std.R.occipital_total = std(NM_T_O2Hb.correct_stat_R.occipital,[])/sqrt(n_subjects);
NM_T_O2Hb.accuracy.R.occipital_total = mean(NM_T_O2Hb.correct_stat_R.occipital);
NM_T_O2Hb.err_std.R.all_total = std(NM_T_O2Hb.correct_stat_R.all,[])/sqrt(n_subjects);
NM_T_O2Hb.accuracy.R.all_total = mean(NM_T_O2Hb.correct_stat_R.all);

%% salvataggio dati
fprintf('Data saving...\n')

% SVM
save('Results/NM_SVM.mat', 'NM_SVM', 'NM_c')
% risultati allenamento rete - statistici
save('Results/NM_S_HHb.mat', 'NM_S_HHb')
save('Results/NM_S_O2Hb.mat', 'NM_S_O2Hb')
% risultati allenamento rete - temporali
save('Results/NM_T_HHb.mat', 'NM_T_HHb')
save('Results/NM_T_O2Hb.mat', 'NM_T_O2Hb')

fprintf('Done!\n')