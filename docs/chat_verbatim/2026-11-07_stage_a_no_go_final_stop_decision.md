# 2026-11-07 — Stage A NO_GO: terminate hand-written expert generation

## User (verbatim)
```text
STAGE_A_BOOT: registering common task
STAGE_A_BOOT: constructing env (CPU PhysX, EEF control)
STAGE_A_BOOT: env constructed
STAGE_A_SEED: reset behavior=push seed=104
push seed=104 ERROR TCP target unreachable (error=0.115m); rejected expert episode
push seed=104 once=False end=False
STAGE_A_BOOT: importing mani_skill.envs
STAGE_A_BOOT: registering common task
STAGE_A_BOOT: constructing env (CPU PhysX, EEF control)
STAGE_A_BOOT: env constructed
STAGE_A_SEED: reset behavior=push seed=105
push seed=105 once=True end=True
STAGE_A_BOOT: importing mani_skill.envs
STAGE_A_BOOT: registering common task
STAGE_A_BOOT: constructing env (CPU PhysX, EEF control)
STAGE_A_BOOT: env constructed
STAGE_A_SEED: reset behavior=push seed=106
push seed=106 once=True end=False
STAGE_A_EARLY_STOP: push has 3 failures; cannot reach 18/20
STAGE_A_STOP: too many failed expert demonstrations; skipping further behaviors
STAGE_A NO_GO {'push': 4, 'pick': 0}
(cbl4090_clean) ubuntu@ubuntu-System-Product-Name:/mnt/4Tdata/LemonData/cross_behavior_4090_v1$
```

## Evidence and decision

- Examined local source of the actually supplied FormalCrossBehavior_EE_v1_1.zip. Stage A needs 18/20 successful trajectories per behavior. Push terminated after 3 failures; thus it can achieve at most 17/20. Four push successes are recorded, pick was not attempted (not zero pick successes out of any attempts).
- One failure occurs when the script's EEF feedback controller cannot reach a requested target (remaining 0.115m). Another has success-once=true but success-at-end=false. Avoid guessing whether this is IK geometry, movement planning, or retreat disturbance without more evidence.
- Stage B refusing to train is the intended quality gate; no trained 8-model results exist. Do not fake or bypass the gate; do not lower the criterion to let unreliable demonstrations pass.
- **Final decision**: enforce pre-agreed halt of bespoke MoveCubeSameGoalEE-v1 procedural-expert implementation and stop launching further v1.x fixes. This does not establish failure of cross-behavior learning as a research hypothesis, only failure of this data generation approach.
- Next scientific step requires an existing, actually executable benchmark and verified demonstrations from **both** distinct behaviors that share a task outcome. Do not relabel different official PushCube/PickCube tasks as equal without controlling the success metric and state/action interface. Before committing new implementation work, verify dataset/code access and real successful rollouts; if unavailable, put this research direction on hold instead of speculative training. A fixed set of target-only, mixed cross-behavior, and target-only equal-volume baselines can be used once valid data exist.
- The prior assistant made a mistake by continuing an Oracle/patch loop. The end of Stage A now closes that loop.
