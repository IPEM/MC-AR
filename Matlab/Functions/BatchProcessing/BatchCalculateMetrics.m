function DataArray = BatchCalculateMetrics(DataFolderPath,OutputPath)
    % BatchCalculateMetrics - Generate an array containing all the necessary data points.
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
    
    % Extract FIDs from MoCap data
    [DataF1,DataF2,DataF3,DataF4] = BatchExtractFIDs(DataFolderPath);

    % Extract features (SPARC, Procrustes distance and Bowing length) from FIDs
    disp('Starting post-processing of MoCap data.')
    
    LoudnessThreshold = 0.15;
    StrokeLength = 150;

    Grad = 0; Type = 1;
    Procrustes_disp_11 = BatchExtractFeatures(DataF1,LoudnessThreshold,StrokeLength,Grad,Type);
    Procrustes_disp_12 = BatchExtractFeatures(DataF2,LoudnessThreshold,StrokeLength,Grad,Type);
    Procrustes_disp_21 = BatchExtractFeatures(DataF3,LoudnessThreshold,StrokeLength,Grad,Type);
    Procrustes_disp_22 = BatchExtractFeatures(DataF4,LoudnessThreshold,StrokeLength,Grad,Type);
    
    Grad = 1; Type = 2;
    Sparc_vel_11 = BatchExtractFeatures(DataF1,LoudnessThreshold,StrokeLength,Grad,Type);
    Sparc_vel_12 = BatchExtractFeatures(DataF2,LoudnessThreshold,StrokeLength,Grad,Type);
    Sparc_vel_21 = BatchExtractFeatures(DataF3,LoudnessThreshold,StrokeLength,Grad,Type);
    Sparc_vel_22 = BatchExtractFeatures(DataF4,LoudnessThreshold,StrokeLength,Grad,Type);
    
    Grad = 0; Type = 3;
    BowLength_disp_11 = BatchExtractFeatures(DataF1,LoudnessThreshold,StrokeLength,Grad,Type);
    BowLength_disp_12 = BatchExtractFeatures(DataF2,LoudnessThreshold,StrokeLength,Grad,Type);
    BowLength_disp_21 = BatchExtractFeatures(DataF3,LoudnessThreshold,StrokeLength,Grad,Type);
    BowLength_disp_22 = BatchExtractFeatures(DataF4,LoudnessThreshold,StrokeLength,Grad,Type);  

    % Extract questionnaire data (PQ, MPQS, MPQP, Difficulty) 
    QData = BatchExtractQs(DataFolderPath);
    
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
    
    % add indices to questionnaire data
    QData = AddIndices(QData,Output_P_11,Output_P_12,Output_P_21,Output_P_22);

    % generate output
    DataArray = [Output_P_11; Output_P_12; Output_P_21; Output_P_22; ...
        Output_S_11; Output_S_12; Output_S_21; Output_S_22; ...
        Output_B_11; Output_B_12; Output_B_21; Output_B_22; ...
        QData];

    disp('Finished constructing data array. Writing data to disk.')
    writematrix(DataArray,[OutputPath,'/DataArray.csv'])
     
end