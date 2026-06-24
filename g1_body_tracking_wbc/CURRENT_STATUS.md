# G1 Body Tracking WBC Current Status

Last updated: 2026-06-24

## Current Baseline Anchor

The packaged spider testbed baselines are tracked in:

- `spider/2026-06-17-testbed-motion-baselines-xwj`

They cover `walk`, `jump`, and `qixing` for baseline method comparisons.

## Migrated Historical Stages

The historical sync package has been split into lightweight registry packages:

- `spider/2026-06-22-best-s128-low-sample-milestone-wjs`
- `spider/2026-06-22-local-frontier-diagnostics-wjs`
- `spider/2026-06-23-fast-quality-pareto-wjs`

Current historical conclusions:

- `best_s128` is the accepted low-sample quality lower bound before the
  mechanism stage.
- The local-frontier stage is preserved as a negative result: metric-local gains
  did not become the new mainline because visual quality did not beat
  `best_s128`.
- The fast-quality Pareto probe records seed variance and motivates comparing
  configurations across repeated rollouts rather than relying on one rollout.

## Current Experiment Status

The latest mechanism study is tracked in:

- `spider/2026-06-23-mechanism-quality-speed-wjs`

Current working conclusions:

- `s512/i2/h40/c20/k8` is the jump base-configuration sample sweet point.
- `i3/s512` is the current jump quality-oriented candidate.
- `mpc_command_reg_weight=0.005` is the strongest speed-quality mechanism
  candidate found so far and needs multi-seed / cross-motion validation.
- Smoothness remains the main gap versus packaged baseline.

See each package report for evidence and limitations.
