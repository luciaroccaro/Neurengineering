% Neuroengineering
% Laboratory 4

% Rigazio Sofia - 282247
% Roccaro Lucia - 289423
% Romano Anastasio - 289707
% Ruzzante Elena - 292194


% DESCRIZIONE SCRIPT: in questo script vengono segmentate le epoche ed
% estratte le features utilizzate successivamente per la classificazione di
% soggetti CON media temporale sui vari trial (1 vettore per task R e 1
% vettore per task L per ogni soggetto)

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
                    num_L = num_L+1; % variabile che conta il numero di 
                                     % task a sinistra sulle righe i campioni dell'epoca,
                                     % sulle colonne le epoche successive di ogni prova del
                                     % soggetto in analisi e del canale in analisi (10*3=30)
                    epoch_L_h(:,num_L) =  sig_h(task_samples) - mean(sig_h(baseline_samples));
                    epoch_L_o(:,num_L) =  sig_o(task_samples) - mean(sig_o(baseline_samples));
                    
                else % (==2) -> RIGHT MI
                    num_R = num_R+1; % variabile che conta il numero di task a destra
                                     % sulle righe i campioni dell'epoca, sulle colonne le
                                     % epoche successive di ogni prova del soggetto in
                                     % analisi e del canale in analisi (10*3 = 30)
                    epoch_R_h(:,num_R) = sig_h(task_samples) - mean(sig_h(baseline_samples));
                    epoch_R_o(:,num_R) = sig_o(task_samples) - mean(sig_o(baseline_samples));
                end
            end
        end

        % mediamo le epoche del segnale dei task di tutti i canali
        subject(v_subj).task_L.mean(:,i) = mean(epoch_L_h,2);
        subject(v_subj).task_L.mean(:,i+n_ch) =  mean(epoch_L_o,2);
        subject(v_subj).task_L.error(:,i) = std(epoch_L_h,[],2)./sqrt(num_L);
        subject(v_subj).task_L.error(:,i+n_ch) =  std(epoch_L_o,[],2)./sqrt(num_L);
       
        subject(v_subj).task_R.mean(:,i) = mean(epoch_R_h,2);
        subject(v_subj).task_R.mean(:,i+n_ch) =  mean(epoch_R_o,2);
        subject(v_subj).task_R.error(:,i) = std(epoch_R_h,[],2)./sqrt(num_R);
        subject(v_subj).task_R.error(:,i+n_ch) =  std(epoch_R_o,[],2)./sqrt(num_R); % pause, hold off
    end
end

%% Features da valutare
% the following statistical features were taken from literature 
% doi: 10.3389/fnbot.2017.00033, while temporal average features are taken
% from DOI: 10.1109/NER49283.2021.9441376

start_obs = (s_before_task+task_duration)*fs;

for v_subj = 1:n_subjects
    for ch = 1:2*n_ch
        subject(v_subj).params.mean_L(ch) = mean(subject(v_subj).task_L.mean(start_obs:end,ch));
        subject(v_subj).params.mean_R(ch) = mean(subject(v_subj).task_R.mean(start_obs:end,ch));
        subject(v_subj).params.var_L(ch) =  var(subject(v_subj).task_L.mean(start_obs:end,ch));
        subject(v_subj).params.var_R(ch) = var(subject(v_subj).task_R.mean(start_obs:end,ch));
        subject(v_subj).params.kurtosis_L(ch) = kurtosis(subject(v_subj).task_L.mean(start_obs:end,ch),0);
        subject(v_subj).params.kurtosis_R(ch) = kurtosis(subject(v_subj).task_R.mean(start_obs:end,ch),0);
        subject(v_subj).params.skewness_L(ch) = skewness(subject(v_subj).task_L.mean(start_obs:end,ch),0);
        subject(v_subj).params.skewness_R(ch) = skewness(subject(v_subj).task_R.mean(start_obs:end,ch),0);    

        % Generazione della media temporale ogni secondo
        % qui per plot della mappa topografica -> su tutto il periodo di
        % tempo del task (da -5 a +30 secondi)
        for temp = 1:floor(time_vis/(2*fs)) % in questo modo medio per ogni secondo
            index_obs = (temp-1)*2*fs+1 : temp*2*fs; % prendo 2*fs campioni = 2 secondi, 20 campioni
            subject(v_subj).params.mean_temp_R.plot(ch, temp) = mean(subject(v_subj).task_R.mean(index_obs,ch));
            subject(v_subj).params.mean_temp_L.plot(ch, temp) = mean(subject(v_subj).task_L.mean(index_obs,ch));
        end

        % qui per classificatore -> siamo interessati solo al periodo
        % temporale dopo la fine dell'esecuzione del task (da 10 a 30 
        % secondi)
        t_obs = start_obs : 1/fs : start_obs+s_after_task;
        for temp = 1:floor(length(t_obs)/(2*fs)) % in questo modo medio per ogni secondo
            index_obs = start_obs+((temp-1)*2*fs+1:temp*2*fs);    % prendo 2*fs campioni = 2 secondo
            subject(v_subj).params.mean_temp_R.svm(ch, temp) = mean(subject(v_subj).task_R.mean(index_obs,ch));
            subject(v_subj).params.mean_temp_L.svm(ch, temp) = mean(subject(v_subj).task_L.mean(index_obs,ch));
        end
        
    end
end

% slope evaluation by linear interpolation
for v_subj = 1:n_subjects
    for ch = 1:2*n_ch
        start_obs = (s_before_task+task_duration)*fs;       
        t_obs = start_obs : 1/fs : start_obs+s_after_task;
        interp = polyfit(t_obs,subject(v_subj).task_L.mean(start_obs:end,ch),1);
        subject(v_subj).params.slope_L(ch) = interp(1);
        interp = polyfit(t_obs,subject(v_subj).task_R.mean(start_obs:end,ch),1);
        subject(v_subj).params.slope_R(ch) = interp(1);
    end
end


%% Plot task mano destra per un soggetto estratto casualmente (tutti i canali)
figure('Position',[20,20,1400,700])
asset_task = linspace(-s_before_task,task_duration+s_after_task,time_vis);
% v_subj = randi(n_subjects);
v_subj = 16;    % scegliamo il 16imo soggetto per le rappresentazioni anche nella relazione
for i = 1:n_ch
    
    mean_valued_HHb = subject(v_subj).task_R.mean(:,i);
    st_err_valued_HHb = subject(v_subj).task_R.error(:,i);
    mean_valued_O2Hb = subject(v_subj).task_R.mean(:,i+n_ch);
    st_err_valued_O2Hb = subject(v_subj).task_R.error(:,i+n_ch);

    subplot(6,6,i)
    plot(asset_task,mean_valued_HHb,'b','LineWidth',2)
    hold on
    plot(asset_task,mean_valued_HHb + st_err_valued_HHb, 'b', LineStyle=":")
    plot(asset_task,mean_valued_HHb - st_err_valued_HHb, 'b', LineStyle=":")
    % barre di errore
    x2 = [asset_task, fliplr(asset_task)];
    inBetween = [(mean_valued_HHb'-st_err_valued_HHb'), fliplr(mean_valued_HHb'+st_err_valued_HHb')];
    fill(x2, inBetween, 'b', 'FaceAlpha', 0.3, 'EdgeColor','none');
    
    plot(asset_task,mean_valued_O2Hb,'r','LineWidth',2)
    hold on
    plot(asset_task,mean_valued_O2Hb + st_err_valued_O2Hb, 'r', LineStyle=":")
    plot(asset_task,mean_valued_O2Hb - st_err_valued_O2Hb, 'r', LineStyle=":")
    % barre di errore
    x2 = [asset_task, fliplr(asset_task)];
    inBetween = [(mean_valued_O2Hb'-st_err_valued_O2Hb'), fliplr(mean_valued_O2Hb'+st_err_valued_O2Hb')];
    fill(x2, inBetween, 'r', 'FaceAlpha',0.3, 'EdgeColor','none');
    
    
    title(sprintf('ch %d - %s', i, ch_name(i)));
    axis([asset_task(1), asset_task(end),-0.6,0.6])
    xlim([asset_task(1), asset_task(end)])
    xline(0, 'Label','start task')
    xline(task_duration, 'Label','end task')
    xlabel('time (s)')
    ylabel('[Hb] changes (µM)')

 end 
sgtitle(sprintf('Subject %d, RIGHT task',v_subj))
            


%% PLOT TOPOGRAPHY di una feature statistica
plot_map = 0;
if plot_map == 1
    % per "params" si può scegliere tra: mean, var, kurtosis, skewness
    params = 'slope';
    figure('Name', 'Plot signal topography')
    sgtitle(params)
    for v_subj = 1: n_subjects
        values_L = eval(sprintf('subject(v_subj).params.%s_L(n_ch+1:end)', params));
        values_R = eval(sprintf('subject(v_subj).params.%s_R(n_ch+1:end)', params));

        [theta_rad,rho] = cart2pol(subject(v_subj).MNT.pos_3d(2,:)*0.5,subject(v_subj).MNT.pos_3d(1,:)*0.5);  % lo 0.5 è per avere valori ben plottabili da plot_topography
        theta = rad2deg(theta_rad); % conversione da radianti a gradi

        % creazione della tabella da passare alla funzione
        locations = table(upper(subject(v_subj).MNT.clab)',theta',rho');
        locations.Properties.VariableNames{1} = 'labels';
        locations.Properties.VariableNames{2} = 'theta';
        locations.Properties.VariableNames{3} = 'radius';

        ch_list = locations.labels; % utilizzo gli stessi label presenti in tabella (! sono in uppercase)

        % normalizzo agli stessi massimi e minimi
        min_clim = min(min(values_R,[],'all'), min(values_L,[],'all'));
        max_clim = max(max(values_R,[],'all'), max(values_L,[],'all'));

        subplot(1,2,1)
        plot_topography(ch_list, values_L, 0, locations, true, false, 1000)
        title(sprintf('Subject %d Left', v_subj))
        colormap jet
        c = colorbar;
        c.Label.String = '(µM)';
        caxis([min_clim, max_clim])  % setta i limiti della colorbar
        hold on
        source = scatter(subject(v_subj).MNT.source.pos_3d(1,:)*0.5,subject(v_subj).MNT.source.pos_3d(2,:)*0.5,25,"red","filled");
        hold on
        detector = scatter(subject(v_subj).MNT.detector.pos_3d(1,:)*0.5,subject(v_subj).MNT.detector.pos_3d(2,:)*0.5,25,"green","filled");
        channel = scatter(subject(v_subj).MNT.pos_3d(1,:)*0.5,subject(v_subj).MNT.pos_3d(2,:)*0.5,14,"magenta","filled");
        legend([source,detector,channel],{'source','detector','channels'})

        subplot(1,2,2)
        plot_topography(ch_list, values_R, 0, locations, true, false, 1000)
         title(sprintf('Subject %d Right', v_subj))
        c = colorbar;
        c.Label.String = '(µM)';
        caxis([min_clim, max_clim])  % setta i limiti della colorbar
        hold on
        source = scatter(subject(v_subj).MNT.source.pos_3d(1,:)*0.5,subject(v_subj).MNT.source.pos_3d(2,:)*0.5,25,"red","filled");
        hold on
        detector = scatter(subject(v_subj).MNT.detector.pos_3d(1,:)*0.5,subject(v_subj).MNT.detector.pos_3d(2,:)*0.5,25,"green","filled");
        channel = scatter(subject(v_subj).MNT.pos_3d(1,:)*0.5,subject(v_subj).MNT.pos_3d(2,:)*0.5,14,"magenta","filled");
        legend([source,detector,channel],{'source','detector','channels'})
        pause
    end
end

%% PLOT TOPOGRAPHY per i parametri temporali
plot_time = 0;
if plot_time == 1
    v_subj = randi(n_subjects,1);

    % calcolo della posizione degli elettrodi in coordinate dei canali
    [theta_rad,rho] = cart2pol(subject(v_subj).MNT.pos_3d(2,:)*0.5,subject(v_subj).MNT.pos_3d(1,:)*0.5);  % lo 0.5 è per avere valori ben plottabili poi da plot_topography
    theta = rad2deg(theta_rad); % conversione da radianti a gradi

    % creazione della tabella da passare alla funzione
    locations = table(upper(subject(v_subj).MNT.clab)',theta',rho');
    locations.Properties.VariableNames{1} = 'labels';
    locations.Properties.VariableNames{2} = 'theta';
    locations.Properties.VariableNames{3} = 'radius';

    ch_list = locations.labels; % utilizzo gli stessi label presenti in tabella (! sono in uppercase)

    asset = linspace(-s_before_task+1, floor((s_after_task+task_duration-1)/2)*2, floor(time_vis/(2*fs)));
    figure('Name', 'Plot signal topography', 'Position',[100, 100, 1500, 900])
    
    valued_L = subject(v_subj).params.mean_temp_L.plot;
    valued_R = subject(v_subj).params.mean_temp_R.plot;
    % setto i limiti della colorbar
    min_clim = min([min(valued_R(n_ch+1:end,:), [], 'all'), min(valued_L(n_ch+1:end,:), [], 'all')]);
    max_clim = max([max(valued_R(n_ch+1:end,:), [], 'all'), max(valued_L(n_ch+1:end,:), [], 'all')]);
    
    for t = 1:length(asset)
        clf
        for task = 1:2
            % scegliamo lato del task e parametro da plottare
            switch task
                case 1
                    task_side = 'L';
                    valued = valued_L;
                case 2
                    task_side = 'R';
                    valued = valued_R;
            end
            
            for i = 1:n_ch  % salvataggio dei vari valori in values
                values(i) = valued(n_ch+i,t);
            end

            subplot(1,2,task)
            plot_topography(ch_list, values, 1, locations, false, false, 500);
            colormap jet
            c = colorbar;
            c.Label.String = '(µM)';
            caxis([min_clim, max_clim])  % setta i limiti della colorbar
            hold on
            channel = scatter(subject(v_subj).MNT.pos_3d(1,:)*0.5,subject(v_subj).MNT.pos_3d(2,:)*0.5,14,"magenta","filled");
            title(sprintf('task side: %s',task_side))
            if asset(t)<0
                sgtitle(sprintf('subject %d - BEFORE TASK - time: %.4f',v_subj, asset(t)))
            elseif asset(t)>=0 && asset(t)<task_duration
                sgtitle(sprintf('subject %d - DURING TASK - time: %.4f',v_subj, asset(t)))
            else
                sgtitle(sprintf('subject %d - AFTER TASK - time: %.4f',v_subj, asset(t)))
            end
            hold off
        end
        pause(0.1)
    end
    
end

%% salvataggio dei dati
save('Results/M_subject.mat','subject')