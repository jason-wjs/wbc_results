# Artifacts

Experiment ID: `2026-06-25-bench-data-three-way-metrics-wjs`

Raw rollouts, per-run `metrics.json`, and logs are intentionally not copied into this repository.
They remain under:

`/data_team/junsong/model-based/spider/outputs/g1_wbc_bench_data_three_way_metrics_20260625`

## Lightweight Files In Git

- `primary_metrics.csv`: 78 normalized metric rows.
- `run_index.csv`: 78 provenance rows pointing to external metrics, rollouts, logs, and commands.
- `configs/method_ranking.csv`: method ranking by motion.
- `configs/baseline_vs_mpc_score.csv`: score deltas versus no-mpc baseline.
- `configs/baseline_vs_mpc_full_deltas.csv`: full metric deltas versus no-mpc baseline.
- `configs/motion_failures.csv`: tracking status and failure labels.
- `configs/runtime_summary.csv`: per-run step/window summary.
- `configs/category_summary.csv`: status summary by category/method.
- `configs/benchmark_config.json`: generated benchmark package config.
- `configs/package_summary.json`: package completion metadata.

## External Counts

- motions: 26
- eval runs: 78 / 78
- videos: 0 / 0
- rollout files: 78, indexed externally via `run_index.csv`

## Method Sections

### no_mpc_baseline

Baseline policy-only evaluation, no MPC. See `run_index.csv` rows where `method=no_mpc_baseline`.

### best_s128

MPC `g1_wbc_joint_global`, 128 samples, 2 iterations, horizon/control 40/20, knot count 8, sigmas 0.04/0.10/0.18.

### sweetpoint

MPC `g1_wbc_joint_global`, 512 samples, 2 iterations, horizon/control 40/20, knot count 8, sigmas 0.04/0.10/0.18.
