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

    %% Extract questionnaire data (PQ, MPQS, MPQP, Difficulty) 
    disp('Extracting Questionnaire data.')
    C1 = dir([DataFolderPath,'/**/C1.csv']);
    C1 = ImportFile(fullfile(C1.folder,C1.name));
    C2 = dir([DataFolderPath,'/**/C2.csv']);
    C2 = ImportFile(fullfile(C2.folder,C2.name));
    
    MPQP_C1 = table2array(mean(C1(:,17:21),2)); 
    Tag = [nan(length(MPQP_C1),2),ones(length(MPQP_C1),1),C1.session,C1.participant,ones(length(MPQP_C1),1),6*ones(length(MPQP_C1),1)];
    MPQP_C1 = [MPQP_C1,Tag];

    MPQS_C1 = table2array(mean(C1(:,22:26),2)); 
    Tag = [nan(length(MPQP_C1),2),ones(length(MPQP_C1),1),C1.session,C1.participant,ones(length(MPQP_C1),1),5*ones(length(MPQP_C1),1)];
    MPQS_C1 = [MPQS_C1,Tag];

    PQ_C1 = table2array(mean(C1(:,27:53),2)); 
    Tag = [nan(length(MPQP_C1),2),ones(length(MPQP_C1),1),C1.session,C1.participant,ones(length(MPQP_C1),1),4*ones(length(MPQP_C1),1)];
    PQ_C1 = [PQ_C1,Tag];

    Difficulty_P1 = table2array(C1(:,65));
    Tag = [nan(length(MPQP_C1),1),ones(length(MPQP_C1),1),nan(length(MPQP_C1),1),C1.session,C1.participant,ones(length(MPQP_C1),1),7*ones(length(MPQP_C1),1)];
    Difficulty_P1 = [Difficulty_P1,Tag];

    DummyData = [nan,nan,nan,1,2,7,1,4 ; ...
        nan,nan,nan,1,2,7,1,5 ; ...
        nan,nan,nan,1,2,7,1,6 ; ...
        nan,nan,1,nan,2,7,1,7];

    QData_1 = [MPQP_C1; MPQS_C1; PQ_C1; Difficulty_P1; DummyData]; 

    %%
    MPQP_C2 = table2array(mean(C2(:,17:21),2)); 
    Tag = [nan(length(MPQP_C2),2),2*ones(length(MPQP_C2),1),C2.session,C2.participant,ones(length(MPQP_C2),1),6*ones(length(MPQP_C2),1)];
    MPQP_C2 = [MPQP_C2,Tag];

    MPQS_C2 = table2array(mean(C2(:,22:26),2)); 
    Tag = [nan(length(MPQP_C2),2),2*ones(length(MPQP_C2),1),C2.session,C2.participant,ones(length(MPQP_C2),1),5*ones(length(MPQP_C2),1)];
    MPQS_C2 = [MPQS_C2,Tag];

    PQ_C2 = table2array(mean(C2(:,27:53),2)); 
    Tag = [nan(length(MPQP_C2),2),2*ones(length(MPQP_C2),1),C2.session,C2.participant,ones(length(MPQP_C2),1),4*ones(length(MPQP_C2),1)];
    PQ_C2 = [PQ_C2,Tag];

    Difficulty_P2 = table2array(C2(:,66));
    Tag = [nan(length(MPQP_C2),1),2*ones(length(MPQP_C2),1),nan(length(MPQP_C2),1),C2.session,C2.participant,ones(length(MPQP_C2),1),7*ones(length(MPQP_C2),1)];
    Difficulty_P2 = [Difficulty_P2,Tag];

    DummyData = [nan,nan,nan,2,2,7,1,4 ; ...
        nan,nan,nan,2,2,7,1,5 ; ...
        nan,nan,nan,2,2,7,1,6 ; ...
        nan,nan,2,nan,2,7,1,7];

    QData_2 = [MPQP_C2; MPQS_C2; PQ_C2; Difficulty_P2; DummyData]; 

    QData = [QData_1;QData_2];

    %%

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
    
    %% retrieve some missing indeces (ugly)

    tmp = [Output_P_11;Output_P_12;Output_P_21;Output_P_22];
    tmp0 = [];
    for idx = 1:11
        sel = find(tmp(:,6)==idx & (tmp(:,5)==1 & tmp(:,4)==1));
        tmp0(idx,:,1) = median(tmp(sel,2:4));
        sel = find(tmp(:,6)==idx & (tmp(:,5)==1 & tmp(:,4)==2));
        tmp0(idx,:,2) = median(tmp(sel,2:4));
    end

    for idx = 1:size(QData,1)

        cc1 = QData(idx,6);
        cc2 = find(squeeze(nansum((QData(idx,2:4) - tmp0(cc1,:,:))))==0);
        QData(idx,2:4) = squeeze(tmp0(cc1,:,cc2));
        
    end

    %% output
    DataArray = [Output_P_11; Output_P_12; Output_P_21; Output_P_22; ...
        Output_S_11; Output_S_12; Output_S_21; Output_S_22; ...
        Output_B_11; Output_B_12; Output_B_21; Output_B_22; ...
        QData];

    disp('Finished constructing data array. Writing data to disk.')
    writematrix(DataArray,[OutputPath,'/DataArray.csv'])
     
end