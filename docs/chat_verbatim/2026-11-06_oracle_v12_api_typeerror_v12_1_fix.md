# 2026-11-06 — Oracle Replay v12 调用参数错误与 v12.1 修复

> 此文件记录当前这一轮消息的原文以及助手处理要点。它不是此前全部历史对话的逐字导出。只归档 Markdown 聊天记录，未向仓库上传代码。

## 用户原文

```text
Archive:  RoboMimic_Oracle_Replay_v12.zip
  inflating: diagnose_oracle_v12.py  
  inflating: README_Oracle_v12.md    
ROBOMIMIC WARNING(
    No private macro file found!
    It is recommended to use a private macro file
    To setup, run: python /mnt/4Tdata/LemonData/cross_behavior_4090_v1/upstream/robomimic/robomimic/scripts/setup_macros.py
)
Traceback (most recent call last):
  File "/mnt/4Tdata/LemonData/cross_behavior_4090_v1/diagnose_oracle_v12.py", line 369, in <module>
    main()
  File "/mnt/4Tdata/LemonData/cross_behavior_4090_v1/diagnose_oracle_v12.py", line 307, in main
    policy, _ = fileutils.policy_from_checkpoint(str(checkpoint), device=device, verbose=False)
TypeError: policy_from_checkpoint() got multiple values for argument 'device'
(cbl4090_clean) ubuntu@ubuntu-System-Product-Name:/mnt/4Tdata/LemonData/cross_behavior_4090_v1$
```

## 助手答复（可核对的主要内容）

本次问题在 v12 脚本而非模型或训练：RoboMimic `policy_from_checkpoint` 的第一个位置参数是 `device`，原 v12 误把 checkpoint 路径传为第一个位置参数，再重复传入 `device=device`。应修改为：

```python
policy, _ = fileutils.policy_from_checkpoint(
    ckpt_path=str(checkpoint), device=device, verbose=False
)
```

已制作本地下载包 `RoboMimic_Oracle_Replay_v12_1.zip`，只修改这一处函数调用，保留 v12 其他代码。使用命令：

```bash
cd /mnt/4Tdata/LemonData/cross_behavior_4090_v1
conda activate cbl4090_clean
unzip -o RoboMimic_Oracle_Replay_v12_1.zip
unset DISPLAY WAYLAND_DISPLAY
HF_HUB_OFFLINE=1 TRANSFORMERS_OFFLINE=1 python diagnose_oracle_v12.py --task PickCube-v1 --episodes 3 --model bc --steps 150
cat results/pilot_v12/expert_replay_v12.md
```

已完成本地语法检查与 AST 参数检查，尚未在用户 ManiSkill 服务器上实际运行。**没有上传代码到 GitHub。**
