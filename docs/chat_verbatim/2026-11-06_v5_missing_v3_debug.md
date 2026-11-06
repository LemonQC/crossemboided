# 当前聊天逐字存档 — v5 缺少 v3 接入文件

> 仅包含本次问题及对应答复，不代表此前全量聊天已归档。对话中的界面组件以文字形式表示。

## 用户（原文）

报错：(cbl4090) ubuntu@ubuntu-System-Product-Name:/mnt/4Tdata/LemonData/cross_behavior_4090_v1$ clear
(cbl4090) ubuntu@ubuntu-System-Product-Name:/mnt/4Tdata/LemonData/cross_behavior_4090_v1$ CBL_RUN_EXTRA=0 \
bash scripts/31_low_cost_baselines.sh \
  PickCube-v1 100 smoke 42
{
  "torch": true,
  "mani_skill": true,
  "h5py": true,
  "robomimic": false,
  "cbl_extra": true,
  "cbl_official": false,
  "dataset_pointer": "/mnt/4Tdata/LemonData/cross_behavior_4090_v1/data_paths/PickCube-v1.txt",
  "dataset_path": "/mnt/4Tdata/LemonData/cross_behavior_4090_v1/data/maniskill/demos/rigid_body/PickCube-v1/motionplanning/trajectory.state.pd_ee_delta_pos.physx_cpu.h5",
  "dataset_exists": true,
  "robomimic_data_exists": false,
  "extra_launcher_exists": true,
  "official_launcher_exists": false,
  "conda_env": "cbl4090",
  "cuda": true,
  "gpu": "NVIDIA GeForce RTX 4090"
}
Missing v3 overlay: scripts/12_train_robomimic.sh
(cbl4090) ubuntu@ubuntu-System-Product-Name:/mnt/4Tdata/LemonData/cross_behavior_4090_v1$

## 助手（当前答复原文）

问题找到了。**这次不是算法报错，而是我之前给你的 v5 安装包缺少 v3 的依赖文件。** 这是交付包之间的衔接问题，不是你的服务器或 RTX 4090 有问题。

你的检查结果表明：

| 检查项 | 状态 | 说明 |
|---|---|---|
| `cbl4090` | 正常 | 环境已激活 |
| PyTorch / CUDA | 正常 | 4090 已识别 |
| ManiSkill 数据 | 正常 | 100 条示范数据路径存在 |
| `cbl_extra` | 正常 | 之前的简化算法已安装 |
| `cbl_official` | 缺失 | v3 尚未合并 |
| RoboMimic | 缺失 | 尚未安装 |

### 一、先修复，不用重新搭环境

我检查了之前生成的 v3 压缩包，确认其中包含缺失的 `scripts/12_train_robomimic.sh`、`cbl_official/` 以及数据转换、评估脚本。

[下载 RoboMimic 官方 Baseline 接入包 v3](sandbox:/mnt/data/CrossBehavior_4090_OfficialBaseline_Adapters_v3.zip)

把它放进原来的项目根目录：

```bash
cd /mnt/4Tdata/LemonData/cross_behavior_4090_v1

unzip -o CrossBehavior_4090_OfficialBaseline_Adapters_v3.zip
```

检查：

```bash
ls scripts/1*_robomimic.sh
ls cbl_official/
```

然后在现有环境中安装官方 RoboMimic：

```bash
conda activate cbl4090

bash scripts/10_setup_robomimic.sh
```

这里有一个注意事项：安装脚本可能更新已有的 Python 依赖。为了保留已经能运行的 DP/ACT 环境，建议安装前先执行：

```bash
python -m pip freeze > requirements_cbl4090_before_robomimic.txt
```

安装完成后：

```bash
python -c "import robomimic; print('RoboMimic import OK')"
```

再执行数据转换：

```bash
bash scripts/11_prepare_robomimic.sh PickCube-v1 100
```

最后重新试跑：

```bash
CBL_RUN_EXTRA=0 \
bash scripts/31_low_cost_baselines.sh PickCube-v1 100 smoke 42
```

这次会先测试官方 BC、BC-GMM 两种配置，每种仅训练 2 Epoch。脚本能运行不等于闭环评估成功，后续仍需检查 checkpoint 和 ManiSkill Rollout。
