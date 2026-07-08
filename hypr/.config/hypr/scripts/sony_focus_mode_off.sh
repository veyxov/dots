#!/bin/bash
# Back to work: ANC on, resume music.
python3 "$HOME/.config/hypr/scripts/sony_xm6_ctl.py" anc --level 20
playerctl play
