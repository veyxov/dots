#!/usr/bin/env python3
"""Render Homebrew JSON snapshots and best-effort upstream release news."""

import json
from pathlib import Path
import re
import sys
import urllib.error
import urllib.parse
import urllib.request


def clean(text):
    # Release bodies are remote text: keep terminal control sequences out.
    text = re.sub(r'\x1b\[[0-?]*[ -/]*[@-~]', '', str(text))
    return ''.join(c for c in text if c in '\n\t' or c.isprintable())


def packages(data):
    result = {}
    for kind in ('formulae', 'casks'):
        for item in data.get(kind, []):
            name = item.get('full_name') or item.get('full_token') or item.get('name')
            installed = item.get('installed', [])
            versions = ([entry['version'] for entry in installed]
                        if isinstance(installed, list) else [installed] if installed else [])
            result[(kind, name)] = (', '.join(sorted(set(versions))), item)
    return result


def release_news(item, version):
    source = item.get('url') or item.get('urls', {}).get('stable', {}).get('url', '')
    homepage = item.get('homepage', '')
    match = re.match(r'https://github\.com/([^/]+/[^/]+?)(?:\.git)?(?:/|$)', source)
    if not match:
        match = re.match(r'https://github\.com/([^/]+/[^/]+?)(?:\.git)?(?:/|$)', homepage)
    if not match:
        return homepage, ''
    repo = match[1]
    fallback = f'https://github.com/{repo}/releases'
    tag_match = re.search(r'/releases/download/([^/]+)/', source)
    # Homebrew appends _revision to formulae and ,build to casks; upstream tags have neither.
    version = re.sub(r'(_\d+)?(,.*)?$', '', version.split(', ')[-1])
    # Never substitute "latest": it might describe a release we didn't install.
    tags = [urllib.parse.unquote(tag_match[1])] if tag_match else [f'v{version}', version]
    for tag in tags:
        url = f'https://api.github.com/repos/{repo}/releases/tags/{urllib.parse.quote(tag, safe="")}'
        request = urllib.request.Request(url, headers={'User-Agent': 'dots-update',
                                                     'Accept': 'application/vnd.github+json'})
        try:
            with urllib.request.urlopen(request, timeout=4) as response:
                release = json.loads(response.read(1_000_000))
            body = clean(release.get('body') or '')
            lines = [line.strip() for line in body.splitlines() if line.strip()]
            return release.get('html_url') or fallback, '\n'.join(lines[:6])[:1200]
        except urllib.error.HTTPError as error:
            if error.code == 404:
                continue
            break
        except (OSError, ValueError):
            break
    return fallback, ''


def main():
    mode, before_path, other_path = sys.argv[1:]
    before = packages(json.loads(Path(before_path).read_text()))
    other = json.loads(Path(other_path).read_text())
    if mode == 'preview':
        count = 0
        for kind in ('formulae', 'casks'):
            for item in other.get(kind, []):
                name = item['name']
                versions = ', '.join(map(str, item.get('installed_versions', [])))
                pinned = ' [pinned; skipped]' if item.get('pinned') else ''
                print(clean(f"  {name}: {versions} -> {item['current_version']}{pinned}"))
                count += 1
        if not count:
            print('  Homebrew packages are up to date.')
        return
    after = packages(other)
    changed = [(name, before.get((kind, name), ('not installed', {}))[0], version, item)
               for (kind, name), (version, item) in after.items()
               if version and set(version.split(', ')) -
               set(before.get((kind, name), ('', {}))[0].split(', '))]
    print(f'Updated packages ({len(changed)})')
    if not changed:
        print('  No installed package versions changed.')
    for name, old, new, item in changed:
        print(clean(f'  {name}: {old} -> {new}'))
    if changed:
        print('\nRelease news (excerpts when available; links otherwise):')
    for name, old, new, item in changed:
        link, notes = release_news(item, new)
        print(clean(f'  {name}: {link or "No upstream news URL available"}'))
        for line in notes.splitlines():
            print(f'    {line}')
    removed = sorted(name for kind, name in before if (kind, name) not in after)
    if removed:
        print(clean('\nRemoved packages: ' + ', '.join(removed)))


if __name__ == '__main__':
    main()
