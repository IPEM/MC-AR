function [PD, dSparc, dBL, ROI, ROIupstrokes, ROIdownstrokes, Result1, Result2] = CalculateMetrics(MocapDataPath1, MocapDataPath2, AudioPath1, AudioFs, MocapFs, WindowLength, LoudnessThreshold, StrokeLength)
    % CalculateMetrics - Calculate a range of metrics comparing two signals from two motion capture datasets.
    %
    % Syntax:
    %   [PD, dSparc, dBL, ROI, ROIupstrokes, ROIdownstrokes, Result1, Result2] = CalculateMetrics(MocapDataPath1, MocapDataPath2, AudioPath1, AudioFs, MocapFs, WindowLength, LoudnessThreshold, StrokeLength)
    %
    % Input:
    %   MocapDataPath1 - Path to the reference MoCap dataset (csv file).
    %   MocapDataPath2 - Path to the MoCap dataset to be compared (csv file).
    %   AudioPath1 - Path to the reference audio file (wav file).
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
    %   ROI - Regions of Interest (ROI) as defined from the reference violinist.
    %   ROIupstrokes - ROI from the bow upstrokes only.
    %   ROIdownstrokes - ROI from the bow downstrokes only.
    %   Result1 - Bowing position of the reference violinist.
    %   Result2 - Bowing position of the violinist to be compared.
    %
    % Description:
    %   This function calculates a range of metrics comparing two signals from two motion capture datasets of two violinists.
    %
    %   The metrics include Procrustes distance (PD), difference in SPARC (Spectral Arc Length) (dSparc), and
    %   difference in bowing length (dBL). The output contains various ROIs and bowing positions for further analysis.

    % Calculate bow position data from avatar and participant motion capture data
    Result2 = ProcessMocapData(MocapDataPath2);
    Result2 = Result2.PreProcessData;
    Result2 = Result2.ProcessData;
    
    Result1 = ProcessMocapData(MocapDataPath1, AudioPath1);
    Result1 = Result1.PreProcessData;
    Result1 = Result1.ProcessData;
    
    % Extract bow position and audio data from the results
    Audio1 = Result1.SyncedAudio.LeftMic;
    Result1_1 = Result1.ProcessedMocapData.ProcessedData.BowPositionData.DB(:, 1);
    Result1_2 = Result1.ProcessedMocapData.ProcessedData.BowPositionData.DV(:, 1);
    Result2_1 = Result2.ProcessedMocapData.ProcessedData.BowPositionData.DB(:, 1);
    Result2_2 = Result2.ProcessedMocapData.ProcessedData.BowPositionData.DV(:, 1);
    
    % Compute a spectrogram from the audio data 
    RelativeWindowLength = WindowLength / MocapFs;
    Spectrogram1 = Spectrogram(Audio1, AudioFs, MocapFs, RelativeWindowLength);
    
    % Find regions of interest (ROI) in the bowing position of the reference violinist 
    [ROI, ROIupstrokes, ROIdownstrokes] = FindRegions(Result1_1, Spectrogram1, LoudnessThreshold, StrokeLength);
    
    % Compare signals 
    % Grad = 0; Type = 1 corresponds to Procrustes distance analysis
    Grad = 0;
    Type = 1;
    PD = CompareSignals([Result1_1, Result1_2], [Result2_1, Result2_2], ROI, Grad, Type);
    
    % Grad = 1; Type = 2 corresponds to difference in SPARC index
    Grad = 1;
    Type = 2;
    dSparc = CompareSignals([Result1_1, Result1_2], [Result2_1, Result2_2], ROI, Grad, Type);
    
    % Grad = 0; Type = 3 corresponds to difference in bow length
    Grad = 0;
    Type = 3;
    dBL = CompareSignals([Result1_1, Result1_2], [Result2_1, Result2_2], ROI, Grad, Type);
end
