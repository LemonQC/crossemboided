# 2026-11-06 — 停止 Oracle 循环，交付正式跨行为实验代码

> 归档范围：本轮用户原文和助手当前决策/交付的文字记录；不是之前全部聊天的完整逐字导出。**本次 GitHub 提交只有 Markdown 文档，不含任何算法源代码或 ZIP 文件。**

## 用户（原文）

那你给出建议啊，改进啊，代码啊

## 助手本轮回复（实质内容记录，非完整 UI 字节原样导出）

已经生成并本地交付 **FormalCrossBehavior_ManiSkill_v1.zip**（下载仅在聊天附件中，不上传到 GitHub）和 README_RUN.md。新方案不再追加旧 PickCube Oracle 或 BC 的补丁版本，不使用 Codex。

研究任务为 `MoveCubeSameGoal-v1`：同一 ManiSkill Panda、同一目标、同一物体、同一状态/动作接口 `pd_joint_pos`；两种操作为 Push 与 Pick-and-Place，均使用 ManiSkill 官方 Panda 运动规划接口，必须真实满足相应行为约束。

先运行 Stage A：两个专家各在 20 个同一批种子下尝试，至少 18/20 成功且检查初始状态一致，再进入 Stage B。Stage B 使用 20 Pick、20 Pick+40 Push、60 Pick、100 Pick 四组数据，每组分别训练本地 BC 和 DP-lite 共 8 个条件，每种在相同 50 个 held-out seeds 上做真实闭环评估。60 Pick 用于匹配混合组数据总量，100 Pick 是大样本正控，不参与小数据公平排名。

Linux 项目入口：

```bash
cd /mnt/4Tdata/LemonData/cross_behavior_4090_v1
conda activate cbl4090_clean
unzip -o FormalCrossBehavior_ManiSkill_v1.zip
bash run_stage_a.sh
bash run_stage_b.sh
cat formal_results/summary.md
```

也支持 `bash run_formal.sh` 串行执行且由 Stage A 决定是否进入训练。包内包含统一环境、双专家、演示采集、数据、BC/DDPM-lite 训练、在线评估和报告脚本。已通过本地 Python 编译、合成数据模型单元测试和 ZIP 校验，但作者环境缺少 ManiSkill，**未在用户 GPU 服务器完成真实物理仿真验证**，绝不编造成功率。

边界：DP-lite 为本地条件扩散动作序列模型，不是 ManiSkill 官方 Diffusion Policy；Cross-Behavior Object Flow、Im2Flow2Act、XSkill 论文方法未在这个包里复现；本阶段仅研究跨行为、非跨具身。后续需以初步结果决定是否进行这些强基线与 T-RO 深化，不能提前宣称创新成立。
