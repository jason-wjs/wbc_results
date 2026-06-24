# Baseline Checkpoints

This directory versions baseline model checkpoints that are part of the shared
experiment contract.

Checkpoint files are tracked with Git LFS.

| checkpoint | path | bytes | sha256 | role |
|---|---|---:|---|---|
| BC policy model | `model_8000.pt` | 152767861 | `98738b9214d12146dc7f4669cb65dfde9d835f4a133e5f2cbaef4e60b1e5b88f` | Current Spider no-MPC baseline checkpoint |

Source:

`../wxy/0608_ckpt_bc/model_8000.pt`

Do not add rollout checkpoints, intermediate training snapshots, or exploratory
model artifacts here. Use this directory only for shared baseline checkpoints
needed to reproduce reviewed experiment packages.
