function [DataF1,DataF2,DataF3,DataF4] = BatchExtractFIDs(DataFolderPath)
    % BatchExtractFIDs - Generate an array of timeseries containing joint
    % angle data from the MoCap data files.
    %
    % Syntax:
    %   [DataF1, DataF2, DataF3, DataF4] = BatchExtractFIDs(DataFolderPath)
    %
    % Input:
    %   DataFolderPath - Path to the folder with all data.
    %   OutputPath - Path where the data array will be saved.
    %
    % Output:
    %   DataF1 - Data array of fragment 1.
    %   DataF2 - Data array of fragment 2.
    %   DataF3 - Data array of fragment 3.
    %   DataF4 - Data array of fragment 4.
    %
    % Description:
    %   This function generates an array containing all the necessary data 
    %   points to reproduce the results as published. The structure of the 
    %   dataset includes various indices for different attributes. 
    %   The dataset can be used for statistical analysis in the R package, 
    %   as described in the publication. It includes information related to 
    %   metrics, participants, sessions, conditions, pieces, and violin 
    %   sections.
        
    disp('Starting extraction of MoCap joint angle data.')

    % find all mocap data files
    AllMocapFiles = dir([DataFolderPath,'/**/*_MoCap.csv']);
    PlaceHolder1 = [];
    PlaceHolder2 = [];
    PlaceHolder3 = [];
    PlaceHolder4 = [];

    % process mocap data and extract bow position data
    for idx = 1:numel(AllMocapFiles) 
    
        PathToMocapFile = fullfile(AllMocapFiles(idx).folder, AllMocapFiles(idx).name);
    
        PathToAudioFile = dir([DataFolderPath,'/**/',AllMocapFiles(idx).name(1:end-10),'_Audio.wav']); 
        
        try
            PathToAudioFile = fullfile(PathToAudioFile(1).folder, PathToAudioFile(1).name);
        catch
        end
    
        if contains(PathToMocapFile,'F1')
    
            % piece F1 -> tag 1
            F = 1;
            
            if contains(PathToMocapFile,'Avatar')
    
                Result = ProcessMocapData(PathToMocapFile,PathToAudioFile);
                Result = Result.PreProcessData;
                Result = Result.ProcessData;
    
                FID = Result.ProcessedMocapData.ProcessedData.BowPositionData.DB(:,1);
                AudioData = Result.SyncedAudio.LeftMic;
                spectrogramOutput = Spectrogram(AudioData,48000,Result.Parameters.Fs,10/(Result.Parameters.Fs));
                
                AvatarTag1 = nan(length(FID),2);
                AvatarTag1(:,2) = FID;
                AvatarTag1(1:length(spectrogramOutput),1) = spectrogramOutput;
                AvatarTag1 = [ones(4,1),F*ones(4,1);AvatarTag1]; % indicates violin section, and piece
                AvatarTag1 = repmat(AvatarTag1,1,1,2);
                AvatarTag1(5:end,2,2) = Result.ProcessedMocapData.ProcessedData.BowPositionData.DV(:,1);
    
            elseif contains(PathToMocapFile,'_T')
    
                Tag(1,1) = F;
    
                if contains(PathToMocapFile,'_2D_')
                    Tag(2,1) = 1;
                elseif contains(PathToMocapFile,'_3D_')
                    Tag(2,1) = 2;
                end
    
                if contains(PathToMocapFile,'_T1_')
                    Tag(3,1) = 1;
                elseif contains(PathToMocapFile,'_T2_')
                    Tag(3,1) = 2;
                elseif contains(PathToMocapFile,'_T3_')
                    Tag(3,1) = 3;
                elseif contains(PathToMocapFile,'_T4_')
                    Tag(3,1) = 4;
                end
    
                [~,FileName] = fileparts(PathToMocapFile);
                Tag(4,1) = str2double(FileName(2:4));
    
                Result = ProcessMocapData(PathToMocapFile);
                Result = Result.PreProcessData;
                Result = Result.ProcessData;
    
                FID = Result.ProcessedMocapData.ProcessedData.BowPositionData.DB(:,1);
     
                if size(PlaceHolder1,1)>0
                    L = size(PlaceHolder1,1) - 4;
                    if length(FID)>=L
                        FID = FID(1:L);
                    elseif length(FID)<L
                        tmp = nan(L,1);
                        tmp(1:length(FID)) = FID;
                        FID = tmp; clear tmp
                    end
                end
    
                tmp = [Tag;FID]; 
                tmp = repmat(tmp,1,1,2);
                tmp(5:end,1,2) = Result.ProcessedMocapData.ProcessedData.BowPositionData.DV(1:length(FID),1);
                PlaceHolder1 = [PlaceHolder1,tmp]; clear tmp
    
            end
    
        elseif contains(PathToMocapFile,'F2')
    
            % piece F2 -> tag 2
            F = 2;
            
            if contains(PathToMocapFile,'Avatar')
    
                Result = ProcessMocapData(PathToMocapFile,PathToAudioFile);
                Result = Result.PreProcessData;
                Result = Result.ProcessData;
    
                FID = Result.ProcessedMocapData.ProcessedData.BowPositionData.DB(:,1);
                AudioData = Result.SyncedAudio.LeftMic;
                spectrogramOutput = Spectrogram(AudioData,48000,Result.Parameters.Fs,10/(Result.Parameters.Fs));
                
                AvatarTag2 = nan(length(FID),2);
                AvatarTag2(:,2) = FID;
                AvatarTag2(1:length(spectrogramOutput),1) = spectrogramOutput;
                AvatarTag2 = [ones(4,1),F*ones(4,1);AvatarTag2]; % indicates violin section, and piece
                AvatarTag2 = repmat(AvatarTag2,1,1,2);
                AvatarTag2(5:end,2,2) = Result.ProcessedMocapData.ProcessedData.BowPositionData.DV(:,1);
    
            elseif contains(PathToMocapFile,'_T')
    
                Tag(1,1) = F;
    
                if contains(PathToMocapFile,'_2D_')
                    Tag(2,1) = 1;
                elseif contains(PathToMocapFile,'_3D_')
                    Tag(2,1) = 2;
                end
    
                if contains(PathToMocapFile,'_T1_')
                    Tag(3,1) = 1;
                elseif contains(PathToMocapFile,'_T2_')
                    Tag(3,1) = 2;
                elseif contains(PathToMocapFile,'_T3_')
                    Tag(3,1) = 3;
                elseif contains(PathToMocapFile,'_T4_')
                    Tag(3,1) = 4;
                end
    
                [~,FileName] = fileparts(PathToMocapFile);
                Tag(4,1) = str2double(FileName(2:4));
    
                Result = ProcessMocapData(PathToMocapFile);
                Result = Result.PreProcessData;
                Result = Result.ProcessData;
    
                FID = Result.ProcessedMocapData.ProcessedData.BowPositionData.DB(:,1);
                
                if size(PlaceHolder2,1)>0
                    L = size(PlaceHolder2,1) - 4;
                    if length(FID)>=L
                        FID = FID(1:L);
                    elseif length(FID)<L
                        tmp = nan(L,1);
                        tmp(1:length(FID)) = FID;
                        FID = tmp; clear tmp
                    end
                end
    
                tmp = [Tag;FID]; 
                tmp = repmat(tmp,1,1,2);
                tmp(5:end,1,2) = Result.ProcessedMocapData.ProcessedData.BowPositionData.DV(1:length(FID),1);
                PlaceHolder2 = [PlaceHolder2,tmp]; clear tmp
    
            end
    
        elseif contains(PathToMocapFile,'F3')
    
            % piece F3 -> tag 1
            F = 1;
            
            if contains(PathToMocapFile,'Avatar')
    
                Result = ProcessMocapData(PathToMocapFile,PathToAudioFile);
                Result = Result.PreProcessData;
                Result = Result.ProcessData;
    
                FID = Result.ProcessedMocapData.ProcessedData.BowPositionData.DB(:,1);
                AudioData = Result.SyncedAudio.LeftMic;
                spectrogramOutput = Spectrogram(AudioData,48000,Result.Parameters.Fs,10/(Result.Parameters.Fs));
                
                AvatarTag3 = nan(length(FID),2);
                AvatarTag3(:,2) = FID;
                AvatarTag3(1:length(spectrogramOutput),1) = spectrogramOutput;
                AvatarTag3 = [2*ones(4,1),F*ones(4,1);AvatarTag3]; % indicates violin section, and piece
                AvatarTag3 = repmat(AvatarTag3,1,1,2);
                AvatarTag3(5:end,2,2) = Result.ProcessedMocapData.ProcessedData.BowPositionData.DV(:,1);
    
            elseif contains(PathToMocapFile,'_T')
    
                Tag(1,1) = F;
    
                if contains(PathToMocapFile,'_2D_')
                    Tag(2,1) = 1;
                elseif contains(PathToMocapFile,'_3D_')
                    Tag(2,1) = 2;
                end
    
                if contains(PathToMocapFile,'_T1_')
                    Tag(3,1) = 1;
                elseif contains(PathToMocapFile,'_T2_')
                    Tag(3,1) = 2;
                elseif contains(PathToMocapFile,'_T3_')
                    Tag(3,1) = 3;
                elseif contains(PathToMocapFile,'_T4_')
                    Tag(3,1) = 4;
                end
    
                [~,FileName] = fileparts(PathToMocapFile);
                Tag(4,1) = str2double(FileName(2:4));
    
                Result = ProcessMocapData(PathToMocapFile);
                Result = Result.PreProcessData;
                Result = Result.ProcessData;
    
                FID = Result.ProcessedMocapData.ProcessedData.BowPositionData.DB(:,1);
     
                if size(PlaceHolder3,1)>0
                    L = size(PlaceHolder3,1) - 4;
                    if length(FID)>=L
                        FID = FID(1:L);
                    elseif length(FID)<L
                        tmp = nan(L,1);
                        tmp(1:length(FID)) = FID;
                        FID = tmp; clear tmp
                    end
                end
                
                tmp = [Tag;FID]; 
                tmp = repmat(tmp,1,1,2);
                tmp(5:end,1,2) = Result.ProcessedMocapData.ProcessedData.BowPositionData.DV(1:length(FID),1);
                PlaceHolder3 = [PlaceHolder3,tmp]; clear tmp
    
            end
    
        elseif contains(PathToMocapFile,'F4')
    
            % piece F4 -> tag 2
            F = 2;
            
            if contains(PathToMocapFile,'Avatar')
    
                Result = ProcessMocapData(PathToMocapFile,PathToAudioFile);
                Result = Result.PreProcessData;
                Result = Result.ProcessData;
    
                FID = Result.ProcessedMocapData.ProcessedData.BowPositionData.DB(:,1);
                AudioData = Result.SyncedAudio.LeftMic;
                spectrogramOutput = Spectrogram(AudioData,48000,Result.Parameters.Fs,10/(Result.Parameters.Fs));
                
                AvatarTag4 = nan(length(FID),2);
                AvatarTag4(:,2) = FID;
                AvatarTag4(1:length(spectrogramOutput),1) = spectrogramOutput;
                AvatarTag4 = [2*ones(4,1),F*ones(4,1);AvatarTag4]; % indicates violin section, and piece
                AvatarTag4 = repmat(AvatarTag4,1,1,2);
                AvatarTag4(5:end,2,2) = Result.ProcessedMocapData.ProcessedData.BowPositionData.DV(:,1);
    
            elseif contains(PathToMocapFile,'_T')
    
                Tag(1,1) = F;
    
                if contains(PathToMocapFile,'_2D_')
                    Tag(2,1) = 1;
                elseif contains(PathToMocapFile,'_3D_')
                    Tag(2,1) = 2;
                end
    
                if contains(PathToMocapFile,'_T1_')
                    Tag(3,1) = 1;
                elseif contains(PathToMocapFile,'_T2_')
                    Tag(3,1) = 2;
                elseif contains(PathToMocapFile,'_T3_')
                    Tag(3,1) = 3;
                elseif contains(PathToMocapFile,'_T4_')
                    Tag(3,1) = 4;
                end
    
                [~,FileName] = fileparts(PathToMocapFile);
                Tag(4,1) = str2double(FileName(2:4));
    
                Result = ProcessMocapData(PathToMocapFile);
                Result = Result.PreProcessData;
                Result = Result.ProcessData;
    
                FID = Result.ProcessedMocapData.ProcessedData.BowPositionData.DB(:,1);
      
                if size(PlaceHolder4,1)>0
                    L = size(PlaceHolder4,1) - 4;
                    if length(FID)>=L
                        FID = FID(1:L);
                    elseif length(FID)<L
                        tmp = nan(L,1);
                        tmp(1:length(FID)) = FID;
                        FID = tmp; clear tmp
                    end
                end
               
                tmp = [Tag;FID]; 
                tmp = repmat(tmp,1,1,2);
                tmp(5:end,1,2) = Result.ProcessedMocapData.ProcessedData.BowPositionData.DV(1:length(FID),1);
                PlaceHolder4 = [PlaceHolder4,tmp]; clear tmp
    
            end
    
        end
    
        disp(['Processed ',num2str(idx),' of ',num2str(numel(AllMocapFiles)),' MoCap Files.'])
    
    end
    
    % Join and trim placeholders
    DataF1 = [nan(size(PlaceHolder1,1),2,2), PlaceHolder1]; DataF1(1:size(AvatarTag1,1),1:2,1:2) = AvatarTag1;
    DataF2 = [nan(size(PlaceHolder2,1),2,2), PlaceHolder2]; DataF2(1:size(AvatarTag2,1),1:2,1:2) = AvatarTag2;
    DataF3 = [nan(size(PlaceHolder3,1),2,2), PlaceHolder3]; DataF3(1:size(AvatarTag3,1),1:2,1:2) = AvatarTag3;
    DataF4 = [nan(size(PlaceHolder4,1),2,2), PlaceHolder4]; DataF4(1:size(AvatarTag4,1),1:2,1:2) = AvatarTag4;
   
end