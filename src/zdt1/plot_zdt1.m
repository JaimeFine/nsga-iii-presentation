function plot_nsga_fronts()
    s1 = load('zdt1_nsga2.mat', 'Obj1');
    s2 = load('zdt1_nsga3.mat', 'Obj2');

    PF1 = s1.Obj1;
    PF2 = s2.Obj2;

    fprintf('NSGA-II size: %d x %d\n', size(PF1,1), size(PF1,2));
    fprintf('NSGA-III size: %d x %d\n', size(PF2,1), size(PF2,2));

    if size(PF1,2) ~= size(PF2,2)
        error('NSGA-II and NSGA-III have different numbers of objectives.');
    end

    M = size(PF1,2);

    % HV reference point
    ref = max([PF1; PF2], [], 1) * 1.1;
    fprintf('HV reference point: %s\n', mat2str(ref,4));

    figure;
    hold on;

    if M == 2
        % True ZDT1 Pareto front: f2 = 1 - sqrt(f1)
        truePF_x = linspace(0, 1, 400);
        truePF_y = 1 - sqrt(truePF_x);

        plot(truePF_x, truePF_y, 'g', 'LineWidth', 2);
        scatter(PF1(:,1), PF1(:,2), 40, 'r', 'filled');
        scatter(PF2(:,1), PF2(:,2), 40, 'b', 'filled');
        scatter(ref(1), ref(2), 140, 'm', 'p', 'filled');

        xlabel('f_1');
        ylabel('f_2');
        legend('True ZDT1 PF', 'NSGA-II', 'NSGA-III', 'HV Reference Point', ...
               'Location', 'best');

    else
        error('Plotting is only supported here for 2 or 3 objectives.');
    end

    title('Pareto Front Comparison: NSGA-II vs NSGA-III');
    grid on;
    hold off;
end