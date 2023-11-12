function Figure_JointAngleData(MocapDataSet1,MocapDataSet2)
    % JointAngleDataFig - Display calculated joint angles of two violinists.
    %
    % Syntax:
    %   JointAngleDataFig(MocapDataSet1, MocapDataSet2)
    %
    % Input:
    %   MocapDataSet1 - FID of violinist 1.
    %   MocapDataSet2 - FID of violinist 2.
    %
    % Description:
    %   This function generates a figure displaying different joint angles of
    %   two test violinists.
    %   The joint angles are calculated and visualized for both violinists, 
    %   providing insights into their respective movements.

    L = min([length(MocapDataSet1.ProcessedMocapData.ProcessedData.R.JointAngleData.Wrist.AA.Angle),...
        length(MocapDataSet2.ProcessedMocapData.ProcessedData.R.JointAngleData.Wrist.AA.Angle)]);
    T = 1:L; T = T - 1; T = T/120;

    figure
    subplot(4,2,1)
    title('Wrist AA angles')
    hold on
    plot(T,MocapDataSet1.ProcessedMocapData.ProcessedData.R.JointAngleData.Wrist.AA.Angle(1:L),'b')
    plot(T,MocapDataSet2.ProcessedMocapData.ProcessedData.R.JointAngleData.Wrist.AA.Angle(1:L),'r')
    axis tight
    xlabel('time (s)')
    ylabel('angle (deg)')

    subplot(4,2,2)
    title('Wrist FE angles')
    hold on
    plot(T,MocapDataSet1.ProcessedMocapData.ProcessedData.R.JointAngleData.Wrist.FE.Angle(1:L),'b')
    plot(T,MocapDataSet2.ProcessedMocapData.ProcessedData.R.JointAngleData.Wrist.FE.Angle(1:L),'r')
    axis tight
    xlabel('time (s)')
    ylabel('angle (deg)')

    subplot(4,2,3)
    title('Elbow FE angles')
    hold on
    plot(T,MocapDataSet1.ProcessedMocapData.ProcessedData.R.JointAngleData.Elbow.FE.Angle(1:L),'b')
    plot(T,MocapDataSet2.ProcessedMocapData.ProcessedData.R.JointAngleData.Elbow.FE.Angle(1:L),'r')
    axis tight
    xlabel('time (s)')
    ylabel('angle (deg)')

    subplot(4,2,4)
    title('Elbow PS angles')
    hold on
    plot(T,MocapDataSet1.ProcessedMocapData.ProcessedData.R.JointAngleData.Elbow.PS.Angle(1:L),'b')
    plot(T,MocapDataSet2.ProcessedMocapData.ProcessedData.R.JointAngleData.Elbow.PS.Angle(1:L),'r')
    axis tight
    xlabel('time (s)')
    ylabel('angle (deg)')

    subplot(4,2,5)
    title('Shoulder AA angles')
    hold on
    plot(T,MocapDataSet1.ProcessedMocapData.ProcessedData.R.JointAngleData.Shoulder.AA.Angle(1:L),'b')
    plot(T,MocapDataSet2.ProcessedMocapData.ProcessedData.R.JointAngleData.Shoulder.AA.Angle(1:L),'r')
    axis tight
    xlabel('time (s)')
    ylabel('angle (deg)')

    subplot(4,2,6)
    title('Shoulder E angles')
    hold on
    plot(T,MocapDataSet1.ProcessedMocapData.ProcessedData.R.JointAngleData.Shoulder.E.Angle(1:L),'b')
    plot(T,MocapDataSet2.ProcessedMocapData.ProcessedData.R.JointAngleData.Shoulder.E.Angle(1:L),'r')
    axis tight
    xlabel('time (s)')
    ylabel('angle (deg)')

    subplot(4,2,7)
    title('Shoulder PS angles')
    hold on
    plot(T,MocapDataSet1.ProcessedMocapData.ProcessedData.R.JointAngleData.Shoulder.PS.Angle(1:L),'b')
    plot(T,MocapDataSet2.ProcessedMocapData.ProcessedData.R.JointAngleData.Shoulder.PS.Angle(1:L),'r')
    axis tight
    xlabel('time (s)')
    ylabel('angle (deg)')

    subplot(4,2,8)
    title('Bow position')
    hold on
    plot(T,MocapDataSet1.ProcessedMocapData.ProcessedData.BowPositionData.DB(1:L,1),'b')
    plot(T,MocapDataSet2.ProcessedMocapData.ProcessedData.BowPositionData.DB(1:L,1),'r')
    axis tight
    xlabel('time (s)')
    ylabel('position (mm)')
    
    sgtitle('Joint Angle Data')

end

