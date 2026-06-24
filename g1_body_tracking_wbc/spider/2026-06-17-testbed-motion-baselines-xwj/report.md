# Testbed Motion Baselines

Experiment ID: `2026-06-17-testbed-motion-baselines-xwj`

## Summary

This package registers the packaged spider testbed baselines for G1 body tracking WBC. It covers `walk`, `jump`, and `qixing` for no-MPC reference rows and Spider-native WBC method variants. Raw rollouts, commands, videos, and logs stay in `g1_wbc_testbed_motion_package_20260617` and are indexed in `run_index.csv` / `artifacts.md`.

The primary Spider-native baseline comparison is the 9-row set formed by `g1_wbc_joint_global`, `g1_wbc_joint`, and `g1_wbc_ee` across the three motions. The 3 `no_mpc` rows are kept in the metrics table as reference anchors, not as optimized WBC runs.

## Primary Metrics

| motion | method | score | global_sum | local_sum | contact | ctrl | acc |
|---|---|---:|---:|---:|---:|---:|---:|
| walk | no_mpc | -1.926464762 | 0.4690858573 |  | 0.237499997 | 0.1448167711 | 86.07175446 |
| walk | g1_wbc_joint | -0.9784627568 | 0.1334418803 | 0.04734018445 | 0.1243750006 | 0.1433157027 | 80.7442627 |
| walk | g1_wbc_joint_global | -1.035968135 | 0.135597378 | 0.05473525263 | 0.1343749911 | 0.1488954425 | 84.31878662 |
| walk | g1_wbc_ee | -0.963920165 | 0.1023334283 | 0.05003932677 | 0.131249994 | 0.1445464641 | 84.05030823 |
| jump | no_mpc | -9.089566199 | 4.67947793 |  | 0.3924999833 | 0.2545717657 | 147.9413605 |
| jump | g1_wbc_joint | -6.375595711 | 2.962807238 | 0.05290101469 | 0.3712500036 | 0.2524214983 | 140.5826263 |
| jump | g1_wbc_joint_global | -2.078044441 | 0.1563242264 | 0.06442904472 | 0.3549999893 | 0.3372446895 | 191.871994 |
| jump | g1_wbc_ee | -2.094175745 | 0.1682856791 | 0.05923711509 | 0.3574999869 | 0.3486168087 | 197.4255829 |
| qixing | no_mpc | -1.972241569 | 0.4047919363 |  | 0.2337500006 | 0.1967930794 | 79.6673584 |
| qixing | g1_wbc_joint | -1.532574068 | 0.2333531156 | 0.06938531622 | 0.2106249928 | 0.1731125116 | 67.87877655 |
| qixing | g1_wbc_joint_global | -1.372238962 | 0.1382661648 | 0.07728167064 | 0.206249997 | 0.186249733 | 73.07279968 |
| qixing | g1_wbc_ee | -1.403355256 | 0.1606904194 | 0.06529192626 | 0.2074999958 | 0.1843123883 | 74.04146576 |

## Claims

| claim | evidence | confidence | limitations | next validation |
|---|---|---|---|---|
| Packaged testbed baselines are the reference anchor for subsequent G1 body tracking WBC experiments. | `primary_metrics.csv` has packaged metrics; `run_index.csv` points to raw artifacts. | baseline | Runtime durations are not consistently preserved in packaged metrics. | Keep this package immutable; add superseding baseline packages if rerun. |
| Spider-native WBC should be compared primarily over 9 rows, excluding no-MPC reference rows. | `primary_metrics.csv` rows with method `g1_wbc_*`. | baseline | Jump rows have `success=false`, so score alone is not sufficient. | Any new baseline should report score, success, global, local, contact, smooth, and wall-clock together. |

## Artifacts

See `artifacts.md`.
