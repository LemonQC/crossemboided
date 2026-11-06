#!/usr/bin/env bash
set -Eeuo pipefail
ENV_NAME="${CBL_NEW_ENV:-cbl4090_clean}"
PIP_INDEX="${CBL_PIP_INDEX:-https://pypi.tuna.tsinghua.edu.cn/simple}"
TORCH_INDEX="${CBL_TORCH_INDEX:-https://download.pytorch.org/whl/cu121}"
[[ "$ENV_NAME" != cbl4090 ]] || { echo "Refusing to overwrite old cbl4090"; exit 2; }
command -v conda >/dev/null || { echo "conda not found"; exit 2; }
if conda env list | awk '{print $1}' | grep -Fxq "$ENV_NAME"; then
  echo "Refusing to overwrite existing $ENV_NAME; pick a new CBL_NEW_ENV name"; exit 2
fi
mkdir -p results/env_rebuild
LOG="$PWD/results/env_rebuild/rebuild_${ENV_NAME}.log"
exec > >(tee -a "$LOG") 2>&1
trap 'echo "SETUP STOPPED at line $LINENO. Read $LOG" >&2' ERR
conda list -n cbl4090 --explicit > results/env_rebuild/old_conda_explicit.txt 2>/dev/null || true
conda create --override-channels -c defaults -n "$ENV_NAME" 'python=3.10' pip setuptools wheel -y
PY="$(conda info --base)/envs/$ENV_NAME/bin/python"
"$PY" - <<'PY'
import platform,ssl,sys
print(sys.executable,platform.python_implementation(),ssl.OPENSSL_VERSION)
assert platform.python_implementation()=='CPython'
assert 'OpenSSL' in ssl.OPENSSL_VERSION
PY
"$PY" -m pip install --index-url "$TORCH_INDEX" torch==2.5.1 torchvision==0.20.1
"$PY" - <<'PY'
import torch
print('torch',torch.__version__,'CUDA',torch.version.cuda,'GPU present',torch.cuda.is_available())
assert torch.cuda.is_available(), 'Stop: GPU missing; check NVIDIA driver and wheel before other installs'
print(torch.cuda.get_device_name(0))
PY
printf '%s\n' 'torch==2.5.1' 'torchvision==0.20.1' > results/env_rebuild/constraints.txt
"$PY" -m pip install -i "$PIP_INDEX" -c results/env_rebuild/constraints.txt 'mani_skill>=3,<4' 'gymnasium>=1,<2' 'numpy>=1.24' 'h5py>=3.9' 'matplotlib>=3.7' 'tensorboard>=2.14' 'pytest>=7' einops diffusers accelerate
if [[ "${CBL_WITH_ROBOMIMIC:-0}" == 1 ]]; then
  "$PY" -m pip install -i "$PIP_INDEX" --no-deps robomimic==0.5.0
fi
"$PY" - <<'PY'
import platform,torch,mani_skill,gymnasium
print('ready:',platform.python_implementation(),'torch:',torch.__version__,'gpu:',torch.cuda.get_device_name(0),'gymnasium:',gymnasium.__version__)
PY
"$PY" -m pip freeze > "results/env_rebuild/${ENV_NAME}_pip_freeze.txt"
"$PY" -m pip check || echo 'WARNING: pip check conflict; check log'
echo "READY: conda activate $ENV_NAME; bash scripts/41_test_clean_env.sh"
