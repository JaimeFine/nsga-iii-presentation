function plot_hv_comparison()
    s1  = load('nsga2_result.mat', 'Obj1');
    PF1 = s1.Obj1;

    s2  = load('nsga3_result.mat', 'Obj2');
    PF2 = s2.Obj2;

    % HV.m expects a Population-like struct
    Population1.best.objs = PF1;
    Population2.best.objs = PF2;

    fprintf('NSGA-II size: %d x %d | Mean: %.4f\n', size(PF1,1), size(PF1,2), mean(PF1(:)));
    fprintf('NSGA-III size: %d x %d | Mean: %.4f\n', size(PF2,1), size(PF2,2), mean(PF2(:)));

    max_val    = max([PF1; PF2], [], 1) * 1.1;
    dummy_front = [zeros(1, size(PF1,2)); max_val];

    hv = [HV(Population1, dummy_front), HV(Population2, dummy_front)];
    algos = {'NSGA-II', 'NSGA-III'};

    fprintf('\n========== HV VALUES ==========\n');
    fprintf('NSGA-II  HV: %.6f\n', hv(1));
    fprintf('NSGA-III HV: %.6f\n', hv(2));
    fprintf('===============================\n');

    figure;
    hBar = bar(hv, 0.5, 'FaceColor', [0.2 0.6 0.8]);
    set(gca, 'XTickLabel', algos);
    ylabel('Hypervolume (HV)');
    title('Hypervolume Performance Comparison');
    grid on;

    xtips  = hBar.XEndPoints;
    ytips  = hBar.YEndPoints;
    labels = cellstr(num2str(hv', '%.4f'));
    text(xtips, ytips, labels, 'HorizontalAlignment', 'center', ...
         'VerticalAlignment', 'bottom', 'FontWeight', 'bold', 'FontSize', 11);
end
