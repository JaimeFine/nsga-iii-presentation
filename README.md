# NSGA-II / NSGA-III DTLZ2 Comparison

This folder contains a small MATLAB + PlatEMO experiment for comparing `NSGA-II` and `NSGA-III` on the `DTLZ2` problem with `3` objectives and population size `92`.

The current workflow is the corrected one:

- `platemo(...)` is called with `'algorithm'`, `'problem'`, `'M'`, and `'N'` without leading hyphens
- the saved `.mat` files store raw objective matrices directly
- `NSGA-III` is supported locally with a custom `pdist2.m`, so no PlatEMO library source needs to be edited

## Files

- `run_nsgas.m`
  Runs `NSGA-II` and `NSGA-III` on `DTLZ2` and saves the final objective matrices as `Obj1` and `Obj2`.

- `nsga2_result.mat`
  Stores `Obj1`, the final NSGA-II objective matrix.

- `nsga3_result.mat`
  Stores `Obj2`, the final NSGA-III objective matrix.

- `plot_hv_comparison.m`
  Loads `Obj1` and `Obj2`, computes HV using PlatEMO's `HV.m`, and generates a bar chart comparing the two algorithms.

- `save_results.m`
  Loads `Obj1` and `Obj2`, computes HV and IGD, and exports the summary table to `performance_summary.csv`.

- `performance_summary.csv`
  CSV summary of the current run.

- `plot_nsgas.m`
  Plots the two obtained fronts together and also overlays:
  the true `DTLZ2` Pareto front and the HV reference point.

- `pdist2.m`
  Local toolbox-free replacement for MATLAB's `pdist2`, used so `NSGAIII` can run without modifying files inside PlatEMO's `Multi-objective optimization` folders.

- `hv_comparison.png`
  Saved HV bar chart.

- `plot1.png`, `plot2.png`, `plot3.png`, `plot4.png`
  Saved front visualization outputs from the plotting scripts.

## Code behavior

### 1. Running the algorithms

`run_nsgas.m` runs:

- `NSGA-II` on `DTLZ2`
- `NSGA-III` on `DTLZ2`

with:

- `M = 3`
- `N = 92`

The script saves the final objective values directly.

### 2. Hypervolume comparison

`plot_hv_comparison.m`:

- loads `Obj1` and `Obj2`
- wraps them into lightweight `Population.best.objs` structs so PlatEMO's `HV.m` can evaluate them
- builds an HV reference point from the worst observed objective values:

```matlab
ref = max([PF1; PF2], [], 1) * 1.1
```

- plots the final HV values in a bar chart

### 3. Metric export

`save_results.m` computes:

- `HV`
- `IGD`

For IGD, it constructs a pseudo-reference front by taking the nondominated union of both obtained fronts.

### 4. Pareto-front visualization

`plot_nsgas.m` plots:

- the NSGA-II front
- the NSGA-III front
- the true analytical DTLZ2 Pareto front
- the HV reference point

For the 3-objective case, the true DTLZ2 front is shown as the positive octant of the unit sphere.

## Current output results

The latest exported results in `performance_summary.csv` are:

| Algorithm | Solutions | Objectives | HV | IGD |
| --- | ---: | ---: | ---: | ---: |
| NSGA-II | 92 | 3 | 0.654508062815249 | 0.0426966404441228 |
| NSGA-III | 91 | 3 | 0.677727010399515 | 0.0287188404797641 |

These values are consistent with the corrected run:

- `NSGA-II` final front size: `92 x 3`
- `NSGA-III` final front size: `91 x 3`
- both algorithms now return valid multi-objective fronts
- `NSGA-III` performs slightly better on this run according to both HV and IGD

## Interpretation

For this run:

- higher `HV` is better
- lower `IGD` is better

So the current results suggest that `NSGA-III` produced a slightly better approximation to the DTLZ2 Pareto front than `NSGA-II`.

This is still a single stochastic run, so for a thesis-quality comparison it would be better to repeat the experiment multiple times and report averages and variation.

## Main debugging discoveries

This folder originally exposed several issues that are now fixed or worked around:

- using `'-algorithm'`, `'-problem'`, `'-M'`, `'-N'` caused PlatEMO to ignore the intended settings
- that earlier mistake produced misleading `100 x 1` zero-valued outputs
- HV became `NaN` in that broken state because the saved data were invalid
- `NSGAIII` required `pdist2`, so a local replacement was added instead of editing PlatEMO source files

At the moment, the folder should be treated as a working corrected experiment rather than only a debugging snapshot.
