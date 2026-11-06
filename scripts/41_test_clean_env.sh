#!/usr/bin/env bash
set -Eeuo pipefail
unset DISPLAY WAYLAND_DISPLAY
ENV_NAME="${CBL_NEW_ENV:-cbl4090_clean}"
[[ "${CONDA_DEFAULT_ENV:-}" == "$ENV_NAME" ]] || { echo "Activate $ENV_NAME first";exit 2; }
python - <<'PY'
import platform,ssl,sys,torch,mani_skill,gymnasium,h5py
assert platform.python_implementation()=='CPython'
assert torch.cuda.is_available()
print('Python:',sys.executable)
print('SSL:',ssl.OPENSSL_VERSION)
print('torch:',torch.__version__,'GPU:',torch.cuda.get_device_name(0),'Gym:',gymnasium.__version__)
PY
python - <<'PY'
import gymnasium as gym,mani_skill
env=gym.make('PickCube-v1',obs_mode='state',control_mode='pd_ee_delta_pos',sim_backend='physx_cpu',render_mode='rgb_array')
obs,info=env.reset(seed=42)
print('PickCube reset PASS')
env.close()
PY
if [[ -f scripts/30_preflight.py && -f data_paths/PickCube-v1.txt ]]; then
 python scripts/30_preflight.py --task PickCube-v1 --number 100
fi
echo 'BASE ENV READY; model training/evaluation must be separately tested.'
