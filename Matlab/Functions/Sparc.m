function Output = Sparc(Input1, Input2, Input3, Input4, Input5)
    % Sparc - Calculate the smoothness of a speed profile using the modified spectral arc
    % length metric.
    %
    % Syntax:
    %   Output = Sparc(Input1, Input2, Input3, Input4, Input5)
    %
    % Input:
    %   Input1 - Array containing the movement speed profile.
    %   Input2 - Sampling frequency of the data.
    %   Input3 - Amount of zero padding for spectral arc length estimation (default = 4).
    %   Input4 - Maximum cut-off frequency for spectral arc length calculation (default = 10.0).
    %   Input5 - Amplitude threshold for determining the cut-off frequency for spectral arc length estimation (default = 0.05).
    %
    % Output:
    %   Output - Spectral arc length estimate of the movement's smoothness.
    %
    % Description:
    %   This function computes the smoothness of a speed profile using the modified spectral arc
    %   length metric.

    % Check the number of input arguments and provide default values if necessary.
    if nargin < 2
        Input2 = 120;     % Default sampling frequency.
        Input3 = 4;       % Default zero padding.
        Input4 = 10.0;    % Default maximum cut-off frequency.
        Input5 = 0.05;    % Default amplitude threshold.
    end

    try
        % Number of zeros to be padded for spectral analysis.
        nfft = round(2.^(ceil(log2(numel(Input1))) + Input3)); 

        % Calculate the frequency vector.
        f = (0 : (Input2 / nfft) : Input2);

        % Create a normalized magnitude spectrum.
        tmp = zeros(1, nfft);
        tmp(1:numel(Input1)) = Input1;
        Mf = abs(fft(tmp));
        Mf = Mf / max(Mf);

        % Choose only the spectrum within the given cut-off frequency Input4
        sel = find(f <= Input4);
        f_sel = f(sel);
        Mf_sel = Mf(sel);

        % Determine the amplitude threshold-based cut-off frequency.
        sel = find(Mf_sel >= Input5);
        sel = (sel(1):1:sel(end));
        f_sel = f_sel(sel);
        Mf_sel = Mf_sel(sel);

        % Calculate the arc length using the modified spectral arc length metric.
        Output = -sum( sqrt( (diff(f_sel) / (f_sel(end) - f_sel(1))).^2 + (diff(Mf_sel)).^2));
    catch
        Output = nan; % Handle exceptions by returning NaN.
    end

end
