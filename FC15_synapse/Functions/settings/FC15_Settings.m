%% FC15_Settings
% Settings for all the datasets 

%% Silane 
imageDownloadServer = 'openconnecto.me';
imageDownloadToken = 'collman15'; 
% Focus channel should be last 
channelList = {'NR1594', 'VGluT1_647', 'Synapsin647', 'PSD95_488'};
resolution = 0; 

synapseDownloadServer = 'dsp061.pha.jhu.edu'; 
synapseDownloadToken = 'silane_manual_annotations';
synapseDownloadChannel = 'silane_man_anno';


maskDownloadServer = 'openconnecto.me';
maskDownloadToken = 'collman_silane_mask_anno'; 
maskDownloadChannel = 'annotation'; 


annoUploadServer = 'dsp061.pha.jhu.edu'; 
annoUploadToken = 'silane_detection_uploads'; 
annoUploadChannel_gt = 'puncta_syn_v1';
annoUploadChannel = 'puncta_upload_v1';
anno_neg_ch = 'puncta_negative_detections'; 

signalthresh = 6; % based on median psd puncta of 0.09um^2
scale = 3.72; %100nm/pixel for chessboard dataset
dxy_thresh = 400; %The threshold was set at 400 nm

%% Gelatin 

% imageDownloadServer = 'openconnecto.me';
% imageDownloadToken = 'collman15'; 
% % Focus channel should be 
% channelList = {'NR1594', 'VGluT1_647', 'Synapsin647', 'PSD95_488'};
% resolution = 0; 
% 
% synapseDownloadServer = 'dsp061.pha.jhu.edu'; 
% synapseDownloadToken = 'collman_silane2';
% synapseDownloadChannel = 'anno1';
% 
% annoUploadServer = 'dsp061.pha.jhu.edu'; 
% annoUploadToken = 'silane_test_upload2'; 
% annoUploadChannel = 'anno1';
% 
% signalthresh = 6; % based on median psd puncta of 0.09um^2
% scale = 3.72; %100nm/pixel for chessboard dataset
% dxy_thresh = 400; %The threshold was set at 400 nm





%% Weiler 

% imageDownloadServer = 'openconnecto.me'; 
% imageDownloadToken = 'Ex10R55'; 
% resolution = 0; 
% signalthresh = 700; % based on median psd puncta of 0.09um^2
% channelList = {'PSD95_1', 'NR2A_1', 'NR2B_3', 'Synapsin1_2', 'vGluT1_3', 'vGluT2_2'};
