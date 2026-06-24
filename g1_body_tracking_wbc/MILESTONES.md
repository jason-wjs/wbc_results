# G1 Body Tracking WBC Milestones

## 2026-06-17 - Testbed Motion Baselines

Package: `spider/2026-06-17-testbed-motion-baselines-xwj`

Established packaged spider testbed baselines on `walk`, `jump`, and `qixing`
for no-MPC and WBC method comparisons.

## 2026-06-22 - best_s128 Low-Sample Milestone

Package: `spider/2026-06-22-best-s128-low-sample-milestone-wjs`

Recorded `best_s128` as the low-sample quality lower bound: not baseline-quality,
but much faster than the packaged 8192-sample baseline and good enough to serve
as the next optimization floor.

## 2026-06-22 - Local Frontier Diagnostics

Package: `spider/2026-06-22-local-frontier-diagnostics-wjs`

Preserved the local-frontier negative result. Several candidates improved local
metrics, but visual review and transfer/recovery checks did not justify using
them as the new mainline.

## 2026-06-23 - Fast Quality Pareto Probe

Package: `spider/2026-06-23-fast-quality-pareto-wjs`

Captured jump-focused sample-budget and repeated-seed Pareto evidence. This
stage established that single rollout comparisons are noisy enough that later
configuration comparisons should include repeatability checks.

## 2026-06-23 - Mechanism Quality-Speed Study

Package: `spider/2026-06-23-mechanism-quality-speed-wjs`

Identified jump `s512/i2/h40/c20/k8` as the base sweet point, `i3/s512` as the
quality-oriented candidate, and `command_reg_weight=0.005` as the strongest
speed-quality mechanism candidate.
