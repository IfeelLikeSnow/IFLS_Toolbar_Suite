#!/usr/bin/env python3
import sys, os, xml.etree.ElementTree as ET

def main():
    path = os.path.join(os.path.dirname(__file__), "..", "index.xml")
    path = os.path.abspath(path)
    try:
        tree = ET.parse(path)
    except Exception as e:
        print(f"ERROR: index.xml is not valid XML: {e}")
        return 2
    root = tree.getroot()
    if root.tag != "index":
        print(f"ERROR: root tag must be <index>, got <{root.tag}>")
        return 2
    # basic sanity
    sources = root.findall(".//source")
    if not sources:
        print("ERROR: no <source> entries found.")
        return 2
    print("OK: index.xml basic XML validation passed")
    print(f"  sources: {len(sources)}")
    return 0

if __name__ == "__main__":
    raise SystemExit(main())
