# Local Frontier Diagnostics

Experiment ID: `2026-06-22-local-frontier-diagnostics-wjs`

## Summary

Negative-result package preserving the local-frontier diagnostics after best_s128.

This package was migrated from `spider/outputs/g1_wbc_metrics_sync_20260623`. It preserves lightweight metrics, summaries, commands, and provenance. Raw copied `raw/` metrics, videos, rollouts, logs, and checkpoints are intentionally not committed.

## Scope

- rows in `primary_metrics.csv`: 50
- rows in `run_index.csv`: 50
- complete rows: 50
- successful rows: 24
- copied summary CSVs: 47

Family counts:

- `l145_visual_review_20260622`: 4
- `local_first_stage_20260622`: 6
- `local_middle_gate_20260622`: 11
- `local_recovery_20260622`: 9
- `local_transfer_20260622`: 8
- `local_upper_bound_20260622`: 12

Motion counts:

- `jump`: 38
- `qixing`: 6
- `walk`: 6

## Best Score Row

- run_id: `local_transfer_20260622__candidates__jg_s128_v14_control__walk__walk_s128_i2_h40_c20_k8_sig0p04_0p1_0p18_seed0__metrics__0b1b80d1`
- motion: `walk`
- config: `s128_i2_h40_c20_k8_seed0`
- score: `-1.099699355661869`
- duration_sec: `120.713`

## Claims

| claim | evidence | confidence | limitations |
|---|---|---|---|
| Metric-local frontier gains did not become the new mainline because visual quality was worse than best_s128. | local frontier, transfer, recovery, and L145 visual review rows | medium | The conclusion depends on qualitative visual review in addition to metrics. |
| Follow-up optimization should return to best_s128 rather than continue from the local-frontier candidates. | milestone_snapshot.md and primary_metrics.csv | medium | Some candidates pass individual transfer checks but not the overall quality bar. |

## Limitations

- This is a migrated registry package; it does not rerun rollouts.
- Raw source artifacts are referenced in `artifacts.md`, not stored in git.
- Qualitative video judgments are preserved as historical conclusions; videos remain external artifacts.

## Artifacts

See `artifacts.md`.
