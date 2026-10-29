#!/bin/bash
# Back to work: ANC on, resume music.
python3 "$(dirname "$0")/sony_xm6_ctl.py" anc --level 20
playerctl play
