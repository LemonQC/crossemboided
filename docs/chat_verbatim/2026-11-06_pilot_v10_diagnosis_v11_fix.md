# 2026-11-06 — RoboMimic Pilot v10 诊断与 v11 修复讨论

> 本文件为**当前轮对话关键内容摘录**，不是全量逐字记录；如需完整用户/助手消息，需原始对话导出。仅保存 Markdown 聊天记录，不上传任何代码文件。

## 用户（原文关键片段）

```text
Created GPT_Backbone model with number of parameters: 3156480
FAILED: stage=pilot line=52. See results/all_in_one/pilot_PickCube-v1_100_seed42.log
Saved: /mnt/4Tdata/LemonData/cross_behavior_4090_v1/results/all_in_one/pilot_diagnostic_v10.md
Saved: /mnt/4Tdata/LemonData/cross_behavior_4090_v1/results/all_in_one/pilot_diagnostic_v10.json
```

用户粘贴的 RoboMimic Pilot 诊断表：

| Method | Rollout exists | Once | End | Checkpoint matches method | Train log errors | Checkpoints |
|---|---|---:|---:|---|---|---:|
| bc | yes | 0.0% | 0.0% | True | False | 3 |
| bc_gmm | yes | 5.0% | 0.0% | True | False | 3 |
| bc_rnn | yes | 0.0% | 0.0% | True | False | 3 |
| bc_rnn_gmm | yes | 0.0% | 0.0% | True | False | 3 |
| bc_transformer | NO | — | — | — | False | 3 |
| bc_transformer_gmm | NO | — | — | — | None | 0 |

用户报告还包含以下完整性数据：100 条演示，42 维状态，4 维动作，训练与验证分割 80/20、不重叠且覆盖所有轨迹；动作 min/max 为 `[-0.17895, -0.18121, -0.34479, -1.0]` / `[0.19477, 0.16575, 0.40848, 1.0]`。

第 20 Epoch 日志：

| Model | Training loss | Validation loss |
|---|---:|---:|
| bc | 0.00091195 | 0.00221437 |
| bc_gmm | -18.70935 | 17435.76001 |
| bc_rnn | 0.00047889 | 0.00246181 |
| bc_rnn_gmm | -15.95312 | 41450.38438 |
| bc_transformer | 0.00248421 | 0.00234147 |

所报已评估 checkpoint 均来自各自目录，但位于 `last_bak.pth`；训练日志另有 `models/model_epoch_20.pth`。Transformer 训练使用 `frame_stack=10` 与 `context_length=10`，但没有 Rollout 记录。BC-Transformer-GMM 没有训练日志与 checkpoint。

## 助手分析与决定

确认基础数据集 80/20 划分合法、四个 BC 系列模型完成 20 Epoch，且 BC-Transformer 已训练成功但评估阶段报错。GMM 训练 NLL 为负并不必然错误，但与验证集数万量级的 NLL 差距极大，不能作为稳定性能指标。官方 RoboMimic BC_Transformer.get_action 接收历史序列；本地旧评估器传单帧，因此高度怀疑 Transformer rollout 时序输入维度不匹配，但缺少原始完整 traceback 不能百分之百确定。

新建本地交付 `RoboMimic_Pilot_Repair_v11.zip`，包含：`cbl_official/evaluate_v11.py`、`scripts/resume_pilot_v11.py`、`scripts/action_audit_v11.py` 与 `README_V11.md`。仅用户本地下载，**这些代码没有上传 GitHub**。

## 助手给出的操作指令（摘要）

```bash
cd /mnt/4Tdata/LemonData/cross_behavior_4090_v1
conda activate cbl4090_clean
unzip -o RoboMimic_Pilot_Repair_v11.zip
unset DISPLAY WAYLAND_DISPLAY
export HF_HUB_OFFLINE=1 TRANSFORMERS_OFFLINE=1

python scripts/action_audit_v11.py --task PickCube-v1 --demos 100 --seed 42 --epochs 20
cat results/pilot_v11/action_audit_v11.md

python scripts/resume_pilot_v11.py --task PickCube-v1 --demos 100 --seed 42 --epochs 20 --episodes 20 --methods bc_transformer bc_transformer_gmm --train-missing
cat results/pilot_v11/summary_v11.md
```

该工具只认 `models/model_epoch_20.pth`，不会使用 `last_bak.pth`；Transformer 在线评估会补足十帧状态历史；只训练缺失的 Transformer-GMM，旧 `results/all_in_one` 不覆盖。代码已本地静态与合成测试，未在用户 GPU 实际验证。

目前仍是同一具身、同一任务 PickCube 的基础算法实验，不能直接证明跨行为迁移，也不能判断 T-RO 假设成败。
