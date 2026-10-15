# Hands Down Gold review — 2026-08-30

Scope: current official Hands Down material and the requested
[`neonfuzz/HandsDown`](https://github.com/neonfuzz/HandsDown) history, compared
with this keymap's four-layer firmware. This is research only; no firmware is
changed.

## Result

**Do not wholesale-sync this keymap to stock Gold.** The official canonical
Gold alpha arrangement is still `J G M P V / R S N D B / X F L C W` on the
left, `: . / ' ? / , A E I H / _ U O Y K` on the right, with `T` on the
non-space thumb. The active map deliberately has the F/G and B/W swaps plus a
different punctuation field; restoring stock would invalidate learned muscle
memory and the custom adaptive rules. Gold remains recommended for
English-focused split/ortho use with a dedicated alpha thumb; HRMs *or*
Callum-style one-shots are both supported approaches, so the current
thumb/one-shot-mod direction needs no change.

Sources: [official Neu/Gold page](https://sites.google.com/alanreiser.com/handsdown/home/hands-down-neu),
[official FAQ](https://sites.google.com/alanreiser.com/handsdown/home/faq),
[active BASE map](keymap.c), and [keymap rationale](LAYOUT.md).

## Actionable conclusion

There is no must-apply Gold update.

1. **Keep `AH -> AU`.** The official Gold documentation names `AU` as Gold's
   principal remaining SFB and explicitly suggests an adaptive `A` then `H`
   rule. The active `adaptive.h` already does exactly that (`AH -> AU`), so it
   is aligned with the current official guidance.
2. **Keep the W/B compensation.** The official implementation includes
   `MV -> MB` for the W/B rearrangement. This map has the corresponding W/B
   choice and the same `MV -> MB` adaptive; do not remove it.
3. **Treat H-digraphs as an experiment, not an upgrade.** The source offers
   `DN=TH`, `CL=CH`, `SN=SH`, `HI=WH`, `GM=GH`, and `PM=PH`. They conflict with
   existing `SN=Esc`, `ND=Tab`, and custom/adaptive behavior, so adopting them
   requires intentional reassignment and measured trial time—not an additive
   patch. [Source combo definitions](https://github.com/neonfuzz/HandsDown/blob/846918634c965d73c5951352974a47b51f5e5049/layouts/community/hands_down_gold/combos.c).
4. **Do not bulk-import neonfuzz smart features.** Linger, large shorthand
   combos, and the remaining adaptive pairs are optional and were written for
   the stock alpha positions. The official author likewise describes smart
   features as optional. Add only a single rule after finding a recurring
   discomfort/slow sequence in the user's own corpus.

## "Latest changes" check

`neonfuzz/HandsDown` main was checked at
[`8469186` (2024-05-29)](https://github.com/neonfuzz/HandsDown/commit/846918634c965d73c5951352974a47b51f5e5049).
Its final changes are README and code-organization updates, not a revised Gold
alpha layout. Its canonical implementation still supplies the adaptive and
combo ideas above ([adaptive source](https://github.com/neonfuzz/HandsDown/blob/846918634c965d73c5951352974a47b51f5e5049/layouts/community/hands_down_gold/adaptive.c)).

The maintained official pages do not present a newer Gold alpha revision. They
do frame Gold as a deliberate English/thumb-alpha choice rather than a
universally best layout; corpus and comfort determine whether any experiment is
worth keeping.
