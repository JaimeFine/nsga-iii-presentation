function save_results()
    data1 = load('nsga2_result.mat');
    fields1 = fieldnames(data1);
    Result1 = data1.(fields1{1}); 
    PF1 = extract_objs(Result1);

    data2 = load('nsga3_result.mat');
    fields2 = fieldnames(data2);
    Result2 = data2.(fields2{1});
    PF2 = extract_objs(Result2);

    % Calculate Live Hypervolume (HV) Metrics
    max_val = max([PF1; PF2], [], 1) * 1.1;
    dummy_front = [zeros(1, size(PF1, 2)); max_val];

    Population1.best.objs = PF1;
    Population2.best.objs = PF2;
    hv_nsga2 = HV(Population1, dummy_front);
    hv_nsga3 = HV(Population2, dummy_front);

    % Generate Pseudo-True Pareto Front for IGD
    combined_solutions = [PF1; PF2];
    FrontNo = NDSort(combined_solutions, 1);
    pseudo_true_pf = combined_solutions(FrontNo == 1, :);

    % Calculate IGD Metrics
    igd_nsga2 = calculate_native_igd(PF1, pseudo_true_pf);
    igd_nsga3 = calculate_native_igd(PF2, pseudo_true_pf);

    % Dynamically Construct the Results Table
    results = table;
    results.Algorithm  = ["NSGA-II"; "NSGA-III"];
    results.Objectives = [size(PF1, 2); size(PF2, 2)]; 
    results.HV         = [hv_nsga2; hv_nsga3];
    results.IGD        = [igd_nsga2; igd_nsga3];

    output_filename = 'performance_summary.csv';
    writetable(results, output_filename);
    
    fprintf('\n==================================================\n');
    fprintf('  SUCCESS: Live results exported to %s\n', output_filename);
    fprintf('  NSGA-II -> HV: %.6f | IGD: %.6f\n', hv_nsga2, igd_nsga2);
    fprintf('  NSGA-III -> HV: %.6f | IGD: %.6f\n', hv_nsga3, igd_nsga3);
    fprintf('==================================================\n');
end

% =========================================================================
% HELPER FUNCTION: Pure Mathematical IGD Calculation
% =========================================================================
function score = calculate_native_igd(obtained_pf, reference_pf)
    % obtained_pf: Matrix of objectives from your algorithm (N1 x M)
    % reference_pf: Matrix of the true/pseudo Pareto front (N2 x M)
    num_ref_points = size(reference_pf, 1);
    min_distances = zeros(num_ref_points, 1);
    
    for i = 1:num_ref_points
        % Find Euclidean distance from current reference point to all obtained points
        diffs = obtained_pf - reference_pf(i, :);
        distances = sqrt(sum(diffs.^2, 2));
        min_distances(i) = min(distances);
    end
    
    % IGD is the average of these minimum distances
    score = mean(min_distances);
end

% =========================================================================
% HELPER FUNCTION: Safely extract raw objective matrices
% =========================================================================
function disp_matrix = extract_objs(R)
    if isnumeric(R)
        disp_matrix = R;
    elseif iscell(R)
        if size(R, 2) == 2
            disp_matrix = extract_objs(R{end, 2});
        else
            disp_matrix = extract_objs(R{end});
        end
    elseif isobject(R)
        try
            disp_matrix = R.objs; 
        catch
            try
                disp_matrix = vertcat(R.obj);
            catch
                error('Could not extract objectives from object.');
            end
        end
    elseif isstruct(R)
        if isfield(R, 'Population')
            disp_matrix = extract_objs(R.Population);
        elseif isfield(R, 'objs')
            disp_matrix = R.objs;
        else
            disp_matrix = R;
        end
    else
        disp_matrix = R;
    end
end