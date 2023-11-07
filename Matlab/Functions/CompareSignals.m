function Output = CompareSignals(AvatarData, ParticipantData, ROI, Grad, Type)
    % CompareSignals - calculates a range of metrics comparing two signals
    % of two different participants, given a ROI is provided.
    %
    % Syntax:
    %   Output = CompareSignals(AvatarData, ParticipantData, ROI, Grad, Type)
    %
    % Input:
    %   AvatarData - FID of avatar (participant 1)
    %   ParticipantData - FID of participant (participant 2)
    %   Grad - handles the first derivative of the input signals AvatarData and ParticipantData
    %   Type - defines the type of analysis. Type = 1, procrustes distance; Type = 2, difference in SPARC; Type = 3, difference in bowing length.
    %
    % Output:
    %   Output - data array containing the calculated differences for a certain metric, for all ROIs.
    %
    % Description:
    %   This function calculates a range of metrics comparing two signals
    %   of two different participants, given a ROI is provided.

    % Handle gradient (grad) if specified
    if Grad == 1
        AvatarData = [diff(AvatarData); [0, 0]];
        ParticipantData = [diff(ParticipantData); [0, 0]];
    end
    
    % Reshape data to include dimensions for different features
    AvatarData = permute(AvatarData, [1, 3, 2]);
    ParticipantData = permute(ParticipantData, [1, 3, 2]);

    ROIs = [];
    
    % Loop through ROIs
    for idx1 = 1:size(ROI, 1)
        
        DataRef = AvatarData(ROI(idx1, 1):ROI(idx1, 2), :, :);
        DataBlock = ParticipantData(ROI(idx1, 1):ROI(idx1, 2), :, :);
        
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