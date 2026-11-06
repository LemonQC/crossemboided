# 2026-11-06 — 前期低成本统一验证：本轮记录

## 用户原话（逐字）
好的，那记着点，每次聊天都保存到github哈，都推送一下。现在我需要怎么干，你需要重新生成可以运行的算法，我去测试么，或者基于开源的去复现，但是尽量保持一个环境，咱们是前期验证，不要耗费太多资源

## 执行决策
- 以 `cbl4090` 为主环境、ManiSkill 为统一闭环仿真平台；不默认下载 Im2Flow2Act 大型权重或建立多个 Conda 环境。
- 已跑通 ManiSkill 官方 DP/ACT，保留其 checkpoint；正在跑的三个轻量 BC 模型不重复启动，也不冒充论文官方实现。
- 优先完成官方 RoboMimic BC 家族的低成本 smoke test（2 epochs），然后按需用 pilot（20 epochs）；完整训练须显式确认。
- 保留同一任务、不同成功行为的真实性门槛。普通 PickCube 不自动构成跨行为数据，现阶段的 BC 成功率只能校准流程，不能证明 T-RO 创新。
- 新增单环境 v5 包：`scripts/30_preflight.py`、`scripts/31_low_cost_baselines.sh`、`scripts/32_cross_behavior_readiness.py`，对应 `docs/VALIDATION_PLAN_2026-11-06.md`。本地检查通过；4090 训练待用户运行。
- 代码包本次对话交付：`CrossBehavior_4090_SingleEnv_Validation_v5.zip`。仓库代码也需与用户本地项目同步，不应误称已经完成端到端 GPU 复现。

## 执行命令
在**有 `data_paths/PickCube-v1.txt` 的原始项目根目录**叠加 v5，不要直接在 v4 CrossPaper 独立目录下运行：
```bash
unzip -o CrossBehavior_4090_SingleEnv_Validation_v5.zip
conda activate cbl4090
python scripts/30_preflight.py --task PickCube-v1 --number 100
CBL_RUN_EXTRA=0 bash scripts/31_low_cost_baselines.sh PickCube-v1 100 smoke 42
# 成功后：
CBL_RUN_EXTRA=0 bash scripts/31_low_cost_baselines.sh PickCube-v1 100 pilot 42
```
注意：RoboMimic 接入依赖 v3 的 `cbl_official/` 和 `scripts/10_*.sh` 至 `14_*.sh`。若未安装，不要误判为算法本身失败。

## GitHub 与原话保真
此文件中“用户原话”是逐字内容；“执行决策”为整理后的研究记录，**不是助理消息的逐字转录**。完整历史逐字归档仍需官方对话导出。禁止声称聊天结束后会后台自动保存。