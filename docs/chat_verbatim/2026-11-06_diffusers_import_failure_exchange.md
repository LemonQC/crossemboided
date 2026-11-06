# 2026-11-06 — RoboMimic 训练导入错误（当前轮聊天）

> 范围说明：当前轮用户 traceback 原文与助手的修复答复。聊天上下文更早的全部消息仍没有完成全量逐字导出。没有提交任何算法源码文件。

## 用户

(cbl4090_clean) ubuntu@ubuntu-System-Product-Name:/mnt/4Tdata/LemonData/cross_behavior_4090_v1$ HF_HUB_OFFLINE=1 TRANSFORMERS_OFFLINE=1 python - <<'PY'
import torch
import robomimic.utils.train_utils
import robomimic.algo

print("Torch:", torch.__version__)
print("CUDA:", torch.cuda.is_available())
print("RoboMimic import: OK")
print("No CLIP download required")
PY
ROBOMIMIC WARNING(
    No private macro file found!
    It is recommended to use a private macro file
    To setup, run: python /mnt/4Tdata/LemonData/cross_behavior_4090_v1/upstream/robomimic/robomimic/scripts/setup_macros.py
)
Traceback (most recent call last):
  File "<stdin>", line 2, in <module>
  File "/mnt/4Tdata/LemonData/cross_behavior_4090_v1/upstream/robomimic/robomimic/utils/train_utils.py", line 22, in <module>
    import robomimic.utils.file_utils as FileUtils
  File "/mnt/4Tdata/LemonData/cross_behavior_4090_v1/upstream/robomimic/robomimic/utils/file_utils.py", line 24, in <module>
    from robomimic.algo import algo_factory
  File "/mnt/4Tdata/LemonData/cross_behavior_4090_v1/upstream/robomimic/robomimic/algo/__init__.py", line 12, in <module>
    from robomimic.algo.diffusion_policy import DiffusionPolicyUNet
  File "/mnt/4Tdata/LemonData/cross_behavior_4090_v1/upstream/robomimic/robomimic/algo/diffusion_policy.py", line 13, in <module>
    from diffusers.schedulers.scheduling_ddpm import DDPMScheduler
  File "/home/fu/SoftWare/Anaconda/envs/cbl4090_clean/lib/python3.10/site-packages/diffusers/__init__.py", line 5, in <module>
    from .utils import (
  File "/home/fu/SoftWare/Anaconda/envs/cbl4090_clean/lib/python3.10/site-packages/diffusers/utils/__init__.py", line 48, in <module>
    from .hub_utils import (
  File "/home/fu/SoftWare/Anaconda/envs/cbl4090_clean/lib/python3.10/site-packages/diffusers/utils/hub_utils.py", line 26, in <module>
    from huggingface_hub import (
ImportError: cannot import name 'resolve_revision' from 'huggingface_hub' (/home/fu/SoftWare/Anaconda/envs/cbl4090_clean/lib/python3.10/site-packages/huggingface_hub/__init__.py)

## 助手（关键操作与说明）

问题在于 RoboMimic v0.5.0 的 `robomimic/algo/__init__.py` 无条件导入 `DiffusionPolicyUNet`。对于本次只运行 BC 的实验，可备份该文件并注释 `from robomimic.algo.diffusion_policy import DiffusionPolicyUNet`，这会避免 BC 导入时触发当前 `diffusers` 与 `huggingface_hub` 版本冲突。保持 BC 的模型与训练过程不变，无需再次更换依赖或下载 CLIP。完成后在离线模式下导入 `robomimic.utils.train_utils`，再运行 `bash scripts/50_run_everything.sh smoke PickCube-v1 100 42`。该建议尚未在用户服务器完成验证。

> 本文件的助手部分为操作说明摘录，非完整双向逐字聊天导出。完整逐字性需要官方 ChatGPT 对话原始导出。