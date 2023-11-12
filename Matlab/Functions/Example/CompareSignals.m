function Output = CompareSignals(MocapDataSet1, MocapDataSet2, ROI, Grad, Type)
    % CompareSignals - Calculate a range of metrics comparing two signals
    % of two different violinists, given an ROI is provided.
    %
    % Syntax:
    %   Output = CompareSignals(MocapDataSet1, MocapDataSet2, ROI, Grad, Type)
    %
    % Input:
    %   MocapDataSet1 - FID of violinist 1.
    %   MocapDataSet2 - FID of violinist 2.
    %   Grad - Handles the first derivative of the input signals MocapDataSet1 and MocapDataSet2.
    %   Type - Defines the type of analysis.
    %          Type = 1 for Procrustes distance.
    %          Type = 2 for difference in SPARC (Spectral Arc Length).
    %          Type = 3 for difference in bowing length.
    %
    % Output:
    %   Output - Data array containing the calculated differences for a certain metric for all ROIs.
    %
    % Description:
    %   This function calculates a range of metrics comparing two signals
    %   of two different violinists, given an ROI is provided.
    %
    %   The available metrics include:
    %   - Procrustes distance (Type = 1)
    %   - Difference in SPARC (Spectral Arc Length) (Type = 2)
    %   - Difference in bowing length (Type = 3)
    %
    %   The output contains the calculated differences for the specified metric
    %   for all regions of interest (ROIs).

    % Handle gradient (grad) if specified
    if Grad == 1
        MocapDataSet1 = [diff(MocapDataSet1); [0, 0]];
        MocapDataSet2 = [diff(MocapDataSet2); [0, 0]];
    end
    
    % Reshape data to include dimensions for different features
    MocapDataSet1 = permute(MocapDataSet1, [1, 3, 2]);
    MocapDataSet2 = permute(MocapDataSet2, [1, 3, 2]);

    ROIs = [];
    
    % Loop through ROIs
    for idx1 = 1:size(ROI, 1)
        
        DataRef = MocapDataSet1(ROI(idx1, 1):ROI(idx1, 2), :, :);
        DataBlock = MocapDataSet2(ROI(idx1, 1):ROI(idx1, 2), :, :);
        
        % Combine reference and block data for analysis
        tmp = [DataRef, DataBlock];
        tmp = mean(mean(tmp, 2), 3);
        sel = find(~isnan(tmp));
        selcheck = 100 * (numel(sel)) / numel(tmp);
        
        % Calculate the specified metric for each feature
        for idx2 = 1:size(DataBlock, 2) 
            
            if selcheck >= 90
                
                Metric(idx1, idx2) = ExtractFeatures(DataBlock(sel, idx2, :), DataRef(sel, 1, :), Type); 
                
                if isnan(Metric(idx1, idx2))
                    break
                end
         
            else
                Metric(idx1, idx2) = nan;
            end

            % Keep track of ROIs
            ROIs = [ROIs; ROI(idx1, 1:2)];
        end
              
    end

    % Combine the calculated metrics and ROIs into the output
    Output = [Metric, ROIs];

end