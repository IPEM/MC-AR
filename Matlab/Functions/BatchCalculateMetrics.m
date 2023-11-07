function DataArray = BatchCalculateMetrics(DataFolderPath,OutputPath)
    % BatchCalculateMetrics - generates an array containing all the necessary data points
    %
    % Syntax:
    %   DataArray = BatchCalculateMetrics(DataFolderPath, OutputPath)
    %
    % Input:
    %   DataFolderPath - Path to the folder with all data.
    %   OutputPath - Path where the data array will be saved.
    %
    % Output:
    %   DataArray - Data array for further analysis.
    %
    % Description:
    %   This function generates an array containing all the necessary data 
    %   points to reproduce the results as published. The structure of the 
    %   dataset includes various indices for different attributes. 
    %   The dataset can be used for statistical analysis in the R package, 
    %   as described in the publication. It includes information related to 
    %   metrics, participants, sessions, conditions, pieces, and violin 
    %   sections.
    
    disp('Starting processing of MoCap data.')
    % find all mocap data files
    AllMocapFiles = dir([DataFolderPath,'/**/*_MoCap.csv']);
    PlaceHolder1 = [];
    PlaceHolder2 = [];
    PlaceHolder3 = [];
    PlaceHolder4 = [];

    % process mocap data and extract bow position data
    for idx = 1:5%numel(AllMocapFiles) 
    
        PathToMocapFile = fullfile(AllMocapFiles(idx).folder, AllMocapFiles(idx).name);
    
        PathToAudioFile = dir([DataFolderPath,'/**/',AllMocapFiles(idx).name(1:end-10),'_Audio.wav']); 
        
        try
            PathToAudioFile = fullfile(PathToAudioFile(1).folder, PathToAudioFile(1).name);
        catch
        end
    
        if contains(PathToMocapFile,'F1')
    
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
                AvatarTag1 = [ones(4,1),ones(4,1);AvatarTag1];
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
                AvatarTag2 = [ones(4,1),2*ones(4,1);AvatarTag2];
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
                AvatarTag3 = [2*ones(4,1),3*ones(4,1);AvatarTag3];
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
                AvatarTag4 = [2*ones(4,1),4*ones(4,1);AvatarTag4];
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
    
    % Extract features (SPARC and Procrustes distance)
    Procrustes_disp_11 = BatchExtractFeatures(DataF1,0.15,150,0,1);
    Procrustes_disp_12 = BatchExtractFeatures(DataF2,0.15,150,0,1);
    Procrustes_disp_21 = BatchExtractFeatures(DataF3,0.15,150,0,1);
    Procrustes_disp_22 = BatchExtractFeatures(DataF4,0.15,150,0,1);
    
    Sparc_vel_11 = BatchExtractFeatures(DataF1,0.15,150,1,2);
    Sparc_vel_12 = BatchExtractFeatures(DataF2,0.15,150,1,2);
    Sparc_vel_21 = BatchExtractFeatures(DataF3,0.15,150,1,2);
    Sparc_vel_22 = BatchExtractFeatures(DataF4,0.15,150,1,2);
    
    BowLength_disp_11 = BatchExtractFeatures(DataF1,0.15,150,0,3);
    BowLength_disp_12 = BatchExtractFeatures(DataF2,0.15,150,0,3);
    BowLength_disp_21 = BatchExtractFeatures(DataF3,0.15,150,0,3);
    BowLength_disp_22 = BatchExtractFeatures(DataF4,0.15,150,0,3);  
    disp('Finished processing of MoCap data.')

    % Extract questionnaire data (PQ, MPQS, MPQP) 
    disp('Extracting Questionnaire data.')
    C1 = dir([DataFolderPath,'/**/C1.csv']);
    C1 = ImportFile(fullfile(C1.folder,C1.name));
    C2 = dir([DataFolderPath,'/**/C2.csv']);
    C2 = ImportFile(fullfile(C2.folder,C2.name));
    
    pp = DataF1(4,3:end,1);
    cc = DataF1(2,3:end,1);
    sel = (pp(cc==1))'; tags = [sel,ones(size(sel)),ones(size(sel)),ones(size(sel))];
    pp = DataF2(4,3:end,1);
    cc = DataF2(2,3:end,1);
    sel = (pp(cc==1))'; tags = [tags;[sel,2*ones(size(sel)),ones(size(sel)),ones(size(sel))]];
    pp = DataF3(4,3:end,1);
    cc = DataF3(2,3:end,1);
    sel = (pp(cc==1))'; tags = [tags;[sel,1*ones(size(sel)),ones(size(sel)),2*ones(size(sel))]];
    pp = DataF4(4,3:end,1);
    cc = DataF4(2,3:end,1);
    sel = (pp(cc==1))'; tags = [tags;[sel,2*ones(size(sel)),ones(size(sel)),2*ones(size(sel))]];
    [~,sel] = sort(tags(:,1)); tags = tags(sel,:); 
    sel = find(tags(:,1) == 7); tags(sel(1),:) = [];
    
    TagC1 = [];
    
    TagC1(1,:) = tags(:,4)'; % section
    TagC1(2,:) = tags(:,2)'; % piece
    TagC1(3,:) = tags(:,3)'; % condition
    TagC1(4,:) = C1.session'; % session
    TagC1(5,:) = tags(:,1)'; % participant
    
    MPQP = table2array(mean(C1(:,17:21),2)); MPQP = [TagC1;MPQP']; MPQP = ReshapeFile(MPQP,6,0);
    MPQS = table2array(mean(C1(:,22:26),2)); MPQS = [TagC1;MPQS']; MPQS = ReshapeFile(MPQS,5,0);
    PQ = table2array(mean(C1(:,27:55),2)); PQ = [TagC1;PQ']; PQ = ReshapeFile(PQ,4,0); 
    
    TagC1 = [MPQP;MPQS;PQ];
    
    DummyData = [nan,2,2,1,2,7,1,4 ; ...
        nan,2,2,1,2,7,1,5 ; ...
        nan,2,2,1,2,7,1,6 ; ...
        nan,2,2,1,2,7,1,7];
    
    TagC1 = [TagC1;DummyData];
    
    pp = DataF1(4,3:end,1);
    cc = DataF1(2,3:end,1);
    sel = (pp(cc==2))'; tags = [sel,ones(size(sel)),2*ones(size(sel)),ones(size(sel))];
    pp = DataF2(4,3:end,1);
    cc = DataF2(2,3:end,1);
    sel = (pp(cc==2))'; tags = [tags;[sel,2*ones(size(sel)),2*ones(size(sel)),ones(size(sel))]];
    pp = DataF3(4,3:end,1);
    cc = DataF3(2,3:end,1);
    sel = (pp(cc==2))'; tags = [tags;[sel,1*ones(size(sel)),2*ones(size(sel)),2*ones(size(sel))]];
    pp = DataF4(4,3:end,1);
    cc = DataF4(2,3:end,1);
    sel = (pp(cc==2))'; tags = [tags;[sel,2*ones(size(sel)),2*ones(size(sel)),2*ones(size(sel))]];
    [~,sel] = sort(tags(:,1)); tags = tags(sel,:); 
    sel = find(tags(:,1) == 7); tags(sel(1),:) = [];
    
    TagC2 = [];
    
    TagC2(1,:) = tags(:,4)'; % section
    TagC2(2,:) = tags(:,2)'; % piece
    TagC2(3,:) = tags(:,3)'; % condition
    TagC2(4,:) = C2.session'; % session
    TagC2(5,:) = tags(:,1)'; % participant
    
    MPQP = table2array(mean(C1(:,17:21),2)); MPQP = [TagC2;MPQP']; MPQP = ReshapeFile(MPQP,6,0);
    MPQS = table2array(mean(C1(:,22:26),2)); MPQS = [TagC2;MPQS']; MPQS = ReshapeFile(MPQS,5,0);
    PQ = table2array(mean(C1(:,27:55),2)); PQ = [TagC2;PQ']; PQ = ReshapeFile(PQ,4,0);
    
    Difficulty_1 = [ tags(:,4)'; ...
        ones(1,length(table2array(C1(:,65)))); ...
        ones(1,length(table2array(C1(:,65)))); ... 
        C1.session'; ...
        C1.participant'; ...
        table2array(C1(:,65))']; Difficulty_1(3,tags(:,2) == 1) = 2;
    
    Difficulty_2 = [ tags(:,4)'; ...
        2*ones(1,length(table2array(C1(:,66)))); ...
        ones(1,length(table2array(C1(:,66)))); ... 
        C1.session'; ...
        C1.participant'; ...
        table2array(C1(:,66))']; Difficulty_2(3,tags(:,2) == 2) = 2;
    
    Difficulty = [Difficulty_1,Difficulty_2]; Difficulty = ReshapeFile(Difficulty,7,0);
    
    TagC2 = [MPQP;MPQS;PQ;Difficulty];
    
    DummyData = [nan,2,1,2,2,7,1,4 ; ...
        nan,2,1,2,2,7,1,5 ; ...
        nan,2,1,2,2,7,1,6 ; ...
        nan,2,1,2,2,7,1,7];
    
    TagC2 = [TagC2;DummyData];
    disp('Finished extracting Questionnaire data.')

    % reshape data, and construct final array
    disp('Reshaping data and constructing final array.')
    Output_P_11 = ReshapeFile(Procrustes_disp_11,1,1);
    Output_P_12 = ReshapeFile(Procrustes_disp_12,1,1);
    Output_P_21 = ReshapeFile(Procrustes_disp_21,1,1);
    Output_P_22 = ReshapeFile(Procrustes_disp_22,1,1);
    
    Output_S_11 = ReshapeFile(Sparc_vel_11,2,1);
    Output_S_12 = ReshapeFile(Sparc_vel_12,2,1);
    Output_S_21 = ReshapeFile(Sparc_vel_21,2,1);
    Output_S_22 = ReshapeFile(Sparc_vel_22,2,1);
    
    Output_B_11 = ReshapeFile(BowLength_disp_11,3,1);
    Output_B_12 = ReshapeFile(BowLength_disp_12,3,1);
    Output_B_21 = ReshapeFile(BowLength_disp_21,3,1);
    Output_B_22 = ReshapeFile(BowLength_disp_22,3,1);
    
    % output
    DataArray = [Output_P_11; Output_P_12; Output_P_21; Output_P_22; ...
        Output_S_11; Output_S_12; Output_S_21; Output_S_22; ...
        Output_B_11; Output_B_12; Output_B_21; Output_B_22; ...
        TagC1; TagC2];

    disp('Finished constructing data array. Writing data to disk.')
    writematrix(DataArray,[OutputPath,'/DataArray.csv'])
    
end