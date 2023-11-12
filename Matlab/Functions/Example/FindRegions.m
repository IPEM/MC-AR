function [ROI, seldownstrokes, selupstrokes] = FindRegions(BowingData, Spectrogram, LoudnessThreshold, StrokeLength)
    % FindRegions - Find regions of interest (ROIs) in bow position data.
    %
    % Syntax:
    %   [ROI, seldownstrokes, selupstrokes] = FindRegions(BowingData, Spectrogram, LoudnessThreshold, StrokeLength)
    %
    % Input:
    %   BowingData - Bow position data to be analyzed.
    %   Spectrogram - Spectrogram associated with the bow position data.
    %   LoudnessThreshold - Sets the minimal loudness as a filter.
    %   StrokeLength - Sets the minimal bow stroke length as a filter.
    %
    % Output:
    %   ROI - Full ROIs of the bow position data.
    %   seldownstrokes - ROIs of the downstrokes.
    %   selupstrokes - ROIs of the upstrokes.
    %
    % Description:
    %   This function finds regions of interest (ROIs) in bow position data.
    %   ROIs are determined based on specified criteria, including loudness
    %   threshold and minimal bow stroke length. The output includes the full ROIs,
    %   as well as separate ROIs for downstrokes and upstrokes.

    % Exclude silent parts and NaN values in the loudness data
    LOUDNESS = Spectrogram; LOUDNESS = LOUDNESS - nanmin(LOUDNESS); LOUDNESS = LOUDNESS/nanmax(LOUDNESS);
    mLOUDNESS = nanmedian(LOUDNESS);
    LOUDNESSlimit = (LoudnessThreshold*mLOUDNESS);
    
    FID = BowingData;
    dFID = diff(FID);
    sel2 = find(diff(sign(dFID))) + 1;
    sel21 = sel2(dFID(sel2)<0);
    sel22 = sel2(dFID(sel2)>0);

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

    allstrokes = [seldownstrokes; selupstrokes];
    [~,cc] = sort(allstrokes(:,1),'ascend');
    ROI = allstrokes(cc,:);
    
end