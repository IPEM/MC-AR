function Output = ImportFile(filename)
    % ImportFile - Extract questionnaire data from the CSV files containing
    % the answers to the questionnaires.
    %
    % Syntax:
    %   Output = ImportFile(filename)
    %
    % Input:
    %   filename - CSV file containing the questionnaire data.
    %
    % Output:
    %   Output - Array containing the data from the questionnaires.
    %
    % Description:
    %   This function extracts questionnaire data from the CSV files containing
    %   the answers to the questionnaires.

    % Set up the Import Options and import the data
    opts = delimitedTextImportOptions("NumVariables", 69, "Encoding", "UTF-8");
    
    % Specify range and delimiter
    opts.DataLines = [3, Inf];
    opts.Delimiter = ",";
    
    % Specify column names and types
    opts.VariableNames = ["startdate", "participant", "session", "SOMA01", "SOMA02", "SOMA03", "SOMA04", "SOMA05", "SOMA06", "SOMA07", "SOMA08", "SOMA09", "SOMA10", "SOMA11", "SOMA12", "SOMA13", "MPQP01", "MPQP02", "MPQP03", "MPQP04", "MPQP05", "MPQS01", "MPQS02", "MPQS03", "MPQS04", "MPQS05", "WPQ01", "WPQ02", "WPQ03", "WPQ04", "WPQ05", "WPQ06", "WPQ07", "WPQ08", "WPQ09", "WPQ10", "WPQ11", "WPQ12", "WPQ13", "WPQ14", "WPQ15", "WPQ16", "WPQ17", "WPQ18", "WPQ19", "WPQ20", "WPQ21", "WPQ22", "WPQ23", "WPQ24", "WPQ25", "WPQ26", "WPQ27", "WPQ28", "WPQ29", "O01", "O02", "O03", "O04", "O05", "O06", "O07", "O08", "D17", "D18", "D19", "D20", "D21", "D22"];
    opts.VariableTypes = ["datetime", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "string", "double", "string", "string", "string", "double", "string", "double", "double", "double", "double", "double", "double"];
    
    % Specify file level properties
    opts.ExtraColumnsRule = "ignore";
    opts.EmptyLineRule = "read";
    
    % Specify variable properties
    opts = setvaropts(opts, ["O02", "O04", "O05", "O06", "O08"], "WhitespaceRule", "preserve");
    opts = setvaropts(opts, ["O02", "O04", "O05", "O06", "O08"], "EmptyFieldRule", "auto");
    opts = setvaropts(opts, "startdate", "InputFormat", "dd/MM/yyyy HH:mm");
    opts = setvaropts(opts, ["participant", "session", "MPQP01", "MPQP02", "MPQP03", "MPQP04", "MPQP05", "MPQS01", "MPQS02", "MPQS03", "MPQS04", "MPQS05", "WPQ01", "WPQ02", "WPQ03", "WPQ04", "WPQ05", "WPQ06", "WPQ07", "WPQ08", "WPQ09", "WPQ10", "WPQ11", "WPQ12", "WPQ13", "WPQ14", "WPQ15", "WPQ16", "WPQ17", "WPQ18", "WPQ19", "WPQ20", "WPQ21", "WPQ22", "WPQ23", "WPQ24", "WPQ25", "WPQ26", "WPQ27", "WPQ28", "WPQ29", "O01", "O03", "O07", "D20", "D21", "D22"], "TrimNonNumeric", true);
    opts = setvaropts(opts, ["participant", "session", "MPQP01", "MPQP02", "MPQP03", "MPQP04", "MPQP05", "MPQS01", "MPQS02", "MPQS03", "MPQS04", "MPQS05", "WPQ01", "WPQ02", "WPQ03", "WPQ04", "WPQ05", "WPQ06", "WPQ07", "WPQ08", "WPQ09", "WPQ10", "WPQ11", "WPQ12", "WPQ13", "WPQ14", "WPQ15", "WPQ16", "WPQ17", "WPQ18", "WPQ19", "WPQ20", "WPQ21", "WPQ22", "WPQ23", "WPQ24", "WPQ25", "WPQ26", "WPQ27", "WPQ28", "WPQ29", "O01", "O03", "O07", "D20", "D21", "D22"], "ThousandsSeparator", ",");
    
    % Import the data
    Output = readtable(filename, opts);

end
