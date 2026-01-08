"""
Simple Lua short-string newline / unterminated string scanner.
Usage:
  python tools/syntax_scan_strings.py
"""
import pathlib, sys, re

def scan(text):
    issues=[]
    i=0
    n=len(text)
    state="code"
    quote=None
    long_delim=None
    while i<n:
        ch=text[i]
        nxt=text[i+1] if i+1<n else ''
        if state=="code":
            if ch=='-' and nxt=='-':
                if i+3<n and text[i+2]=='[':
                    m=re.match(r'--\[(=*)\[', text[i:])
                    if m:
                        long_delim=m.group(1); state="longcomment"; i+=len(m.group(0)); continue
                state="linecomment"; i+=2; continue
            if ch=='[':
                m=re.match(r'\[(=*)\[', text[i:])
                if m:
                    long_delim=m.group(1); state="longstring"; i+=len(m.group(0)); continue
            if ch in ("'", '"'):
                quote=ch; state="string"; i+=1; continue
            i+=1; continue
        if state=="linecomment":
            if ch=='\n': state="code"
            i+=1; continue
        if state=="longcomment":
            if ch==']':
                m=re.match(r'\]'+re.escape(long_delim)+r'\]', text[i:])
                if m: state="code"; i+=len(m.group(0)); continue
            i+=1; continue
        if state=="longstring":
            if ch==']':
                m=re.match(r'\]'+re.escape(long_delim)+r'\]', text[i:])
                if m: state="code"; i+=len(m.group(0)); continue
            i+=1; continue
        if state=="string":
            if ch=='\\': i+=2; continue
            if ch=='\n' or ch=='\r': issues.append("newline_in_string"); state="code"; quote=None; i+=1; continue
            if ch==quote: state="code"; quote=None; i+=1; continue
            i+=1; continue
    if state=="string": issues.append("unterminated_string_eof")
    return issues

root=pathlib.Path(__file__).resolve().parents[1]
bad=[]
for p in root.rglob("*.lua"):
    try:
        txt=p.read_text(encoding="utf-8", errors="replace")
    except Exception:
        continue
    iss=scan(txt)
    if iss:
        bad.append((str(p.relative_to(root)).replace("\\","/"), iss))
if bad:
    for f, iss in bad:
        print("BAD", f, iss)
    sys.exit(1)
print("OK: no short-string newline/unterminated-string issues found")
