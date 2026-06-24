# Fast Quality Pareto Probe

Experiment ID: `2026-06-23-fast-quality-pareto-wjs`

## Summary

Jump-focused sample-budget and Pareto probe before the mechanism-quality-speed experiment.

This package was migrated from `spider/outputs/g1_wbc_metrics_sync_20260623`. It preserves lightweight metrics, summaries, commands, and provenance. Raw copied `raw/` metrics, videos, rollouts, logs, and checkpoints are intentionally not committed.

## Scope

- rows in `primary_metrics.csv`: 15
- rows in `run_index.csv`: 15
- complete rows: 15
- successful rows: 7
- copied summary CSVs: 2

Family counts:

- `fast_quality_pareto_20260623`: 15

Motion counts:

- `jump`: 15

## Best Score Row

- run_id: `fast_quality_pareto_20260623__candidates__jg_s128_v14_control__jump__jump_s192_i2_h40_c20_k8_sig0p04_0p1_0p18_seed0__metrics__c2095a07`
- motion: `jump`
- config: `s192_i2_h40_c20_k8_seed0`
- score: `-2.1115755259990694`
- duration_sec: `125.602`

## Claims

| claim | evidence | confidence | limitations |
|---|---|---|---|
| Single-rollout comparisons are insufficient because repeated seeds show outcome variance. | fast_quality_pareto rows across seeds | medium | Jump-only probe; not a full cross-motion validation. |
| The Pareto probe motivated the next mechanism experiment rather than being a final algorithmic solution. | pareto_summary.csv and primary_metrics.csv | medium | Only a compact candidate family was tested. |

## Limitations

- This is a migrated registry package; it does not rerun rollouts.
- Raw source artifacts are referenced in `artifacts.md`, not stored in git.
- Qualitative video judgments are preserved as historical conclusions; videos remain external artifacts.

## Artifacts

See `artifacts.md`.
