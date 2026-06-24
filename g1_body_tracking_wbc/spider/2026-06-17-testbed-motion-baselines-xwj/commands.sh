#!/usr/bin/env bash
set -euo pipefail

# This package migrates precomputed packaged baseline results from:
#   ../g1_wbc_testbed_motion_package_20260617
# Raw rollout/video/log artifacts are indexed in run_index.csv and artifacts.md.

# Example render inspection command for saved rollouts:
# python scripts/visualize_g1_wbc.py --device cpu \
#   --motion ../g1_wbc_testbed_motion_package_20260617/input_motions/jump/motion.npz \
#   --motion-type isaaclab --method saved \
#   --saved-rollout spider_baseline:../g1_wbc_testbed_motion_package_20260617/outputs/spider/jump/g1_wbc_joint_global/rollout.npz
