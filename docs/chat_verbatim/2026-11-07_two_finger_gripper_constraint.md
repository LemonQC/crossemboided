# 2026-11-07 — Hardware constraint: only a two-finger gripper

## User verbatim

注意，我现在只有一个二指夹爪，没有多指

## Assistant research decision (summary)

The user's physical manipulation platform supports a **two-finger parallel-jaw gripper** only. No multi-finger/dexterous-hand methods, special fingertip contact sensing, multi-finger in-hand manipulation, or collecting data requiring dexterous hands should be assumed for this project.

Cross-embodiment remains possible if it compares different **robot arms** with two-finger grippers under the same task definition: DOF, kinematics, workspace, collision geometry, sensing/viewpoints, and control mapping can differ even when the end-effector is functionally similar.

The publicly released BARX repository `barx/benchmark.py` defines `panda` with `Robotiq85Gripper`, and `panda_og` with `PandaGripper`. Both are parallel-gripper variants on the same Panda arm, so Panda vs Panda-OG alone is NOT a cross-arm embodiment comparison. BARX also lists distinct IIWA, Kinova3, UR5e, and Jaco variants, but any planned comparison must first verify which actual finger configurations are supported for each simulator embodiment. We will not invent compatibility with the user's physical robot.

No new simulation environment, expert planner, or learning code should be started just because of this hardware clarification. Determine actual robot arm model before mapping to an official benchmark. Only this Markdown note was committed; no code.
