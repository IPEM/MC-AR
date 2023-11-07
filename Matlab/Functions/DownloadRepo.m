function DownloadRepo(DataFolderPath)
    % DownloadRepo - downloads the necessary data files from Zenodo.
    %
    % Syntax:
    %   DownloadRepo(DataFolderPath)
    %
    % Input:
    %   DataFolderPath - folder where data will be stored after downloading.
    %
    % Description:
    %   This function downloads the necessary data files from Zenodo to the
    %   folder as specified in the Input.

    % Display a message to indicate the start of the download process
    disp('Starting download of MoCap data from Zenodo...')

    % Define the URL for downloading MoCap data from Zenodo
    httpsUrl = 'https://zenodo.org/records/8147435/files/Labeled_MoCap_Data.zip?download=1';

    % Define the local file path for the downloaded MoCap data
    DataFile = fullfile(DataFolderPath, 'Labeled_MoCap_Data.zip');

    % Download the MoCap data from Zenodo
    websave(DataFile, httpsUrl);

    % Display a message to indicate the completion of the MoCap data download
    disp('Finished downloading of MoCap data from Zenodo.')
    disp('Starting download of Avatar data from Zenodo...')

    % Define the URL for downloading Avatar data from Zenodo
    httpsUrl = 'https://zenodo.org/records/8147435/files/Avatar_Data.zip?download=1';

    % Define the local file path for the downloaded Avatar data
    DataFile = fullfile(DataFolderPath, 'Avatar_Data.zip');

    % Download the Avatar data from Zenodo
    websave(DataFile, httpsUrl);

    % Display a message to indicate the completion of the Avatar data download
    disp('Finished downloading of Avatar data from Zenodo.')
    disp('Starting download of Questionnaire data from Zenodo.')

    % Define the URL for downloading Questionnaire data from Zenodo
    httpsUrl = 'https://zenodo.org/records/8147435/files/Questionnaire_Data.zip?download=1';

    % Define the local file path for the downloaded Questionnaire data
    DataFile = fullfile(DataFolderPath, 'Questionnaire_Data.zip');

    % Download the Questionnaire data from Zenodo
    websave(DataFile, httpsUrl);

    % Display a message to indicate the completion of the Questionnaire data download
    disp('Finished downloading of Questionnaire data from Zenodo.')
    disp('Run the following function: UnpackRepo.m')

end