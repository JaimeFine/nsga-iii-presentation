function plot_hv_comparison()

    %% Load results
    s1 = load('zdt1_nsga2.mat','Obj1');
    s2 = load('zdt1_nsga3.mat','Obj2');

    PF1 = s1.Obj1;
    PF2 = s2.Obj2;

    %% Keep only nondominated solutions
    PF1 = PF1(NDSort(PF1,1)==1,:);
    PF2 = PF2(NDSort(PF2,1)==1,:);

    %% Population structs for PlatEMO HV
    Population1.best.objs = PF1;
    Population2.best.objs = PF2;

    %% Statistics
    fprintf('NSGA-II size: %d x %d\n',size(PF1,1),size(PF1,2));
    fprintf('NSGA-III size: %d x %d\n',size(PF2,1),size(PF2,2));

    %% ZDT1 reference point
    ref = [1.1 1.1];

    %% Dummy PF used by PlatEMO HV
    PF_ref = [
        0     0
        ref
    ];

    %% Hypervolume
    hv1 = HV(Population1,PF_ref);
    hv2 = HV(Population2,PF_ref);

    hv = [hv1 hv2];

    %% Print results
    fprintf('\n========== HV VALUES ==========\n');
    fprintf('NSGA-II  HV : %.6f\n',hv1);
    fprintf('NSGA-III HV : %.6f\n',hv2);
    fprintf('===============================\n');

    %% Plot
    figure;

    hBar = bar(hv,0.5);

    set(gca,'XTickLabel',{'NSGA-II','NSGA-III'});

    ylabel('Hypervolume (HV)');
    title('ZDT1 Hypervolume Comparison');

    grid on;

    xtips = hBar.XEndPoints;
    ytips = hBar.YEndPoints;

    labels = cellstr(num2str(hv','%.6f'));

    text(xtips,ytips,labels,...
        'HorizontalAlignment','center',...
        'VerticalAlignment','bottom',...
        'FontWeight','bold');

end