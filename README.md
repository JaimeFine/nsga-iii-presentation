# NSGA-II / NSGA-III Presentation Repo

This repository contains small MATLAB + PlatEMO experiments that compare `NSGA-II` and `NSGA-III` on three benchmark problems:

- `DTLZ2` with `3` objectives
- `WFG2` with `3` objectives
- `ZDT1` with `2` objectives

The repo includes scripts to:

- run both algorithms
- save the final objective matrices to `.mat` files
- compute `HV` and `IGD`
- export summary CSV files
- generate Pareto-front and hypervolume plots

## Repository Structure

```text
nsga-iii-presentation/
|-- LICENSE
|-- README.md
|-- src/
|   |-- pdist2.m
|   |-- dtlz1/
|   |   |-- run_nsgas.m
|   |   |-- save_results.m
|   |   |-- plot_hv_comparison.m
|   |   `-- plot_nsgas.m
|   |-- wfg2/
|   |   |-- run_nsgas_w.m
|   |   |-- save_wfg2.m
|   |   |-- plot_hv_wfg2.m
|   |   `-- plot_wfg2.m
|   `-- zdt1/
|       |-- run_nsgas_z.m
|       |-- save_zdt1.m
|       |-- plot_hv_zdt1.m
|       `-- plot_zdt1.m
`-- results/
    |-- dtlz2/
    |   |-- nsga2_result.mat
    |   |-- nsga3_result.mat
    |   |-- performance_summary.csv
    |   |-- hv_comparison.png
    |   |-- plot1.png
    |   |-- plot2.png
    |   |-- plot3.png
    |   `-- plot4.png
    |-- wfg2/
    |   |-- wfg2_nsga2.mat
    |   |-- wfg2_nsga3.mat
    |   |-- wfg2_performance_summary.csv
    |   |-- hv_wfg2.png
    |   |-- wfg2_1.png
    |   |-- wfg2_2.png
    |   |-- wfg2_3.png
    |   `-- wfg2_4.png
    `-- zdt1/
        |-- zdt1_nsga2.mat
        |-- zdt1_nsga3.mat
        |-- zdt1_performance_summary.csv
        |-- hv_zdt1.png
        `-- zdt1.png
```

## Notes About the Current Layout

- `src/dtlz1/` is a misleading folder name: the scripts inside it actually run `DTLZ2`, not `DTLZ1`.
- `src/pdist2.m` is a local replacement for MATLAB's `pdist2`, used so `NSGAIII` can run without editing PlatEMO source files.
- The scripts save and load files using relative paths, so it is best to run each script from its own problem folder under `src/` or `results/`.
- Several MATLAB files have first-function names that do not match their filenames. If MATLAB refuses to call them by function name, open the file and run it from the editor, or rename the file/function pairs to match.

## Requirements

- MATLAB
- PlatEMO on the MATLAB path

The scripts use PlatEMO components such as:

- `platemo`
- `NSGAII`
- `NSGAIII`
- `DTLZ2`
- `WFG2`
- `ZDT1`
- `HV`
- `NDSort`

## Usage

### 1. Add the project and PlatEMO to the MATLAB path

Example:

```matlab
cd('C:\Users\13647\OneDrive\Desktop\nsga-iii-presentation')
addpath(genpath(pwd))
```

Make sure PlatEMO is also available on the MATLAB path before running the experiments.

### 2. Run an experiment

Each problem has a run script inside `src/<problem>/`.

#### DTLZ2

From `src/dtlz1/`:

```matlab
run_nsgas
```

This runs:

- `NSGA-II` on `DTLZ2` with `M = 3`, `N = 92`
- `NSGA-III` on `DTLZ2` with `M = 3`, `N = 92`

and saves:

- `nsga2_result.mat`
- `nsga3_result.mat`

#### WFG2

From `src/wfg2/`:

```matlab
run_nsgas_w
```

This runs:

- `NSGA-II` on `WFG2` with `M = 3`, `N = 92`
- `NSGA-III` on `WFG2` with `M = 3`, `N = 92`

and saves:

- `wfg2_nsga2.mat`
- `wfg2_nsga3.mat`

#### ZDT1

From `src/zdt1/`:

```matlab
run_nsgas_z
```

This runs:

- `NSGA-II` on `ZDT1` with `N = 100`
- `NSGA-III` on `ZDT1` with `N = 100`

and saves:

- `zdt1_nsga2.mat`
- `zdt1_nsga3.mat`

### 3. Compute metrics and export CSV summaries

Run the matching save script from the same problem folder:

#### DTLZ2

```matlab
save_results
```

Exports:

- `performance_summary.csv`

#### WFG2

```matlab
save_wfg2
```

Exports:

- `wfg2_performance_summary.csv`

Note: `save_wfg2.m` currently declares `function save_results()`. On some MATLAB setups this name mismatch may require running the file from the editor or renaming the function to `save_wfg2`.

#### ZDT1

```matlab
save_zdt1
```

Exports:

- `zdt1_performance_summary.csv`

Note: `save_zdt1.m` currently declares `function save_results()`. On some MATLAB setups this name mismatch may require running the file from the editor or renaming the function to `save_zdt1`.

### 4. Generate plots

Run the plot scripts from the same problem folder.

#### DTLZ2

```matlab
plot_hv_comparison
plot_nsgas
```

#### WFG2

```matlab
plot_hv_wfg2
plot_wfg2
```

#### ZDT1

```matlab
plot_hv_zdt1
plot_zdt1
```

## What Each Script Does

### DTLZ2 scripts in `src/dtlz1/`

- `run_nsgas.m`: runs `NSGA-II` and `NSGA-III` on `DTLZ2` and saves the final objective matrices.
- `save_results.m`: computes `HV` and `IGD`, using the nondominated union of both fronts as a pseudo-reference front for `IGD`.
- `plot_hv_comparison.m`: computes and plots the final `HV` values for both algorithms.
- `plot_nsgas.m`: visualizes both fronts together with the analytical `DTLZ2` Pareto front and the hypervolume reference point.

### WFG2 scripts in `src/wfg2/`

- `run_nsgas_w.m`: runs `NSGA-II` and `NSGA-III` on `WFG2` and saves the final objective matrices.
- `save_wfg2.m`: filters each front to nondominated points, computes `HV` and `IGD`, and uses `WFG2().GetOptimum(1000)` as the `IGD` reference front.
- `plot_hv_wfg2.m`: computes and plots the final `HV` values for both algorithms.
- `plot_wfg2.m`: visualizes both fronts together with the `WFG2` Pareto front and the hypervolume reference point.

### ZDT1 scripts in `src/zdt1/`

- `run_nsgas_z.m`: runs `NSGA-II` and `NSGA-III` on `ZDT1` and saves the final objective matrices.
- `save_zdt1.m`: filters each front to nondominated points, computes `HV` and `IGD`, and uses the analytical `ZDT1` Pareto curve as the `IGD` reference front.
- `plot_hv_zdt1.m`: computes and plots the final `HV` values for both algorithms.
- `plot_zdt1.m`: visualizes both fronts together with the analytical `ZDT1` Pareto front and the hypervolume reference point.

## Current Result Snapshots

The repo already contains exported summary CSV files in `results/`:

### DTLZ2

| Algorithm | Solutions | Objectives | HV | IGD |
| --- | ---: | ---: | ---: | ---: |
| NSGA-II | 92 | 3 | 0.654508062815249 | 0.0426966404441228 |
| NSGA-III | 91 | 3 | 0.677727010399515 | 0.0287188404797641 |

### WFG2

| Algorithm | Solutions | Objectives | HV | IGD |
| --- | ---: | ---: | ---: | ---: |
| NSGA-II | 92 | 3 | 0.927259437230212 | 0.255714642272937 |
| NSGA-III | 91 | 3 | 0.928649266158432 | 0.169624210974288 |

### ZDT1

| Algorithm | Solutions | Objectives | HV | IGD |
| --- | ---: | ---: | ---: | ---: |
| NSGA-II | 100 | 2 | 0.75692015891145 | 0.0121859334729157 |
| NSGA-III | 100 | 2 | 0.730335789945207 | 0.0341920066674504 |

## Interpretation

- higher `HV` is better
- lower `IGD` is better

In the current saved outputs:

- `NSGA-III` performs better than `NSGA-II` on `DTLZ2`
- `NSGA-III` performs better than `NSGA-II` on `WFG2`
- `NSGA-II` performs better than `NSGA-III` on `ZDT1`

These are still single-run snapshots. For a stronger comparison, repeat each experiment multiple times and report averages and variation.
