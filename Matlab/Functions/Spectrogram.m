function spectrogramOutput = Spectrogram(AudioSignal, AudioFs, MocapFs, WindowLength)
    % Spectrogram - Compute a spectrogram from an audio signal.
    %
    % Syntax:
    %   spectrogramOutput = Spectrogram(AudioSignal, AudioFs, MocapFs, WindowLength)
    %
    % Input:
    %   AudioSignal - The input audio signal to be analyzed.
    %   AudioFs - The sampling rate of the audio signal.
    %   MocapFs - The desired sampling rate for the spectrogram.
    %   WindowLength - The window length for analysis.
    % Output:
    %   spectrogramOutput - The spectrogram matrix.
    %
    % Description:
    %   This function computes a spectrogram from an audio signal.

    % Calculate the window size in samples based on WindowLength and AudioFs
    Window = round(WindowLength * AudioFs);

    % Calculate the resampling factor from AudioFs to MocapFs
    rsf = round(AudioFs / MocapFs);

    % Determine the starting indices of rows for the spectrogram
    Rows = 1:rsf:length(AudioSignal);

    % Filter out rows where the window would extend beyond the signal's length
    Rows = Rows((Rows + Window - 1) < length(AudioSignal));

    % Count the number of rows in the spectrogram
    RowsCount = numel(Rows);

    % Calculate the overlap length L
    L = round(Window / 2);
    L = Window - L + 1;

    % Initialize the spectrogram matrix M
    M = zeros(L, RowsCount);

    % Calculate the spectrogram using a loop
    for index = 1:(RowsCount - 1)
        tmp = AudioSignal(Rows(index):(Rows(index) + Window - 1));
        tmp = abs(fft(tmp));
        M(:, index) = tmp(1:L);
    end

    % Store the spectrogram in the spectrogramOutput variable
    spectrogramOutput = M;

    % Set frequency cutoffs for spectral analysis
    cutoff2 = 3000;
    cutoff1 = 100;

    % Calculate the frequency values
    f = AudioFs * (0:(Window / 2)) / Window;

    % Find indices corresponding to the specified frequency cutoffs
    c2 = find(f < cutoff2, 1, 'last');
    c1 = find(f > cutoff1, 1);

    % Sum the spectral components within the specified frequency range
    spectrogramOutput = nansum(spectrogramOutput(c1:c2, :));
    
end