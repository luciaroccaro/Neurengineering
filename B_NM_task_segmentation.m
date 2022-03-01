% Neuroengineering
% Laboratory 4

% Rigazio Sofia - 282247
% Roccaro Lucia - 289423
% Romano Anastasio - 289707
% Ruzzante Elena - 292194


% DESCRIZIONE SCRIPT: in questo script vengono segmentate le epoche ed
% estratte le features utilizzate successivamente per la classificazione di
% soggetti SENZA media temporale sui vari trial (30 vettori per task R e 30
% vettori per task L per ogni soggetto)

clear variables
close all
clc

%% Data loading
addpath Results
load('subject.mat');
load('params.mat');

%% Task segmentation and averaging
task_duration = 10; % from given paper
s_before_task = 5;
s_after_task = 20;

time_vis = (s_before_task+task_duration+s_after_task)*fs; % lunghezza della finestra di osservazione in campioni

for v_subj = 1:n_subjects
    for i = 1:n_ch  
        num_L = 0;
        num_R = 0;
        for j = 1:n_trials
            start_task = subject(v_subj).MRK(j).time; % vector containing the task onsets
            start_task = start_task * 10^(-3)*fs; % convert to samples
            end_task = start_task + task_duration*fs; % task duration = 10s

            sig_h = subject(v_subj).CNT(j).sig_f(:,i);      % h -> HHb
            sig_o = subject(v_subj).CNT(j).sig_f(:,n_ch+i); % o -> O2Hb
            
            % determination of the task (left or right)
            task_label = subject(v_subj).MRK(j).event.desc; % 1 = LMI, 2 = RMI
            for task = 1:length(start_task)
                % calcoliamo la posizione dell'inizio dell'acquisizione del
                % segnale per la segmentazione dei singoli task
                start_sampling = round(start_task(task)-s_before_task*fs);   % posizione in campioni 

                % indici dei campioni di segnale che osserviamo per ogni task
                task_samples = (start_sampling:start_sampling+time_vis-1);

                % baseline: indici dei campioni del segnale che risultano
                % essere tra -5 e -2 secondi rispetto all'inizio del task
                baseline_samples = (round(start_task(task)-5*fs):round(start_task(task)-2*fs)-1);
                
                if task_label(task) == 1 % -> LEFT MI
                    num_L = num_L+1; % variabile che conta il numero di task a sinistra
                    % 1a dim: numero del task
                    % 2a dim: tutta la finestra di osservazione
                    % 3a dim: canale (quando "+n_ch" indica la O2Hb)
                    subject(v_subj).epoch_L(num_L,:,i) =  sig_h(task_samples)' - mean(sig_h(baseline_samples));
                    subject(v_subj).epoch_L(num_L,:,i+n_ch) =  sig_o(task_samples)' - mean(sig_o(baseline_samples));
                    
                else % (==2) -> RIGHT MI
                    num_R = num_R+1; % variabile che conta il numero di task a destra
                    % 1a dim: numero del task
                    % 2a dim: tutta la finestra di osservazione
                    % 3a dim: canale (quando "+n_ch" indica la O2Hb)
                    subject(v_subj).epoch_R(num_R,:,i) = sig_h(task_samples)' - mean(sig_h(baseline_samples));
                    subject(v_subj).epoch_R(num_R,:,i+n_ch) = sig_o(task_samples)' - mean(sig_o(baseline_samples));
                end
            end
        end
    end
end

%% Features da valutare
% the following statistical features were taken from literature 
% doi: 10.3389/fnbot.2017.00033, while temporal average features are taken
% from DOI: 10.1109/NER49283.2021.9441376

start_obs = (s_before_task+task_duration)*fs;
t_obs = start_obs : 1/fs : start_obs+s_after_task;

for v_subj = 1:n_subjects
    for ch = 1:2*n_ch
        % otteniamo una matrice di dimensioni 30*72 per ogni feature
        % - 30 = tutti i task dello stesso lato nei 3 trial (3*10)
        % - 72 = canali (36*2 -> 1-36 HHb , 37-72 O2Hb)

        subject(v_subj).params.mean_L(:,ch) = mean(subject(v_subj).epoch_L(:,start_obs:end,ch),2);
        subject(v_subj).params.mean_R(:,ch) = mean(subject(v_subj).epoch_R(:,start_obs:end,ch),2);
        subject(v_subj).params.var_L(:,ch) =  var(subject(v_subj).epoch_L(:,start_obs:end,ch),[],2);
        subject(v_subj).params.var_R(:,ch) = var(subject(v_subj).epoch_R(:,start_obs:end,ch),[],2);
        subject(v_subj).params.kurtosis_L(:,ch) = kurtosis(subject(v_subj).epoch_L(:,start_obs:end,ch),0,2);
        subject(v_subj).params.kurtosis_R(:,ch) = kurtosis(subject(v_subj).epoch_R(:,start_obs:end,ch),0,2);
        subject(v_subj).params.skewness_L(:,ch) = skewness(subject(v_subj).epoch_L(:,start_obs:end,ch),0,2);
        subject(v_subj).params.skewness_R(:,ch) = skewness(subject(v_subj).epoch_R(:,start_obs:end,ch),0,2);

        % Generazione della media temporale ogni secondo
        for epoch = 1:num_L % a destra abbiamo lo stesso numero di task
            for temp = 1:floor(length(t_obs)/(2*fs)) % in questo modo medio per ogni secondo
                index_obs = start_obs+((temp-1)*2*fs+1:temp*2*fs);    % prendo 2*fs campioni = 2 secondo
                 subject(v_subj).params.mean_temp_R(ch, epoch, temp) = mean(squeeze(subject(v_subj).epoch_R(epoch,index_obs,ch)));
                 subject(v_subj).params.mean_temp_L(ch, epoch, temp) = mean(squeeze(subject(v_subj).epoch_L(epoch,index_obs,ch)));
            end
        end
        
        for j = 1:num_L % a destra abbiamo lo stesso numero di task
            interp = polyfit(t_obs,subject(v_subj).epoch_L(j,start_obs:end,ch),1);
            subject(v_subj).params.slope_L(j,ch) = interp(1);
            interp = polyfit(t_obs,subject(v_subj).epoch_R(j,start_obs:end,ch),1);
            subject(v_subj).params.slope_R(j,ch) = interp(1);
        end
    end
end

%% salvataggio dei dati
save('Results/NM_subject.mat','subject')