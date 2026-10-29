#!/bin/bash
# Someone's talking to you: pause music, switch headphones to ambient/transparency.
playerctl pause
python3 "$(dirname "$0")/sony_xm6_ctl.py" ambient --level 20 --voice
