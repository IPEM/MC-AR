function QData = BatchExtractQs(DataFolderPath)
    % BatchExtractQs - Generate an array containing all the answers from
    % the questionnaires.
    %
    % Syntax:
    %   QData = BatchExtractQs(DataFolderPath)
    %
    % Input:
    %   DataFolderPath - Path to the folder with all data.
    %
    % Output:
    %   QData - Data array for further analysis.
    %
    % Description:
    %   This function generates an array containing all the necessary data 
    %   points to reproduce the results as published. The structure of the 
    %   dataset includes various indices for different attributes. 
    %   The dataset can be used for statistical analysis in the R package, 
    %   as described in the publication. It includes information related to 
    %   metrics, participants, sessions, conditions, pieces, and violin 
    %   sections.
    
    disp('Starting extraction of questionnaire data.')
    C1 = dir([DataFolderPath,'/**/C1.csv']);
    C1 = ImportFile(fullfile(C1.folder,C1.name));
    C2 = dir([DataFolderPath,'/**/C2.csv']);
    C2 = ImportFile(fullfile(C2.folder,C2.name));
    
    MPQP_C1 = table2array(mean(C1(:,17:21),2)); 
    Tag = [nan(length(MPQP_C1),2),ones(length(MPQP_C1),1),C1.session,C1.participant,ones(length(MPQP_C1),1),6*ones(length(MPQP_C1),1)];
    MPQP_C1 = [MPQP_C1,Tag];

    MPQS_C1 = table2array(mean(C1(:,22:26),2)); 
    Tag = [nan(length(MPQP_C1),2),ones(length(MPQP_C1),1),C1.session,C1.participant,ones(length(MPQP_C1),1),5*ones(length(MPQP_C1),1)];
    MPQS_C1 = [MPQS_C1,Tag];

    PQ_C1 = table2array(mean(C1(:,27:53),2)); 
    Tag = [nan(length(MPQP_C1),2),ones(length(MPQP_C1),1),C1.session,C1.participant,ones(length(MPQP_C1),1),4*ones(length(MPQP_C1),1)];
    PQ_C1 = [PQ_C1,Tag];

    Difficulty_P1 = table2array(C1(:,65));
    Tag = [nan(length(MPQP_C1),1),ones(length(MPQP_C1),1),nan(length(MPQP_C1),1),C1.session,C1.participant,ones(length(MPQP_C1),1),7*ones(length(MPQP_C1),1)];
    Difficulty_P1 = [Difficulty_P1,Tag];

    DummyData = [nan,nan,nan,1,2,7,1,4 ; ...
        nan,nan,nan,1,2,7,1,5 ; ...
        nan,nan,nan,1,2,7,1,6 ; ...
        nan,nan,1,nan,2,7,1,7];

    QData_1 = [MPQP_C1; MPQS_C1; PQ_C1; Difficulty_P1; DummyData]; 

    MPQP_C2 = table2array(mean(C2(:,17:21),2)); 
    Tag = [nan(length(MPQP_C2),2),2*ones(length(MPQP_C2),1),C2.session,C2.participant,ones(length(MPQP_C2),1),6*ones(length(MPQP_C2),1)];
    MPQP_C2 = [MPQP_C2,Tag];

    MPQS_C2 = table2array(mean(C2(:,22:26),2)); 
    Tag = [nan(length(MPQP_C2),2),2*ones(length(MPQP_C2),1),C2.session,C2.participant,ones(length(MPQP_C2),1),5*ones(length(MPQP_C2),1)];
    MPQS_C2 = [MPQS_C2,Tag];

    PQ_C2 = table2array(mean(C2(:,27:53),2)); 
    Tag = [nan(length(MPQP_C2),2),2*ones(length(MPQP_C2),1),C2.session,C2.participant,ones(length(MPQP_C2),1),4*ones(length(MPQP_C2),1)];
    PQ_C2 = [PQ_C2,Tag];

    Difficulty_P2 = table2array(C2(:,66));
    Tag = [nan(length(MPQP_C2),1),2*ones(length(MPQP_C2),1),nan(length(MPQP_C2),1),C2.session,C2.participant,ones(length(MPQP_C2),1),7*ones(length(MPQP_C2),1)];
    Difficulty_P2 = [Difficulty_P2,Tag];

    DummyData = [nan,nan,nan,2,2,7,1,4 ; ...
        nan,nan,nan,2,2,7,1,5 ; ...
        nan,nan,nan,2,2,7,1,6 ; ...
        nan,nan,2,nan,2,7,1,7];

    QData_2 = [MPQP_C2; MPQS_C2; PQ_C2; Difficulty_P2; DummyData]; 

    QData = [QData_1;QData_2];

end