function plot_wfg2_fronts()

    %% Load results
    s1 = load('wfg2_nsga2.mat', 'Obj1');
    s2 = load('wfg2_nsga3.mat', 'Obj2');

    PF1 = s1.Obj1;
    PF2 = s2.Obj2;

    fprintf('NSGA-II size: %d x %d\n', size(PF1,1), size(PF1,2));
    fprintf('NSGA-III size: %d x %d\n', size(PF2,1), size(PF2,2));

    %% TRUE PF (same method, but now WFG2)
    problem = WFG2();
    PF_true = problem.GetPF();

    X = PF_true{1};
    Y = PF_true{2};
    Z = PF_true{3};

    %% Reference point
    ref = max([PF1; PF2], [], 1) * 1.1;

    fprintf('HV reference point: %s\n', mat2str(ref,4));

    %% Plot
    figure;
    hold on;

    surf(X, Y, Z, ...
        'FaceColor', [0.75 0.75 0.75], ...
        'FaceAlpha', 0.25, ...
        'EdgeColor', 'none');

    scatter3(PF1(:,1), PF1(:,2), PF1(:,3), ...
        40, 'r', 'filled');

    scatter3(PF2(:,1), PF2(:,2), PF2(:,3), ...
        40, 'b', 'filled');

    scatter3(ref(1), ref(2), ref(3), ...
        180, 'm', 'p', 'filled');

    xlabel('f_1');
    ylabel('f_2');
    zlabel('f_3');

    title('WFG2 Pareto Front Comparison');

    legend('True PF', 'NSGA-II', 'NSGA-III', 'HV Ref', ...
        'Location','best');

    view(135,30);
    grid on;
    hold off;

end