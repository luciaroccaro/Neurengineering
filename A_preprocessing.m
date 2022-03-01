% Neuroengineering
% Laboratory 4

% Rigazio Sofia - 282247
% Roccaro Lucia - 289423
% Romano Anastasio - 289707
% Ruzzante Elena - 292194


% DESCRIZIONE SCRIPT: in questo script applichiamo la legge di Lambert-Beer
% ed effettuiamo il filtraggio dei segnali.

clear variables
close all
clc

% creazione della cartella dove salvare il workspace
folder_name = 'Results';
if ~exist(folder_name, 'dir')
   mkdir(folder_name)
end

%% Data loading
n_subjects = 29;
n_trials = 3;
subject = struct();
for i = 1:n_subjects
    load(sprintf('Data/S%d/MI_cnt.mat',i));
    load(sprintf('Data/S%d/MI_mnt.mat',i));
    load(sprintf('Data/S%d/MI_mrk.mat',i));
    for j = 1:n_trials
        subject(i).CNT(j) = MI_cnt{1, j};
        subject(i).MRK(j) = MI_mrk{1, j};
    end
    subject(i).MNT = MNT;
end
% clear of all the unnecessary variables
clear i j MI_mrk MI_cnt MNT

% the channels 1-36 are related to the lower wavelength (760 nm), while the
% other channels (37-72) are related to the higher wavelength (850 nm)

n_ch = length(subject(1).CNT(1).clab)/2;        % number of channels
fs = subject(1).CNT(1).fs;                      % sampling frequency
lambda_low = subject(1).CNT(1).wavelengths(1);  % 760 nm - lambda 1
lambda_high = subject(1).CNT(1).wavelengths(2); % 850 nm - lambda 2

%% Saving channel title names
for v_subj = 1:n_subjects
    for i = 1:n_ch
        for j = 1:n_trials
            titolo = char(subject(v_subj).CNT(j).clab(i));
            ch_name(i) = string(titolo(1:end-5));
        end
    end
end
clear titolo

save('Results/params.mat','n_subjects','n_trials','n_ch','fs','ch_name')

%% Modified Lambert-Beer law
% parameters needed
% source: https://omlc.org/spectra/hemoglobin/summary.html
% we divide by 10^6 because we have 1/M and we want 1/µM
alpha_low_h = 1548.52/10^6;  % (1/(µM*cm))
alpha_low_o = 586/10^6;      % (1/(µM*cm))
alpha_high_h = 691.32/10^6;  % (1/(µM*cm))
alpha_high_o = 1058/10^6;    % (1/(µM*cm))

% Differential path length calculation
% source: DOI: 10.1117/1.JBO.26.10.100901
DPL = @(age,lambda) 223.3 + 0.05624*age^(0.8493) - 5.723*10^(-7)*lambda^3 + 0.001245*lambda^2 - 0.9025*lambda;
% the formula takes age in years and lambda in nm

age_vector = 2016 - [1988, 1991, 1990, 1993, 1989, 1982, 1988, 1987, ...
    1989, 1984, 1985, 1987, 1983, 1989, 1991, 1984, 1977, 1990, 1984, ...
    1988, 1992, 1993, 1989, 1989, 1990, 1989, 1989, 1980, 1990];
mean_age = mean(age_vector); % the average age of the subjects is 28.4 y

B_low = DPL(mean_age, lambda_low);      % 6.25
B_high = DPL(mean_age, lambda_high);    % 5.19

% inter-optode distance
d = 3; % cm -> "The inter-optode distance was 30 mm" (from given paper)

L1 = d*B_low;
L2 = d*B_high;

% Calculation of HHb and O2Hb concentration changes
for v_subj = 1:n_subjects
    for i = 1:n_ch
         for j = 1:n_trials
% the signals in the dataset are the delta A in the formula from slide 13 
            A1 = subject(v_subj).CNT(j).x(:,i);        % delta A (760nm)
            A2 = subject(v_subj).CNT(j).x(:,n_ch+i);   % delta A (850nm)

            % calculating delta concentrations (solutions of the linear sistem)
            % source: doi: 10.1088/0031-9155/51/5/N02
            sig_o = (alpha_low_h*A2/L2-alpha_high_h*A1/L1)./(alpha_low_h*alpha_high_o-alpha_high_h*alpha_low_o);
            sig_h = (alpha_low_o*A2/L2-alpha_high_o*A1/L1)./(alpha_low_o*alpha_high_h-alpha_high_o*alpha_low_h);

            % saving concentration changes signals into struct
            subject(v_subj).CNT(j).sig(:,i) = sig_h;
            subject(v_subj).CNT(j).sig(:,n_ch+i) = sig_o;

        end
    end
end


%% Parametric Power spectral density -> BURG
x = subject(1).CNT(1).sig(:,15);
% BURG METHOD: Calculation of the asymptotic variance of the model for
% orders between 2 and 50
for NN = 2:50
    [a,e(NN)] = arburg(x, NN); 
end
% The asymptotic variance will be the last value of the vector containing
% the variance (the one obtained for order equal to 50)

% Calculate 5% of the asymptotic variance and add to the asymptotic variance
asint = e(NN)+5/100*e(NN);

% Find the variance values that are less than the asymptotic variance
% increased by 5%.
ind =  find(e < asint);

order = ind(2); % choosing the order

% parametric PSD with Burg method
[Pb, f] = pburg(x-mean(x), order, 1000, fs);

% Visualization of Burg PSD
plot_PSD = '1';
if plot_PSD == '1'
    figure
    plot(f, Pb/max(Pb))
    title('PSD - Burg')
end

%% Signal filtering
n = 6;          % filter order
fNy = fs/2;     % Nyquist frequency

% low-pass filter, 100mHz
ft_low = 0.1;  % cutoff freuency for low-pass filter
[b_low, a_low] = butter(n,ft_low/fNy);

% high-pass filter, 10mHz
ft_high = 0.01; % cutoff freuency for high-pass filter
[b_high, a_high] = butter(n,ft_high/fNy, 'high');

plot_filtri = 0;
if plot_filtri == 1
    figure
    freqz(b_low, a_low, 1000, fs)
    title(sprintf('Low-Pass Filter - ft = %.2fHz',ft_low))
    
    figure
    freqz(b_high, a_high, 1000, fs)
    title(sprintf('High-Pass Filter - ft = %.2fHz',ft_high))
end

for v_subj = 1:n_subjects
    for i = 1:n_ch
        for j = 1:n_trials

            sig_h = subject(v_subj).CNT(j).sig(:,i);      % h -> HHb
            sig_o = subject(v_subj).CNT(j).sig(:,n_ch+i); % o -> O2Hb

            % facciamo la media per campione del segnale su tutti i canali
            % -> risulta quindi un vettore di dimensioni (n_samples, 1) sia
            % per l'ossigenata che per la deossigenata
%             mean_h = mean(subject(v_subj).CNT(j).sig(:,1:n_ch),2);
%             mean_o = mean(subject(v_subj).CNT(j).sig(:,n_ch+1:2*n_ch),2);
            % rimuoviamo la media dai segnali dei canali per evidenziare le 
            % differenze tra essi
%             sig_h = sig_h - mean_h;
%             sig_o = sig_o - mean_o;
% NOTA: la baseline correction generale su tutto il segnale, dopo essere
% stata provata nelle righe qui sopra, è stata rimossa perchè portava a
% segnali visivamente incoerenti con quanto ci si aspetta. Delle
% attivazioni precedentemente visibili venivano completamente azzerate
% dalla rimozione della media generalizzata.

            % anticausal bandpass filtering to avoid introducing delays
            sig_h = filtfilt(b_high, a_high, sig_h);
            sig_h = filtfilt(b_low, a_low, sig_h);
            sig_o = filtfilt(b_high, a_high, sig_o);
            sig_o = filtfilt(b_low, a_low, sig_o);

            subject(v_subj).CNT(j).sig_f(:,i) = sig_h;
            subject(v_subj).CNT(j).sig_f(:,n_ch+i) = sig_o;
        end
    end
end

%% Data saving
save('Results/subject.mat','subject')