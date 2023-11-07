function Figure_JointAngleData(ResultAvatar,ResultParticipant)
    % JointAngleDataFig - Displays calculated joint angles of two test subjects.
    %
    % Syntax:
    %   JointAngleDataFig(ResultAvatar, ResultParticipant)
    %
    % Input:
    %   ResultAvatar - FID of avatar (participant 1)
    %   ResultParticipant - FID of student (participant 2)
    %
    % Description:
    %   This function generates a figure displaying different joint angles of
    %   two test subjects.

    L = min([length(ResultAvatar.ProcessedMocapData.ProcessedData.R.JointAngleData.Wrist.AA.Angle),...
        length(ResultParticipant.ProcessedMocapData.ProcessedData.R.JointAngleData.Wrist.AA.Angle)]);
    T = 1:L; T = T - 1; T = T/120;

    figure
    subplot(4,2,1)
    title('Wrist AA angles')
    hold on
    plot(T,ResultAvatar.ProcessedMocapData.ProcessedData.R.JointAngleData.Wrist.AA.Angle(1:L),'b')
    plot(T,ResultParticipant.ProcessedMocapData.ProcessedData.R.JointAngleData.Wrist.AA.Angle(1:L),'r')
    axis tight
    xlabel('time (s)')
    ylabel('angle (deg)')

    subplot(4,2,2)
    title('Wrist FE angles')
    hold on
    plot(T,ResultAvatar.ProcessedMocapData.ProcessedData.R.JointAngleData.Wrist.FE.Angle(1:L),'b')
    plot(T,ResultParticipant.ProcessedMocapData.ProcessedData.R.JointAngleData.Wrist.FE.Angle(1:L),'r')
    axis tight
    xlabel('time (s)')
    ylabel('angle (deg)')

    subplot(4,2,3)
    title('Elbow FE angles')
    hold on
    plot(T,ResultAvatar.ProcessedMocapData.ProcessedData.R.JointAngleData.Elbow.FE.Angle(1:L),'b')
    plot(T,ResultParticipant.ProcessedMocapData.ProcessedData.R.JointAngleData.Elbow.FE.Angle(1:L),'r')
    axis tight
    xlabel('time (s)')
    ylabel('angle (deg)')

    subplot(4,2,4)
    title('Elbow PS angles')
    hold on
    plot(T,ResultAvatar.ProcessedMocapData.ProcessedData.R.JointAngleData.Elbow.PS.Angle(1:L),'b')
    plot(T,ResultParticipant.ProcessedMocapData.ProcessedData.R.JointAngleData.Elbow.PS.Angle(1:L),'r')
    axis tight
    xlabel('time (s)')
    ylabel('angle (deg)')

    subplot(4,2,5)
    title('Shoulder AA angles')
    hold on
    plot(T,ResultAvatar.ProcessedMocapData.ProcessedData.R.JointAngleData.Shoulder.AA.Angle(1:L),'b')
    plot(T,ResultParticipant.ProcessedMocapData.ProcessedData.R.JointAngleData.Shoulder.AA.Angle(1:L),'r')
    axis tight
    xlabel('time (s)')
    ylabel('angle (deg)')

    subplot(4,2,6)
    title('Shoulder E angles')
    hold on
    plot(T,ResultAvatar.ProcessedMocapData.ProcessedData.R.JointAngleData.Shoulder.E.Angle(1:L),'b')
    plot(T,ResultParticipant.ProcessedMocapData.ProcessedData.R.JointAngleData.Shoulder.E.Angle(1:L),'r')
    axis tight
    xlabel('time (s)')
    ylabel('angle (deg)')

    subplot(4,2,7)
    title('Shoulder PS angles')
    hold on
    plot(T,ResultAvatar.ProcessedMocapData.ProcessedData.R.JointAngleData.Shoulder.PS.Angle(1:L),'b')
    plot(T,ResultParticipant.ProcessedMocapData.ProcessedData.R.JointAngleData.Shoulder.PS.Angle(1:L),'r')
    axis tight
    xlabel('time (s)')
    ylabel('angle (deg)')

    subplot(4,2,8)
    title('Bow position')
    hold on
    plot(T,ResultAvatar.ProcessedMocapData.ProcessedData.BowPositionData.DB(1:L,1),'b')
    plot(T,ResultParticipant.ProcessedMocapData.ProcessedData.BowPositionData.DB(1:L,1),'r')
    axis tight
    xlabel('time (s)')
    ylabel('position (mm)')
    
    sgtitle('Joint Angle Data')

end

