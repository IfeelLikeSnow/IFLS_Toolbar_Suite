#!/usr/bin/env python3
import os, sys
import xml.etree.ElementTree as ET
from pathlib import Path

def main() -> int:
    repo_root = Path(__file__).resolve().parent.parent
    index_path = repo_root / "index.xml"
    try:
        tree = ET.parse(index_path)
    except Exception as e:
        print(f"ERROR: index.xml is not valid XML: {e}")
        return 2

    root = tree.getroot()
    if root.tag != "index":
        print(f"ERROR: root tag must be <index>, got <{root.tag}>")
        return 2

    sources = root.findall(".//source")
    if not sources:
        print("ERROR: no <source> entries found.")
        return 2

    bad = 0
    missing = 0
    for s in sources:
        file_attr = s.get("file") or ""
        url_attr = s.get("url")
        url_text = (s.text or "").strip()

        if url_attr:
            print(f"ERROR: <source> has forbidden url= attribute (ReaPack expects URL as text): file={file_attr} url={url_attr}")
            bad += 1

        if not url_text:
            print(f"ERROR: empty source url text for file={file_attr}")
            bad += 1

        if not file_attr:
            print("ERROR: <source> missing file= attribute")
            bad += 1
        else:
            p = (repo_root / file_attr)
            if not p.exists():
                print(f"ERROR: file referenced by index.xml not found: {file_attr}")
                missing += 1

    if bad or missing:
        print(f"FAILED: {bad} invalid source entries, {missing} missing files")
        return 2

    print("OK: index.xml passed validation")
    print(f"  sources: {len(sources)}")
    return 0

if __name__ == "__main__":
    raise SystemExit(main())
