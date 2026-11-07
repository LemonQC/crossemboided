# 2026-11-07 — ROKAE SR5 cross-embodiment research: proposed coupled executability and observability

## User (verbatim)
不用ros，我们都用的python，这个你不用担心，你现在考虑研究的东西和算法呀

## Assistant decision (summary; not whole UI verbatim)
The user already controls their ROKAE SR5-5/0.9C six-DoF arm via Python, with DH Robotics PGIA-140-80-W parallel two-finger gripper and wrist-mounted Intel RealSense D435i. Do not discuss ROS, wiring, robot drivers or installation as research contributions.

**One focused, conditional research proposal**: `Embodiment-Conditioned Executability and Observability for Cross-Embodiment Manipulation` (working name COFT). Distinguish source-to-target *task effect* from source-to-target identical motion. For a source success trace, consider several geometrically distinct target-embodiment approach/contact paths that achieve the same task goal. A 6-DoF arm with rigid eye-in-hand camera cannot generally steer camera view independently while preserving a full 6D gripper pose. Mechanical feasibility, visibility, contact and future closed-loop success may interact. The hypothesis is that transfer requires target-conditioned **joint** interaction-execution/observation reasoning instead of merely shared end-effector trajectories plus IK or separately filtered visibility and reachability.

Candidate architecture:
1. Extract source interaction/task-effect representation in an object frame; generate limited candidates with different approach, grasp orientations and contact paths. Object-centric action representation is prior art, not claimed novel.
2. Target-conditioned joint predictor `P(task success | candidate, target robot geometry, camera calibration, visual belief)` trained on counterfactual candidates from the same scene. Explicitly consider multi-step consequences, partial observation, failures; no blind independent weighted sum of two separate scores.
3. Lightweight candidate generation/ranking and receding-horizon policy for the target arm; compare **against equal-information, equal-compute MPC/CEM** and analytic reachability + view thresholds. Do not misrepresent a standard cost as an original contribution.

Related 2025–26 work directly adjacent and must be confronted:
- BARX ICRA 2026: https://arxiv.org/abs/2607.27549 (behavior-aligned reps, training dataset and benchmark)
- KITE 2026: https://arxiv.org/abs/2606.22113 (contact intent + morphology-specific kinematic decoders)
- CrossZero CVPRW 2026: https://openaccess.thecvf.com/content/CVPR2026W/GigaBrainChallenge/html/Ge_CrossZero_Zero-Shot_of_Unseen_Embodiment_Manipulation_via_Object-Centric_Hierarchical_Diffusion_CVPRW_2026_paper.html (object-centric diffusion + IK diffusion)
- Cloak CoRL 2026: https://tml.stanford.edu/cloak/ (wrist gripper masking for cross-embodiment)
- SeeTraceAct 2026: https://arxiv.org/abs/2606.02745 (visibility-aware cross-embodiment demonstration trace prediction)
- Visible-Reachable Workspace 2026: https://arxiv.org/abs/2609.08905 (coupled reachability/visibility for perception-aware humanoid design)
- Observe Then Act IEEE RA-L 2025: https://doi.org/10.1109/LRA.2025.3541334 (active camera NBV + action)

**First scientific gate before any new deep network or expert data generation**:
- Use real target manipulator kinematics / calibrated eye-in-hand camera, source Panda analog, a common tabletop task goal and multiple permissible approaches.
- Check actual candidate rank reversals across embodiments, motion feasible but critical scene occluded, and alternatives achieving same goal under both view and motion constraints.
- Compare standard IK+collision, simple visibility threshold, independent linear scoring, information-equivalent MPC/CEM.
- Only if these controls fail on repeatable, practically relevant cases, proceed to learned joint predictor/conditional strategy; if simple screening solves everything, reject the COFT claim. Avoid re-running the endless old Oracle and custom expert generation loops.
- Suggested baselines for later: target-only BC-RNN; target-only DP/DP3; source+target BC/DP3; EE+IK; motion-only and visibility-only screens; independent model; equal-info CEM/MPC; selected released BARX/CrossZero/Cloak/KITE if code/compute realistically permit.
- Physical test candidates within 2-finger/EIH limits: orientation-constrained tabletop grasp/place, occlusion-prone confined pickup, transfer/reorientation/precise placing. No tactile assumptions or multitouch.
- Current research status: direction is aligned with hardware and cross-embodiment definition; novelty and potential T-RO quality are **unproven**. Do not promise acceptance or immediately code/launch expensive VLA training. This is a falsifiable proposal, not a validated new method.

### Archive policy
This is a research discussion record, **Markdown only**. No code uploaded to GitHub. This document is an honest summary rather than a verbatim export of the entire assistant UI text.