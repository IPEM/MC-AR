function Output = BatchExtractFeatures(Input, LoudnessThreshold, StrokeLength, Grad, Type)
    % BatchExtractFeatures - calculates a range of metrics comparing all signals
    % in Input with one of the signals in Input.
    %
    % Syntax:
    %   Output = BatchExtractFeatures(Input, LoudnessThreshold, StrokeLength, Grad, Type)
    %
    % Input:
    %   Input - data array of signals
    %   LoudnessThreshold - Sets the minimal loudness as a filter.
    %   StrokeLength - Sets the minimal bow stroke length as a filter.
    %   Grad - handles the first derivative of the signals if 1
    %   Type - defines the type of analysis. Type = 1, procrustes distance; Type = 2, difference in SPARC; Type = 3, difference in bowing length.
    %
    % Output:
    %   Output - data array containing the calculated differences for a certain metric, for all rois.
    %
    % Description:
    %   This function calculates a range of metrics comparing all signals
    % in Input with one of the signals in Input.

    % Extract tags from the input data
    Tags = Input(1:4, 3:end, 1);
    Tags = [Input(1, 1) * ones(1, size(Tags, 2)); Tags];
    
    % Remove the tags from the input data
    Input = Input(5:end, :, :);

    % Exclude silent parts and NaN values from the loudness signal
    LOUDNESS = Input(:, 1, 1);
    LOUDNESS = LOUDNESS - nanmin(LOUDNESS);
    LOUDNESS = LOUDNESS / nanmax(LOUDNESS);
    mLOUDNESS = nanmedian(LOUDNESS);
    LOUDNESSlimit = LoudnessThreshold * mLOUDNESS;

    FID = Input(:, 2, 1);
    dFID = diff(FID);
    
    % Find downstrokes and upstrokes
    sel2 = find(diff(sign(dFID)) + 1);
    sel21 = sel2(dFID(sel2) < 0);
    sel22 = sel2(dFID(sel2) > 0);

    seldownstrokes = [];
    for idx = 1:numel(sel21)
        ss1 = sel21(idx);
        ss2 = sel22(find(sel22>ss1,1));
        if abs(FID(ss1) - FID(ss2))>StrokeLength
            if mean(LOUDNESS(ss1:ss2))>LOUDNESSlimit
                seldownstrokes = [seldownstrokes; [ss1, ss2, mean(LOUDNESS(ss1:ss2)), abs(FID(ss1) - FID(ss2))]];
            end
        end
    end
    selupstrokes = [];
    for idx = 1:numel(sel22)
        ss1 = sel22(idx);
        ss2 = sel21(find(sel21>ss1,1));
        if abs(FID(ss1) - FID(ss2))>StrokeLength
            if mean(LOUDNESS(ss1:ss2))>LOUDNESSlimit
                selupstrokes = [selupstrokes; [ss1, ss2, mean(LOUDNESS(ss1:ss2)),abs(FID(ss1) - FID(ss2))]];
            end
        end
    end

    % Combine downstrokes and upstrokes and sort by the start time
    allstrokes = [seldownstrokes; selupstrokes];
    [~, cc] = sort(allstrokes(:, 1), 'ascend');
    allstrokes = allstrokes(cc, :);

    % Prepare inputs for analysis
    referenceFID = Input(:, 2, :);

    % Handle gradient (first derivative) if Grad is 1
    if Grad == 1
        [~, Input] = gradient(Input(:, 3:end, :));
    else
        Input = Input(:, 3:end, :);
    end

    ROIs = [];

    % Loop through blocks
    Metric = NaN(size(allstrokes, 1), size(Input, 2));

    for idx1 = 1:size(allstrokes, 1)
        DataRef = referenceFID(allstrokes(idx1, 1):allstrokes(idx1, 2), :, :);
        DataBlock = Input(allstrokes(idx1, 1):allstrokes(idx1, 2), :, :);
        
        % Prepare data for analysis and check for valid data
        tmp = [DataRef, DataBlock];
        tmp = mean(mean(tmp, 2), 3);
        sel = find(~isnan(tmp));
        selcheck = 100 * (numel(sel)) / numel(tmp);
        
        % Calculate the chosen metric for each signal
        for idx2 = 1:size(DataBlock, 2)
            if selcheck >= 90
                Metric(idx1, idx2) = ExtractFeatures(DataBlock(sel, idx2, :), DataRef(sel, 1, :), Type);
                if isnan(Metric(idx1, idx2))
                    break
                end
            else
                Metric(idx1, idx2) = NaN;
            end
            ROIs = [ROIs; allstrokes(idx1, 1:2)];
        end
    end

    % Combine tags and SparcDist
    Output = [Tags; Metric];

end