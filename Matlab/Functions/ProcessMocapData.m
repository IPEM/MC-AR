classdef ProcessMocapData
    properties
        PathToMocapFile = [];
        PathToAudioFile = [];
        Parameters = [];
        ProcessedMocapData = [];
        Warnings = [];
        StartDist = 175;
        SyncedMocapData = [];
        SyncedAudio = [];
    end

    methods

        function obj = ProcessMocapData(PathToMocapFile,PathToAudioFile)
            obj.PathToMocapFile = PathToMocapFile;
            data = readtable(PathToMocapFile);
            labels = data.Properties.VariableNames(1:3:end);
            labels = erase(labels,'X_');
            data = table2array(data);
            obj.SyncedMocapData.data = data;
            obj.SyncedMocapData.markerName = labels;

            if nargin == 2
                obj.PathToAudioFile = PathToAudioFile;
                [y,~] = audioread(PathToAudioFile);
                obj.SyncedAudio.LeftMic = y(:,1);
                obj.SyncedAudio.RightMic = y(:,2);
            end

            warning('off')

        end
        
        function obj = PreProcessData(obj)
            obj.Parameters.sides = [{'L'},{'R'}];
            obj.Parameters.Fs = 120;
            markernames = obj.SyncedMocapData.markerName;
            originaldata = obj.SyncedMocapData.data;
            obj.ProcessedMocapData.OriginalData.MarkerNames = markernames;
            obj.ProcessedMocapData.OriginalData.Data = originaldata;
            obj = StabilizeData(obj);
        end

        function obj = ProcessData(obj)
            temp = obj.ProcessedMocapData.StabilizedData;
            for iii = 1:numel(obj.Parameters.sides)
                extra = GetMarkerData(obj,temp,obj.Parameters.sides{iii});
                [jointangledata,~] = CalculateJointAngles(obj,temp,obj.Parameters.sides{iii}); 
                obj.ProcessedMocapData.ProcessedData.(obj.Parameters.sides{iii}).JointAngleData = jointangledata;
                obj.ProcessedMocapData.ProcessedData.(obj.Parameters.sides{iii}).Extra = extra;
            end
            obj.ProcessedMocapData.ProcessedData.BowPositionData = CalculateBowPosition(obj,temp);
        end

    end

    methods (Access = protected)

        function obj = StabilizeData(obj)
            temp = obj.ProcessedMocapData.OriginalData;
            data_stabilized_R = temp.Data;
            data_stabilized_L = temp.Data;
            [Ot,Xt,Yt,Zt,sentinel] = JCS_thorax(obj,temp,obj.Parameters.sides{2});
            obj.ProcessedMocapData.Sentinel = sentinel;
            if sum(~isnan(Ot(:))) > 0
                TM = -Ot; % translation, center dataset around origin Ot.
                for index = 1:size(temp.Data,1)
                    lst1 = [Xt(index,:);...
                        Yt(index,:);...
                        Zt(index,:)];
                    lst2 = [norm(Xt(index,:)) 0 0;...
                        0 norm(Yt(index,:)) 0;...
                        0 0 norm(Zt(index,:))];
                    M=[0 0 0; ...
                        0 0 0; ...
                        0 0 0];
                    outerproduct = zeros(size(lst1,2),size(lst2,2));
                    for index2 = 1:size(lst1,1)
                        x = lst1(index2,:);
                        y = lst2(index2,:);
                        for i1=1:length(x)
                            for i2=1:length(y)
                                outerproduct(i1,i2) = x(i1)*y(i2);
                            end
                        end
                        M = M + outerproduct;
                    end
                    N11 = M(1,1) + M(2,2) + M(3,3);
                    N22 = M(1,1) - M(2,2) - M(3,3);
                    N33 = -M(1,1) + M(2,2) - M(3,3);
                    N44 = -M(1,1) - M(2,2) + M(3,3);
                    N12 = M(2,3) - M(3,2);
                    N13 = M(3,1) - M(1,3);
                    N14 = M(1,2) - M(2,1);
                    N21 = N12;
                    N23 = M(1,2) + M(2,1);
                    N24 = M(1,3) + M(3,1);
                    N31 = N13;
                    N32 = N23;
                    N34 = M(3,2) + M(2,3);
                    N41 = N14;
                    N42 = N24;
                    N43 = N34;
                    N=[N11,N12,N13,N14; ...
                        N21,N22,N23,N24; ...
                        N31,N32,N33,N34; ...
                        N41,N42,N43,N44];
                    N(isinf(N)|isnan(N)) = 0;
                    [V,~,~] = eig(N);
                    D = eig(N);
                    [~,c]=max(D);
                    temp_ = rotatepoint(quaternion(V(:,c)'),[temp.Data(index,1:3:end)'+TM(index,1),temp.Data(index,2:3:end)'+TM(index,2),temp.Data(index,3:3:end)'+TM(index,3)]);
                    offset = 10000; % cheapo way to make sure everything is in the right quadrant
                    data_stabilized_R(index,1:3:end) = temp_(:,1)' + offset;
                    data_stabilized_R(index,2:3:end) = temp_(:,3)' + offset;
                    data_stabilized_R(index,3:3:end) = temp_(:,2)' + offset;
                    data_stabilized_L(index,1:3:end) = temp_(:,1)' + offset;
                    data_stabilized_L(index,2:3:end) = -temp_(:,3)' + offset;
                    data_stabilized_L(index,3:3:end) = temp_(:,2)' + offset;
                end
                temp.Data = [];
                temp.Data(:,:,1) = data_stabilized_R;
                temp.Data(:,:,2) = data_stabilized_L;
                obj.ProcessedMocapData.StabilizedData = temp;
            end
        end

        function [Oout,Xout,Yout,Zout,sentinel] = JCS_thorax(obj,temp,side)
            MarkerData = GetMarkerData(obj,temp,side);
            Oout = MarkerData.IJ;
            Yt1 = (MarkerData.T8 + MarkerData.PX)/2;
            Yt2 = (Oout + MarkerData.C7)/2;
            Yout = Yt2-Yt1;
            Yout = 100*Yout./vecnorm(Yout,2,2);
            Zout = cross(MarkerData.IJ-Yt1,MarkerData.C7-Yt1);
            Zout = 100*Zout./vecnorm(Zout,2,2);
            Xout = cross(Yt2-Yt1,Zout);
            Xout = 100*Xout./vecnorm(Xout,2,2);
            sentinel = ones(1,size(Oout,1));
            sentinel(isinf(sum(sum([Oout,Xout,Yout,Zout],2),2))|isnan(sum(sum([Oout,Xout,Yout,Zout],2),2))) = 0;
        end

        function [GH, residuals] = LocateShoulder(obj,temp,side)
            MarkerData = GetMarkerData(obj,temp,side);
            HX = MarkerData.H(:,1);
            HY = MarkerData.H(:,2);
            HZ = MarkerData.H(:,3);
            cc = find(~isnan(sum(HX+HY+HZ,2)));
            HX = HX(cc,:);
            HY = HY(cc,:);
            HZ = HZ(cc,:);
            nPoint = size(HX,2);
            nFrame = size(HX,1);
            MPM = [HX(:), HY(:), HZ(:)];
            A = cat(2, 2 .* MPM, zeros(nFrame * nPoint, nPoint));
            for iN = 1:nPoint
              A(((iN - 1) * nFrame + 1):(iN * nFrame), 3 + iN) = 1;
            end
            b = sum(MPM .* MPM, 2);
            x = A \ b;
            GH = transpose(x(1:3));
            residuals = A * x - b;
            residuals = mean(abs(residuals));
        end

        function [Oout,Xout,Yout,Zout] = JCS_humerus(obj,temp,side)
            [MarkerData] = GetMarkerData(obj,temp,side);
            [GH, ~] = LocateShoulder(obj,temp,side); % could also be added as an input
            [~,~,Yf,~] = JCS_forearm(obj,temp,side);
            Oout = repmat(GH,size(MarkerData.US,1),1);
            Yout = GH - MarkerData.EL;
            Yout = 100*Yout./vecnorm(Yout,2,2);
            Zout = cross(-Yout,Yf); % sign convention?
            Zout = 100*Zout./vecnorm(Zout,2,2);
            Xout = cross(Zout,Yout); % sign convention?
            Xout = 100*Xout./vecnorm(Xout,2,2);
        end

        function [Oout,Xout,Yout,Zout] = JCS_forearm(obj,temp,side)
            [MarkerData] = GetMarkerData(obj,temp,side);
            Yout = MarkerData.EL - MarkerData.US;
            Yout = 100*Yout./vecnorm(Yout,2,2);
            Oout = MarkerData.US;
            Xout = cross(-MarkerData.US+MarkerData.EL, MarkerData.US-MarkerData.RS); % ***
            Xout = 100*Xout./vecnorm(Xout,2,2);
            Zout = cross(Yout,Xout);
            Zout = 100*Zout./vecnorm(Zout,2,2);
        end

        function [Oout,Xout,Yout,Zout] = JCS_radius(obj,temp,side)
            [MarkerData] = GetMarkerData(obj,temp,side);
            Oout = (MarkerData.US + MarkerData.RS)/2;
            Yout = MarkerData.EL-Oout; % more or less following the ISB
            Yout = 100*Yout./vecnorm(Yout,2,2);
            Xout = cross(MarkerData.US-MarkerData.EL,MarkerData.RS-MarkerData.EL);
            Xout = 100*Xout./vecnorm(Xout,2,2);
            Zout = cross(Yout,Xout);
            Zout = 100*Zout./vecnorm(Zout,2,2);
        end

        function [Oout,Xout,Yout,Zout] = JCS_metacarpal(obj,temp,side)
            [MarkerData] = GetMarkerData(obj,temp,side);
            Oout = MarkerData.MC;
            Yout = MarkerData.RS - Oout; % more or less following the ISB
            Yout = 100*Yout./vecnorm(Yout,2,2);
            Xout = cross(Yout, MarkerData.US - Oout);
            Xout = 100*Xout./vecnorm(Xout,2,2);
            Zout = cross(Xout,Yout);
            Zout = 100*Zout./vecnorm(Zout,2,2);
        end

        function [Oout,Xout,Yout,Zout] = JCS_tibialfibula(obj,temp,side)
            [MarkerData] = GetMarkerData(obj,temp,side);
            IM = (MarkerData.MM+MarkerData.LM)/2;
            IC = (MarkerData.LC+MarkerData.MCk)/2;
            Oout = IM;
            Yout = IC - IM;
            Zout = cross(Yout, MarkerData.LC - MarkerData.MCk);
            Xout = cross(Yout,-Zout);
            Xout = 100*Xout./vecnorm(Xout,2,2);
            Yout = 100*Yout./vecnorm(Yout,2,2);
            Zout = 100*Zout./vecnorm(Zout,2,2);
        end

        function [Oout,Xout,Yout,Zout] = JCS_calcaneus(obj,temp,side)
            [MarkerData] = GetMarkerData(obj,temp,side);
            IM = (MarkerData.MM+MarkerData.LM)/2;
            Oout = IM;
            IT = mean(cat(3,MarkerData.FFo,MarkerData.FFi,MarkerData.TT),3,"omitnan");
            Xout = IT - Oout;
            Yout = cross(Xout, MarkerData.LM - MarkerData.MM);
            Zout = cross(-Xout,Yout);
            Xout = 100*Xout./vecnorm(Xout,2,2);
            Yout = 100*Yout./vecnorm(Yout,2,2);
            Zout = 100*Zout./vecnorm(Zout,2,2);
        end

        function [Oout,Xout,Yout,Zout] = JCS_femur(obj,temp,side)
            [MarkerData] = GetMarkerData(obj,temp,side);
            Oout = MarkerData.MCk;
            Yout = MarkerData.T - Oout;
            Yout = 100*Yout./vecnorm(Yout,2,2);
            Xout = nan(size(Yout));
            Zout = nan(size(Yout));
        end

        function [Oout,Xout,Yout,Zout] = JCS_hips(obj,temp,side)
            [MarkerData] = GetMarkerData(obj,temp,side);
            if strcmpi(side,'R') == 1
                Oout = (MarkerData.ASIS_R + MarkerData.PSIS_R)/2;
                Zout = MarkerData.ASIS_R - MarkerData.ASIS_L;
                MS = MarkerData.ASIS_R - (MarkerData.PSIS_R + MarkerData.PSIS_L)/2;
                proj_MS_Zout = dot(MS,Zout,2)./vecnorm(Zout,2,2) .* Zout./vecnorm(Zout,2,2);
                Xout = MS - proj_MS_Zout;
                Yout = cross(-Zout,Xout);
                Xout = 100*Xout./vecnorm(Xout,2,2);
                Yout = 100*Yout./vecnorm(Yout,2,2);
                Zout = 100*Zout./vecnorm(Zout,2,2);
            elseif strcmpi(side,'L') == 1
                Oout = (MarkerData.ASIS_L + MarkerData.PSIS_L)/2;
                Zout = MarkerData.ASIS_L - MarkerData.ASIS_R;
                MS = MarkerData.ASIS_L - (MarkerData.PSIS_R + MarkerData.PSIS_L)/2;
                proj_MS_Zout = dot(MS,Zout,2)./vecnorm(Zout,2,2) .* Zout./vecnorm(Zout,2,2);
                Xout = MS - proj_MS_Zout;
                Yout = cross(-Zout,Xout);
                Xout = 100*Xout./vecnorm(Xout,2,2);
                Yout = 100*Yout./vecnorm(Yout,2,2);
                Zout = 100*Zout./vecnorm(Zout,2,2);
            else
                error('Please indicate if you want to analyze the right side (side argument = ''R'') or the left side (side argument = ''L'')')
            end
        end

        function [Oout,Xout,Yout,Zout] = JCS_neck(obj,temp,side)
            [MarkerData] = GetMarkerData(obj,temp,side);
            Oout = MarkerData.C7;
            Yout = MarkerData.HT - Oout;
            Zout = MarkerData.HR - MarkerData.HL;
            Xout = cross(Yout,Zout);
            Xout = 100*Xout./vecnorm(Xout,2,2);
            Yout = 100*Yout./vecnorm(Yout,2,2);
            Zout = 100*Zout./vecnorm(Zout,2,2);
        end

        function [Oout,Xout,Yout,Zout] = JCS_violin(obj,temp,side)
            [InstrumentData] = GetMarkerData(obj,temp,side);
            [MarkerData] = GetMarkerData(obj,temp,side);
            k1 = zeros(1,size(InstrumentData.Violin,3));
            for index = 1:size(InstrumentData.Violin,3)
                 k1(index) = median(sqrt(sum((InstrumentData.Violin(:,:,index) - MarkerData.RST).^2,2)),"omitnan");
            end
            [~,c1] = sort(k1,'ascend');
            k2 = zeros(1,size(InstrumentData.Violin,3));
            for index = 1:size(InstrumentData.Violin,3)
                k2(index) = median(sqrt(sum((InstrumentData.Violin(:,:,index) - MarkerData.LST).^2,2)),"omitnan");
            end
            % [~,c2] = sort(k2,'ascend');
            P1 = squeeze(InstrumentData.Violin(:,:,c1(1)));
            P2 = squeeze(InstrumentData.Violin(:,:,c1(2)));
            if size(InstrumentData.Violin,3) == 3
                c3 = setdiff([1 2 3], [c1(1), c1(2)]);
                P3 = squeeze(InstrumentData.Violin(:,:,c3));
            elseif size(InstrumentData.Violin,3) == 4
                c3 = setdiff([1 2 3 4], [c1(1), c1(2)]);
                P3 = squeeze(sum(InstrumentData.Violin(:,:,c3),3)/2);
            end
            Oout = (P1 + P2)/2;
            Yout = P3 - Oout; % longitudinal axis
            Xout = P1 - P2; % transversal axis
            Zout = cross(Xout,Yout); % normal of plane define by above
            Xout = 100*Xout./vecnorm(Xout,2,2);
            Yout = 100*Yout./vecnorm(Yout,2,2);
            Zout = 100*Zout./vecnorm(Zout,2,2);
        end

        function [Oout,Xout,Yout,Zout] = JCS_bow(obj,temp,side)
            [InstrumentData] = GetMarkerData(obj,temp,side);
            [MarkerData] = GetMarkerData(obj,temp,side);
            k1 = zeros(1,size(InstrumentData.Bow,3));
            for index = 1:size(InstrumentData.Bow,3)
                k1(index) = median(sqrt(sum((InstrumentData.Bow(:,:,index) - MarkerData.RWO).^2,2)),"omitnan");
            end
            [~,c1] = sort(k1,'ascend');
            P1 = squeeze(InstrumentData.Bow(:,:,c1(1)));
            P3 = squeeze(InstrumentData.Bow(:,:,c1(3)));
            Yout = P3 - P1;
            Oout = nan(size(Yout));
            Xout = nan(size(Yout));
            Zout = nan(size(Yout));
        end

        function MarkerData = GetMarkerData(obj,temp,side)
            MarkerNames = {'All'}; MarkerData.XYZ = GetMarkerDataColumns(obj,MarkerNames,temp,side);
            MarkerNames = ({'Chest'}); MarkerData.IJ = GetMarkerDataColumns(obj,MarkerNames,temp,side);
            MarkerNames = ({'WaistLBack', 'WaistRBack'}); T8 = GetMarkerDataColumns(obj,MarkerNames,temp,side,'mean');
            MarkerNames = ({'BackL', 'BackR'}); T8 = cat(3,T8,GetMarkerDataColumns(obj,MarkerNames,temp,side,'mean'));
            MarkerNames = ({'SpineTop','SpineThoracic2'}); T8 = cat(3,T8,GetMarkerDataColumns(obj,MarkerNames,temp,side)); MarkerData.T8 = mean(T8,3,"omitnan");
            MarkerNames = ({'Chest','WaistLFront','WaistRFront'}); MarkerData.PX = GetMarkerDataColumns(obj,MarkerNames,temp,side,'nanmean');
            MarkerNames = ({'SpineTop','SpineThoracic2'}); MarkerData.C7 = GetMarkerDataColumns(obj,MarkerNames,temp,side);
            MarkerNames = strcat(side,{'ElbowOut'}); MarkerData.EL = GetMarkerDataColumns(obj,MarkerNames,temp,side);
            MarkerNames = strcat(side,{'ElbowIn'}); MarkerData.EM = GetMarkerDataColumns(obj,MarkerNames,temp,side);
            MarkerNames = strcat(side,{'WristIn'}); MarkerData.US = GetMarkerDataColumns(obj,MarkerNames,temp,side);
            MarkerNames = strcat(side,{'WristOut'}); MarkerData.RS = GetMarkerDataColumns(obj,MarkerNames,temp,side);
            MarkerNames = strcat(side,{'Arm'}); MarkerData.H = GetMarkerDataColumns(obj,MarkerNames,temp,side);
            MarkerNames = strcat(side,{'HandOut','Hand2'}); MarkerData.MC = GetMarkerDataColumns(obj,MarkerNames,temp,side);
            MarkerNames = strcat(side,{'HeelBack'}); MarkerData.MM = GetMarkerDataColumns(obj,MarkerNames,temp,side); % AnkleIn would be better
            MarkerNames = strcat(side,{'AnkleOut'}); MarkerData.LM = GetMarkerDataColumns(obj,MarkerNames,temp,side);
            MarkerNames = strcat(side,{'Shin','ShinFrontHigh'}); MarkerData.LC = GetMarkerDataColumns(obj,MarkerNames,temp,side); % Should be KneeIn ideally
            MarkerNames = strcat(side,{'KneeOut'}); MarkerData.MCk = GetMarkerDataColumns(obj,MarkerNames,temp,side);
            MarkerNames = strcat(side,{'ForefootIn'}); MarkerData.FFi = GetMarkerDataColumns(obj,MarkerNames,temp,side);
            MarkerNames = strcat(side,{'ForefootOut'}); MarkerData.FFo = GetMarkerDataColumns(obj,MarkerNames,temp,side);
            MarkerNames = strcat(side,{'ToeTip'}); MarkerData.TT = GetMarkerDataColumns(obj,MarkerNames,temp,side);
            MarkerNames = strcat(side,{'Thigh','ThighFrontLow'}); MarkerData.T = GetMarkerDataColumns(obj,MarkerNames,temp,side);
            MarkerNames = ({'WaistRBack','WaistR'}); MarkerData.PSIS_R = GetMarkerDataColumns(obj,MarkerNames,temp,side);
            MarkerNames = ({'WaistLBack','WaistL'}); MarkerData.PSIS_L = GetMarkerDataColumns(obj,MarkerNames,temp,side);
            MarkerNames = ({'WaistRFront'}); MarkerData.ASIS_R = GetMarkerDataColumns(obj,MarkerNames,temp,side);
            MarkerNames = ({'WaistLFront'}); MarkerData.ASIS_L = GetMarkerDataColumns(obj,MarkerNames,temp,side);
            MarkerNames = ({'HeadFront'}); MarkerData.HF = GetMarkerDataColumns(obj,MarkerNames,temp,side);
            MarkerNames = ({'HeadTop'}); MarkerData.HT = GetMarkerDataColumns(obj,MarkerNames,temp,side);
            MarkerNames = ({'HeadL'}); MarkerData.HL = GetMarkerDataColumns(obj,MarkerNames,temp,side);
            MarkerNames = ({'HeadR'}); MarkerData.HR = GetMarkerDataColumns(obj,MarkerNames,temp,side);
            MarkerNames = ({'VIOLIN'}); MarkerData.Violin = GetInstrumentDataColumns(obj,MarkerNames,temp,side);
            MarkerNames = ({'BOW'}); MarkerData.Bow = GetInstrumentDataColumns(obj,MarkerNames,temp,side);
            MarkerNames = ({'RShoulderTop'}); MarkerData.RST = GetMarkerDataColumns(obj,MarkerNames,temp,side);
            MarkerNames = ({'LShoulderTop'}); MarkerData.LST = GetMarkerDataColumns(obj,MarkerNames,temp,side);
            MarkerNames = ({'RWristOut'}); MarkerData.RWO = GetMarkerDataColumns(obj,MarkerNames,temp,side);
        end

        function [XYZ,obj] = GetMarkerDataColumns(obj,MarkerNames,temp,side,flag)
            if strcmpi(side,obj.Parameters.sides{2}) == 1
                sideArg = 1;
            elseif strcmpi(side,obj.Parameters.sides{1}) == 1
                sideArg = 2;
            else
                error('Something is wrong, check data for inconsistencies!')
            end
            if size(temp.Data,3)>1
                X = temp.Data(:,1:3:end,sideArg);
                Y = temp.Data(:,2:3:end,sideArg);
                Z = temp.Data(:,3:3:end,sideArg);
            else
                X = temp.Data(:,1:3:end);
                Y = temp.Data(:,2:3:end);
                Z = temp.Data(:,3:3:end);
            end
            cc = [];
            for k = 1:numel(temp.MarkerNames)
                if find(endsWith(temp.MarkerNames(k),MarkerNames))
                    cc = cat(1,cc,k);
                end
            end
            if nargin == 4
                if strcmp(MarkerNames,'All') == 0
                    if length(cc)>1
                        obj.Warnings{end+1,1} = ['The naming of body markers is ambigous.']; %#ok<*NBRAK>
                    end
                    if isempty(cc)
                        XYZ = nan(size(temp.Data,1),3);
                        for index = 1:numel(MarkerNames)
                            obj.Warnings{end+1,1} = ['Marker with label: ',MarkerNames{index}, ' was not found.'];
                        end
                    else
                        XYZ = [X(:,cc),Y(:,cc),Z(:,cc)];
                    end
                elseif strcmp(MarkerNames,'All') == 1
                    if size(temp.Data,3)>1
                        XYZ = temp.Data(:,:,sideArg);
                    else
                        XYZ = temp.Data;
                    end
                end
            elseif nargin > 4
                if strcmp(flag,'mean') == 1
                    if isempty(cc)
                        XYZ = nan(size(temp.Data,1),3);
                    else
                        XYZ = [mean(X(:,cc),2),mean(Y(:,cc),2),mean(Z(:,cc),2)];
                    end
                elseif strcmp(flag,'nanmean') == 1
                    if isempty(cc)
                        XYZ = nan(size(temp.Data,1),3);
                    else
                        XYZ = [mean(X(:,cc),2,"omitnan"),mean(Y(:,cc),2,"omitnan"),mean(Z(:,cc),2,"omitnan")];
                    end
                end
            end
        end

        function [XYZ,obj] = GetInstrumentDataColumns(obj,MarkerNames,temp,side)
            if strcmpi(side,obj.Parameters.sides{2}) == 1
                sideArg = 1;
            elseif strcmpi(side,obj.Parameters.sides{1}) == 1
                sideArg = 2;
            else
                error('Hm.. something is wrong, buddy..')
            end
            if size(temp.Data,3)>1
                X = temp.Data(:,1:3:end,sideArg);
                Y = temp.Data(:,2:3:end,sideArg);
                Z = temp.Data(:,3:3:end,sideArg);
            else
                X = temp.Data(:,1:3:end);
                Y = temp.Data(:,2:3:end);
                Z = temp.Data(:,3:3:end);
            end
            cc = [];
            for k = 1:numel(temp.MarkerNames)
                if find(contains(temp.MarkerNames(k),MarkerNames)) % edit 180923
                    cc = cat(1,cc,k);
                end
            end
            XYZ = zeros(size(X,1),3,numel(cc));
            XYZ(:,1,:) = X(:,cc);
            XYZ(:,2,:) = Y(:,cc);
            XYZ(:,3,:) = Z(:,cc);
        end

        function [jointangledata,GH] = CalculateJointAngles(obj,temp,side)
            [~,Xt,Yt,Zt,~] = JCS_thorax(obj,temp,side);
            [GH,~] = LocateShoulder(obj,temp,side); % find shoulder "joint"
            [~,Xh2,Yh2,Zh2] = JCS_humerus(obj,temp,side); % JCS humerus
            [~,Xf,Yf,~] = JCS_forearm(obj,temp,side); % JCS forearm
            e1 = Zh2; e1 = e1./vecnorm(e1,2,2); e3 = Yf; e3 = e3./vecnorm(e3,2,2); e2 = cross(Zh2,Yf); e2 = e2./vecnorm(e2,2,2); % define rotational axes
            jointangledata.Elbow.FE = obj.findangle(e2,Yh2,e1,90);  % flexion (+)/hyperextension (-), in order to follow convention
            jointangledata.Elbow.PS = obj.findangle(e2,Xf,-e3,90); % pronation (+)/supination (-), with neutral position knuckles in same plane humerus-elbow-forearm
            [~,~,Yr,Zr] = JCS_radius(obj,temp,side); % JCS radius
            [~,~,Ym,~] = JCS_metacarpal(obj,temp,side); % JCS metacarpal bones (~hand)
            e1 = Zr; e1 = e1./vecnorm(e1,2,2); e3 = Ym; e3 = e3./vecnorm(e3,2,2); e2 = cross(Zr,Ym); e2 = e2./vecnorm(e2,2,2); % define rotational axes
            jointangledata.Wrist.FE = obj.findangle(e2,Yr,-e1,-90); % flexion/extension, flexion towards the palm is positive
            jointangledata.Wrist.AA = obj.findangle(e1,e3,e2,-90); % abduction/adduction, deflection to the ulna (to the outside of the hand with knuckles up) is positive
            e1 = Yt; e1 = e1./vecnorm(e1,2,2); e3 = Yh2; e3 = e3./vecnorm(e3,2,2); e2 = cross(e1,e3); e2 = e2./vecnorm(e2,2,2); % define rotational axes
            jointangledata.Shoulder.AA = obj.findangle(e2,Xt,e1); % abduction (0 deg) <-> forward flexion (90 deg)
            jointangledata.Shoulder.E = obj.findangle(e1,e3,-e2); % elevation (-)
            jointangledata.Shoulder.PS = obj.findangle(e2,Xh2,-e3); % pronation/supination, to inside (+) outside (-)
            [~,Xtf,Ytf,~] = JCS_tibialfibula(obj,temp,side);
            [~,~,Ycn,Zcn] = JCS_calcaneus(obj,temp,side);
            e1 = Xtf; e1 = e1./vecnorm(e1,2,2); e3 = Ycn; e3 = e3./vecnorm(e3,2,2); e2 = cross(e1,e3); e2 = e2./vecnorm(e2,2,2);
            jointangledata.Ankle.DP = obj.findangle(e1,e3,e2,- 90); % dorsiflexion (+) or plantar- flexion (-)
            jointangledata.Ankle.R = obj.findangle(-e2,Zcn,e3); % internal rotation (+) or external rotation (-)
            jointangledata.Ankle.E = obj.findangle(e2,Ytf,e1,90); % inversion (+) or eversion (-)
            [~,~,Yfm,~] = JCS_femur(obj,temp,side);
            e1 = Yfm; e1 = e1./vecnorm(e1,2,2); e3 = Ytf; e3 = e3./vecnorm(e3,2,2); e2 = cross(e1,e3); e2 = e2./vecnorm(e2,2,2);
            jointangledata.Knee.FE = obj.findangle(e1,e3,e2); % flexion or extension knee
            [~,~,Yhip,Zhip] = JCS_hips(obj,temp,side);
            e1 = Zhip; e1 = e1./vecnorm(e1,2,2); e3 = Yfm; e3 = e3./vecnorm(e3,2,2); e2 = cross(e1,e3); e2 = e2./vecnorm(e2,2,2);
            jointangledata.Hip.FE = obj.findangle(-e2,Yhip,e1); % flexion or extension hip
            jointangledata.Hip.AA = obj.findangle(e1,e3,e2,-90); % abduction or adduction hip
            [~,~,Yhd,Zhd] = JCS_neck(obj,temp,side);
            e1 = Zt; e1 = e1./vecnorm(e1,2,2); e3 = Yhd; e3 = e3./vecnorm(e3,2,2); e2 = cross(e1,e3); e2 = e2./vecnorm(e2,2,2);
            jointangledata.Neck.AA = obj.findangle(e2,Yt,e1,90); % yes
            jointangledata.Neck.BB = obj.findangle(e1,e3,e2,-90); % wobble
            jointangledata.Neck.GG = obj.findangle(e2,Zhd,e3,90); % no
            e1 = Zhip; e1 = e1./vecnorm(e1,2,2); e3 = Yt; e3 = e3./vecnorm(e3,2,2); e2 = cross(e1,e3); e2 = e2./vecnorm(e2,2,2);
            jointangledata.Spine.AA = obj.findangle(e2,Yhip,e1,90); % bow
            jointangledata.Spine.BB = obj.findangle(e1,e3,e2,-90); % lean left/right
            jointangledata.Spine.GG = obj.findangle(e2,Zt,e3,90); % twist

            % addition for bow and violin
            [~,~,Yt,Zt,~] = JCS_thorax(obj,temp,side);
            [~,~,Yv,Zv] = JCS_violin(obj,temp,side);
            e1 = Zt; e1 = e1./vecnorm(e1,2,2); e3 = Yv; e3 = e3./vecnorm(e3,2,2); e2 = cross(e1,e3); e2 = e2./vecnorm(e2,2,2);
            jointangledata.Violin.AA = obj.findangle(e2,Yt,e1); % violin angle up/down; violin vertically up = -90, violin vertically down = 90, perfectly horizontal = 0;
            jointangledata.Violin.BB = obj.findangle(e1,e3,e2); % violin angle left/right. violin perpendicular to transversal body axis = 90, violin completely to the left = 0;
            jointangledata.Violin.GG = obj.findangle(-e2,Zv,e3); % violin tilt .. not entirely clear how to interpret.. not important neither
            [~,~,Yb,~] = JCS_bow(obj,temp,side);
            e1 = Yv; e1 = e1./vecnorm(e1,2,2); e3 = Yb; e3 = e3./vecnorm(e3,2,2); e2 = cross(e1,e3); e2 = e2./vecnorm(e2,2,2);
            jointangledata.Bow.AA = obj.findangle(e2,Zv,e1); % bow angle relative to axis out of violin.
            jointangledata.Bow.BB = obj.findangle(e1,e3,e2); % bow angle relative to longitudinal axis violin
        end

        function bowpositiondata = CalculateBowPosition(obj,temp)
            side = obj.Parameters.sides{2};
            [InstrumentData] = GetMarkerData(obj,temp,side);
            [MarkerData] = GetMarkerData(obj,temp,side);
            k1 = zeros(1,size(InstrumentData.Violin,3));
            for index = 1:size(InstrumentData.Violin,3)
                 k1(index) = median(sqrt(sum((InstrumentData.Violin(:,:,index) - MarkerData.RST).^2,2)),"omitnan");
            end
            [~,c1] = sort(k1,'ascend');
            k2 = zeros(1,size(InstrumentData.Violin,3));
            for index = 1:size(InstrumentData.Violin,3)
                k2(index) = median(sqrt(sum((InstrumentData.Violin(:,:,index) - MarkerData.LST).^2,2)),"omitnan");
            end
            % [~,c2] = sort(k2,'ascend');
            P1 = squeeze(InstrumentData.Violin(:,:,c1(1)));
            P2 = squeeze(InstrumentData.Violin(:,:,c1(2)));
            if size(InstrumentData.Violin,3) == 3
                c3 = setdiff([1 2 3], [c1(1), c1(2)]);
                P3 = squeeze(InstrumentData.Violin(:,:,c3));
            elseif size(InstrumentData.Violin,3) == 4
                c3 = setdiff([1 2 3 4], [c1(1), c1(2)]);
                P3 = squeeze(sum(InstrumentData.Violin(:,:,c3),3)/2);
            end
            V1 = (P1 + P2)/2; V2 = P3;
            k1 = zeros(1,size(InstrumentData.Bow,3));
            for index = 1:size(InstrumentData.Bow,3)
                k1(index) = median(sqrt(sum((InstrumentData.Bow(:,:,index) - MarkerData.RWO).^2,2)),"omitnan");
            end
            [~,c1] = sort(k1,'ascend');
            P1 = squeeze(InstrumentData.Bow(:,:,c1(1)));
            P3 = squeeze(InstrumentData.Bow(:,:,c1(3)));
            B1 = P1; B2 = P3;
            vV = V2 - V1;
            vB = B2 - B1;
            B1 = B1 - obj.StartDist*vB./vecnorm(vB,2,2);
            vB = B2 - B1;
            nVB = cross(vV,vB);
            DV = zeros(size(nVB,1),2);
            DB = DV;
            for index = 1:size(nVB,1)
                tt = [nVB(index,:)', vV(index,:)', vB(index,:)']\[B1(index,:) - V1(index,:)]';
                vx1 = V1(index,:) + tt(2)*vV(index,:);
                bx1 = B1(index,:) + tt(3)*vB(index,:);
                DV(index,:) = [sqrt(sum((V1(index,:) - vx1).^2)), sqrt(sum((V1(index,:) - V2(index,:)).^2))];
                DB(index,:) = [sqrt(sum((B1(index,:) - bx1).^2)), sqrt(sum((B1(index,:) - B2(index,:)).^2))];
            end
            bowpositiondata.DV = DV;
            bowpositiondata.DB = DB;
            bowpositiondata.B1 = P1;
            bowpositiondata.B2 = P3;
            bowpositiondata.V1 = V1;
            bowpositiondata.V2 = V2;
        end

    end

    methods (Static, Access = protected)

        function Output = findangle(A,B,N,offset)
            A = A./vecnorm(A,2,2); 
            B = B./vecnorm(B,2,2);
            N = N./vecnorm(N,2,2);
            if nargin == 3
                Output.Angle = rad2deg(atan2(dot(cross(A,B),N,2),dot(A,B,2)));
                Output.AngularVelocity = diff(Output.Angle,1,1);
                Output.AngularAcceleration = diff(Output.Angle,2,1);
            elseif nargin >= 4
                Output.Angle = rad2deg(atan2(dot(cross(A,B),N,2),dot(A,B,2))) + offset;
                Output.AngularVelocity = diff(Output.Angle,1,1);
                Output.AngularAcceleration = diff(Output.Angle,2,1);
            end
        end

    end

end
