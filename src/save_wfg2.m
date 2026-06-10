function save_results()

    %% Load WFG2 results
    s1  = load('wfg2_nsga2.mat', 'Obj1');
    PF1 = s1.Obj1;

    s2  = load('wfg2_nsga3.mat', 'Obj2');
    PF2 = s2.Obj2;

    %% Ensure nondominated filtering (recommended)
    PF1 = PF1(NDSort(PF1,1)==1,:);
    PF2 = PF2(NDSort(PF2,1)==1,:);

    %% Hypervolume calculation
    max_val     = max([PF1; PF2], [], 1) * 1.1;
    dummy_front = [zeros(1, size(PF1, 2)); max_val];

    Population1.best.objs = PF1;
    Population2.best.objs = PF2;

    hv_nsga2 = HV(Population1, dummy_front);
    hv_nsga3 = HV(Population2, dummy_front);

    %% TRUE WFG2 Pareto front (IMPORTANT FIX)
    problem = WFG2();
    PF_true = problem.GetOptimum(1000);

    %% IGD (correct reference)
    igd_nsga2 = calculate_native_igd(PF1, PF_true);
    igd_nsga3 = calculate_native_igd(PF2, PF_true);

    %% Results table
    results = table;
    results.Algorithm  = ["NSGA-II"; "NSGA-III"];
    results.Solutions  = [size(PF1,1); size(PF2,1)];
    results.Objectives = [size(PF1,2); size(PF2,2)];
    results.HV         = [hv_nsga2; hv_nsga3];
    results.IGD        = [igd_nsga2; igd_nsga3];

    %% Export
    output_filename = 'wfg2_performance_summary.csv';
    writetable(results, output_filename);

    %% Print summary
    fprintf('\n==================================================\n');
    fprintf('SUCCESS: Results exported to %s\n', output_filename);

    fprintf('NSGA-II  -> size: %d x %d | HV: %.6f | IGD: %.6f\n', ...
        size(PF1,1), size(PF1,2), hv_nsga2, igd_nsga2);

    fprintf('NSGA-III -> size: %d x %d | HV: %.6f | IGD: %.6f\n', ...
        size(PF2,1), size(PF2,2), hv_nsga3, igd_nsga3);

    fprintf('==================================================\n');

end

%% IGD function (unchanged)
function score = calculate_native_igd(obtained_pf, reference_pf)

    num_ref_points = size(reference_pf, 1);
    min_distances  = zeros(num_ref_points, 1);

    for i = 1:num_ref_points
        diffs = obtained_pf - reference_pf(i, :);
        distances = sqrt(sum(diffs.^2, 2));
        min_distances(i) = min(distances);
    end

    score = mean(min_distances);

end