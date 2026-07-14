#!/bin/bash
# Someone's talking to you: pause music, switch headphones to ambient/transparency.
playerctl pause
python3 "$HOME/.config/hypr/scripts/sony_xm6_ctl.py" ambient --level 20 --voice
