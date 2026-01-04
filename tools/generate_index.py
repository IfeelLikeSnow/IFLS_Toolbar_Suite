#!/usr/bin/env python3
"""Generate a valid ReaPack index.xml for this repository.

Safe-by-design:
- Writes proper XML (<index version="1"> ...), never a URL list.
- Includes only files that actually exist in the repo.
- Marks entry scripts as main="main" (Actions in REAPER).
- URL-encodes paths to avoid ReaPack URL errors.

Usage:
  python tools/generate_index.py
Optional env vars:
  REAPACK_GITHUB_USER, REAPACK_GITHUB_REPO, REAPACK_REF
"""

from __future__ import annotations
import os, sys, subprocess
from pathlib import Path
from urllib.parse import quote
import xml.etree.ElementTree as ET

REPO_ROOT = Path(__file__).resolve().parents[1]
SCRIPTS_DIR = REPO_ROOT / "Scripts"
INDEX_PATH = REPO_ROOT / "index.xml"

def get_git_remote() -> str | None:
    try:
        out = subprocess.check_output(["git", "remote", "get-url", "origin"], cwd=REPO_ROOT, text=True).strip()
        return out or None
    except Exception:
        return None

def parse_user_repo(remote: str) -> tuple[str|None, str|None]:
    # supports https://github.com/user/repo(.git) and git@github.com:user/repo(.git)
    remote = remote.strip()
    if remote.startswith("git@github.com:"):
        path = remote.split(":", 1)[1]
    elif "github.com/" in remote:
        path = remote.split("github.com/", 1)[1]
    else:
        return None, None
    path = path.removesuffix(".git")
    parts = [p for p in path.split("/") if p]
    if len(parts) >= 2:
        return parts[0], parts[1]
    return None, None

def get_head_sha() -> str | None:
    try:
        return subprocess.check_output(["git", "rev-parse", "HEAD"], cwd=REPO_ROOT, text=True).strip()
    except Exception:
        return None

def iter_sources() -> list[Path]:
    if not SCRIPTS_DIR.exists():
        return []
    allowed = {".lua", ".eel", ".py", ".jsfx", ".txt", ".png", ".csv", ".json", ".md"}
    files = []
    for p in SCRIPTS_DIR.rglob("*"):
        if p.is_file() and p.suffix.lower() in allowed:
            # skip hidden/system-ish
            if any(part.startswith(".") for part in p.relative_to(REPO_ROOT).parts):
                continue
            files.append(p)
    return sorted(files, key=lambda x: str(x).lower())

def is_main(path: Path) -> bool:
    rel = path.relative_to(REPO_ROOT).as_posix()
    return "/entry/" in rel or rel.endswith("/tools/diagnostics.lua")

def main() -> int:
    user = os.environ.get("REAPACK_GITHUB_USER")
    repo = os.environ.get("REAPACK_GITHUB_REPO")
    ref  = os.environ.get("REAPACK_REF")  # e.g. a commit sha or 'main'

    remote = get_git_remote()
    if (not user or not repo) and remote:
        u, r = parse_user_repo(remote)
        user = user or u
        repo = repo or r

    sha = get_head_sha()
    ref = ref or sha or "main"

    if not user or not repo:
        print("ERROR: Can't determine GitHub user/repo. Set REAPACK_GITHUB_USER and REAPACK_GITHUB_REPO.", file=sys.stderr)
        return 2

    base = f"https://raw.githubusercontent.com/{user}/{repo}/{ref}/"

    # version name: if VERSION file exists use it; else use short sha; else 'dev'
    version_name = "dev"
    vfile = REPO_ROOT / "VERSION"
    if vfile.exists():
        version_name = vfile.read_text(encoding="utf-8").strip() or version_name
    elif sha:
        version_name = sha[:7]

    idx = ET.Element("index", {"version":"1", "name":"IFLS_Toolbar_Suite"})
    if sha:
        idx.set("commit", sha)

    cat = ET.SubElement(idx, "category", {"name":"Scripts"})
    rp = ET.SubElement(cat, "reapack", {
        "name":"IFLS_Toolbar_Suite (Core)",
        "type":"script",
        "desc":"IFLS_Toolbar_Suite – Button 1 + core libs (ReaPack)"
    })
    ver = ET.SubElement(rp, "version", {"name": version_name})

    for f in iter_sources():
        rel = f.relative_to(REPO_ROOT).as_posix()
        url = base + quote(rel)
        attrs = {"file": rel, "url": url}
        if is_main(f):
            attrs["main"] = "main"
        ET.SubElement(ver, "source", attrs)

    # pretty-ish output
    xml_bytes = ET.tostring(idx, encoding="utf-8", xml_declaration=True)
    INDEX_PATH.write_bytes(xml_bytes + b"\n")
    print(f"Wrote {INDEX_PATH} with {len(ver.findall('source'))} sources (ref={ref}).")
    return 0

if __name__ == "__main__":
    raise SystemExit(main())
