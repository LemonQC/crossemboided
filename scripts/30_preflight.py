"""Read-only single-environment readiness audit. No download/training."""
import argparse,importlib.util,json,os,sys
from pathlib import Path
def audit(root,task,number):
 root=Path(root).resolve(); r={}
 for name in ('torch','mani_skill','h5py','robomimic','cbl_extra','cbl_official'):
  try:r[name]=importlib.util.find_spec(name) is not None
  except (ImportError,ModuleNotFoundError):r[name]=False
 ptr=root/'data_paths'/f'{task}.txt'; raw=ptr.read_text().strip() if ptr.exists() else ''
 src=Path(raw) if raw else None
 if src and not src.is_absolute():src=root/src
 r['dataset_pointer']=str(ptr) if ptr.exists() else None
 r['dataset_path']=str(src) if src else None
 r['dataset_exists']=bool(src and src.is_file())
 r['robomimic_data_exists']=(root/'data'/'robomimic'/task/f'demos_{number}.hdf5').is_file()
 r['extra_launcher_exists']=(root/'scripts/09_run_extra_baselines.sh').exists()
 r['official_launcher_exists']=(root/'scripts/12_train_robomimic.sh').exists()
 r['conda_env']=os.environ.get('CONDA_DEFAULT_ENV','unknown')
 try:
  import torch
  r['cuda']=torch.cuda.is_available()
  r['gpu']=torch.cuda.get_device_name(0) if r['cuda'] else None
 except Exception as e:r['torch_error']=repr(e)
 return r
def main():
 p=argparse.ArgumentParser()
 p.add_argument('--root',default='.');p.add_argument('--task',default='PickCube-v1')
 p.add_argument('--number',type=int,default=100);p.add_argument('--output',default='results/validation_preflight.json')
 a=p.parse_args();r=audit(a.root,a.task,a.number);out=Path(a.root)/a.output
 out.parent.mkdir(parents=True,exist_ok=True);out.write_text(json.dumps(r,indent=2,ensure_ascii=False)+'\n')
 print(json.dumps(r,indent=2,ensure_ascii=False))
 if not r['dataset_exists']:
  print('ERROR: original ManiSkill replay dataset absent',file=sys.stderr);return 2
 return 0
if __name__=='__main__':sys.exit(main())
