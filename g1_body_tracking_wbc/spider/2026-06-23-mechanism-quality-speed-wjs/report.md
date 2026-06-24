# G1 WBC Mechanism Experiments Report

Date: 2026-06-23

Scope: this stage did not run full `bench_data`. It tested jump/walk/qixing sample budgets, then used `jump` as the mechanism probe motion. The quality floor is the current acceptable `best_s128`; the long-term target is packaged `baseline_8192`.

Metric grouping:

- `global_sum = root_pos + body_global_pos + ee_global_pos`
- `local_sum = body_local_pos + ee_local_pos`
- `contact = contact_mismatch_rate`
- `smooth = control_delta_mean / joint_acc_mean`
- Score is higher-is-better; all other metrics are lower-is-better.

## Source Artifacts

- Stage A budget curve: `outputs/g1_wbc_mechanism_20260623/stage_a_budget_curve/summary.csv`
- Jump repeats: `outputs/g1_wbc_mechanism_20260623/stage_a_jump_repeats/summary.csv`
- Stage B structure: `outputs/g1_wbc_mechanism_20260623/stage_b_structure/**/summary.csv`
- Stage C mechanisms: `outputs/g1_wbc_mechanism_20260623/stage_c_mechanisms/**/summary.csv`

## Main Conclusions

1. `nsamples` matters, but it is not monotonic and is not the best lever for speed-quality tradeoff. On jump, `s512` is the current sample sweet spot; `s2048` improves global/smooth a little, but is about 3.4x slower than `s512` and less stable on contact/score across seeds.

2. Runtime is dominated by rollout/evaluation budget. Stage A runtime is roughly linear in samples with fixed overhead: `s128` around 112-120s, `s512` around 178-203s, `s2048` around 581-713s on this 4070 laptop. High samples also show bad tail latency.

3. `mpc_command_reg_weight=0.005` is the strongest algorithmic result in this stage. It lifts jump `s128` from score `-2.2037` to `-2.0561` in about `112s`, exceeding the packaged jump baseline score `-2.0780` while staying much faster than `s512` and `s2048`.

4. `i3/s512` is the best quality-oriented jump setting found here. It reaches score `-1.9812`, global_sum `0.1453`, and contact `0.3413`, beating the packaged baseline on score/global/contact, but it is slower than `i2/s512` and still worse than baseline on smooth.

5. The unresolved gap is smoothness versus packaged baseline. Even the strong candidates still have higher `control_delta_mean` and `joint_acc_mean` than baseline. Current command smoothness penalty `0.0001` did not solve this cleanly.

## Stage A: Sample Budget Across Motions

Best single-seed budget by metric:

| motion | score best | global best | local best | contact best | smooth best | note |
|---|---:|---:|---:|---:|---:|---|
| jump | s512 `-2.0607` | s2048 `0.1697` | s2048 `0.0676` | s512 `0.3344` | s2048 ctrl `0.4244`, acc `214.0` | s512 is score/contact sweet spot; s2048 mainly improves tracking/smooth. |
| walk | s2048 `-1.0735` | s2048 `0.1406` | s96 `0.0514` | s128 `0.1287` | s96 ctrl `0.1790`, acc `95.9` | s128 is already near score best; high samples have tiny score gain. |
| qixing | s2048 `-1.4726` | s192 `0.1946` | s1024 `0.0704` | s2048 `0.2050` | s2048 ctrl `0.2152`, acc `83.7` | sample helps score/contact at high budget, but global is non-monotonic. |

Jump three-seed repeats:

| samples | success | score mean | global_sum | local_sum | contact | ctrl | acc | duration |
|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| 128 | 1/3 | `-2.2193` | `0.2401` | `0.0716` | `0.3525` | `0.4540` | `225.1` | `115.1s` |
| 512 | 2/3 | `-2.0536` | `0.1863` | `0.0696` | `0.3346` | `0.4457` | `217.4` | `188.7s` |
| 2048 | 2/3 | `-2.1080` | `0.1770` | `0.0695` | `0.3533` | `0.4233` | `212.6` | `641.2s` |

Interpretation: `s512` is the better Pareto point for jump. `s2048` buys smoother and slightly better global tracking, but the score/contact variance and runtime cost are not justified for the main speed target.

## Stage B: Structure Factors On Jump

Anchor: `s512/i2/h40/c20/k8`, score `-2.0607`, global_sum `0.1947`, contact `0.3344`, ctrl `0.4401`, acc `217.7`, runtime `203.5s`.

| variant | score | global_sum | local_sum | contact | ctrl | acc | duration | verdict |
|---|---:|---:|---:|---:|---:|---:|---:|---|
| i1 | `-2.5858` | `0.4494` | `0.0845` | `0.3556` | `0.5078` | `244.7` | `117.4s` | Too little optimization depth. |
| i3 | `-1.9812` | `0.1453` | `0.0639` | `0.3413` | `0.4163` | `212.6` | `276.9s` | Best quality setting; slower but better than raising samples to 2048. |
| k4 | `-2.6747` | `0.5538` | `0.0820` | `0.3419` | `0.3715` | `194.8` | `173.6s` | Smooth but under-expressive; tracking collapses. |
| k12 | `-2.3972` | `0.3229` | `0.0710` | `0.3594` | `0.5639` | `249.6` | `182.5s` | Worse quality and smoothness. |
| k16 | `-2.8916` | `0.6371` | `0.0725` | `0.3587` | `0.6706` | `286.0` | `193.4s` | Too high-dimensional for s512. |
| h20/c10 | `-8.8669` | `4.5793` | `0.0609` | `0.3713` | `0.2516` | `148.4` | `314.8s` | Short lookahead fails despite smooth output. |
| h80/c20 | `-2.1987` | `0.1638` | `0.0776` | `0.3662` | `0.4020` | `207.3` | `268.3s` | Better global, worse score/contact/local. |
| h80/c40 | `-2.2804` | `0.1893` | `0.0853` | `0.3775` | `0.4127` | `210.6` | `136.7s` | Faster, but quality below floor. |

Interpretation: keep `h40/c20/k8` as the structure anchor. If quality is prioritized, `i3` is a better upgrade than increasing samples or horizon. If speed is prioritized, `i1`, `h80/c40`, and `k4` do not meet the quality floor.

## Stage C: Algorithm Mechanisms On Jump

| variant | samples | score | global_sum | local_sum | contact | ctrl | acc | duration | verdict |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---|
| base | 128 | `-2.2037` | `0.2204` | `0.0727` | `0.3562` | `0.4553` | `230.2` | `120.2s` | Current low-sample floor is unstable. |
| warm-best | 128 | `-2.1205` | `0.1980` | `0.0724` | `0.3456` | `0.4496` | `226.9` | `113.5s` | Helps low samples. |
| warm-best | 256 | `-2.1024` | `0.1729` | `0.0719` | `0.3469` | `0.4604` | `228.4` | `138.5s` | Good tracking/contact, smooth not improved. |
| warm-best | 512 | `-2.1267` | `0.2283` | `0.0775` | `0.3356` | `0.4501` | `222.1` | `198.3s` | Regresses at higher sample. |
| warm-mean-0.8 | 128 | `-2.2597` | `0.2565` | `0.0746` | `0.3481` | `0.4890` | `227.9` | `111.3s` | Worse than base/warm-best. |
| warm-mean-0.8 | 256 | `-2.4045` | `0.2365` | `0.0715` | `0.4031` | `0.4543` | `225.0` | `133.9s` | Bad contact. |
| warm-mean-0.8 | 512 | `-2.1043` | `0.1914` | `0.0688` | `0.3450` | `0.4281` | `216.3` | `192.8s` | Acceptable, but not better than reg. |
| reg0.005 | 128 | `-2.0561` | `0.1772` | `0.0681` | `0.3363` | `0.4372` | `221.1` | `112.0s` | Best speed-quality candidate. |
| reg0.005 | 256 | `-2.0628` | `0.1804` | `0.0697` | `0.3381` | `0.4438` | `220.0` | `139.1s` | Similar quality, more cost. |
| reg0.005 | 512 | `-2.0562` | `0.2030` | `0.0671` | `0.3312` | `0.4300` | `216.1` | `184.9s` | Best contact/local, not best global. |
| smooth0.0001 | 128 | `-2.1820` | `0.2150` | `0.0698` | `0.3519` | `0.4675` | `225.0` | `112.4s` | Not enough. |
| smooth0.0001 | 256 | `-2.2210` | `0.2103` | `0.0701` | `0.3681` | `0.4397` | `221.5` | `135.9s` | Contact/score regress. |
| smooth0.0001 | 512 | `-2.0563` | `0.1798` | `0.0708` | `0.3400` | `0.4412` | `220.3` | `175.4s` | Good score, weaker than reg on speed-quality. |

Packaged jump baseline reference:

- score `-2.0780`
- global_sum `0.1563`
- contact `0.3550`
- ctrl `0.3372`
- acc `191.9`

Key candidates versus packaged baseline:

- `reg0.005/s128`: score better by `+0.0219`; contact better by `-0.0187`; global still worse by `+0.0208`; smooth still worse by ctrl `+0.1000`, acc `+29.3`; runtime `112.0s`.
- `i3/s512`: score better by `+0.0968`; global better by `-0.0111`; contact better by `-0.0137`; smooth still worse by ctrl `+0.0790`, acc `+20.7`; runtime `276.9s`.
- `base/s2048`: score only slightly better by `+0.0028`; global worse by `+0.0134`; smooth worse by ctrl `+0.0872`, acc `+22.1`; runtime `664.9s`.

## Current Ranking Of Factors

1. `command_reg_weight`: strongest quality-per-second lever. It improves score/global/contact at low samples without runtime cost.
2. `mpc_num_iterations`: increasing `i2 -> i3` is the best quality lever, and more efficient than `s2048`.
3. `mpc_num_samples`: useful up to `s512` on jump, weak/non-monotonic beyond that; motion-dependent on walk/qixing.
4. `horizon/control`: very sensitive; `h40/c20` is a good anchor. Short lookahead fails jump; long horizon helps global but hurts score/contact/local or cost.
5. `knot_count`: `k8` is the current balance. `k4` is too smooth/under-expressive; `k12/k16` dilute search and worsen smoothness.
6. `warm_start`: `best` helps low samples but is not stable at `s512`; `mean/0.8` is not recommended.
7. `command_smooth_weight=0.0001`: not a strong mechanism as configured.

## Next Recommended Experiments

1. Repeat `reg0.005/s128` and `reg0.005/s256` across seeds 1/2 and across walk/qixing. This is the most important validation before treating command reg as a general solution.
2. Sweep command reg around the discovered point: `0.001, 0.002, 0.005, 0.01`, preferably on `s128/s256` first.
3. Test combinations that directly follow from this stage:
   - `reg0.005 + i3/s512` as a quality ceiling candidate.
   - `reg0.005 + warm-best/s128` only if reg repeats show seed stability.
   - lower command smooth values such as `0.00002, 0.00005`, because `0.0001` did not cleanly improve smoothness.
4. Keep reporting all four groups separately. Score alone hides failures: `k4` and `h20/c10` look smoother but fail global tracking; `h80/c20` improves global but fails contact/local/score.

