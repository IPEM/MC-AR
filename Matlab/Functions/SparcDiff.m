function Output = SparcDiff(Input0, Input1, Input2, Input3, Input4, Input5)
    % SparcDiff - Compute the difference between two SPARC values.
    %
    % Syntax:
    %   Output = SparcDiff(Input0, Input1, Input2, Input3, Input4, Input5)
    %
    % Input:
    %   Input0 - Array containing the movement speed profile.
    %   Input1 - Array containing another movement speed profile for comparison.
    %   Input2 - Sampling frequency of the data.
    %   Input3 - Amount of zero padding for spectral arc length estimation (default = 4).
    %   Input4 - Maximum cut-off frequency for spectral arc length calculation (default = 10.0).
    %   Input5 - Amplitude threshold for determining the cut-off frequency for spectral arc length estimation (default = 0.05).
    %
    % Output:
    %   Output - The difference between two SPARC values.
    %
    % Description:
    %   This function computes the difference between two SPARC values.

    % Calculate the SPARC values for Input0 and Input1 by calling the Sparc function
    Fid0 = Sparc(Input0, Input2, Input3, Input4, Input5);
    Fid1 = Sparc(Input1, Input2, Input3, Input4, Input5);

    % Calculate the difference between Fid0 and Fid1
    % Output represents the difference between the two SPARC values
    Output = (Fid0 - Fid1);

end