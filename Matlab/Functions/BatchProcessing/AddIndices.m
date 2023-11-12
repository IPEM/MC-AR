function QData = AddIndices(QData,Output_P_11,Output_P_12,Output_P_21,Output_P_22)
    % AddIndices - Add indices to the questionnaire data, based on
    % the data structure of the FID arrays.
    %
    % Syntax:
    %   QData = AddIndices(QData, Output_P_11, Output_P_12, Output_P_21, Output_P_22)
    %
    % Input:
    %   QData - Data array containing questionnaire data.
    %   Output_P_11 - Data array to retrieve index structure.
    %   Output_P_12 - Data array to retrieve index structure.
    %   Output_P_21 - Data array to retrieve index structure.
    %   Output_P_22 - Data array to retrieve index structure.
    %
    % Output:
    %   QData - Data array for further analysis.
    %
    % Description:
    %   This function adds missing indices to the questionnaire data, in
    %   order for these data to be passed on to the R scripts.

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

end

