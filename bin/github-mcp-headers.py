#!/usr/bin/env python3
"""Supply Codex's GitHub MCP request header from the GitHub CLI keyring."""

import json
import subprocess


token = subprocess.check_output(
    ["gh", "auth", "token"], text=True, stderr=subprocess.DEVNULL
).strip()
print(json.dumps({"Authorization": f"Bearer {token}"}))
