# Testbed Motion Data

This directory versions the three shared testbed motion inputs used by the
migrated G1 body-tracking WBC experiment packages.

| motion | path | bytes | sha256 |
|---|---|---:|---|
| walk | `walk/motion.npz` | 22100738 | `a9baaa714d61da19c6114077cf0c919c965ad6802f770cc83ed695396c4c8c9f` |
| jump | `jump/motion.npz` | 21907202 | `07b3b8e1bf9ba3f94dfbe552819cd792f81a06a3c4ff6e5029b55b2897b7c544` |
| qixing | `qixing/motion.npz` | 2481922 | `825281f62dde581874b37410becbe6d6f137f78a4159c346cc63601cfef70032` |

Source:

`../g1_wbc_testbed_motion_package_20260617/input_motions/{walk,jump,qixing}/motion.npz`

This is the only allowed `.npz` data directory in `wbc_results`. Raw rollout
files, MPC command arrays, videos, logs, checkpoints, and full output trees
remain excluded from git.
