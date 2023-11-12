function [cm] = ExtractFeatures(P, Q, Type)
    % ExtractFeatures - Calculate a range of metrics for signal comparison.
    %
    % Syntax:
    %   [cm] = ExtractFeatures(P, Q, Type)
    %
    % Input:
    %   P - Signal 1.
    %   Q - Signal 2.
    %   Type - Defines the type of analysis. 
    %          Type = 1 for Procrustes distance.
    %          Type = 2 for difference in SPARC (Spectral Arc Length).
    %          Type = 3 for difference in bowing length.
    %
    % Output:
    %   cm - Metric describing the difference between Signal 1 and Signal 2, based on the metric defined by Type.
    %
    % Description:
    %   This function calculates a range of metrics for signal comparison.
    %
    %   The available metrics include:
    %   - Procrustes distance (Type = 1)
    %   - Difference in SPARC (Spectral Arc Length) (Type = 2)
    %   - Difference in bowing length (Type = 3)
    %
    %   Each metric provides insights into different aspects of the similarity or difference
    %   between Signal 1 and Signal 2. Users can specify the desired metric by setting the Type
    %   parameter accordingly.

    % to be tested
    xP = P(:,:,1);
    yP = P(:,:,2);
    
    % reference
    xQ = Q(:,:,1);
    yQ = Q(:,:,2);
    
    if Type == 1 
        
        sP = sqrt((sum((xP - nanmean(xP)).^2) / numel(xP)) + (sum((yP - nanmean(yP)).^2) / numel(yP)));
        sQ = sqrt((sum((xQ - nanmean(xQ)).^2) / numel(xQ)) + (sum((yQ - nanmean(yQ)).^2) / numel(yQ)));
    
        yP = (yP - nanmean(yP))/sP; yP = yP(:);
        yQ = (yQ - nanmean(yQ))/sQ; yQ = yQ(:);
        xP = (xP - nanmean(xP))/sP; xP = xP(:);
        xQ = (xQ - nanmean(xQ))/sQ; xQ = xQ(:);
    
        theta = atan2(sum(xQ.*yP - xP.*yQ), sum(xP.*xQ + yP.*yQ));
    
        xQ = cos(theta)*xQ - sin(theta)*yQ;
        yQ = sin(theta)*xQ + cos(theta)*yQ;
    
        cm = mean(sqrt((xP-xQ).^2 + (yP-yQ).^2));
            
    elseif Type == 2 
        
        cm = SparcDiff(xP, xQ, 120, 10, 4, 0.05);
       
    elseif Type == 3 
        
        xP = xP(xP > 0 & xP < 700);
        xQ = xQ(xQ > 0 & xQ < 700);
        tmp1 = (max(xP) - min(xP));
        tmp2 = (max(xQ) - min(xQ));
        cm = (tmp1 - tmp2);
       
    end

end