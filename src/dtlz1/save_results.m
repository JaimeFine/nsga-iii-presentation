function save_results()
    s1  = load('nsga2_result.mat', 'Obj1');
    PF1 = s1.Obj1;

    s2  = load('nsga3_result.mat', 'Obj2');
    PF2 = s2.Obj2;

    % Calculate HV
    max_val     = max([PF1; PF2], [], 1) * 1.1;
    dummy_front = [zeros(1, size(PF1, 2)); max_val];

    Population1.best.objs = PF1;
    Population2.best.objs = PF2;
    hv_nsga2 = HV(Population1, dummy_front);
    hv_nsga3 = HV(Population2, dummy_front);

    % Generate pseudo-true Pareto front for IGD
    combined_solutions = [PF1; PF2];
    FrontNo = NDSort(combined_solutions, 1);
    pseudo_true_pf = combined_solutions(FrontNo == 1, :);

    % Calculate IGD
    igd_nsga2 = calculate_native_igd(PF1, pseudo_true_pf);
    igd_nsga3 = calculate_native_igd(PF2, pseudo_true_pf);

    % Build results table
    results = table;
    results.Algorithm  = ["NSGA-II"; "NSGA-III"];
    results.Solutions  = [size(PF1,1); size(PF2,1)];
    results.Objectives = [size(PF1,2); size(PF2,2)];
    results.HV         = [hv_nsga2; hv_nsga3];
    results.IGD        = [igd_nsga2; igd_nsga3];

    output_filename = 'performance_summary.csv';
    writetable(results, output_filename);

    fprintf('\n==================================================\n');
    fprintf('SUCCESS: Results exported to %s\n', output_filename);
    fprintf('NSGA-II   -> size: %d x %d | HV: %.6f | IGD: %.6f\n', ...
        size(PF1,1), size(PF1,2), hv_nsga2, igd_nsga2);
    fprintf('NSGA-III  -> size: %d x %d | HV: %.6f | IGD: %.6f\n', ...
        size(PF2,1), size(PF2,2), hv_nsga3, igd_nsga3);
    fprintf('==================================================\n');
end

function score = calculate_native_igd(obtained_pf, reference_pf)
    num_ref_points = size(reference_pf, 1);
    min_distances = zeros(num_ref_points, 1);

    for i = 1:num_ref_points
        diffs = obtained_pf - reference_pf(i, :);
        distances = sqrt(sum(diffs.^2, 2));
        min_distances(i) = min(distances);
    end

    score = mean(min_distances);
end
