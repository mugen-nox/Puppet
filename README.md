# The Puppet String — Jam Skeleton

## Core Concept

You control a marionette by pulling strings, not by moving limbs directly.
Over the course of the game, strings get cut — one by one, sometimes by
you, sometimes by the world. Each cut removes a piece of your control
but frees that limb to move imperfectly on its own. By the end, you
have no strings left, and the puppet moves without you.

**Emotional throughline:** control → loss → trust → release.

---

## Design Template (fill this in before Day 1 ends)

For each limb, define:
- **Controlled behavior:** how it moves while the string is attached (should feel
  slightly imprecise — a marionette, not a directly-mapped input)
- **Autonomous behavior:** how it moves once cut — should feel *alive*, not broken.
  This is the emotional pivot of the whole game; don't let it default to ragdoll flop.
- **When it gets cut:** by player choice, by a level trigger, or forced by the world
- **What's lost / what's gained:** e.g. cut the arm-string → can't grab, but the arm
  now swings naturally with momentum instead of stiffly following input

Do this in writing for all 5 limbs before touching code seriously.

---

## Project Structure

```
puppet-string-jam/
├── project.godot
├── scenes/
│   ├── main.tscn              # shell / level loader
│   ├── puppet.tscn            # PuppetController + StringManager
│   ├── limbs/
│   │   ├── arm_left.tscn
│   │   ├── arm_right.tscn
│   │   ├── leg_left.tscn
│   │   ├── leg_right.tscn
│   │   └── head.tscn
│   ├── levels/
│   │   ├── level_0_full_control.tscn
│   │   ├── level_1_cut_first_string.tscn
│   │   ├── level_2_cut_second_string.tscn
│   │   ├── level_3_barely_holding_on.tscn
│   │   └── level_4_finale_no_strings.tscn
│   └── ui/
│       └── hud.tscn
├── scripts/
│   ├── limb.gd                # base class: controlled vs autonomous state
│   ├── string_manager.gd      # single source of truth for what's still attached
│   ├── puppet_controller.gd   # reads input, pulls strings (never limbs directly)
│   └── level_base.gd          # shared level signal / transition logic
├── audio/
│   ├── sfx/                   # string snap, footstep, ambient — invest real time here
│   └── music/
└── art/
    ├── puppet/
    └── environment/
```

### Architecture notes

- `Limb` is the base class every limb scene uses. It never reads input directly —
  it only checks `string_attached` and switches between `_process_controlled()`
  and `_process_autonomous()`. Both are stubbed with TODOs.
- `StringManager` is the single source of truth for which strings are still
  attached. Levels and the finale should query it, never track cut-state themselves.
- `PuppetController` is the only thing that reads player input. It pulls
  strings via the manager — cut limbs are structurally unreachable by input,
  not just ignored, which keeps the "loss of control" honest.
- `LevelBase` gives every level a consistent `level_complete` signal so
  `main.tscn` can chain them without per-level special-casing.

---

## Level Progression

- **Level 0 — Full Control:** learn the controls, all 5 strings attached, no cutting
- **Level 1 — Cut First String:** player chooses to cut one string (probably an arm)
  to solve a puzzle only a freed limb can solve — reframes cutting as a tool, not just loss
- **Level 2 — Cut Second String:** a string is cut *for* the player by a world event —
  first taste of losing control involuntarily
- **Level 3 — Barely Holding On:** only 1–2 strings left; movement is now mostly autonomous,
  player is mostly steering rather than controlling
- **Level 4 — Finale, No Strings:** `string_manager.cut_all_in_sequence()` triggers,
  no more strings. Player influence is (almost) gone. This is the emotional peak —
  budget real time for the last moments: silence, a held shot, the puppet walking
  off-screen without you.

---

## Day-by-Day (2.5 days)

**Day 1**
- Fill in the design template above for real, in writing (1 hr)
- Build `Limb` + `StringManager` + `PuppetController` fully — get ONE limb
  (an arm) working end-to-end: controlled pull feel + autonomous freed feel
- Level 0 playable and the controlled-pull feel is *right* by end of day

**Day 2**
- Wire up remaining 4 limbs
- Build levels 1–3, using Level 1's cut-to-solve-puzzle to test that
  "losing control" reads as interesting, not just as removal
- First real audio pass: string snap sound is the single most important
  SFX in the game — get it right

**Day 3 (final stretch)**
- Build Level 4 finale: sequenced cuts, then the puppet walks on its own
- Final 20–30 seconds: no new mechanics, just the held shot / silence / puppet
  walking away — this is not optional polish, it's the point of the game
- Cut only: extra levels, cosmetic variety, menus, settings
- Never cut: the snap SFX, the autonomous-motion feel, the finale's ending beat

---

## What Not to Cut

- The feel of `_process_autonomous()` — if freed limbs just flop like ragdolls,
  the whole emotional arc collapses. This needs real iteration time.
- The finale's silence/held-shot ending
- At least one moment (Level 1) where cutting a string is a *choice that helps*,
  not just a loss — this is what makes "independence" read as double-edged
  rather than purely sad

## What's Safe to Cut

- A 6th limb / extra puzzle limbs
- Any UI beyond a minimal HUD (a string-count indicator is enough)
- Dialogue/story text beyond level titles
- Additional levels beyond the 5 listed
