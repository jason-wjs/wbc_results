# Best s128 Low-Sample Milestone

Experiment ID: `2026-06-22-best-s128-low-sample-milestone-wjs`

## Summary

Historical low-sample tuning and best_s128 milestone used as the quality lower bound for later optimization.

This package was migrated from `spider/outputs/g1_wbc_metrics_sync_20260623`. It preserves lightweight metrics, summaries, commands, and provenance. Raw copied `raw/` metrics, videos, rollouts, logs, and checkpoints are intentionally not committed.

## Scope

- rows in `primary_metrics.csv`: 46
- rows in `run_index.csv`: 46
- complete rows: 46
- successful rows: 28
- copied summary CSVs: 9

Family counts:

- `low_latency_tuning_20260619`: 46

Motion counts:

- `jump`: 44
- `qixing`: 1
- `walk`: 1

## Best Score Row

- run_id: `low_latency_tuning_20260619__jump_short_sweep__jump__jump_s64_i2_h20_c40_k8_sig0p08_0p18_0p28_seed0__metrics__7c5eb318`
- motion: `jump`
- config: `s64_i2_h20_c40_k8_seed0`
- score: `-0.33503666426986456`
- duration_sec: `15.581`

## Claims

| claim | evidence | confidence | limitations |
|---|---|---|---|
| best_s128 is the accepted low-sample quality lower bound before mechanism experiments. | milestone_snapshot.md and low_latency_tuning rows | medium | Historical jump best metrics and visualized rerun differ because the best metrics run did not retain rollout.npz. |
| best_s128 preserves a large speed advantage over the packaged 8192-sample baseline. | duration_sec in primary_metrics.csv | medium | Timings mix historical 4070 Laptop and packaged 4090 sources, so use as directional evidence. |

## Limitations

- This is a migrated registry package; it does not rerun rollouts.
- Raw source artifacts are referenced in `artifacts.md`, not stored in git.
- Qualitative video judgments are preserved as historical conclusions; videos remain external artifacts.

## Artifacts

See `artifacts.md`.
