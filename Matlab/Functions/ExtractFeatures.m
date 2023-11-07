function [cm] = ExtractFeatures(P, Q, Type)
    % ExtractFeatures - calculates a range of metrics for signal comparison.
    %
    % Syntax:
    %   [cm] = ExtractFeatures(P, Q, Type)
    %
    % Input:
    %   P - signal 1
    %   Q - signal 2
    %   Type - defines the type of analysis. Type = 1, procrustes distance; Type = 2, difference in SPARC; Type = 3, difference in bowing length.
    %
    % Output:
    %   cm - metric describing the difference between signal 1 and signal 2, based on the metric defined by Type
    %
    % Description:
    %   This function calculates a range of metrics for signal comparison.

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