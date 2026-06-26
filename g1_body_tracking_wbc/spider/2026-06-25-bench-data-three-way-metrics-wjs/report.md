# Bench Data Three-Way Metrics

Experiment ID: `2026-06-25-bench-data-three-way-metrics-wjs`

## Summary

This is the metrics-only bench_data comparison across 26 motions and three configurations: `no_mpc_baseline`, `best_s128`, and `sweetpoint`. The run used full motion length within the <=60s subset and did not render videos.

## Completeness

- motions: 26
- eval metrics: 78 / 78
- rendered videos: 0 / 0
- selected categories: 21
- source package: `/data_team/junsong/model-based/spider/outputs/g1_wbc_bench_data_three_way_metrics_20260625`

## Aggregate Results

| method | wins | success | tracked | borderline | failed | avg score |
|---|---:|---:|---:|---:|---:|---:|
| no_mpc_baseline | 1 | 24/26 | 16 | 1 | 9 | -1.919252 |
| best_s128 | 4 | 26/26 | 20 | 2 | 4 | -1.347441 |
| sweetpoint | 21 | 26/26 | 22 | 4 | 0 | -1.140826 |

## Delta Versus No-MPC

| method | improved | regressed | mean score delta |
|---|---:|---:|---:|
| best_s128 | 22 | 4 | 0.571811 |
| sweetpoint | 25 | 1 | 0.778426 |

## Recommendation

Use `sweetpoint` as the current quality default for this bench subset: it wins 21/26 motions, has no failed track-status rows, and improves over no-mpc on 25/26 motions. Keep `best_s128` as the lower-cost ablation or speed baseline: it improves over no-mpc on 22/26 motions but has 4 failed track-status rows and wins only 4/26 motions.

`no_mpc_baseline` remains useful as a policy-only floor, but it has 9 failed track-status rows and wins only 1/26 motions in this run.

## Limitations

- Seed: 0 only.
- No render/video review was performed for this package.
- Source repo had local uncommitted changes required for this run: empty-`fps` loading support, full-length bench runner support, metrics-only/no-render mode, and tail-window reference-index clamping.
- Wall-clock timings should not be treated as clean speed benchmarks because other GPU jobs were concurrently active on the machine.

## Artifacts

See `artifacts.md` and the CSVs under `configs/`.
