# 2026-11-06 当前对话记录：RoboMimic Smoke 结果

> 归档范围：当前用户消息与助手本轮答复。附带 CSV 和 MD 内容按用户上传文件的文本记录。此前聊天的完整逐字归档仍未完成。此次只提交聊天文档，**不上传代码**。

## 用户（原文）

这是结果：Collected 2 actual rollout records: /mnt/4Tdata/LemonData/cross_behavior_4090_v1/results/all_in_one/summary.csv / /mnt/4Tdata/LemonData/cross_behavior_4090_v1/results/all_in_one/summary.md
(cbl4090_clean) ubuntu@ubuntu-System-Product-Name:/mnt/4Tdata/LemonData/cross_behavior_4090_v1$ ，附件我上传了

## 附件内容（原文）

`summary.csv`

```csv
source,task,method,episodes,eval_seed,success_once,success_at_end
results/all_in_one/PickCube-v1_bc_100_2_seed42_rollout.json,PickCube-v1,robomimic_official,2,6000,0.0,0.0
results/all_in_one/PickCube-v1_bc_gmm_100_2_seed42_rollout.json,PickCube-v1,robomimic_official,2,6000,0.0,0.0
```

`summary(2).md`

```markdown
# Actual rollout results only

No unrun algorithm or test has been assigned a score.

| Record | Task | Method | Episodes | Success once | Success at end |
|---|---|---|---:|---:|---:|
| results/all_in_one/PickCube-v1_bc_100_2_seed42_rollout.json | PickCube-v1 | robomimic_official | 2 | 0.0% | 0.0% |
| results/all_in_one/PickCube-v1_bc_gmm_100_2_seed42_rollout.json | PickCube-v1 | robomimic_official | 2 | 0.0% | 0.0% |
```

## 助手回复（原文字句和执行命令，纯 Markdown 表达）

这次有实质性进展了。**RoboMimic 官方 BC 和 BC-GMM 已经完成最小训练测试，并生成了实际 ManiSkill Rollout 评估结果。** 之前的依赖安装、CLIP 自动下载、数据集划分等问题，至少没有阻止这两次实验完成。

我检查了你上传的 `summary.csv` 和 `summary.md`。

### 一、目前的实验结果

| 算法 | 训练预算 | 测试 Episodes | Success Once | Success at End |
|---|---:|---:|---:|---:|
| RoboMimic BC | 2 Epoch | 2 | 0% | 0% |
| RoboMimic BC-GMM | 2 Epoch | 2 | 0% | 0% |

**这个结果完全不足以判断算法性能，更不能用来否定研究思路。**

原因是训练只有 2 Epoch，而且每种算法仅测试 2 次。我们设计 `smoke` 的目的只是验证完整流程能否运行，不是验证学习效果。

还有一个需要修正的小问题：CSV 的 `method` 字段都写成了 `robomimic_official`，没有区分 BC 和 BC-GMM。现在只能通过文件名区分算法，正式对比表必须修复这个标识。

### 二、正式对比前的两个修复

本地提供 `fix_robomimic_v9.py`（**代码没有提交 GitHub**），修复当前模型 checkpoint 选择范围以及评估 JSON 的方法标识。

```bash
cd /mnt/4Tdata/LemonData/cross_behavior_4090_v1
conda activate cbl4090_clean
python fix_robomimic_v9.py
```

```bash
python - <<'PY'
import json
from pathlib import Path
for p in sorted(Path("results/all_in_one").glob("*_2_seed42_rollout.json")):
    d = json.loads(p.read_text())
    print(p.name)
    print("  checkpoint:", d.get("checkpoint"))
    print("  success_once:", d.get("success_once"))
    print("  success_at_end:", d.get("success_at_end"))
PY
```

原 v7 脚本会从所有 RoboMimic 模型目录寻找最新 checkpoint；本次修复让它只选择当前方法对应的实验目录。之前两个 0% 的归属应以实际 JSON 的 checkpoint 路径核实，不能只凭汇总文件名。

### 三、下一步 Pilot

```bash
HF_HUB_OFFLINE=1 TRANSFORMERS_OFFLINE=1 \
bash scripts/50_run_everything.sh \
pilot PickCube-v1 100 42

bash scripts/50_run_everything.sh report
cat results/all_in_one/summary.md
```

20 Epoch × 6 种 BC 变体，每种 20 次 Rollout。这个阶段只能探索模型表现，正式结果需更多回合和多个随机种子。
