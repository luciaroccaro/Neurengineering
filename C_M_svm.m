% Neuroengineering
% Laboratory 4

% Rigazio Sofia - 282247
% Roccaro Lucia - 289423
% Romano Anastasio - 289707
% Ruzzante Elena - 292194


% DESCRIZIONE SCRIPT: in questo script vengono creati i vari classificatori
% tramite le apposite funzioni (svm_statistical, svm_temp), utilizzando i
% segnali ricavati CON media temporale sui vari trial (1 vettore per task R
% e 1 vettore per task L per ogni canale di ogni soggetto) 

% Al termine dello script, si avrà a disposizione una serie di struct, al
% cui interno sono contenuti i vari classificatori SVM allenati, le varie
% classificazioni ottenute dalle medesime, ed i relativi valori di
% accuratezza e errore standard per ogni casistica. Per completezza, sono
% state anche ricavate le relative confusion matrix.

clear variables
close all
clc

%% Caricamento dei dati
fprintf('Mediated ephochs - SVM Calculation\n')
fprintf('Data loading and initial definitions\n')

addpath Results
addpath Functions

load('M_subject.mat');
load('params.mat');

%% Definizione dei canali e inizializzazione strutture
M_SVM = struct();

frontal_ch = 1:9;
occipital_ch = 10:12;
motor_ch_sx = 13:24;
motor_ch_dx = 25:36;
all_ch = 1:n_ch;

% creazione delle struct vuote che conterranno i risultati
M_T_HHb = struct();
M_T_O2Hb = struct();
M_S_HHb = struct();
M_S_O2Hb = struct();

%% Divisione in Training e Test Set
% suddivisione randomica dei soggetti in training set e test set
index_all_subject = 1:1:n_subjects; % vettore che contiene tutti i soggetti
M_c = cvpartition(n_subjects,'Leaveout');  % crea i 29 vettori con randomici i vari leave one out

%% Classificazione
fprintf('SVM Classification\n')

for trial = 1:n_subjects
    set = training(M_c,trial);
    index_subj_train = index_all_subject(set);
    index_subj_test = index_all_subject(~set);
    n_subj_train = length(index_subj_train); % numero di soggetti per allenare la rete (training set)
    n_subj_test = n_subjects - n_subj_train; % numero di soggetti per il test

    %% +++++++++++++ TEMPORAL DATA ++++++++++++++++++++++++++++
    % +++++++++++++ HHb +++++++++++++++++++++++++
    % CORTECCIA MOTORIA
    [M_SVM(trial).HHb_net.motor, M_T_HHb.correct_stat.motor(trial,:), M_T_HHb.correct_stat_R.motor(trial,:), M_T_HHb.correct_stat_L.motor(trial,:), ...
        M_T_HHb.CM_stat.Train_motor, M_T_HHb.CM_stat.Test_motor, M_T_HHb.MANOVA.d_motor, M_T_HHb.MANOVA.p_motor] = ...
        svm_temp(subject, index_subj_train, index_subj_test, 1, [motor_ch_dx, motor_ch_sx]);
    
    M_T_HHb.L1O_predicted_class.motor(index_subj_test) = M_T_HHb.correct_stat.motor(trial, index_subj_test);
    M_T_HHb.L1O_predicted_class_R.motor(index_subj_test) = M_T_HHb.correct_stat_R.motor(trial, index_subj_test);
    M_T_HHb.L1O_predicted_class_L.motor(index_subj_test) = M_T_HHb.correct_stat_L.motor(trial, index_subj_test);

    % CORTECCIA FRONTALE
    [M_SVM(trial).HHb_net.frontal, M_T_HHb.correct_stat.frontal(trial,:), M_T_HHb.correct_stat_R.frontal(trial,:), M_T_HHb.correct_stat_L.frontal(trial,:),...
        M_T_HHb.CM_stat.Train_frontal, M_T_HHb.CM_stat.Test_frontal, M_T_HHb.MANOVA.d_frontal, M_T_HHb.MANOVA.p_frontal] = ...
        svm_temp(subject, index_subj_train, index_subj_test, 1, frontal_ch);
   
    M_T_HHb.L1O_predicted_class.frontal(index_subj_test) = M_T_HHb.correct_stat.frontal(trial, index_subj_test);
    M_T_HHb.L1O_predicted_class_R.frontal(index_subj_test) = M_T_HHb.correct_stat_R.frontal(trial, index_subj_test);
    M_T_HHb.L1O_predicted_class_L.frontal(index_subj_test) = M_T_HHb.correct_stat_L.frontal(trial, index_subj_test);

    % CORTECCIA OCCIPITALE
    [M_SVM(trial).HHb_net.occipital, M_T_HHb.correct_stat.occipital(trial,:), M_T_HHb.correct_stat_R.occipital(trial,:), M_T_HHb.correct_stat_L.occipital(trial,:),...
        M_T_HHb.CM_stat.Train_occipital,M_T_HHb.CM_stat.Test_occipital, M_T_HHb.MANOVA.d_occipital, M_T_HHb.MANOVA.p_occipital] = ...
        svm_temp(subject, index_subj_train, index_subj_test, 1, occipital_ch);
    
    M_T_HHb.L1O_predicted_class.occipital(index_subj_test) = M_T_HHb.correct_stat.occipital(trial, index_subj_test);
    M_T_HHb.L1O_predicted_class_R.occipital(index_subj_test) = M_T_HHb.correct_stat_R.occipital(trial, index_subj_test);
    M_T_HHb.L1O_predicted_class_L.occipital(index_subj_test) = M_T_HHb.correct_stat_L.occipital(trial, index_subj_test);

    % TUTTI I CANALI
    [M_SVM(trial).HHb_net.all, M_T_HHb.correct_stat.all(trial,:), M_T_HHb.correct_stat_R.all(trial,:), M_T_HHb.correct_stat_L.all(trial,:),...
        M_T_HHb.CM_stat.Train_all, M_T_HHb.CM_stat.Test_all, M_T_HHb.MANOVA.d_all, M_T_HHb.MANOVA.p_all] = ...
        svm_temp(subject, index_subj_train, index_subj_test, 1, all_ch);
    
    M_T_HHb.L1O_predicted_class.all(index_subj_test) = M_T_HHb.correct_stat.all(trial, index_subj_test);
    M_T_HHb.L1O_predicted_class_R.all(index_subj_test) = M_T_HHb.correct_stat_R.all(trial, index_subj_test);
    M_T_HHb.L1O_predicted_class_L.all(index_subj_test) = M_T_HHb.correct_stat_L.all(trial, index_subj_test);
    
    % +++++++++++++ O2Hb +++++++++++++++++++++++++
    % CORTECCIA MOTORIA
    [M_SVM(trial).O2Hb_net.motor, M_T_O2Hb.correct_stat.motor(trial,:), M_T_O2Hb.correct_stat_R.motor(trial,:), M_T_O2Hb.correct_stat_L.motor(trial,:),...
        M_T_O2Hb.CM_stat.Train_motor, M_T_O2Hb.CM_stat.Test_motor, M_T_O2Hb.MANOVA.d_motor, M_T_O2Hb.MANOVA.p_motor] = ...
        svm_temp(subject, index_subj_train, index_subj_test, 1, [motor_ch_dx, motor_ch_sx]+n_ch);
    
    M_T_O2Hb.L1O_predicted_class.motor(index_subj_test) = M_T_O2Hb.correct_stat.motor(trial, index_subj_test);
    M_T_O2Hb.L1O_predicted_class_R.motor(index_subj_test) = M_T_O2Hb.correct_stat_R.motor(trial, index_subj_test);
    M_T_O2Hb.L1O_predicted_class_L.motor(index_subj_test) = M_T_O2Hb.correct_stat_L.motor(trial, index_subj_test);

    % CORTECCIA FRONTALE
    [M_SVM(trial).O2Hb_net.frontal, M_T_O2Hb.correct_stat.frontal(trial,:), M_T_O2Hb.correct_stat_R.frontal(trial,:), M_T_O2Hb.correct_stat_L.frontal(trial,:), ...
        M_T_O2Hb.CM_stat.Train_frontal, M_T_O2Hb.CM_stat.Test_frontal, M_T_O2Hb.MANOVA.d_frontal, M_T_O2Hb.MANOVA.p_frontal] = ...
        svm_temp(subject, index_subj_train, index_subj_test, 1, frontal_ch+n_ch);
    
    M_T_O2Hb.L1O_predicted_class.frontal(index_subj_test) = M_T_O2Hb.correct_stat.frontal(trial, index_subj_test);
    M_T_O2Hb.L1O_predicted_class_R.frontal(index_subj_test) = M_T_O2Hb.correct_stat_R.frontal(trial, index_subj_test);
    M_T_O2Hb.L1O_predicted_class_L.frontal(index_subj_test) = M_T_O2Hb.correct_stat_L.frontal(trial, index_subj_test);
    
    % CORTECCIA OCCIPITALE
    [M_SVM(trial).O2Hb_net.occipital, M_T_O2Hb.correct_stat.occipital(trial,:), M_T_O2Hb.correct_stat_R.occipital(trial,:), M_T_O2Hb.correct_stat_L.occipital(trial,:), ...
        M_T_O2Hb.CM_stat.Train_occipital,M_T_O2Hb.CM_stat.Test_occipital, M_T_O2Hb.MANOVA.d_occipital, M_T_O2Hb.MANOVA.p_occipital] = ...
        svm_temp(subject, index_subj_train, index_subj_test, 1, occipital_ch+n_ch);

    M_T_O2Hb.L1O_predicted_class.occipital(index_subj_test) = M_T_O2Hb.correct_stat.occipital(trial, index_subj_test);
    M_T_O2Hb.L1O_predicted_class_R.occipital(index_subj_test) = M_T_O2Hb.correct_stat_R.occipital(trial, index_subj_test);
    M_T_O2Hb.L1O_predicted_class_L.occipital(index_subj_test) = M_T_O2Hb.correct_stat_L.occipital(trial, index_subj_test);

    % TUTTI I CANALI
    [M_SVM(trial).O2Hb_net.all, M_T_O2Hb.correct_stat.all(trial,:), M_T_O2Hb.correct_stat_R.all(trial,:), M_T_O2Hb.correct_stat_L.all(trial,:), ...
        M_T_O2Hb.CM_stat.Train_all, M_T_O2Hb.CM_stat.Test_all, M_T_O2Hb.MANOVA.d_all, M_T_O2Hb.MANOVA.p_all] = ...
        svm_temp(subject, index_subj_train, index_subj_test, 1, all_ch+n_ch);
   
    M_T_O2Hb.L1O_predicted_class.all(index_subj_test) = M_T_O2Hb.correct_stat.all(trial, index_subj_test);
    M_T_O2Hb.L1O_predicted_class_R.all(index_subj_test) = M_T_O2Hb.correct_stat_R.all(trial, index_subj_test);
    M_T_O2Hb.L1O_predicted_class_L.all(index_subj_test) = M_T_O2Hb.correct_stat_L.all(trial, index_subj_test);


    %% +++++++++++++ STATISTICAL DATA ++++++++++++++++++++++++++++
    % +++++++++++++ HHb +++++++++++++++++++++++++
    % CORTECCIA MOTORIA
    [M_SVM(trial).HHb_net.motor, M_S_HHb.correct_stat.motor(trial,:), M_S_HHb.correct_stat_R.motor(trial,:), M_S_HHb.correct_stat_L.motor(trial,:), ...
        M_S_HHb.CM_stat.Train_motor, M_S_HHb.CM_stat.Test_motor, M_S_HHb.MANOVA.d_motor, M_S_HHb.MANOVA.p_motor] = ...
        svm_statistical(subject, index_subj_train, index_subj_test, 1, [motor_ch_dx, motor_ch_sx]);
    
    M_S_HHb.L1O_predicted_class.motor(index_subj_test) = M_S_HHb.correct_stat.motor(trial, index_subj_test);
    M_S_HHb.L1O_predicted_class_R.motor(index_subj_test) = M_S_HHb.correct_stat_R.motor(trial, index_subj_test);
    M_S_HHb.L1O_predicted_class_L.motor(index_subj_test) = M_S_HHb.correct_stat_L.motor(trial, index_subj_test);

    % CORTECCIA FRONTALE
    [M_SVM(trial).HHb_net.frontal, M_S_HHb.correct_stat.frontal(trial,:), M_S_HHb.correct_stat_R.frontal(trial,:), M_S_HHb.correct_stat_L.frontal(trial,:),...
        M_S_HHb.CM_stat.Train_frontal, M_S_HHb.CM_stat.Test_frontal, M_S_HHb.MANOVA.d_frontal, M_S_HHb.MANOVA.p_frontal] = ...
        svm_statistical(subject, index_subj_train, index_subj_test, 1, frontal_ch);
   
    M_S_HHb.L1O_predicted_class.frontal(index_subj_test) = M_S_HHb.correct_stat.frontal(trial, index_subj_test);
    M_S_HHb.L1O_predicted_class_R.frontal(index_subj_test) = M_S_HHb.correct_stat_R.frontal(trial, index_subj_test);
    M_S_HHb.L1O_predicted_class_L.frontal(index_subj_test) = M_S_HHb.correct_stat_L.frontal(trial, index_subj_test);

    % CORTECCIA OCCIPITALE
    [M_SVM(trial).HHb_net.occipital, M_S_HHb.correct_stat.occipital(trial,:), M_S_HHb.correct_stat_R.occipital(trial,:), M_S_HHb.correct_stat_L.occipital(trial,:),...
        M_S_HHb.CM_stat.Train_occipital,M_S_HHb.CM_stat.Test_occipital, M_S_HHb.MANOVA.d_occipital, M_S_HHb.MANOVA.p_occipital] = ...
        svm_statistical(subject, index_subj_train, index_subj_test, 1, occipital_ch);
    
    M_S_HHb.L1O_predicted_class.occipital(index_subj_test) = M_S_HHb.correct_stat.occipital(trial, index_subj_test);
    M_S_HHb.L1O_predicted_class_R.occipital(index_subj_test) = M_S_HHb.correct_stat_R.occipital(trial, index_subj_test);
    M_S_HHb.L1O_predicted_class_L.occipital(index_subj_test) = M_S_HHb.correct_stat_L.occipital(trial, index_subj_test);

    % TUTTI I CANALI
    [M_SVM(trial).HHb_net.all, M_S_HHb.correct_stat.all(trial,:), M_S_HHb.correct_stat_R.all(trial,:), M_S_HHb.correct_stat_L.all(trial,:),...
        M_S_HHb.CM_stat.Train_all, M_S_HHb.CM_stat.Test_all, M_S_HHb.MANOVA.d_all, M_S_HHb.MANOVA.p_all] = ...
        svm_statistical(subject, index_subj_train, index_subj_test, 1, all_ch);
    
    M_S_HHb.L1O_predicted_class.all(index_subj_test) = M_S_HHb.correct_stat.all(trial, index_subj_test);
    M_S_HHb.L1O_predicted_class_R.all(index_subj_test) = M_S_HHb.correct_stat_R.all(trial, index_subj_test);
    M_S_HHb.L1O_predicted_class_L.all(index_subj_test) = M_S_HHb.correct_stat_L.all(trial, index_subj_test);
    
    % +++++++++++++ O2Hb +++++++++++++++++++++++++
    % CORTECCIA MOTORIA
    [M_SVM(trial).O2Hb_net.motor, M_S_O2Hb.correct_stat.motor(trial,:), M_S_O2Hb.correct_stat_R.motor(trial,:), M_S_O2Hb.correct_stat_L.motor(trial,:),...
        M_S_O2Hb.CM_stat.Train_motor, M_S_O2Hb.CM_stat.Test_motor, M_S_O2Hb.MANOVA.d_motor, M_S_O2Hb.MANOVA.p_motor] = ...
        svm_statistical(subject, index_subj_train, index_subj_test, 1, [motor_ch_dx, motor_ch_sx]+n_ch);
    
    M_S_O2Hb.L1O_predicted_class.motor(index_subj_test) = M_S_O2Hb.correct_stat.motor(trial, index_subj_test);
    M_S_O2Hb.L1O_predicted_class_R.motor(index_subj_test) = M_S_O2Hb.correct_stat_R.motor(trial, index_subj_test);
    M_S_O2Hb.L1O_predicted_class_L.motor(index_subj_test) = M_S_O2Hb.correct_stat_L.motor(trial, index_subj_test);

    % CORTECCIA FRONTALE
    [M_SVM(trial).O2Hb_net.frontal, M_S_O2Hb.correct_stat.frontal(trial,:), M_S_O2Hb.correct_stat_R.frontal(trial,:), M_S_O2Hb.correct_stat_L.frontal(trial,:), ...
        M_S_O2Hb.CM_stat.Train_frontal, M_S_O2Hb.CM_stat.Test_frontal, M_S_O2Hb.MANOVA.d_frontal, M_S_O2Hb.MANOVA.p_frontal] = ...
        svm_statistical(subject, index_subj_train, index_subj_test, 1, frontal_ch+n_ch);
    
    M_S_O2Hb.L1O_predicted_class.frontal(index_subj_test) = M_S_O2Hb.correct_stat.frontal(trial, index_subj_test);
    M_S_O2Hb.L1O_predicted_class_R.frontal(index_subj_test) = M_S_O2Hb.correct_stat_R.frontal(trial, index_subj_test);
    M_S_O2Hb.L1O_predicted_class_L.frontal(index_subj_test) = M_S_O2Hb.correct_stat_L.frontal(trial, index_subj_test);
    
    % CORTECCIA OCCIPITALE
    [M_SVM(trial).O2Hb_net.occipital, M_S_O2Hb.correct_stat.occipital(trial,:), M_S_O2Hb.correct_stat_R.occipital(trial,:), M_S_O2Hb.correct_stat_L.occipital(trial,:), ...
        M_S_O2Hb.CM_stat.Train_occipital,M_S_O2Hb.CM_stat.Test_occipital, M_S_O2Hb.MANOVA.d_occipital, M_S_O2Hb.MANOVA.p_occipital] = ...
        svm_statistical(subject, index_subj_train, index_subj_test, 1, occipital_ch+n_ch);

    M_S_O2Hb.L1O_predicted_class.occipital(index_subj_test) = M_S_O2Hb.correct_stat.occipital(trial, index_subj_test);
    M_S_O2Hb.L1O_predicted_class_R.occipital(index_subj_test) = M_S_O2Hb.correct_stat_R.occipital(trial, index_subj_test);
    M_S_O2Hb.L1O_predicted_class_L.occipital(index_subj_test) = M_S_O2Hb.correct_stat_L.occipital(trial, index_subj_test);

    % TUTTI I CANALI
    [M_SVM(trial).O2Hb_net.all, M_S_O2Hb.correct_stat.all(trial,:), M_S_O2Hb.correct_stat_R.all(trial,:), M_S_O2Hb.correct_stat_L.all(trial,:), ...
        M_S_O2Hb.CM_stat.Train_all, M_S_O2Hb.CM_stat.Test_all, M_S_O2Hb.MANOVA.d_all, M_S_O2Hb.MANOVA.p_all] = ...
        svm_statistical(subject, index_subj_train, index_subj_test, 1, all_ch+n_ch);
   
    M_S_O2Hb.L1O_predicted_class.all(index_subj_test) = M_S_O2Hb.correct_stat.all(trial, index_subj_test);
    M_S_O2Hb.L1O_predicted_class_R.all(index_subj_test) = M_S_O2Hb.correct_stat_R.all(trial, index_subj_test);
    M_S_O2Hb.L1O_predicted_class_L.all(index_subj_test) = M_S_O2Hb.correct_stat_L.all(trial, index_subj_test);

end

%% Valutazione delle performance dei classificatori
fprintf('Performances evaluation\n')
% Temp - HHb
M_T_HHb.err_std.motor = std(M_T_HHb.L1O_predicted_class.motor,[])/sqrt(n_subjects);
M_T_HHb.accuracy.motor = mean(M_T_HHb.L1O_predicted_class.motor);
M_T_HHb.err_std.frontal = std(M_T_HHb.L1O_predicted_class.frontal,[])/sqrt(n_subjects);
M_T_HHb.accuracy.frontal = mean(M_T_HHb.L1O_predicted_class.frontal);
M_T_HHb.err_std.occipital = std(M_T_HHb.L1O_predicted_class.occipital,[])/sqrt(n_subjects);
M_T_HHb.accuracy.occipital = mean(M_T_HHb.L1O_predicted_class.occipital);
M_T_HHb.err_std.all = std(M_T_HHb.L1O_predicted_class.all,[])/sqrt(n_subjects);
M_T_HHb.accuracy.all = mean(M_T_HHb.L1O_predicted_class.all);

M_T_O2Hb.err_std.motor = std(M_T_O2Hb.L1O_predicted_class.motor,[])/sqrt(n_subjects);
M_T_O2Hb.accuracy.motor = mean(M_T_O2Hb.L1O_predicted_class.motor);
M_T_O2Hb.err_std.frontal = std(M_T_O2Hb.L1O_predicted_class.frontal,[])/sqrt(n_subjects);
M_T_O2Hb.accuracy.frontal = mean(M_T_O2Hb.L1O_predicted_class.frontal);
M_T_O2Hb.err_std.occipital = std(M_T_O2Hb.L1O_predicted_class.occipital,[])/sqrt(n_subjects);
M_T_O2Hb.accuracy.occipital = mean(M_T_O2Hb.L1O_predicted_class.occipital);
M_T_O2Hb.err_std.all = std(M_T_O2Hb.L1O_predicted_class.all,[])/sqrt(n_subjects);
M_T_O2Hb.accuracy.all = mean(M_T_O2Hb.L1O_predicted_class.all);

% Sinistra
M_T_HHb.err_std.L.motor = std(M_T_HHb.L1O_predicted_class_L.motor,[])/sqrt(n_subjects);
M_T_HHb.accuracy.L.motor = mean(M_T_HHb.L1O_predicted_class_L.motor);
M_T_HHb.err_std.L.frontal = std(M_T_HHb.L1O_predicted_class_L.frontal,[])/sqrt(n_subjects);
M_T_HHb.accuracy.L.frontal = mean(M_T_HHb.L1O_predicted_class_L.frontal);
M_T_HHb.err_std.L.occipital = std(M_T_HHb.L1O_predicted_class_L.occipital,[])/sqrt(n_subjects);
M_T_HHb.accuracy.L.occipital = mean(M_T_HHb.L1O_predicted_class_L.occipital);
M_T_HHb.err_std.L.all = std(M_T_HHb.L1O_predicted_class_L.all,[])/sqrt(n_subjects);
M_T_HHb.accuracy.L.all = mean(M_T_HHb.L1O_predicted_class_L.all);

M_T_O2Hb.err_std.L.motor = std(M_T_O2Hb.L1O_predicted_class_L.motor,[])/sqrt(n_subjects);
M_T_O2Hb.accuracy.L.motor = mean(M_T_O2Hb.L1O_predicted_class_L.motor);
M_T_O2Hb.err_std.L.frontal = std(M_T_O2Hb.L1O_predicted_class_L.frontal,[])/sqrt(n_subjects);
M_T_O2Hb.accuracy.L.frontal = mean(M_T_O2Hb.L1O_predicted_class_L.frontal);
M_T_O2Hb.err_std.L.occipital = std(M_T_O2Hb.L1O_predicted_class_L.occipital,[])/sqrt(n_subjects);
M_T_O2Hb.accuracy.L.occipital = mean(M_T_O2Hb.L1O_predicted_class_L.occipital);
M_T_O2Hb.err_std.L.all = std(M_T_O2Hb.L1O_predicted_class_L.all,[])/sqrt(n_subjects);
M_T_O2Hb.accuracy.L.all = mean(M_T_O2Hb.L1O_predicted_class_L.all);

% Destra
M_T_HHb.err_std.R.motor = std(M_T_HHb.L1O_predicted_class_R.motor,[])/sqrt(n_subjects);
M_T_HHb.accuracy.R.motor = mean(M_T_HHb.L1O_predicted_class_R.motor);
M_T_HHb.err_std.R.frontal = std(M_T_HHb.L1O_predicted_class_R.frontal,[])/sqrt(n_subjects);
M_T_HHb.accuracy.R.frontal = mean(M_T_HHb.L1O_predicted_class_R.frontal);
M_T_HHb.err_std.R.occipital = std(M_T_HHb.L1O_predicted_class_R.occipital,[])/sqrt(n_subjects);
M_T_HHb.accuracy.R.occipital = mean(M_T_HHb.L1O_predicted_class_R.occipital);
M_T_HHb.err_std.R.all = std(M_T_HHb.L1O_predicted_class_R.all,[])/sqrt(n_subjects);
M_T_HHb.accuracy.R.all = mean(M_T_HHb.L1O_predicted_class_R.all);

M_T_O2Hb.err_std.R.motor = std(M_T_O2Hb.L1O_predicted_class_R.motor,[])/sqrt(n_subjects);
M_T_O2Hb.accuracy.R.motor = mean(M_T_O2Hb.L1O_predicted_class_R.motor);
M_T_O2Hb.err_std.R.frontal = std(M_T_O2Hb.L1O_predicted_class_R.frontal,[])/sqrt(n_subjects);
M_T_O2Hb.accuracy.R.frontal = mean(M_T_O2Hb.L1O_predicted_class_R.frontal);
M_T_O2Hb.err_std.R.occipital = std(M_T_O2Hb.L1O_predicted_class_R.occipital,[])/sqrt(n_subjects);
M_T_O2Hb.accuracy.R.occipital = mean(M_T_O2Hb.L1O_predicted_class_R.occipital);
M_T_O2Hb.err_std.R.all = std(M_T_O2Hb.L1O_predicted_class_R.all,[])/sqrt(n_subjects);
M_T_O2Hb.accuracy.R.all = mean(M_T_O2Hb.L1O_predicted_class_R.all);


% Stat - HHb
M_S_HHb.err_std.motor = std(M_S_HHb.L1O_predicted_class.motor,[])/sqrt(n_subjects);
M_S_HHb.accuracy.motor = mean(M_S_HHb.L1O_predicted_class.motor);
M_S_HHb.err_std.frontal = std(M_S_HHb.L1O_predicted_class.frontal,[])/sqrt(n_subjects);
M_S_HHb.accuracy.frontal = mean(M_S_HHb.L1O_predicted_class.frontal);
M_S_HHb.err_std.occipital = std(M_S_HHb.L1O_predicted_class.occipital,[])/sqrt(n_subjects);
M_S_HHb.accuracy.occipital = mean(M_S_HHb.L1O_predicted_class.occipital);
M_S_HHb.err_std.all = std(M_S_HHb.L1O_predicted_class.all,[])/sqrt(n_subjects);
M_S_HHb.accuracy.all = mean(M_S_HHb.L1O_predicted_class.all);

M_S_O2Hb.err_std.motor = std(M_S_O2Hb.L1O_predicted_class.motor,[])/sqrt(n_subjects);
M_S_O2Hb.accuracy.motor = mean(M_S_O2Hb.L1O_predicted_class.motor);
M_S_O2Hb.err_std.frontal = std(M_S_O2Hb.L1O_predicted_class.frontal,[])/sqrt(n_subjects);
M_S_O2Hb.accuracy.frontal = mean(M_S_O2Hb.L1O_predicted_class.frontal);
M_S_O2Hb.err_std.occipital = std(M_S_O2Hb.L1O_predicted_class.occipital,[])/sqrt(n_subjects);
M_S_O2Hb.accuracy.occipital = mean(M_S_O2Hb.L1O_predicted_class.occipital);
M_S_O2Hb.err_std.all = std(M_S_O2Hb.L1O_predicted_class.all,[])/sqrt(n_subjects);
M_S_O2Hb.accuracy.all = mean(M_S_O2Hb.L1O_predicted_class.all);

% Sinistra
M_S_HHb.err_std.L.motor = std(M_S_HHb.L1O_predicted_class_L.motor,[])/sqrt(n_subjects);
M_S_HHb.accuracy.L.motor = mean(M_S_HHb.L1O_predicted_class_L.motor);
M_S_HHb.err_std.L.frontal = std(M_S_HHb.L1O_predicted_class_L.frontal,[])/sqrt(n_subjects);
M_S_HHb.accuracy.L.frontal = mean(M_S_HHb.L1O_predicted_class_L.frontal);
M_S_HHb.err_std.L.occipital = std(M_S_HHb.L1O_predicted_class_L.occipital,[])/sqrt(n_subjects);
M_S_HHb.accuracy.L.occipital = mean(M_S_HHb.L1O_predicted_class_L.occipital);
M_S_HHb.err_std.L.all = std(M_S_HHb.L1O_predicted_class_L.all,[])/sqrt(n_subjects);
M_S_HHb.accuracy.L.all = mean(M_S_HHb.L1O_predicted_class_L.all);

M_S_O2Hb.err_std.L.motor = std(M_S_O2Hb.L1O_predicted_class_L.motor,[])/sqrt(n_subjects);
M_S_O2Hb.accuracy.L.motor = mean(M_S_O2Hb.L1O_predicted_class_L.motor);
M_S_O2Hb.err_std.L.frontal = std(M_S_O2Hb.L1O_predicted_class_L.frontal,[])/sqrt(n_subjects);
M_S_O2Hb.accuracy.L.frontal = mean(M_S_O2Hb.L1O_predicted_class_L.frontal);
M_S_O2Hb.err_std.L.occipital = std(M_S_O2Hb.L1O_predicted_class_L.occipital,[])/sqrt(n_subjects);
M_S_O2Hb.accuracy.L.occipital = mean(M_S_O2Hb.L1O_predicted_class_L.occipital);
M_S_O2Hb.err_std.L.all = std(M_S_O2Hb.L1O_predicted_class_L.all,[])/sqrt(n_subjects);
M_S_O2Hb.accuracy.L.all = mean(M_S_O2Hb.L1O_predicted_class_L.all);

% Destra
M_S_HHb.err_std.R.motor = std(M_S_HHb.L1O_predicted_class_R.motor,[])/sqrt(n_subjects);
M_S_HHb.accuracy.R.motor = mean(M_S_HHb.L1O_predicted_class_R.motor);
M_S_HHb.err_std.R.frontal = std(M_S_HHb.L1O_predicted_class_R.frontal,[])/sqrt(n_subjects);
M_S_HHb.accuracy.R.frontal = mean(M_S_HHb.L1O_predicted_class_R.frontal);
M_S_HHb.err_std.R.occipital = std(M_S_HHb.L1O_predicted_class_R.occipital,[])/sqrt(n_subjects);
M_S_HHb.accuracy.R.occipital = mean(M_S_HHb.L1O_predicted_class_R.occipital);
M_S_HHb.err_std.R.all = std(M_S_HHb.L1O_predicted_class_R.all,[])/sqrt(n_subjects);
M_S_HHb.accuracy.R.all = mean(M_S_HHb.L1O_predicted_class_R.all);

M_S_O2Hb.err_std.R.motor = std(M_S_O2Hb.L1O_predicted_class_R.motor,[])/sqrt(n_subjects);
M_S_O2Hb.accuracy.R.motor = mean(M_S_O2Hb.L1O_predicted_class_R.motor);
M_S_O2Hb.err_std.R.frontal = std(M_S_O2Hb.L1O_predicted_class_R.frontal,[])/sqrt(n_subjects);
M_S_O2Hb.accuracy.R.frontal = mean(M_S_O2Hb.L1O_predicted_class_R.frontal);
M_S_O2Hb.err_std.R.occipital = std(M_S_O2Hb.L1O_predicted_class_R.occipital,[])/sqrt(n_subjects);
M_S_O2Hb.accuracy.R.occipital = mean(M_S_O2Hb.L1O_predicted_class_R.occipital);
M_S_O2Hb.err_std.R.all = std(M_S_O2Hb.L1O_predicted_class_R.all,[])/sqrt(n_subjects);
M_S_O2Hb.accuracy.R.all = mean(M_S_O2Hb.L1O_predicted_class_R.all);


%% salvataggio dei risultati nella cartella Results
fprintf('Data saving...\n')

% SVM
save('Results/M_SVM.mat','M_SVM', 'M_c')
% risultati allenamento rete - temporali
save('Results/M_T_HHb.mat', 'M_T_HHb')
save('Results/M_T_O2Hb.mat', 'M_T_O2Hb')
% risultati allenamento rete - statistici
save('Results/M_S_HHb.mat', 'M_S_HHb')
save('Results/M_S_O2Hb.mat', 'M_S_O2Hb')

fprintf('Done!\n')