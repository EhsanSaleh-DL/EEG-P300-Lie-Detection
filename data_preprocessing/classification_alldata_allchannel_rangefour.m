clc
clear all
close all
%% Parameters and Channels
Fs=250;
all_channel=21; % kole sotunhaye data khame khuruji
channel=19;     % tedade channel haye sabt shode
eog_channel=20; % shomare sutuni az data estekhraj shode az WinEEG ke baraye hazf harekat cheshm estefade shode
T_on = 1.1;     %1100 mili saniye tahrik ast
T_off = 2;      % bad az har 1100 mlisaniye tahrik, 2000 milisaniye safhe black ast
Fs_on = Fs*T_on;
Fs_off = Fs*T_off;
probe=3;        % shomareyi az 6 moharek ke be onvane probe dar nazar gerefte shode
target=1;       % shomareyi az 6 moharek ke be onvane targete dar nazar gerefte shode
threshold_eog=70; % micro V
[b,a]=butter(3,[0.3 30]/(Fs/2),'bandpass');
channels_number = 19;

% channel
CHANNELS = {'Fp1','Fp2','F3','F4','C3','C4','P3','P4','O1','O2',...
'F7','F8','T3-21ch','T4-21ch','T5-21ch','T6-21ch','Fz','Cz','Pz'}; %bior1.2
Ch = [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19];
%Ch = [17 18 19];
channels = CHANNELS(Ch);

%% Data loading for Truth
for i = 1:23
    % In ghesmat baraye joda kardan zamanyahe tahrik hast
    fileID = fopen(strcat('ERP', 'T', num2str(i), '.txt'),'r');
    tline = fgetl(fileID);      % satre aval file ro mide ke tuye file text ham ghabele moshahede hast
    time_ERP=fscanf(fileID,'%f%*d');

    % In ghesmat baraye joda kardane noe tahrik hast
    fileID = fopen(strcat('ERP', 'T', num2str(i), '.txt'),'r');
    fgetl(fileID);
    triger_ERP=fscanf(fileID,'%*f%d');
    number_of_stimulus=size(triger_ERP);

    % In code baraye emtehan kardan '%f' dar nazar gerefte shode ke bebinim che mikone
    %fileID = fopen('ERP.txt','r');
    %t_line = fgetl(fileID);
    %A = fscanf(fileID, '%f');

    % In ghesmat baraye bedast avardane tedade nemuneha hast
    fid=fopen(strcat('signal', 'T', num2str(i), '.txt'));
    g = textscan(fid,'%s','delimiter','\n');
    full_eeg_samples=length(g{1}); %kolan mige ke bara har channel chanta sample hast
    fclose(fid);

    % In ghestmat baraye tashkil signal ba channelhash(SIGNAL) va hamchenin tabdile har sample be zaman hast(full_eeg_times)
    fileID = fopen(strcat('signal', 'T', num2str(i), '.txt'),'r');
    SIGNAL=fscanf(fileID,'%f',[21,full_eeg_samples]); % data khame hame channel ha hast
    full_eeg_times(1:full_eeg_samples,1)=(1:full_eeg_samples)/Fs; % mige ke har sample moadel ba che zamani hast, sample 250 barabar ba zaman e yek shode

    % signal (transposed and filtering)
    SIGNAL=SIGNAL';
    data = filtfilt(b,a,SIGNAL);
    %Signal(1,:,:)=SIGNAL(:,1:channel);

    % EOG
    %Signal(1,:,:)=SIGNAL(:,1:channel);
    %eog_Signal=SIGNAL(:,eog_channel);
    %eog_Signal=filtfilt(b,a,eog_Signal);
    %eog_peak=eog_Signal>threshold_eog; % logical
    %eog_peak=cast(eog_peak,'double');

    % Seperate channel elevenchannel(FzF3F4CzC3C4PzP3P4T5T6) for Probe 
    sample_ERP = time_ERP * Fs; %tabdile bordar zamaniye time_ERP be sample
    Fz = data(:, [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19]);
    pos_probe = find(triger_ERP == 3);  %position probe ba label 3 dar triger_ERP ro peyda mikone

    % probe segmentation of elevenchannel(FzF3F4CzC3C4PzP3P4T5T6)(consider that it has 276 samples which is wierd because the on-set has 275 samples!!)
    for j = 1:length(pos_probe)
        Fz_probe(:,19*j-18:19*j) = Fz(sample_ERP(pos_probe(j)):sample_ERP(pos_probe(j))+Fs_on, :);
    end

    alldata_allchannel_probe_rangefour_T(:, 570*i-569:570*i) = Fz_probe(1:250, :); %rangefour = 0.0-1 secs
end

% get all channels into a one column for classification
for i = 1:length(alldata_allchannel_probe_rangefour_T)/channels_number
    alldata_allchannel_rangefour_T_classification(:,i) = reshape(alldata_allchannel_probe_rangefour_T(:, channels_number*i-18:channels_number*i), [size(alldata_allchannel_probe_rangefour_T, 1)*channels_number, 1]);
end

%% Data loading for Lie
for i = 1:25
    % In ghesmat baraye joda kardan zamanyahe tahrik hast
    fileID = fopen(strcat('ERP', 'L', num2str(i), '.txt'),'r');
    tline = fgetl(fileID);      % satre aval file ro mide ke tuye file text ham ghabele moshahede hast
    time_ERP=fscanf(fileID,'%f%*d');

    % In ghesmat baraye joda kardane noe tahrik hast
    fileID = fopen(strcat('ERP', 'L', num2str(i), '.txt'),'r');
    fgetl(fileID);
    triger_ERP=fscanf(fileID,'%*f%d');
    number_of_stimulus=size(triger_ERP);

    % In code baraye emtehan kardan '%f' dar nazar gerefte shode ke bebinim che mikone
    %fileID = fopen('ERP.txt','r');
    %t_line = fgetl(fileID);
    %A = fscanf(fileID, '%f');

    % In ghesmat baraye bedast avardane tedade nemuneha hast
    fid=fopen(strcat('signal', 'L', num2str(i), '.txt'));
    g = textscan(fid,'%s','delimiter','\n');
    full_eeg_samples=length(g{1}); %kolan mige ke bara har channel chanta sample hast
    fclose(fid);

    % In ghestmat baraye tashkil signal ba channelhash(SIGNAL) va hamchenin tabdile har sample be zaman hast(full_eeg_times)
    fileID = fopen(strcat('signal', 'L', num2str(i), '.txt'),'r');
    SIGNAL=fscanf(fileID,'%f',[21,full_eeg_samples]); % data khame hame channel ha hast
    full_eeg_times(1:full_eeg_samples,1)=(1:full_eeg_samples)/Fs; % mige ke har sample moadel ba che zamani hast, sample 250 barabar ba zaman e yek shode

    % signal (transposed and filtering)
    SIGNAL=SIGNAL';
    data = filtfilt(b,a,SIGNAL);
    %Signal(1,:,:)=SIGNAL(:,1:channel);

    % EOG
    %Signal(1,:,:)=SIGNAL(:,1:channel);
    %eog_Signal=SIGNAL(:,eog_channel);
    %eog_Signal=filtfilt(b,a,eog_Signal);
    %eog_peak=eog_Signal>threshold_eog; % logical
    %eog_peak=cast(eog_peak,'double');

    % Seperate channel elevenchannel(FzF3F4CzC3C4PzP3P4T5T6) for Probe
    sample_ERP = time_ERP * Fs; %tabdile bordar zamaniye time_ERP be sample
    Fz = data(:, [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19]);
    pos_probe = find(triger_ERP == 3);  %position probe ba label 3 dar triger_ERP ro peyda mikone

    % probe segmentation of elevenchannel(FzF3F4CzC3C4PzP3P4T5T6)(consider that it has 276 samples which is wierd because the on-set has 275 samples!!)
    for j = 1:length(pos_probe)
        Fz_probe(:,19*j-18:19*j) = Fz(sample_ERP(pos_probe(j)):sample_ERP(pos_probe(j))+Fs_on, :);
    end

    alldata_allchannel_probe_rangefour_L(:, 570*i-569:570*i) = Fz_probe(1:250, :); %rangefour = 0.0-1 secs
end

% get all channels into a one column for classification
for i = 1:length(alldata_allchannel_probe_rangefour_L)/channels_number
    alldata_allchannel_rangefour_L_classification(:,i) = reshape(alldata_allchannel_probe_rangefour_L(:, channels_number*i-18:channels_number*i), [size(alldata_allchannel_probe_rangefour_L, 1)*channels_number, 1]);
end

%% Data preparing for classification

alldata_allchannel = [alldata_allchannel_rangefour_L_classification, alldata_allchannel_rangefour_T_classification];
label_l = ones(1, size(alldata_allchannel_rangefour_L_classification, 2));
label_t = zeros(1, size(alldata_allchannel_rangefour_T_classification, 2));
label_data = [label_l, label_t];
final_alldata_allchannel = [alldata_allchannel; label_data]';

%% Machine Learning Classification using Classification Learner App

% Prepare predictor matrix (X) and response labels (Y)
% Rows correspond to observations (trials) and columns correspond to features (time-series points)
X = final_alldata_allchannel(:, 1:end-1); 
Y = final_alldata_allchannel(:, end);

% Open the MATLAB Classification Learner App
classificationLearner;

%{
--------------------------------------------------------------------------------
INSTRUCTIONS FOR USING CLASSIFICATION LEARNER APP:
--------------------------------------------------------------------------------
1. After running this script, the "Classification Learner" window will automatically open.
2. Click on "New Session" -> "From Workspace".
3. In the setup window:
   - Select 'X' as your Predictors (Features).
   - Select 'Y' as your Response (Labels: 1 for Lie, 0 for Truth).
4. Choose your Data Split method (e.g., 5-fold or 10-fold Cross-Validation, or Holdout Validation).
5. Click "Start Session".
6. In the top toolstrip, select any machine learning model (e.g., SVM, Decision Trees, 
   KNN, Ensemble Classifiers, or Train All Models) and click "Train".
--------------------------------------------------------------------------------
%}
