function plot_nsga_fronts()
    s1 = load('nsga2_result.mat', 'Obj1');
    s2 = load('nsga3_result.mat', 'Obj2');

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
        % True DTLZ2 Pareto front: quarter unit circle
        t = linspace(0, pi/2, 400);
        truePF_x = cos(t);
        truePF_y = sin(t);

        plot(truePF_x, truePF_y, 'k-', 'LineWidth', 2);
        scatter(PF1(:,1), PF1(:,2), 40, 'r', 'filled');
        scatter(PF2(:,1), PF2(:,2), 40, 'b', 'filled');
        scatter(ref(1), ref(2), 140, 'm', 'p', 'filled');

        xlabel('f_1');
        ylabel('f_2');
        legend('True DTLZ2 PF', 'NSGA-II', 'NSGA-III', 'HV Reference Point', ...
               'Location', 'best');

    elseif M == 3
        % True DTLZ2 Pareto front: positive octant of unit sphere
        [X, Y, Z] = sphere(60);
        X(X < 0) = NaN;
        Y(Y < 0) = NaN;
        Z(Z < 0) = NaN;

        surf(X, Y, Z, ...
            'FaceColor', [0.7 0.7 0.7], ...
            'FaceAlpha', 0.18, ...
            'EdgeColor', 'none');

        scatter3(PF1(:,1), PF1(:,2), PF1(:,3), 40, 'r', 'filled');
        scatter3(PF2(:,1), PF2(:,2), PF2(:,3), 40, 'b', 'filled');
        scatter3(ref(1), ref(2), ref(3), 180, 'm', 'p', 'filled');

        xlabel('f_1');
        ylabel('f_2');
        zlabel('f_3');
        view(135, 30);
        axis equal;

        legend('True DTLZ2 PF', 'NSGA-II', 'NSGA-III', 'HV Reference Point', ...
               'Location', 'best');
    else
        error('Plotting is only supported here for 2 or 3 objectives.');
    end

    title('Pareto Front Comparison: NSGA-II vs NSGA-III');
    grid on;
    hold off;
end
