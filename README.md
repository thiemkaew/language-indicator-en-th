# Language Indicator EN/TH

Windows caret language indicator based on Language Indicator v0.78, customized for English and Thai.

- English: white **EN** text on a blue badge.
- Thai: white **TH** text on a green badge.
- Compact **36 × 20 px** badges, including Caps Lock variants.
- Detects the keyboard layout of the focused input control. This fixes modern Notepad showing EN after its editor switches to Thai.
- Maps English to badge 1 and Thai to badge 2 independently of language order.
- Uses native GUI PNG rendering and reads PNG dimensions from the file header.

## Run from source

1. Install AutoHotkey **v2** on Windows.
2. Download or clone this repository, keeping `carets` and `cursors` next to `language-indicator.ahk`.
3. Exit any already running Language Indicator from the notification area.
4. Run `language-indicator.ahk` with AutoHotkey v2.

The script is self-contained; its helper libraries are embedded in the source. `assets` contains the editable badge images. The source was exported from the working customized application and retains the original bundled helper code.

To produce an executable, use AutoHotkey's Ahk2Exe with a v2 base and compile `language-indicator.ahk`. Keep the `carets` and `cursors` folders beside the resulting executable. A compiled executable is not included in this source repository.

## Verification on Windows

- Notepad: English `a`, Thai `ฟ`, then English `a`; badges followed each switch.
- Notepad: both languages with Caps Lock enabled; badge also remained visible while idle.
- Google Chrome: English `a` and Thai `ฟ` in a textarea; switching back showed EN.

Caret availability depends on the application exposing its text caret; these results describe the applications tested, not every Windows application.

## Optional diagnostics

Run with `--diagnostics` to write `badge-test.json` beside the script. It records the active process, keyboard-layout/thread metadata, and badge state/position. It does not record typed text. Normal startup does not write this log.

## Source provenance

This repository contains the customized Language Indicator v0.78 source and bundled helper libraries from the installed application. Original upstream copyright and license notices, where present, are retained. No new license is asserted for third-party code.
