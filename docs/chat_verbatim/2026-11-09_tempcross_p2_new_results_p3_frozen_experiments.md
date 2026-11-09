# 2026-11-09 — P2 latest result review and P3 experimental direction

## User (verbatim)
根据新的结果分析，要进行的下一步实验

## Reviewed result source
- https://github.com/LemonQC/tempcross/commit/702005202d84ba0f39d213d3af72cffeaf30cc41
- docs/P2_INTERVENTION_REPORT.md, docs/P2_TARGET_ADAPTATION.md, docs/P2_SCIENTIFIC_DECISION.md, evidence/p2/status.json
- evidence/p2/execution_2145/{cells,paired_comparisons,stage_counts,b2_mechanism,paired_stage_changes,episodes}.csv
- p2_validation/{controls,replay_intervention,train_adapter,train_suite,run_policy}.py
- Recent overlapping 2026 literature: KITE (arxiv 2606.22113), CrossZero (CVPRW 2026), CEI (IEEE RA-L 2026)

## Verified outcomes
- New formal episodes 120: source UR5e Joint 8/20, Panda Joint 1/20, Panda B1 gripper-only 3/20, Panda NoReps 1/20, Panda NoReps restricted LoRA 2/20, Panda Joint restricted LoRA 3/20 on frozen indices 20–39.
- Joint B1 rescued indices 37,39 with 0 regressions; restricted Joint LoRA rescued 34,37,39, regressed previously successful 35.
- Development B1 .85/.90/.93 all 0/8; .85 selected by frozen tiebreak, not superior dev evidence.
- B2 finite forced-close at 6 negative branch instants across 3 failed trajectories yielded no bilateral contact and no rescue; source-style positive control succeeded. NOT a general grasp oracle. Failure does not establish inability of spatial pose-corrected grasp.
- Both LoRA models actually ran 3000 updates batch2 (6000 sample positions, 1/128 official reference exposure), target PnP 50 demos per direction 100 total, same source/target sample sequence; official full-parameter attempt failed GPU OOM, LoRA works. Underexposure cannot rule out normal adaptation.
- No wrist-camera observation intervention evidence; current COFT executability×observability novel-network claim is unsupported.

## Fixed P3 plan — no endless expansions
**P3-A: spatial-vs-temporal mechanism gate**, use only already evaluated conditions 22,24,26,29,34,35,37,39. On 22/24/26/29, source UR5e Joint succeeded while original Panda, B1 and restricted Joint LoRA failed; 34 LoRA rescued only; 37/39 B1 and LoRA rescued; 35 original Panda succeeded but LoRA regressed. Extract source successful stable grasp object-relative gripper TCP 6D pose; attempt target Panda continuous standard IK/OSC approach to feasible candidate, using oracle object geometry ONLY for diagnostic. Run factorial controls: original (reuse existing), gripper-only at fixed chosen branch, pose-only retaining gripper command, pose+gripper with deterministic physical hold/lift. Max 8×3=24 new controlled developer rollouts, positive case 35, predeclare tolerances and branch rule and collision/joint checks, no object teleport or modifying physics. Separate pose reached, two-finger contact, sustained lift, final official task outcome. This test diagnoses whether spatial alignment, temporal closing or both are needed; not a new method or valid nonprivileged baseline.
**P3-B: stronger ordinary adaptation**. Use original released target_50 dataset (100 total, 50 per direction) and source RLDS mixture, original Joint checkpoint, same optimizer and official LoRA code; first trial batch8 else4/2 verified on RTX3090, deterministic 96,000 mixture sample positions (16× prior 6,000, still 1/8 official 768,000). No static cache of 6000 merely repeated without provenance; count unique source/target exposure, freeze final checkpoint, don't claim official full fine-tune equivalence. Only train No Reps same larger budget if needed to support *between-model* conclusions. Not allowed to select checkpoints based on held-out 40–59.
**P3-C one confirmation only**: currently untouched frozen bundle indices 40–59. Compare 5 groups ×20 episodes: UR5e original Joint, Panda original Joint, Panda frozen B1(.85), Panda original 6k Joint LoRA, Panda upgraded 96k Joint LoRA (100 episodes). If pose+gripper diagnostic validated on development, optional separate clearly privileged 20 only for physical feasibility, not fair learned baseline. Record paired rescue/regressions, stable contacts/placement, errors, all videos, seed/condition hash. Do not tune from heldout and rerun. Qualitative decision whether enhanced ordinary adaptation closes gap, or a privileged spatial correction establishes feasibility that source policy misses.
- If classic object-relative IK retargeting alone solves: this is prior-art geometry, not a new T-RO novelty claim. KITE/CrossZero/CEI already address contact-intent/kinematics and object-centric retargeting; later method would need stronger novel mechanism and equal-information controls.
- Strong LoRA failure when only 1/8 official training remains is still not proof fully trained adaptation fails; mark resource scope.
- Do not start another network, change tasks, Eye-in-Hand, true robot, generate experts or tune 40–59.
- Codex deliver executable code, actual physics and trained model results, independent success labels, stage metrics, exact budget, result reports and commit to LemonQC/tempcross.

## Decision
Current new COFT neural-model branch remains unapproved. This P3 is a single bounded mechanism+strong-standard-control check—not an open-ended chain of smoke tests. 
