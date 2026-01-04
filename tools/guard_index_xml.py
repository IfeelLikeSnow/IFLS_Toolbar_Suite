#!/usr/bin/env python3
import sys, xml.etree.ElementTree as ET, pathlib

p = pathlib.Path('index.xml')
if not p.exists():
    print('ERROR: index.xml missing')
    sys.exit(1)

txt = p.read_text(encoding='utf-8', errors='replace').lstrip()
if not txt.startswith('<'):
    print('ERROR: index.xml does not start with "<" (looks like a URL list / corrupted).')
    sys.exit(1)

try:
    ET.parse(str(p))
except Exception as e:
    print('ERROR: index.xml is not valid XML:', e)
    sys.exit(1)

print('OK: index.xml looks like valid XML')
sys.exit(0)
