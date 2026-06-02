function D = pdist2(X, Y, distanceType)
% PDIST2 Custom toolbox-free replacement for the Statistics Toolbox function.
% Shadows the missing toolbox function locally without altering PlatEMO library files.

    if nargin < 3
        distanceType = 'euclidean';
    end

    switch lower(distanceType)
        case 'cosine'
            % Compute the magnitude (norm) of each row vector
            normX = sqrt(sum(X.^2, 2));
            normY = sqrt(sum(Y.^2, 2));
            
            % Prevent division by zero for any edge-case zero vectors
            normX(normX == 0) = 1e-12;
            normY(normY == 0) = 1e-12;
            
            % Normalize the vectors to unit length
            X_norm = X ./ normX;
            Y_norm = Y ./ normY;
            
            % Pairwise Cosine Distance = 1 - Cosine Similarity
            D = 1 - (X_norm * Y_norm');
            
        case 'euclidean'
            % High-performance vectorized pairwise Euclidean distance
            X2 = sum(X.^2, 2);
            Y2 = sum(Y.^2, 2);
            D = sqrt(max(0, X2 - 2 * (X * Y') + Y2'));
            
        otherwise
            error('Custom pdist2 only supports ''cosine'' and ''euclidean'' distance profiles.');
    end
end
