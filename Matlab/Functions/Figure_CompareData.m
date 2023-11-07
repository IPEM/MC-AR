function Figure_CompareData(ResultAvatar, ResultParticipant, ROI, sel1, sel2, PD, dSparc, BL)
    % CompareDataFig - illustrates a range of metrics comparing two signals
    % of two different participants
    %
    % Syntax:
    %   CompareDataFig(BowAvatar1, BowParticipant1, ROI, sel1, sel2, PD, dSparc, BL)
    %
    % Input:
    %   ResultAvatar - analyzed mocap data of avatar (participant 1)
    %   ResultParticipant - analyzed mocap data  of participant (participant 2)
    %   ROI - ROIs
    %   sel1 - ROIs of upstrokes
    %   sel2 - ROIs of downstrokes
    %   PD - Procrustes distance
    %   dSparc - Difference in SPARC
    %   BL - Difference in bowing length.
    %
    % Description:
    %   This function illustrates a range of metrics comparing two signals
    %   of two different participants.
    
    % Truncate BowAvatar1 and BowParticipant1 to the minimum length
    BowAvatar1 = ResultAvatar.ProcessedMocapData.ProcessedData.BowPositionData.DB(:,1);
    BowParticipant1 = ResultParticipant.ProcessedMocapData.ProcessedData.BowPositionData.DB(:,1);

    % Calculate the minimum length between BowAvatar1 and BowParticipant1
    L = min([length(BowAvatar1), length(BowParticipant1)]);
    
    % Create a time vector T from 0 to (L-1)/120 at intervals of 1/120
    T = 1:L; 
    T = T - 1; 
    T = T / 120;

    BowAvatar1 = BowAvatar1(1:L);
    BowParticipant1 = BowParticipant1(1:L);
    
    % Create a new figure
    figure
    
    % First subplot: Data series for Bow Avatar 1 and Bow Participant 1
    subplot(4, 1, 1)
    title('Bow position')
    hold on
    plot(T, BowAvatar1, 'b')
    plot(T, BowParticipant1, 'r')
    xlabel('time (s)')
    ylabel('position (mm)')

    % Indicate analyzed regions in the plot
    for idx = 1:size(sel1, 1)
        plot(T(sel1(idx, 1):sel1(idx, 2)), BowAvatar1(sel1(idx, 1):sel1(idx, 2)), 'b-', 'LineWidth', 2)
    end
    for idx = 1:size(sel2, 1)
        plot(T(sel2(idx, 1):sel2(idx, 2)), BowAvatar1(sel2(idx, 1):sel2(idx, 2)), 'b-', 'LineWidth', 2)
    end
    
    for idx = 1:size(sel1, 1)
        plot(T(sel1(idx, 1):sel1(idx, 2)), BowParticipant1(sel1(idx, 1):sel1(idx, 2)), 'r-', 'LineWidth', 2)
    end
    for idx = 1:size(sel2, 1)
        plot(T(sel2(idx, 1):sel2(idx, 2)), BowParticipant1(sel2(idx, 1):sel2(idx, 2)), 'r-', 'LineWidth', 2)
    end
    
    % Set the x-axis limits for the plot
    ylim([0, 800])
    xlim([min(T), max(T)])
    
    % Second subplot: Indicate PD (Procrustes distance) data
    subplot(4, 1, 2)
    title('Procrustes Distance (PD)')
    hold on
    for idx = 1:size(ROI, 1)
        plot(T(ROI(idx, 1):ROI(idx, 2)), PD(idx, 1) * ones(size(ROI(idx, 1):ROI(idx, 2))), 'g-*', 'LineWidth', 1)
    end
    xlabel('time (s)')
    ylabel({'PD (au)'})

    % Set the x-axis limits for the plot
    axis tight
    xlim([min(T), max(T)])
    
    % Third subplot: Indicate dSparc data
    subplot(4, 1, 3)
    title('Difference Sparc index (dSI)')
    hold on
    for idx = 1:size(ROI, 1)
        plot(T(ROI(idx, 1):ROI(idx, 2)), dSparc(idx, 1) * ones(size(ROI(idx, 1):ROI(idx, 2))), 'g-*', 'LineWidth', 1)
    end
    xlabel('time (s)')
    ylabel({'dSI (au)'})

    % Set the x-axis limits for the plot
    axis tight
    xlim([min(T), max(T)])
    
    % Fourth subplot: Indicate bow length data
    subplot(4, 1, 4)
    title('Difference Bowing Length (dBL)')
    hold on
    for idx = 1:size(ROI, 1)
        plot(T(ROI(idx, 1):ROI(idx, 2)), BL(idx, 1) * ones(size(ROI(idx, 1):ROI(idx, 2))), 'g-*', 'LineWidth', 1)
    end
    xlabel('time (s)')
    ylabel({'dBL (mm)'})
    
    % Set the x-axis limits for the plot
    axis tight
    xlim([min(T), max(T)])
    
    sgtitle('Compare Signals')

end