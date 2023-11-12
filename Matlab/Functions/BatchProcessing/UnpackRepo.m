function UnpackRepo(DataFolderPath)
    % UnpackRepo - Unpack data from zip files located in the specified folder.
    %
    % Syntax:
    %   UnpackRepo(DataFolderPath)
    %
    % Input:
    %   DataFolderPath - The path to the folder containing the zip files to be
    %   unpacked.
    %
    % Description:
    %   This function unpacks data from zip files located in the specified
    %   DataFolderPath. It unzips MoCap, Avatar, and Questionnaire data into
    %   their respective directories.
    
    disp('Starting unpacking of MoCap data.')

    DataFile = fullfile(DataFolderPath, 'Labeled_MoCap_Data.zip');
    unzip(DataFile, 'Mocap')

    disp('Finished unpacking of MoCap data.')
    disp('Starting unpacking of Avatar data.')

    DataFile = fullfile(DataFolderPath, 'Avatar_Data.zip');
    unzip(DataFile, 'Avatar')

    disp('Finished unpacking of Avatar data.')
    disp('Starting unpacking of Questionnaire data.')

    DataFile = fullfile(DataFolderPath, 'Questionnaire_Data.zip');
    unzip(DataFile, 'Questionnaire')

    disp('Finished unpacking of Questionnaire data.')
    disp('Proceed to: 4: Demonstration of analysis ;')
    disp('Or:')
    disp('Proceed to: 5. Arrange dataset for further processing (see R package) .')

end
