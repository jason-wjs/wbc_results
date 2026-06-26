# HomeJrHangMr Three-Way Rollout Comparison

Experiment ID: `2026-06-26-homejrhangmr-three-way-wjs`

## Summary

This package records a single-motion, full-length, no-render comparison of `no_mpc_baseline`, `sweetpoint`, and `n8192` on:

`/data_zcy/wxy/test_motion/homejrhangmr_dataset_pbhc_contact_maskACCADFemale1Walking_c3dB19-walktopickupbox_posespkl/motion.npz`

The source rollout artifacts remain under `/data_team/junsong/model-based/spider/outputs/g1_wbc_single_motion_homejrhangmr_compare_20260626` and are indexed from this registry package. As a one-off approved exception, the sweetpoint and n8192 rollout and MPC command npz files are also versioned under `assets/results/2026-06-26-homejrhangmr-three-way-wjs/`.

## Result Table

| config | score | root pos | body global pos | ee global pos | contact mismatch | control delta | action delta | joint acc | joint jerk |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| no_mpc_baseline | -1.633575 | 0.223149 | 0.222694 | 0.220326 | 0.075362 | 0.156196 | 0.372051 | 77.777100 | 83.646538 |
| sweetpoint | -0.904510 | 0.079301 | 0.082026 | 0.078572 | **0.061047** | 0.177741 | 0.418670 | 81.980911 | 95.954437 |
| n8192 | **-0.875192** | **0.054118** | **0.055350** | **0.052975** | 0.077035 | **0.147369** | **0.354116** | **70.790924** | **78.832199** |

## Interpretation

- `n8192` is best on score and global tracking. It reduces root position error from 0.0793 to 0.0541 versus sweetpoint, and from 0.2231 versus no-mpc.
- `n8192` is also smoothest on this run by control delta, action delta, joint acceleration, and joint jerk.
- `sweetpoint` is best on contact consistency: contact mismatch is 0.0610 versus 0.0770 for n8192. It also has lower false-negative and contact-switch rates than n8192.
- `no_mpc_baseline` succeeds but has much larger global position errors, making it useful mainly as the policy-only floor for this motion.

## Completeness

- runs: 3 / 3 complete
- rollout files indexed: no_mpc_baseline, sweetpoint, n8192
- rollout files stored in assets/results: sweetpoint, n8192
- MPC command files indexed: sweetpoint, n8192
- MPC command files stored in assets/results: sweetpoint, n8192
- videos rendered: 0
- seed: 0
- max steps: unset, full motion length

## Limitations

- Single motion and seed 0 only.
- No rendered video review was performed for this package.
- n8192 was completed on an empty-H100 cluster after the local shared-GPU attempt was paused; wall-clock timings are not used as comparable metrics.
- Raw `.npz` artifacts normally stay outside `wbc_results`; this package has a user-approved exception for the sweetpoint and n8192 rollout plus MPC command files.
