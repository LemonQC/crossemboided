"""Metadata-only check; no fictional paired cross-embodiment examples."""
import argparse,csv,json,sys
from pathlib import Path
from collections import defaultdict
def check(rows):
 required={'episode_id','task_id','behavior_id','embodiment_id','success'}
 if not rows:return {'ready':False,'reason':'No metadata rows supplied','episodes':0}
 missing=required-set(rows[0])
 if missing:return {'ready':False,'reason':f'Missing CSV fields: {sorted(missing)}','episodes':len(rows)}
 grouped=defaultdict(lambda:defaultdict(set));unique=set()
 for row in rows:
  if not all(row.get(x,'').strip() for x in required):
   return {'ready':False,'reason':'Empty metadata value encountered','episodes':len(rows)}
  if row['episode_id'] in unique:return {'ready':False,'reason':'Duplicate episode_id','episodes':len(rows)}
  unique.add(row['episode_id'])
  if row['success'].lower() in ('true','1','yes'):
   grouped[row['task_id']][row['behavior_id']].add(row['embodiment_id'])
 multi={t:{b:sorted(e) for b,e in bs.items()} for t,bs in grouped.items() if len(bs)>=2}
 cross_emb={t:len(set(e for es in bs.values() for e in es))>=2 for t,bs in multi.items()}
 return {'ready':bool(multi),'episodes':len(rows),'tasks_with_multiple_successful_behaviors':multi,
  'tasks_with_multiple_embodiments':cross_emb,
  'warning':'Checks labels only, not real goal equivalence, matching initial states, or sensor alignment.'}
def main():
 p=argparse.ArgumentParser();p.add_argument('--metadata',type=Path,required=True)
 p.add_argument('--output',type=Path,default=Path('results/cross_behavior_readiness.json'))
 a=p.parse_args()
 if not a.metadata.is_file():print('No CSV supplied; not ready',file=sys.stderr);return 2
 with a.metadata.open(newline='') as f:rows=list(csv.DictReader(f))
 r=check(rows);a.output.parent.mkdir(parents=True,exist_ok=True)
 a.output.write_text(json.dumps(r,indent=2,ensure_ascii=False)+'\n');print(json.dumps(r,indent=2,ensure_ascii=False))
 return 0 if r['ready'] else 3
if __name__=='__main__':sys.exit(main())
