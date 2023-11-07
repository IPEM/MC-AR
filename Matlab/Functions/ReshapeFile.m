function Output = ReshapeFile(Input, MetricNumber, FilterNans)
    % ReshapeFile - Reshapes a data array for further processing.
    %
    % Syntax:
    %   Output = ReshapeFile(Input, MetricNumber, FilterNans)
    %
    % Input:
    %   Input - Array to be reshaped.
    %   MetricNumber - Metric index to be added as a tag.
    %   FilterNans - Filter out NaN values if necessary (1 for filtering, 0 for no filtering).
    %
    % Output:
    %   Output - Reshaped data array for further processing.
    %
    % Description:
    %   This function reshapes a data array for further processing.

    tmp0 = [];
    
    if FilterNans == 1
        sel = find(~isnan(sum(Input(6:end,:),2)));
        sel = sel + 5;
        Input = Input([[1:5]'; sel(:)], :);
    end
    
    for idx = 1:size(Input, 2)
        L = size(Input(6:end, idx), 1);
        tmp1 = [Input(6:end, idx), repmat(Input(1:5, idx)', L, 1), [1:L]', ones(L, 1) * MetricNumber];
        tmp0 = [tmp0; tmp1];
    end

    Output = tmp0;
    
end