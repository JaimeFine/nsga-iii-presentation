# NSGA-II / NSGA-III Debug Folder

This folder collects a small PlatEMO-based experiment for comparing `NSGA-II` and `NSGA-III`, plus the intermediate results and plots produced during debugging.

## Files

- `run_nsgas.m`
  Runs both algorithms through `platemo(...)` and saves two `.mat` result files.

- `plot_hv_comparison.m`
  Loads the saved results, extracts objective values, computes hypervolume, and generates a bar chart.

- `save_results.m`
  Loads the saved results again, computes summary metrics such as HV and IGD, and exports a CSV table.

- `nsga2_result.mat`
  Saved MATLAB result file intended to store the NSGA-II output.

- `nsga3_result.mat`
  Saved MATLAB result file intended to store the NSGA-III output.

- `performance_summary.csv`
  Exported metric summary.

- `nsga2.png`
  Plot image associated with the NSGA-II run.

- `nsga3.png`
  Plot image associated with the NSGA-III run.

- `hv_comparison.png`
  Bar chart image comparing HV values.
