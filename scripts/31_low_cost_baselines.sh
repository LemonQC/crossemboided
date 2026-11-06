#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"; export PYTHONPATH="$ROOT:${PYTHONPATH:-}"
unset DISPLAY WAYLAND_DISPLAY
TASK="${1:-PickCube-v1}"; COUNT="${2:-100}"; MODE="${3:-smoke}"; SEED="${4:-42}"
case "$MODE" in
 smoke) EPOCHS=2; EPISODES=2;;
 pilot) EPOCHS=20; EPISODES=20;;
 full) EPOCHS=100; EPISODES=50;;
 *) echo 'Usage: bash scripts/31_low_cost_baselines.sh TASK COUNT smoke|pilot|full SEED' >&2;exit 2;;
esac
[[ "${CONDA_DEFAULT_ENV:-}" == cbl4090 ]] || echo "WARNING: expected cbl4090, got '${CONDA_DEFAULT_ENV:-unknown}'" >&2
python scripts/30_preflight.py --task "$TASK" --number "$COUNT"
if [[ "$MODE" == full && "${CBL_CONFIRM_FULL:-0}" != 1 ]];then
 echo 'Full budget requires CBL_CONFIRM_FULL=1' >&2; exit 2
fi
if [[ "${CBL_RUN_EXTRA:-1}" == 1 ]];then
 [[ -f scripts/09_run_extra_baselines.sh ]] || { echo 'v2 overlay missing' >&2;exit 2; }
 bash scripts/09_run_extra_baselines.sh "$TASK" "$COUNT" "$EPOCHS" "$EPISODES" "$SEED"
fi
if [[ "${CBL_RUN_ROBOMIMIC:-1}" == 1 ]];then
 [[ -f scripts/12_train_robomimic.sh ]] || { echo 'v3 overlay missing' >&2;exit 2; }
 python - <<'PY'
import importlib.util,sys
if importlib.util.find_spec('robomimic') is None:
 sys.exit('RoboMimic is missing. Inspect scripts/10_setup_robomimic.sh before installing in cbl4090.')
PY
 if [[ ! -f "data/robomimic/$TASK/demos_$COUNT.hdf5" ]];then
  bash scripts/11_prepare_robomimic.sh "$TASK" "$COUNT"
 fi
 METHODS=(bc bc_gmm bc_rnn bc_rnn_gmm bc_transformer bc_transformer_gmm)
 [[ "$MODE" != smoke ]] || METHODS=(bc bc_gmm)
 for METHOD in "${METHODS[@]}";do
  bash scripts/12_train_robomimic.sh "$METHOD" "$TASK" "$COUNT" "$EPOCHS" "$SEED"
 done
 echo 'Training done. Model rollout success is NOT established until evaluated in ManiSkill.'
fi
