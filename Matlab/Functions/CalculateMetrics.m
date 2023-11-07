function [PD, dSparc, dBL, ROI, ROIupstrokes, ROIdownstrokes, ResultAvatar, ResultParticipant] = CalculateMetrics(AvatarMocapPath, ParticipantMocapPath, AvatarAudioPath, AudioFs, MocapFs, WindowLength, LoudnessThreshold, StrokeLength)
    % CalculateMetrics - Calculate a range of metrics comparing two signals from two motion capture datasets.
    %
    % Syntax:
    %   [PD, dSparc, dBL, ROI, ROIupstrokes, ROIdownstrokes, BowAvatar1, BowParticipant2] = CalculateMetrics(AvatarMocapPath, ParticipantMocapPath, AvatarAudioPath, AudioFs, MocapFs, WindowLength, LoudnessThreshold, StrokeLength)
    %
    % Input:
    %   AvatarMocapPath - Path to the reference MoCap data set (csv file).
    %   ParticipantMocapPath - Path to the MoCap data set to be compared (csv file).
    %   AvatarAudioPath - Path to the reference audio file (wav file).
    %   AudioFs - Sampling frequency of audio.
    %   MocapFs - Sampling frequency of motion capture data.
    %   WindowLength - Window length of the spectrogram.
    %   LoudnessThreshold - Loudness threshold for further processing.
    %   StrokeLength - Bowing length threshold for further processing.
    %
    % Output:
    %   PD - Procrustes metric.
    %   dSparc - Difference in SPARC index between two violinists.
    %   dBL - Difference in bowing length between two violinists.
    %   ROI - Regions of Interest (ROI) as defined from the reference violinists.
    %   ROIupstrokes - ROI from the bow upstrokes only.
    %   ROIdownstrokes - ROI from the bow downstrokes only.
    %   BowAvatar1 - Bowing position of the reference violinist.
    %   BowParticipant2 - Bowing position of the violinist to be compared.
    %
    % Description:
    %   This function calculates a range of metrics comparing two signals from two motion capture datasets of two violinists.

    % Calculate bow position data from avatar and participant motion capture data
    ResultParticipant = ProcessMocapData(ParticipantMocapPath);
    ResultParticipant = ResultParticipant.PreProcessData;
    ResultParticipant = ResultParticipant.ProcessData;
    
    ResultAvatar = ProcessMocapData(AvatarMocapPath, AvatarAudioPath);
    ResultAvatar = ResultAvatar.PreProcessData;
    ResultAvatar = ResultAvatar.ProcessData;
    
    % Extract bow position and audio data from the results
    BowAvatar1 = ResultAvatar.ProcessedMocapData.ProcessedData.BowPositionData.DB(:, 1);
    BowAvatar2 = ResultAvatar.ProcessedMocapData.ProcessedData.BowPositionData.DV(:, 1);
    BowParticipant1 = ResultParticipant.ProcessedMocapData.ProcessedData.BowPositionData.DB(:, 1);
    BowParticipant2 = ResultParticipant.ProcessedMocapData.ProcessedData.BowPositionData.DV(:, 1);
    AudioAvatar = ResultAvatar.SyncedAudio.LeftMic;
    
    % Compute a spectrogram from the audio data 
    RelativeWindowLength = WindowLength / MocapFs;
    SpectrogramAvatar = Spectrogram(AudioAvatar, AudioFs, MocapFs, RelativeWindowLength);
    
    % Find regions of interest (ROI) in the bowing position of the reference violinist 
    [ROI, ROIupstrokes, ROIdownstrokes] = FindRegions(BowAvatar1, SpectrogramAvatar, LoudnessThreshold, StrokeLength);
    
    % Compare signals 
    % Grad = 0; Type = 1 corresponds to Procrustes distance analysis
    Grad = 0;
    Type = 1;
    PD = CompareSignals([BowAvatar1, BowAvatar2], [BowParticipant1, BowParticipant2], ROI, Grad, Type);
    
    % Grad = 1; Type = 2 corresponds to difference in SPARC index
    Grad = 1;
    Type = 2;
    dSparc = CompareSignals([BowAvatar1, BowAvatar2], [BowParticipant1, BowParticipant2], ROI, Grad, Type);
    
    % Grad = 0; Type = 3 corresponds to difference in bow length
    Grad = 0;
    Type = 3;
    dBL = CompareSignals([BowAvatar1, BowAvatar2], [BowParticipant1, BowParticipant2], ROI, Grad, Type);
end
