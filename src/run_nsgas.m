clear;
clc;

addpath(genpath(pwd))

[~, Obj1, ~] = platemo( ...
    'algorithm', @NSGAII, 'problem', @DTLZ2, 'M', 3, 'N', 92 ...
);

[~, Obj2, ~] = platemo( ...
    'algorithm', @NSGAIII, 'problem', @DTLZ2, 'M', 3, 'N', 92 ...
);

save('nsga2_result.mat', 'Obj1');
save('nsga3_result.mat', 'Obj2');
