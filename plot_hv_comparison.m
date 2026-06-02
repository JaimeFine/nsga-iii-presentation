function plot_hv_comparison()
    data1 = load('nsga2_result.mat');
    fields1 = fieldnames(data1);
    Result1 = data1.(fields1{1}); 
    PF1 = extract_objs(Result1);
    Population1.best.objs = PF1;

    data2 = load('nsga3_result.mat');
    fields2 = fieldnames(data2);
    Result2 = data2.(fields2{1});
    PF2 = extract_objs(Result2);
    Population2.best.objs = PF2;
    
    % Diagnostic
    fprintf('NSGA-II data points: %d | Mean objective value: %.4f\n', size(PF1, 1), mean(PF1(:)));
    fprintf('NSGA-III data points: %d | Mean objective value: %.4f\n', size(PF2, 1), mean(PF2(:)));

    % Define normalization bounds
    max_val = max([PF1; PF2], [], 1) * 1.1;
    dummy_front = [zeros(1, size(PF1, 2)); max_val];

    % Calculate Hypervolume (HV)
    hv = [HV(Population1, dummy_front), HV(Population2, dummy_front)];
    algos = {'NSGA-II', 'NSGA-III'};
    
    fprintf('\n========== EXACT HV VALUES ==========\n');
    fprintf('  NSGA-II Hypervolume:  %.6f\n', hv(1));
    fprintf('  NSGA-III Hypervolume: %.6f\n', hv(2));
    fprintf('=====================================\n');

    figure;
    hBar = bar(hv, 0.5, 'FaceColor', [0.2 0.6 0.8]);
    set(gca, 'XTickLabel', algos);
    ylabel('Hypervolume (HV)');
    title('Hypervolume Performance Comparison');
    grid on;
    xtips = hBar.XEndPoints;
    ytips = hBar.YEndPoints;
    labels = cellstr(num2str(hv', '%.4f'));
    text(xtips, ytips, labels, 'HorizontalAlignment', 'center', ...
         'VerticalAlignment', 'bottom', 'FontWeight', 'bold', 'FontSize', 11);
    padding = (max(hv) - min(hv)) * 0.5;
    if padding > 0
        ylim([max(0, min(hv) - padding), max(hv) + padding]);
    else
        ylim([0, max(hv) * 1.2]);
    end
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