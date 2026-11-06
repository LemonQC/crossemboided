# 2026-11-06 — 用户要求结束 Oracle 循环、转向正式跨行为实验

> 本文件包含用户本轮提供的 v13 报告原文（用户第二次重复粘贴同一报告未在下面重复），以及助手明确研究决定的聊天摘录。不是整个账户聊天历史逐字导出。没有上传任何可执行代码。

## 用户原文（首次报告）

你一直在做Oracle的实验，感觉做一周也进入不了正式的实验，永远停留在测试上，这是上次结果，你要好好想想，减少这个，确定方针：(cbl4090_clean) ubuntu@ubuntu-System-Product-Name:/mnt/4Tdata/LemonData/cross_behavior_4090_v1$ cat results/pilot_v13/expert_replay_v13.md
# v13 Fresh-env expert replay versus learned BC

**This is a diagnostic, not an independent benchmark.** Source expert initializations are used, not the 6000+ evaluation seeds.

- Source: `/mnt/4Tdata/LemonData/cross_behavior_4090_v1/data/maniskill/demos/rigid_body/PickCube-v1/motionplanning/trajectory.state.pd_ee_delta_pos.physx_cpu.h5`
- Metadata: `/mnt/4Tdata/LemonData/cross_behavior_4090_v1/data/maniskill/demos/rigid_body/PickCube-v1/motionplanning/trajectory.state.pd_ee_delta_pos.physx_cpu.json`
- Model: `/mnt/4Tdata/LemonData/cross_behavior_4090_v1/runs/robomimic/PickCube-v1/demos_100_seed_42/official-bc-seed42/20261106202030/models/model_epoch_20.pth`
- Environment kwargs: `{"obs_mode": "state", "control_mode": "pd_ee_delta_pos", "render_mode": "rgb_array", "reward_mode": null, "shader_dir": "default", "sim_backend": "physx_cpu", "reconfiguration_freq": 1, "max_episode_steps": 150}`

| Trajectory | Initial alignment | Expert once/end | BC once/end | First-step action L2 | First-next-state max error |
|---|---|---|---|---:|---:|
| traj_0 | recorded_reset | True/True | False/False | 0.01957 | 0 |
| traj_1 | not_aligned | — | — | — | — |
| traj_2 | not_aligned | — | — | — | — |

## Diagnostics (read-only)

### traj_0
- Alignment: **recorded_reset**, details: none
- recorded_reset_comparison: max_abs=0.0, MAE=0.0, top diffs=[{'index': 41, 'observed': 0.2689334452152252, 'reference': 0.2689334452152252, 'abs_diff': 0.0}, {'index': 40, 'observed': -0.055625684559345245, 'reference': -0.055625684559345245, 'abs_diff': 0.0}, {'index': 39, 'observed': 0.027564413845539093, 'reference': 0.027564413845539093, 'abs_diff': 0.0}, {'index': 38, 'observed': -0.1621522456407547, 'reference': -0.1621522456407547, 'abs_diff': 0.0}]
- Matched converted demonstration: {'matched': True, 'nearest_demo': 'demo_0', 'max_abs_difference': 0.0, 'split': 'cbl_train_seed42', 'tolerance': 0.0001}
- BC on recorded expert states (74 steps): MSE=0.0007679, per-dim RMSE=[0.0038944343104958534, 0.005951304454356432, 0.016450736671686172, 0.052445705980062485], gripper sign=100.0%
- BC online first10 state max abs deviations: [0.0, 0.023489773273468018, 0.04127557948231697, 0.04851479083299637, 0.05712234601378441, 0.06092700734734535, 0.06272181123495102, 0.06499390304088593, 0.06401655077934265, 0.057880327105522156]
- BC online first10 action L2 vs time-matched expert actions (**not same state**): [0.01957, 0.03344, 0.03975, 0.04159, 0.04002, 0.03727, 0.03504, 0.03149, 0.02632, 0.02491]

### traj_1
- Alignment: **not_aligned**, details: Restoring saved first env state still does not reproduce expert initial observation
- recorded_reset_comparison: max_abs=1.0, MAE=0.02380952425301075, top diffs=[{'index': 18, 'observed': 0.0, 'reference': 1.0, 'abs_diff': 1.0}, {'index': 41, 'observed': 0.226311594247818, 'reference': 0.226311594247818, 'abs_diff': 0.0}, {'index': 39, 'observed': 0.008445411920547485, 'reference': 0.008445411920547485, 'abs_diff': 0.0}, {'index': 38, 'observed': -0.14461831748485565, 'reference': -0.14461831748485565, 'abs_diff': 0.0}]
- restored_state_comparison: max_abs=1.0, MAE=0.02380952425301075, top diffs=[{'index': 18, 'observed': 0.0, 'reference': 1.0, 'abs_diff': 1.0}, {'index': 41, 'observed': 0.226311594247818, 'reference': 0.226311594247818, 'abs_diff': 0.0}, {'index': 39, 'observed': 0.008445411920547485, 'reference': 0.008445411920547485, 'abs_diff': 0.0}, {'index': 38, 'observed': -0.14461831748485565, 'reference': -0.14461831748485565, 'abs_diff': 0.0}]
- Matched converted demonstration: {'matched': True, 'nearest_demo': 'demo_1', 'max_abs_difference': 0.0, 'split': 'cbl_train_seed42', 'tolerance': 0.0001}

### traj_2
- Alignment: **not_aligned**, details: Restoring saved first env state still does not reproduce expert initial observation
- recorded_reset_comparison: max_abs=1.0, MAE=0.02380952425301075, top diffs=[{'index': 18, 'observed': 0.0, 'reference': 1.0, 'abs_diff': 1.0}, {'index': 41, 'observed': 0.028730589896440506, 'reference': 0.028730589896440506, 'abs_diff': 0.0}, {'index': 39, 'observed': 0.0008682608604431152, 'reference': 0.0008682608604431152, 'abs_diff': 0.0}, {'index': 38, 'observed': -0.16316817700862885, 'reference': -0.16316817700862885, 'abs_diff': 0.0}]
- restored_state_comparison: max_abs=1.0, MAE=0.02380952425301075, top diffs=[{'index': 18, 'observed': 0.0, 'reference': 1.0, 'abs_diff': 1.0}, {'index': 41, 'observed': 0.028730589896440506, 'reference': 0.028730589896440506, 'abs_diff': 0.0}, {'index': 39, 'observed': 0.0008682608604431152, 'reference': 0.0008682608604431152, 'abs_diff': 0.0}, {'index': 38, 'observed': -0.16316817700862885, 'reference': -0.16316817700862885, 'abs_diff': 0.0}]
- Matched converted demonstration: {'matched': True, 'nearest_demo': 'demo_2', 'max_abs_difference': 0.0, 'split': 'cbl_train_seed42', 'tolerance': 0.0001}

## Interpretation

- If initial alignment fails, recorded expert actions cannot be fairly replayed from the current reset state. Inspect task version, robot control configuration, and recorded reset kwargs/first-state restoration.
- If initial alignment holds but expert replay drifts immediately or fails, investigate simulator/control mismatch before spending GPU on training.
- If expert replay succeeds but BC fails on the **same initial state**, prioritize policy closed-loop error accumulation, action scaling, and observation distribution shift. This still does not prove a causal diagnosis.
- If expert and BC succeed from recorded starts but BC fails on held-out eval seeds, investigate test-state generalization rather than a broken action adapter.
- Policy and oracle use CPU physics with explicit metadata settings; the reported environment overrides must be checked against the original recorded metadata.
- A success rate must not be inferred when the environment exposes no success signal; such rows show `None`.

Full details including state/action discrepancies are stored in the accompanying JSON.

## 助手的当轮明确决定（内容摘录）

我之前的推进方式有问题：从 v7 反复调试到 v13，缺少明确停止条件。**停止 Oracle v14+；旧 PickCube 的六种 20 Epoch BC 只作为基础摸底结果，不再无目的地增加训练量。**

v13 的 traj_0 专家重放成功、首步状态一致，BC 同起点失败；traj_1/2 的第 18 维状态差异无法在现有证据下解释，但不再阻挡正式实验。

**研究目标：**在同一 ManiSkill 平台内构建“同一最终目标，由 Push 或 Pick-and-Place 完成”的统一 MoveCubeToGoal 环境，不能直接把官方 PushCube 和 PickCube 两个不同任务当作行为等效数据。第二项长序列验证为 Move-then-Stack；先同具身 Panda，再考虑实际跨具身机器人迁移。

**Go/No-Go 三阶段：**
A. 两种专家策略各测试 20 个独立起点，至少 18/20 成功；不达标最多集中修复一次，仍失败则换简单环境。
B. 固定 20 条目标机器人示范、额外 40 条异行为示范，做 BC/DP target-only 与 mixed、object-flow-transfer 真实对比；额外训练 100 条目标示范的 DP 作为可学习性正控，评估每方法先 50 episodes。不将强正控与低数据实验作公平排名。
C. 只有在现有 object-flow / naive transfer 失败模式可重复且体现接触可行性约束的情况下，才开发新方法，扩展长序列、跨具身和 ≥10 项忠实 baselines。

对应交付为 `Codex_Formal_Experiment_GoNoGo_v1.md` 本地文件，只提供用户下载给 Codex 执行，**不会作为代码提交到 GitHub**。主张尚未实验验证，不能宣称已达 T-RO 创新要求。
