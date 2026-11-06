# 2026-11-06 — RoboMimic 安装版本错误：当前对话摘录

> 记录状态：仅当前这轮可核对内容；助手部分为重要答复节选，不是完整的历史逐字导出。仅提交聊天记录，不上传代码。

## 用户（原文）

# 运行 BC 和 BC-GMM 的 2 Epoch 测试
bash scripts/50_run_everything.sh smoke PickCube-v1 100 42
/home/fu/SoftWare/Anaconda/envs/cbl4090_clean/bin/python
2.5.1+cu121
True
CPython 3.10.22 Torch 2.5.1+cu121 GPU NVIDIA GeForce RTX 4090 SSL OpenSSL 3.5.9 29 Sep 2026
Preserving torch: 2.5.1+cu121
RoboMimic not yet usable: ModuleNotFoundError No module named 'robomimic'
Looking in indexes: https://pypi.tuna.tsinghua.edu.cn/simple
ERROR: Could not find a version that satisfies the requirement robomimic==0.5.0 (from versions: 0.1.0, 0.2.0, 0.3.0)
ERROR: No matching distribution found for robomimic==0.5.0
FAILED: stage=setup-robomimic line=78. See results/all_in_one/setup-robomimic_PickCube-v1_100_seed42.log
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
ModuleNotFoundError: No module named 'robomimic'
CPython 3.10.22 Torch 2.5.1+cu121 GPU NVIDIA GeForce RTX 4090 SSL OpenSSL 3.5.9 29 Sep 2026
{
  "torch": true,
  "mani_skill": true,
  "h5py": true,
  "robomimic": false,
  "cbl_extra": true,
  "cbl_official": true,
  "dataset_pointer": "/mnt/4Tdata/LemonData/cross_behavior_4090_v1/data_paths/PickCube-v1.txt",
  "dataset_path": "/mnt/4Tdata/LemonData/cross_behavior_4090_v1/data/maniskill/demos/rigid_body/PickCube-v1/motionplanning/trajectory.state.pd_ee_delta_pos.physx_cpu.h5",
  "dataset_exists": true,
  "robomimic_data_exists": false,
  "extra_launcher_exists": true,
  "official_launcher_exists": true,
  "conda_env": "cbl4090_clean",
  "cuda": true,
  "gpu": "NVIDIA GeForce RTX 4090"
}
RoboMimic unavailable: ModuleNotFoundError("No module named 'robomimic'"). Run stage setup-robomimic before training.
FAILED: stage=smoke line=29. See results/all_in_one/smoke_PickCube-v1_100_seed42.log

## 助手解决方案（核心内容摘录，非逐字完整回复）

RoboMimic 0.5.0 已在官方 GitHub 仓库发布，但清华 PyPI 镜像只提供 0.1.0～0.3.0。新环境 CPython 3.10.22、torch 2.5.1+cu121 及 CUDA 运行正常。建议直接从作者仓库 `v0.5.0` 源码安装，禁用依赖自动覆盖现有 torch，不再调用旧 setup 脚本。

```bash
cd /mnt/4Tdata/LemonData/cross_behavior_4090_v1
conda activate cbl4090_clean
python -m pip freeze > requirements_before_robomimic.txt
mkdir -p upstream
git clone --depth 1 --branch v0.5.0 https://github.com/ARISE-Initiative/robomimic.git upstream/robomimic
python -m pip install --no-deps --no-build-isolation -e upstream/robomimic
python -m pip check
bash scripts/11_prepare_robomimic.sh PickCube-v1 100
bash scripts/12_train_robomimic.sh bc PickCube-v1 100 2 42
bash scripts/12_train_robomimic.sh bc_gmm PickCube-v1 100 2 42
```

该安装路径没有在用户服务器验证，不能称作训练复现成功。完整逐字历史仍需 ChatGPT 数据导出。