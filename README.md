# FUBoot Tours

VRML mini-game from a Freie Universität Berlin course (*Webbasierte 3D-Anwendungsentwicklung*, ca. 2003): steer a submarine through a virtual sea around the former Soviet submarine harbour of Murmansk.

## Contents

| Path | Description |
|------|-------------|
| `index.html` | Framed website entry |
| `vrml/welt.wrl` | Open-sea world (UBoot HUD + Navigator + seabed sphere) |
| `vrml/play-opensea.html` | X_ITE player for the open sea |
| `vrml/harbour/` | Harbour scavenger hunt + `play.html` |
| `dokumentation/` | Course documentation (Word) |
| `sponsoren/` | Sponsor assets |
| `addon/` | Notes on historical VRML tooling (installers excluded from git) |

## Play with X_ITE (localhost)

```bash
python3 serve-xite.py
```

- Open sea (gauge HUD): http://127.0.0.1:8765/vrml/play-opensea.html
- Harbour scavenger: http://127.0.0.1:8765/vrml/harbour/play.html

On the open sea, hover the left strip for forward/back speed and the circular pad for turn + dive/rise; click the pad to lock/unlock course.

## Requirements (historical)

Originally needed a browser with the **Blaxxun Contact** VRML plugin and a PC of about Pentium III / Athlon era with 3D acceleration. Modern browsers can use the X_ITE pages above instead.

## Authors

Andreas Gramm, Philipp Heroven, Oliver Kudell, Frank Schlesinger — Fachbereich Informatik, Freie Universität Berlin.
