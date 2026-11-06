# 2026-11-06 — Oracle v12.1 expert replay: expert succeeds, BC fails on same start

> Archive scope: the current user's reported results are reproduced below. Assistant analysis and v13 instructions are described separately and are not claimed as a complete verbatim transcript. **No code is uploaded to GitHub**; the v13 diagnostic ZIP is provided only through the chat.

## User (verbatim report)

```text
nzip -o RoboMimic_Oracle_Replay_v12_1.zip

unset DISPLAY WAYLAND_DISPLAY

HF_HUB_OFFLINE=1 TRANSFORMERS_OFFLINE=1 \
python diagnose_oracle_v12.py \
  --task PickCube-v1 \
  --episodes 3 \
  --model bc \
  --steps 150

cat results/pilot_v12/expert_replay_v12.md
Archive:  RoboMimic_Oracle_Replay_v12_1.zip
  inflating: diagnose_oracle_v12.py
  inflating: README_FIX_v12_1.md
ROBOMIMIC WARNING(
    No private macro file found!
    It is recommended to use a private macro file
    To setup, run: python /mnt/4Tdata/LemonData/cross_behavior_4090_v1/upstream/robomimic/robomimic/scripts/setup_macros.py
)

============= Initialized Observation Utils with Obs Spec =============

using obs modality: low_dim with keys: ['state']
using obs modality: rgb with keys: []
using obs modality: depth with keys: []
using obs modality: scan with keys: []
2026-11-06 22:01:40,375 - mani_skill  - WARNING - shader_dir argument will be deprecated after ManiSkill v3.0.0 official release. Please use sensor_configs/human_render_camera_configs to set shaders.
traj_0: oracle once/end=True/True drift_first={'dimensions_match': True, 'observed_dim': 42, 'reference_dim': 42, 'mae': 0.0, 'max_abs': 0.0}
traj_0: learned bc once/end=False/False, first_action_l2=0.01957
traj_1: initial observation cannot be reproduced: not_aligned
traj_2: initial observation cannot be reproduced: not_aligned
SAVED: /mnt/4Tdata/LemonData/cross_behavior_4090_v1/results/pilot_v12/expert_replay_v12.json
SAVED: /mnt/4Tdata/LemonData/cross_behavior_4090_v1/results/pilot_v12/expert_replay_v12.md
```

## Report excerpt (user-provided)

# v12 ManiSkill expert replay versus learned BC

**This is a diagnostic, not an independent benchmark.** Source expert initializations are used, not the 6000+ evaluation seeds.

| Trajectory | Initial alignment | Expert once/end | BC once/end | First-step action L2 | First-next-state max error |
|---|---|---|---|---:|---:|
| traj_0 | recorded_reset | True/True | False/False | 0.01957 | 0 |
| traj_1 | not_aligned | — | — | — | — |
| traj_2 | not_aligned | — | — | — | — |

The user pasted the report twice; its outcome in both copies was the same.

## Assistant — analysis and decision (summary)

- On traj_0, the saved expert actions genuinely reproduce success with exactly matched initial state and first next state, while the 20-epoch BC policy fails from the same start. This is evidence of real closed-loop difficulty, but does not yet establish the root cause or prove failure on all trajectories.
- traj_1 and traj_2 were **not aligned**; they must not be counted as failed replays. Need distinguish reused environment reconfiguration from missing or incompatible saved initial state.
- Do not train more epochs, download more demonstrations, or change the BC algorithm yet.
- A new local-only artifact `RoboMimic_Oracle_Diagnostics_v13.zip` was created. It makes a fresh ManiSkill environment for each trajectory, reports detailed reset/restore mismatch dimensions, matches converted demos to the train/valid split by observation contents, and logs teacher-forced BC action errors and online divergence on aligned trajectories. The code ZIP is shared only for direct download, not committed to GitHub. Its scripts passed Python syntax and synthetic HDF5 tests, but not real GPU-host replay.

## User-facing v13 instruction

```bash
cd /mnt/4Tdata/LemonData/cross_behavior_4090_v1
conda activate cbl4090_clean
unzip -o RoboMimic_Oracle_Diagnostics_v13.zip
unset DISPLAY WAYLAND_DISPLAY
export HF_HUB_OFFLINE=1 TRANSFORMERS_OFFLINE=1
python diagnose_oracle_v13.py --task PickCube-v1 --episodes 3 --model bc --steps 150
cat results/pilot_v13/expert_replay_v13.md
```

This is a limited diagnostic, not a generalization benchmark.
