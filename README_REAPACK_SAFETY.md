# IFLS_Toolbar_Suite – ReaPack safety checklist

If ReaPack shows HTTP 404 for files under raw.githubusercontent.com, it's always one of these:

1) The file is not present on GitHub at that exact path/case.
2) `index.xml` references a path that does not exist.
3) ReaPack is using a cached (old) index or cached downloads.

## Guaranteed safe workflow

1. **Never hand-edit `index.xml`.** Always run:
   - `tools/RELEASE.bat` (Windows) or `python tools/generate_index.py` then `python tools/validate_reapack_index.py`

2. Before committing, confirm `index.xml` begins with `<?xml` and contains `<index version="1">`.

3. After pushing, verify these URLs in a browser:
   - `https://raw.githubusercontent.com/IfeelLikeSnow/IFLS_Toolbar_Suite/main/index.xml`
   - Any file that ReaPack complains about (copy/paste the URL).

4. If you changed paths, bump the `<version name="...">` in `index.xml` and clear ReaPack cache:
   - `%APPDATA%\REAPER\ReaPack\cache\`

This repo includes a GitHub Action that runs the validator on every push to `main`.
