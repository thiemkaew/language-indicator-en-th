# Language Indicator EN/TH

Windows caret language indicator based on Language Indicator v0.78, customized for English and Thai.

- English: white **EN** text on a blue badge.
- Thai: white **TH** text on a green badge.
- Compact **36 × 20 px** badges, including Caps Lock variants.
- Detects the keyboard layout of the focused input control. This fixes modern Notepad showing EN after its editor switches to Thai.
- Maps English to badge 1 and Thai to badge 2 independently of language order.
- Uses native GUI PNG rendering and reads PNG dimensions from the file header.

## ใช้งานบน Windows (ชุดพร้อมใช้)

1. ดาวน์โหลด **Code > Download ZIP** จาก GitHub แล้วแตกไฟล์ทั้งหมดก่อนใช้งาน
2. เก็บโฟลเดอร์นี้ไว้ในตำแหน่งถาวร แล้วดับเบิลคลิก `START.cmd` หรือ `language-indicator.exe` ไม่ต้องติดตั้ง AutoHotkey
3. หากต้องการเริ่มพร้อม Windows ให้เรียก `install.cmd` หลังวางโฟลเดอร์ในตำแหน่งถาวรแล้ว
4. `uninstall.cmd` ยกเลิกการเริ่มพร้อม Windows เท่านั้น หากต้องการหยุดโปรแกรมให้ Exit จากไอคอนบริเวณนาฬิกาด้วย
5. หากต้องการคืนรูปป้ายเริ่มต้น ให้ Exit โปรแกรม เรียก `RUN-SETUP.cmd` แล้วเปิดโปรแกรมใหม่ ตัวตั้งค่าจะสำรอง carets ก่อนและกำหนด 1 = EN / 2 = TH อัตโนมัติ

ห้ามแยก `.exe` ออกจากโฟลเดอร์ `carets` และ `cursors` และไม่ต้องเลือกสลับหมายเลขภาษาด้วยตนเอง รองรับป้ายภาษาอังกฤษและไทยตามที่ทดสอบ ไม่ได้ยืนยันทุกแอปหรือทุกภาษา

### ไฟล์ในชุด

| ไฟล์ | หน้าที่ |
| --- | --- |
| `language-indicator.ahk` | ซอร์ส AutoHotkey v2 รวม helper libraries |
| `language-indicator.exe` | ตัวโปรแกรม Windows พร้อมใช้จากชุดที่ทดสอบ |
| `START.cmd` | เปิดโปรแกรม |
| `install.cmd` / `uninstall.cmd` | เพิ่ม/ลบ shortcut เริ่มพร้อม Windows |
| `RUN-SETUP.cmd` / `Setup-TH-EN.ps1` | คืนค่ารูปป้ายพร้อมสำรองของเดิม |
| `assets` / `carets` / `cursors` | รูปป้ายและ cursor ประกอบ |
| `SHA256SUMS.txt` | SHA-256 ของไฟล์ในชุด |

ตัวโปรแกรมที่แนบเป็นไฟล์ที่ใช้งานและทดสอบก่อนหน้านี้ ไม่ใช่ binary ที่สร้างใหม่จากขั้นตอน build ใน repository นี้ ไฟล์สำรองส่วนตัวและ diagnostic log จากเครื่องผู้ใช้ไม่รวมอยู่ในชุด

## Run from source

1. Install AutoHotkey **v2** on Windows.
2. Download or clone this repository, keeping `carets` and `cursors` next to `language-indicator.ahk`.
3. Exit any already running Language Indicator from the notification area.
4. Run `language-indicator.ahk` with AutoHotkey v2.

The script is self-contained; its helper libraries are embedded in the source. `assets` contains the editable badge images. The source was exported from the working customized application and retains the original bundled helper code.

To produce an executable, use AutoHotkey's Ahk2Exe with a v2 base and compile `language-indicator.ahk`. Keep the `carets` and `cursors` folders beside the resulting executable. The repository also includes the working Windows executable copied from the tested installation. It does not require AutoHotkey to run.

## Verification on Windows

- Notepad: English `a`, Thai `ฟ`, then English `a`; badges followed each switch.
- Notepad: both languages with Caps Lock enabled; badge also remained visible while idle.
- Google Chrome: English `a` and Thai `ฟ` in a textarea; switching back showed EN.

Caret availability depends on the application exposing its text caret; these results describe the applications tested, not every Windows application.

## Optional diagnostics

Run with `--diagnostics` to write `badge-test.json` beside the script. It records the active process, keyboard-layout/thread metadata, and badge state/position. It does not record typed text. Normal startup does not write this log.

## Source provenance

This repository contains the customized Language Indicator v0.78 source and bundled helper libraries from the installed application. Original upstream copyright and license notices, where present, are retained. No new license is asserted for third-party code.
