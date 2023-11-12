%% 1. Clear the workspace
clc
clear
close all
% addpath([cd,'/Functions/Example/'])
addpath([cd,'/Functions/BatchProcessing/'])
addpath([cd,'/Functions/General/'])
%% 2. Demonstration of analysis
% 2.1. Prepare workspace
% Path to participant's MoCap data file
ParticipantMocapPath = [cd, '/Assets/ParticipantMoCap.csv'];

% Paths to avatar's MoCap and Audio files
AvatarMocapPath = [cd, '/Assets/AvatarMoCap.csv'];
AvatarAudioPath = [cd, '/Assets/AvatarAudio.wav'];

% 2.1. Compare the motion capture data of the avatar and the participant
AudioFs = 48000; MocapFs = 120; WindowLength = 10; LoudnessThreshold = 0.15; StrokeLength = 150;
[PD, dSparc, dBL, ROI, ROIupstrokes, ROIdownstrokes, ResultAvatar, ResultParticipant] = CalculateMetrics(AvatarMocapPath, ParticipantMocapPath, AvatarAudioPath, AudioFs, MocapFs, WindowLength, LoudnessThreshold, StrokeLength);

% 2.2. Visualize the results
% Create a figure showing joint angles and bow position data 
Figure_JointAngleData(ResultAvatar, ResultParticipant)

% Create a figure comparing avatar and participant data
Figure_CompareData(ResultAvatar, ResultParticipant, ROI, ROIupstrokes, ROIdownstrokes, PD, dSparc, dBL)

%% 3. Reconstruct dataset for analysis using R package.
% 3.1. Specify the path
% Define the path for downloading and unzipping data (requires about 3 GB)
DataFolderPath = '/Users/adriaancampo/Desktop/ONGOING_PROJECTS/SOFTWARE IMPACTS/GIT_MATLAB';

% 3.2. Download the dataset from Zenodo
% Download the data 
DownloadRepo(DataFolderPath);

% 3.3. Unpack downloaded dataset
% Unpack the downloaded data 
UnpackRepo(DataFolderPath);

% 3.4. Arrange dataset for further processing (see R package)
% Prepare the dataset for statistical analysis and save it locally.
% The function BatchCalculateMetrics takes two arguments:
% - InputPath: The path to the unpacked dataset.
% - OutputPath: The path to save the data array for further analysis.

% Call the BatchCalculateMetrics function with the InputPath (DataFolderPath) and
% OutputPath (DataFolderPath) both set to DataFolderPath to prepare and
% save the dataset locally.
DataArray = BatchCalculateMetrics(DataFolderPath, DataFolderPath);
