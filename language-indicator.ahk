; <COMPILER: v1.1.37.02>
#requires AutoHotkey v2.0
#singleinstance force
#requires AutoHotkey v2.0
#requires AutoHotkey v2.0
#requires AutoHotkey v2.0
class MarkResolver {
static GetMarkName(locale, capslock) {
if (locale == 1 and capslock == 0)
return ""
figures := Map("0", "circle", "1", "arrow")
colors := Map("1", "white", "2", "red", "3", "green", "4", "blue")
sizes := ["9px", "12px"]
figure := figures.Get("" . capslock, "undefined")
color := colors.Get("" . locale, "undefined")
size := sizes[2]
return figure "_" color "_" size
}
static GetMarkFile(filesCfg, locale, capslock) {
for ext in filesCfg.extensions {
if capslock {
path := filesCfg.folder . locale . filesCfg.capslockSuffix . ext
if FileExist(path)
return path
}
path := filesCfg.folder . locale . ext
if FileExist(path)
return path
}
return ""
}
}
#requires AutoHotkey v2.0
#requires AutoHotkey v2.0
GetCapslockState() {
return GetKeyState("Capslock", "T")
}
#requires AutoHotkey v2.0
#requires AutoHotkey v2.0
#DllLoad "Imm32"
global imm := DllCall("GetModuleHandle", "Str", "Imm32", "Ptr")
global immGetDefaultIMEWnd := DllCall("GetProcAddress", "Ptr", imm, "AStr", "ImmGetDefaultIMEWnd", "Ptr")
GetInputLocaleId() {
global languageProbe
foregroundWindow := DllCall("GetForegroundWindow", "Ptr")
foregroundThread := DllCall("GetWindowThreadProcessId", "Ptr", foregroundWindow, "Ptr", 0, "UInt")
focusWindow := 0
info := Buffer(A_PtrSize = 8 ? 72 : 48, 0)
NumPut("UInt", info.Size, info)
if DllCall("GetGUIThreadInfo", "UInt", 0, "Ptr", info)
focusWindow := NumGet(info, A_PtrSize = 8 ? 16 : 12, "Ptr")
targetWindow := focusWindow ? focusWindow : foregroundWindow
if WinActive("ahk_class ConsoleWindowClass") {
imeWindow := DllCall(immGetDefaultIMEWnd, "Ptr", foregroundWindow, "Ptr")
if imeWindow
targetWindow := imeWindow
}
inputThread := DllCall("GetWindowThreadProcessId", "Ptr", targetWindow, "Ptr", 0, "UInt")
if !inputThread
inputThread := foregroundThread
inputLocale := DllCall("GetKeyboardLayout", "UInt", inputThread, "Ptr")
languageProbe := {foregroundThread: foregroundThread, inputThread: inputThread, focusWindow: focusWindow, foregroundLayout: Format("0x{:X}", DllCall("GetKeyboardLayout", "UInt", foregroundThread, "Ptr")), inputLayout: Format("0x{:X}", inputLocale)}
return inputLocale
}
#requires AutoHotkey v2.0
HasValue(haystack, val) {
for index, value in haystack
if (value = val)
return index
if !IsObject(haystack)
throw ValueError("haystack id not an object", -1, haystack)
return 0
}
global localesArray := [GetInputLocaleId()]
GetInputLocaleIndex() {
; Stable badge assignment independent of startup language and encounter order.
lang := GetInputLocaleId() & 0xffff
if ((lang & 0x3ff) = 9)
return 1
if (lang = 0x041e)
return 2
return 0
}
class InputState {
locale := 1
capslock := 0
prev := {}
__New() {
this.prev := {
locale: 1,
capslock: 0
}
}
Update() {
this.prev.locale := this.locale
this.prev.capslock := this.capslock
this.locale := GetInputLocaleIndex()
this.capslock := GetCapslockState()
}
HasChanged() {
return this.locale != this.prev.locale
or this.capslock != this.prev.capslock
}
IsDefault() {
return this.locale == 1 and this.capslock == 0
}
}
#requires AutoHotkey v2.0
#Requires AutoHotkey v2.0-beta.13+
ImagePutBase64(image, extension := "", quality := "") {
return ImagePut("base64", image, extension, quality)
}
ImagePutBitmap(image) {
return ImagePut("bitmap", image)
}
ImagePutBuffer(image) {
return ImagePut("buffer", image)
}
ImagePutClipboard(image) {
return ImagePut("clipboard", image)
}
ImagePutCursor(image, xHotspot := "", yHotspot := "") {
return ImagePut("cursor", image, xHotspot, yHotspot)
}
ImagePutDC(image, alpha := "") {
return ImagePut("dc", image, alpha)
}
ImagePutDesktop(image) {
return ImagePut("desktop", image)
}
ImagePutEncodedBuffer(image, extension := "", quality := "") {
return ImagePut("EncodedBuffer", image, extension, quality)
}
ImagePutExplorer(image, default := "") {
return ImagePut("explorer", image, default)
}
ImagePutFile(image, filepath := "", quality := "") {
return ImagePut("file", image, filepath, quality)
}
ImagePutFormData(image, boundary := "--ImagePut abc 321 xyz--") {
return ImagePut("formdata", image, boundary)
}
ImagePutHBitmap(image, alpha := "") {
return ImagePut("hBitmap", image, alpha)
}
ImagePutHex(image, extension := "", quality := "") {
return ImagePut("hex", image, extension, quality)
}
ImagePutHIcon(image) {
return ImagePut("hIcon", image)
}
ImagePutRandomAccessStream(image, extension := "", quality := "") {
return ImagePut("RandomAccessStream", image, extension, quality)
}
ImagePutSafeArray(image, extension := "", quality := "") {
return ImagePut("safeArray", image, extension, quality)
}
ImagePutScreenshot(image, screenshot := "", alpha := "") {
return ImagePut("screenshot", image, screenshot, alpha)
}
ImagePutSharedBuffer(image, name := "") {
return ImagePut("SharedBuffer", image, name)
}
ImagePutStream(image, extension := "", quality := "") {
return ImagePut("stream", image, extension, quality)
}
ImagePutURI(image, extension := "", quality := "") {
return ImagePut("uri", image, extension, quality)
}
ImagePutWallpaper(image) {
return ImagePut("wallpaper", image)
}
ImagePutWICBitmap(image) {
return ImagePut("wicBitmap", image)
}
ImagePutWindow(image, title := "", pos := "", style := 0x82C80000, styleEx := 0x9, parent := "", playback := True, cache := False) {
return ImagePut("window", image, title, pos, style, styleEx, parent, playback, cache)
}
ImageShow(image, title := "", pos := "", style := 0x90000000, styleEx := 0x80088, parent := "", playback := True, cache := False) {
return ImagePut("show", image, title, pos, style, styleEx, parent, playback, cache)
}
ImageDestroy(image) {
return ImagePut.Destroy(image)
}
ImageWidth(image) {
return ImagePut.Dimensions(image)[1]
}
ImageHeight(image) {
return ImagePut.Dimensions(image)[2]
}
class ImagePut {
static decode := False
static render := True
static validate := False
static call(cotype, image, p*) {
this.gdiplusStartup()
try type := this.DontVerifyImageType(&image, &keywords)
catch
type := this.ImageType(image)
crop      := keywords.HasProp("crop")      ? keywords.crop      : ""
scale     := keywords.HasProp("scale")     ? keywords.scale     : ""
upscale   := keywords.HasProp("upscale")   ? keywords.upscale   : ""
downscale := keywords.HasProp("downscale") ? keywords.downscale : ""
sprite    := keywords.HasProp("sprite")    ? keywords.sprite    : ""
decode    := keywords.HasProp("decode")    ? keywords.decode    : this.decode
render    := keywords.HasProp("render")    ? keywords.render    : this.render
validate  := keywords.HasProp("validate")  ? keywords.validate  : this.validate
try index := keywords.index
cleanup := ""
try stream := this.ImageToStream(type, image, keywords)
catch Error as e
if (e.Message ~= "^Conversion from")
goto make_bitmap
else throw
if not stream
throw Error("Stream cannot be zero.")
stream:
DllCall("shlwapi\IStream_Size", "ptr", stream, "uint64*", &size:=0, "hresult")
DllCall("shlwapi\IStream_Reset", "ptr", stream, "hresult")
size := min(size, 2048)
bin := Buffer(size)
(ComCall(Seek := 5, stream, "uint64", 0, "uint", 1, "uint64*", &current:=0), current != 0 && MsgBox(current))
DllCall("shlwapi\IStream_Read", "ptr", stream, "ptr", bin, "uint", size, "hresult")
DllCall("shlwapi\IStream_Reset", "ptr", stream, "hresult")
length := 2*size + (size-1) + 1
VarSetStrCapacity(&str, length)
flags := 0x40000004
DllCall("crypt32\CryptBinaryToString", "ptr", bin, "uint", size, "uint", flags, "str", str, "uint*", &length)
extension := 0                                                              ? ""
: str ~= "(?i)66 74 79 70 61 76 69 66"                                      ? "avif"
: str ~= "(?i)^42 4d (.. ){36}00 00 .. 00 00 00"                            ? "bmp"
: str ~= "(?i)^01 00 00 00 (.. ){36}20 45 4D 46"                            ? "emf"
: str ~= "(?i)^47 49 46 38 (37|39) 61"                                      ? "gif"
: str ~= "(?i)66 74 79 70 68 65 69 63"                                      ? "heic"
: str ~= "(?i)^00 00 01 00"                                                 ? "ico"
: str ~= "(?i)^ff d8 ff"                                                    ? "jpg"
: str ~= "(?i)^25 50 44 46 2d"                                              ? "pdf"
: str ~= "(?i)^89 50 4e 47 0d 0a 1a 0a"                                     ? "png"
: str ~= "(?i)^(((?!3c|3e).. )|3c (3f|21) ((?!3c|3e).. )*3e )*+3c 73 76 67" ? "svg"
: str ~= "(?i)^(49 49 2a 00|4d 4d 00 2a)"                                   ? "tif"
: str ~= "(?i)^52 49 46 46 .. .. .. .. 57 45 42 50"                         ? "webp"
: str ~= "(?i)^d7 cd c6 9a"                                                 ? "wmf"
: ""
if (render && extension ~= "^(?i:pdf|svg)$") {
(extension = "pdf") && this.RenderPdf(&stream, index?)
(extension = "svg") && pBitmap := this.RenderSvg(&stream, 800, 800)
goto( IsSet(pBitmap) ? "bitmap" : "stream" )
}
weight := decode || crop || scale || upscale || downscale || sprite ||
!( cotype ~= "^(?i:encodedbuffer|url|hex|base64|uri|stream|randomaccessstream|safearray)$"
&& (!p.Has(1) || p[1] == "" || p[1] = extension)
|| cotype = "formdata"
&& (!p.Has(2) || p[2] == "" || p[2] = extension)
|| cotype = "file"
&& (!p.Has(1) || p[1] == "" || p[1] ~= "(^|:|\\|\.)" extension "$"
|| !(RegExReplace(p[1], "^.*(?:^|:|\\|\.)(.*)$", "$1")
~= "^(?i:avif|avifs|bmp|dib|rle|gif|heic|heif|hif|jpg|jpeg|jpe|jfif|png|tif|tiff)$"))
|| cotype)
if weight
goto clean_stream
try coimage := this.StreamToCoimage(cotype, stream, p*)
catch Error as e
if (e.Message ~= "^Conversion from")
goto clean_stream
else throw
if (cotype != "stream")
ObjRelease(stream)
goto exit
clean_stream:
type := "stream"
image := stream
cleanup := "stream"
make_bitmap:
if !(pBitmap := this.ImageToBitmap(type, image, keywords))
throw Error("pBitmap cannot be zero.")
bitmap:
(validate) && DllCall("gdiplus\GdipImageForceValidation", "ptr", pBitmap)
(crop) && this.BitmapCrop(&pBitmap, crop)
(scale) && this.BitmapScale(&pBitmap, scale)
(upscale) && this.BitmapScale(&pBitmap, upscale, 1)
(downscale) && this.BitmapScale(&pBitmap, downscale, -1)
(sprite) && this.BitmapSprite(&pBitmap)
if (type = "stream" && extension = "webp" && cotype ~= "^(?i:show|window)$") {
this.ParseWebp(stream, &pDelays, &pCount)
DllCall("gdiplus\GdipSetPropertyItem", "ptr", pBitmap, "ptr", pDelays)
DllCall("gdiplus\GdipSetPropertyItem", "ptr", pBitmap, "ptr", pCount)
}
coimage := this.BitmapToCoimage(cotype, pBitmap, p*)
if (cotype != "bitmap")
DllCall("gdiplus\GdipDisposeImage", "ptr", pBitmap)
if (cleanup = "stream")
ObjRelease(stream)
exit:
this.gdiplusShutdown(cotype)
return coimage
}
static Inputs :=
[
"ClipboardPng",
"Clipboard",
"SafeArray",
"Screenshot",
"Window",
"Object",
"EncodedBuffer",
"Buffer",
"Monitor",
"Desktop",
"Wallpaper",
"Cursor",
"Url",
"File",
"SharedBuffer",
"Hex",
"Base64",
"DC",
"HBitmap",
"HIcon",
"Bitmap",
"Stream",
"RandomAccessStream",
"WicBitmap",
"D2dBitmap"
]
static DontVerifyImageType(&image, &keywords := "") {
keywords := {}
if !IsObject(image)
throw Error("Must be an object.")
if image.HasProp("image") {
keywords := image
image := image.image
throw Error("Must catch this error with ImageType.")
}
for type in this.inputs
if image.HasProp(type) {
keywords := image
image := image.%type%
return type
}
throw Error("Invalid type.")
}
static ImageType(image) {
if not IsObject(image)
goto string
if image.HasProp("prototype") && image.prototype.HasProp("__class") && image.prototype.__class == "ClipboardAll"
or type(image) == "ClipboardAll" && this.IsClipboard(image.ptr, image.size)
if DllCall("IsClipboardFormatAvailable", "uint", DllCall("RegisterClipboardFormat", "str", "png", "uint"))
return "ClipboardPng"
else if DllCall("IsClipboardFormatAvailable", "uint", 2)
return "Clipboard"
else throw Error("Clipboard format not supported.")
array:
if ComObjType(image) and ComObjType(image) & 0x2000
return "SafeArray"
if image.HasProp("__Item") && image.HasProp("length") && image.length ~= "4|5"
&& image[1] ~= "^-?\d+$" && image[2] ~= "^-?\d+$" && image[3] ~= "^\d+$" && image[4] ~= "^\d+$"
&& (image.Has(5) ? WinExist(image[5]) : True)
return "Screenshot"
object:
if image.HasProp("hwnd")
return "Window"
if image.HasProp("pBitmap")
try if !DllCall("gdiplus\GdipGetImageType", "ptr", image.pBitmap, "ptr*", &_type:=0) && (_type == 1)
return "Object"
if not image.HasProp("ptr")
goto end
("POINTER IS BAD AND PROGRAM IS CRASH") && NumGet(image.ptr, "char")
if image.HasProp("ptr") && image.HasProp("size") && this.IsImage(image.ptr, image.size)
return "EncodedBuffer"
if image.HasProp("ptr")
and ( image.HasProp("width") && image.HasProp("height")
or image.HasProp("stride") && image.HasProp("height")
or image.HasProp("size") && (image.HasProp("stride") || image.HasProp("width") || image.HasProp("height")))
return "Buffer"
image := image.ptr
goto pointer
string:
if (image == "")
throw Error("Image data is an empty string.")
if (image ~= "^\d+$" && image >= 0 && image <= MonitorGetCount())
return "Monitor"
if (image = "desktop")
return "Desktop"
if (image = "wallpaper")
return "Wallpaper"
if (image ~= "(?i)^A_Cursor|Unknown|(IDC_)?(AppStarting|Arrow|Cross|Hand(writing)?|"
. "Help|IBeam|No|Pin|Person|SizeAll|SizeNESW|SizeNS|SizeNWSE|SizeWE|UpArrow|Wait)$")
return "Cursor"
if this.IsUrl(image)
return "Url"
if FileExist(image)
return "File"
if WinExist(image)
return "Window"
if DllCall("CloseHandle", "ptr", DllCall("OpenFileMapping", "uint", 2, "int", 0, "str", image, "ptr"))
return "SharedBuffer"
if (StrLen(image) >= 48) && (image ~= "^\s*(?:[A-Fa-f0-9]{2})*+\s*$")
return "Hex"
if (StrLen(image) >= 32) && (image ~= "^\s*(?:data:image\/[a-z]+;base64,)?"
. "(?:[A-Za-z0-9+\/]{4})*+(?:[A-Za-z0-9+\/]{3}=|[A-Za-z0-9+\/]{2}==)?\s*$")
return "Base64"
if not (image ~= "^-?\d+$") {
for extension in ["bmp","dib","rle","jpg","jpeg","jpe","jfif","gif","tif","tiff","png","ico","exe","dll"]
if FileExist(image "." extension)
throw Error("A ." extension " file extension is required!", -3)
goto end
}
handle:
if (DllCall("GetObjectType", "ptr", image, "uint") == 3 || DllCall("GetObjectType", "ptr", image, "uint") == 10)
return "DC"
if (DllCall("GetObjectType", "ptr", image, "uint") == 7)
return "HBitmap"
if DllCall("DestroyIcon", "ptr", DllCall("CopyIcon", "ptr", image, "ptr"))
return "HIcon"
("POINTER IS BAD AND PROGRAM IS CRASH") && NumGet(image, "char")
try if !DllCall("gdiplus\GdipGetImageType", "ptr", image, "ptr*", &_type:=0) && (_type == 1)
return "Bitmap"
(A_PtrSize == 8) && ObjRelease(image)
pointer:
try if ComObjQuery(image, "{0000000C-0000-0000-C000-000000000046}")
return "Stream"
try if ComObjQuery(image, "{905A0FE1-BC53-11DF-8C49-001E4FC686DA}")
return "RandomAccessStream"
try if ComObjQuery(image, "{00000120-A8F2-4877-BA0A-FD2B6645FB94}")
return "WicBitmap"
try if ComObjQuery(image, "{A2296057-EA42-4099-983B-539FB6505426}")
return "D2dBitmap"
end:
throw Error("Image type could not be identified.")
}
static ImageToBitmap(type, image, keywords := "") {
try index := keywords.index
if (type = "ClipboardPng")
return this.ClipboardPngToBitmap()
if (type = "Clipboard")
return this.ClipboardToBitmap()
if (type = "SafeArray")
return this.SafeArrayToBitmap(image)
if (type = "Screenshot")
return this.ScreenshotToBitmap(image)
if (type = "Window")
return this.WindowToBitmap(image)
if (type = "Object")
return this.BitmapToBitmap(image.pBitmap)
if (type = "EncodedBuffer")
return this.EncodedBufferToBitmap(image)
if (type = "Buffer")
return this.BufferToBitmap(image)
if (type = "SharedBuffer")
return this.SharedBufferToBitmap(image)
if (type = "Monitor")
return this.MonitorToBitmap(image)
if (type = "Desktop")
return this.DesktopToBitmap()
if (type = "Wallpaper")
return this.WallpaperToBitmap()
if (type = "Cursor")
return this.CursorToBitmap()
if (type = "Url")
return this.UrlToBitmap(image)
if (type = "File")
return this.FileToBitmap(image)
if (type = "Hex")
return this.HexToBitmap(image)
if (type = "Base64")
return this.Base64ToBitmap(image)
if (type = "DC")
return this.DCToBitmap(image)
if (type = "HBitmap")
return this.HBitmapToBitmap(image)
if (type = "HIcon")
return this.HIconToBitmap(image)
if (type = "Bitmap")
return this.BitmapToBitmap(image)
if (type = "Stream")
return this.StreamToBitmap(image)
if (type = "RandomAccessStream")
return this.RandomAccessStreamToBitmap(image)
if (type = "WicBitmap")
return this.WicBitmapToBitmap(image)
if (type = "D2dBitmap")
return this.D2dBitmapToBitmap(image)
throw Error("Conversion from " type " to bitmap is not supported.")
}
static BitmapToCoimage(cotype, pBitmap, p1:="", p2:="", p3:="", p4:="", p5:="", p6:="", p7:="", p*) {
if (cotype = "Clipboard")
return this.BitmapToClipboard(pBitmap)
if (cotype = "Screenshot")
return this.BitmapToScreenshot(pBitmap, p1, p2)
if (cotype = "Window")
return this.BitmapToWindow(pBitmap, p1, p2, p3, p4, p5, p6, p7)
if (cotype = "Show")
return this.Show(pBitmap, p1, p2, p3, p4, p5, p6, p7)
if (cotype = "EncodedBuffer")
return this.BitmapToEncodedBuffer(pBitmap, p1, p2)
if (cotype = "Buffer")
return this.BitmapToBuffer(pBitmap)
if (cotype = "SharedBuffer")
return this.BitmapToSharedBuffer(pBitmap, p1)
if (cotype = "Desktop")
return this.BitmapToDesktop(pBitmap)
if (cotype = "Wallpaper")
return this.BitmapToWallpaper(pBitmap)
if (cotype = "Cursor")
return this.BitmapToCursor(pBitmap, p1, p2)
if (cotype = "Url")
return this.BitmapToUrl(pBitmap)
if (cotype = "File")
return this.BitmapToFile(pBitmap, p1, p2)
if (cotype = "Hex")
return this.BitmapToHex(pBitmap, p1, p2)
if (cotype = "Base64")
return this.BitmapToBase64(pBitmap, p1, p2)
if (cotype = "Uri")
return this.BitmapToUri(pBitmap, p1, p2)
if (cotype = "DC")
return this.BitmapToDC(pBitmap, p1)
if (cotype = "HBitmap")
return this.BitmapToHBitmap(pBitmap, p1)
if (cotype = "HIcon")
return this.BitmapToHIcon(pBitmap)
if (cotype = "Bitmap")
return pBitmap
if (cotype = "Stream")
return this.BitmapToStream(pBitmap, p1, p2)
if (cotype = "RandomAccessStream")
return this.BitmapToRandomAccessStream(pBitmap, p1, p2)
if (cotype = "WicBitmap")
return this.BitmapToWicBitmap(pBitmap)
if (cotype = "Explorer")
return this.BitmapToExplorer(pBitmap, p1)
if (cotype = "SafeArray")
return this.BitmapToSafeArray(pBitmap, p1, p2)
if (cotype = "FormData")
return this.BitmapToFormData(pBitmap, p1, p2, p3)
throw Error("Conversion from bitmap to " cotype " is not supported.")
}
static ImageToStream(type, image, keywords := "") {
try index := keywords.index
if (type = "ClipboardPng")
return this.ClipboardPngToStream()
if (type = "SafeArray")
return this.SafeArrayToStream(image)
if (type = "EncodedBuffer")
return this.EncodedBufferToStream(image)
if (type = "Url")
return this.UrlToStream(image)
if (type = "File")
return this.FileToStream(image)
if (type = "Hex")
return this.HexToStream(image)
if (type = "Base64")
return this.Base64ToStream(image)
if (type = "Stream")
return this.StreamToStream(image)
if (type = "RandomAccessStream")
return this.RandomAccessStreamToStream(image)
throw Error("Conversion from " type " to stream is not supported.")
}
static StreamToCoimage(cotype, stream, p1 := "", p2 := "", p*) {
if (cotype = "Clipboard")
return this.StreamToClipboard(stream)
if (cotype = "EncodedBuffer")
return this.StreamToEncodedBuffer(stream)
if (cotype = "File")
return this.StreamToFile(stream, p1)
if (cotype = "Hex")
return this.StreamToHex(stream)
if (cotype = "Base64")
return this.StreamToBase64(stream)
if (cotype = "Uri")
return this.StreamToUri(stream)
if (cotype = "Stream")
return stream
if (cotype = "RandomAccessStream")
return this.StreamToRandomAccessStream(stream)
if (cotype = "Explorer")
return this.StreamToExplorer(stream, p1)
if (cotype = "SafeArray")
return this.StreamToSafeArray(stream)
if (cotype = "FormData")
return this.StreamToFormData(stream, p1)
throw Error("Conversion from stream to " cotype " is not supported.")
}
static BitmapCrop(&pBitmap, crop) {
if not (IsObject(crop)
&& crop[1] ~= "^-?\d+(\.\d*)?%?$" && crop[2] ~= "^-?\d+(\.\d*)?%?$"
&& crop[3] ~= "^-?\d+(\.\d*)?%?$" && crop[4] ~= "^-?\d+(\.\d*)?%?$")
throw Error("Invalid crop.")
DllCall("gdiplus\GdipGetImageWidth", "ptr", pBitmap, "uint*", &width:=0)
DllCall("gdiplus\GdipGetImageHeight", "ptr", pBitmap, "uint*", &height:=0)
DllCall("gdiplus\GdipGetImagePixelFormat", "ptr", pBitmap, "int*", &format:=0)
(crop[1] ~= "%$") && crop[1] := SubStr(crop[1], 1, -1) * 0.01 *  width
(crop[2] ~= "%$") && crop[2] := SubStr(crop[2], 1, -1) * 0.01 * height
(crop[3] ~= "%$") && crop[3] := SubStr(crop[3], 1, -1) * 0.01 *  width
(crop[4] ~= "%$") && crop[4] := SubStr(crop[4], 1, -1) * 0.01 * height
crop[1] := Abs(crop[1])
crop[2] := Abs(crop[2])
crop[3] := (crop[3] < 0) ?  width - Abs(crop[3]) - Abs(crop[1]) : crop[3]
crop[4] := (crop[4] < 0) ? height - Abs(crop[4]) - Abs(crop[2]) : crop[4]
crop[1] := Round(crop[1])
crop[2] := Round(crop[2])
crop[3] := Round(crop[1] + crop[3]) - Round(crop[1])
crop[4] := Round(crop[2] + crop[4]) - Round(crop[2])
if (crop[1] = 0 && crop[2] = 0 && crop[3] == width && crop[4] == height)
return pBitmap
safe_x := (crop[1] >= width)
safe_y := (crop[2] >= height)
safe_w := (crop[3] <= 0 || crop[1] + crop[3] > width)
safe_h := (crop[4] <= 0 || crop[2] + crop[4] > height)
if (safe_x || safe_y || safe_w || safe_h)
return pBitmap
DllCall("gdiplus\GdipCloneBitmapAreaI"
,    "int", crop[1]
,    "int", crop[2]
,    "int", crop[3]
,    "int", crop[4]
,    "int", format
,    "ptr", pBitmap
,   "ptr*", &pBitmapCrop:=0)
DllCall("gdiplus\GdipDisposeImage", "ptr", pBitmap)
return pBitmap := pBitmapCrop
}
static BitmapScale(&pBitmap, scale, direction := 0) {
if not (IsObject(scale) && ((scale[1] ~= "^\d+$") || (scale[2] ~= "^\d+$")) || (scale ~= "^\d+(\.\d+)?$"))
throw Error("Invalid scale.")
DllCall("gdiplus\GdipGetImageWidth", "ptr", pBitmap, "uint*", &width:=0)
DllCall("gdiplus\GdipGetImageHeight", "ptr", pBitmap, "uint*", &height:=0)
DllCall("gdiplus\GdipGetImagePixelFormat", "ptr", pBitmap, "int*", &format:=0)
if IsObject(scale) {
safe_w := (scale[1] ~= "^\d+$") ? scale[1] : Round(width / height * scale[2])
safe_h := (scale[2] ~= "^\d+$") ? scale[2] : Round(height / width * scale[1])
} else {
safe_w := Ceil(width * scale)
safe_h := Ceil(height * scale)
}
if (safe_w = width && safe_h = height)
return pBitmap
if (direction > 0 and (safe_w < width && safe_h < height))
return pBitmap
if (direction < 0 and (safe_w > width && safe_h > height))
return pBitmap
DllCall("gdiplus\GdipCreateBitmapFromScan0"
, "int", safe_w, "int", safe_h, "int", 0, "int", format, "ptr", 0, "ptr*", &pBitmapScale:=0)
DllCall("gdiplus\GdipGetImageGraphicsContext", "ptr", pBitmapScale, "ptr*", &pGraphics:=0)
DllCall("gdiplus\GdipSetPixelOffsetMode",    "ptr", pGraphics, "int", 2)
DllCall("gdiplus\GdipSetCompositingMode",    "ptr", pGraphics, "int", 1)
DllCall("gdiplus\GdipSetInterpolationMode",  "ptr", pGraphics, "int", 7)
DllCall("gdiplus\GdipCreateImageAttributes", "ptr*", &ImageAttr:=0)
DllCall("gdiplus\GdipSetImageAttributesWrapMode", "ptr", ImageAttr, "int", 3, "uint", 0, "int", 0)
DllCall("gdiplus\GdipDrawImageRectRectI"
,    "ptr", pGraphics
,    "ptr", pBitmap
,    "int", 0, "int", 0, "int", safe_w, "int", safe_h
,    "int", 0, "int", 0, "int",  width, "int", height
,    "int", 2
,    "ptr", ImageAttr
,    "ptr", 0
,    "ptr", 0)
DllCall("gdiplus\GdipDisposeImageAttributes", "ptr", ImageAttr)
DllCall("gdiplus\GdipDeleteGraphics", "ptr", pGraphics)
DllCall("gdiplus\GdipDisposeImage", "ptr", pBitmap)
return pBitmap := pBitmapScale
}
static BitmapSprite(&pBitmap) {
DllCall("gdiplus\GdipGetImageWidth", "ptr", pBitmap, "uint*", &width:=0)
DllCall("gdiplus\GdipGetImageHeight", "ptr", pBitmap, "uint*", &height:=0)
Rect := Buffer(16, 0)
NumPut(  "uint",   width, Rect,  8)
NumPut(  "uint",  height, Rect, 12)
BitmapData := Buffer(16+2*A_PtrSize, 0)
DllCall("gdiplus\GdipBitmapLockBits"
,    "ptr", pBitmap
,    "ptr", Rect
,   "uint", 3
,    "int", 0x26200A
,    "ptr", BitmapData)
Scan0 := NumGet(BitmapData, 16, "ptr")
static code := 0
if !code {
b64 := (A_PtrSize == 4)
? "VYnli0UIi1UMi00QOdBzDzkIdQbHAAAAAACDwATr7V3D"
: "SDnRcw9EOQF1BDHAiQFIg8EE6+zD"
s64 := StrLen(RTrim(b64, "=")) * 3 // 4
code := DllCall("GlobalAlloc", "uint", 0, "uptr", s64, "ptr")
DllCall("crypt32\CryptStringToBinary", "str", b64, "uint", 0, "uint", 0x1, "ptr", code, "uint*", s64, "ptr", 0, "ptr", 0)
DllCall("VirtualProtect", "ptr", code, "ptr", s64, "uint", 0x40, "uint*", 0)
}
DllCall(code, "ptr", Scan0, "ptr", Scan0 + 4*width*height, "uint", NumGet(Scan0, "uint"), "cdecl")
DllCall("gdiplus\GdipBitmapUnlockBits", "ptr", pBitmap, "ptr", BitmapData)
return pBitmap
}
static IsClipboard(ptr, size) {
if (ptr == 0 && size == 0)
return True
pos := 0
while (pos < size)
if (offset := NumGet(ptr + pos + 4, "uint"))
pos += offset + 8
else break
return pos + 4 == size && !NumGet(ptr + pos, "uint")
}
static IsImage(ptr, size) {
if (size < 24)
return False
size := min(size, 2048)
length := VarSetStrCapacity(&str, 2*size + (size-1) + 1)
DllCall("crypt32\CryptBinaryToString", "ptr", ptr, "uint", size, "uint", 0x40000004, "str", str, "uint*", &length)
if str ~= "(?i)66 74 79 70 61 76 69 66"
|| str ~= "(?i)^42 4d (.. ){36}00 00 .. 00 00 00"
|| str ~= "(?i)^01 00 00 00 (.. ){36}20 45 4D 46"
|| str ~= "(?i)^47 49 46 38 (37|39) 61"
|| str ~= "(?i)66 74 79 70 68 65 69 63"
|| str ~= "(?i)^00 00 01 00"
|| str ~= "(?i)^ff d8 ff"
|| str ~= "(?i)^25 50 44 46 2d"
|| str ~= "(?i)^89 50 4e 47 0d 0a 1a 0a"
|| str ~= "(?i)^(((?!3c|3e).. )|3c (3f|21) ((?!3c|3e).. )*3e )*+3c 73 76 67"
|| str ~= "(?i)^(49 49 2a 00|4d 4d 00 2a)"
|| str ~= "(?i)^52 49 46 46 .. .. .. .. 57 45 42 50"
|| str ~= "(?i)^d7 cd c6 9a"
return True
return False
}
static IsUrl(url) {
return url ~= "^(?i)"
. "(?:(?:https?|ftp):\/\/)"
. "(?:\S+(?::\S*)?@)?"
. "(?:"
. "(?!(?:10|127)(?:\.\d{1,3}){3})"
. "(?!(?:169\.254|192\.168)(?:\.\d{1,3}){2})"
. "(?!172\.(?:1[6-9]|2\d|3[0-1])(?:\.\d{1,3}){2})"
. "(?:[1-9]\d?|1\d\d|2[01]\d|22[0-3])"
. "(?:\.(?:1?\d{1,2}|2[0-4]\d|25[0-5])){2}"
. "(?:\.(?:[1-9]\d?|1\d\d|2[0-4]\d|25[0-4]))"
. "|"
. "(?:(?:[a-z0-9\x{00a1}-\x{ffff}][a-z0-9\x{00a1}-\x{ffff}_-]{0,62})?[a-z0-9\x{00a1}-\x{ffff}]\.)+"
. "(?:[a-z\x{00a1}-\x{ffff}]{2,}\.?)"
. ")"
. "(?::\d{2,5})?"
. "(?:[/?#]\S*)?$"
}
static ClipboardToBitmap() {
loop
if DllCall("OpenClipboard", "ptr", A_ScriptHwnd)
break
else
if A_Index < 6
Sleep (2**(A_Index-1) * 30)
else throw Error("Clipboard could not be opened.")
if DllCall("IsClipboardFormatAvailable", "uint", 8)
if !(handle := DllCall("GetClipboardData", "uint", 8, "ptr"))
throw Error("Shared clipboard data has been deleted.")
ptr := DllCall("GlobalLock", "ptr", handle, "ptr")
width := NumGet(ptr + 4, "int")
height := NumGet(ptr + 8, "int")
bpp := NumGet(ptr + 14, "ushort")
stride := ((height < 0) ? 1 : -1) * (width * bpp + 31) // 32 * 4
pBits := ptr + 40
Scan0 := (height < 0) ? pBits : pBits - stride*(height-1)
DllCall("gdiplus\GdipCreateBitmapFromScan0"
, "int", width, "int", height, "int", 0, "uint", 0x26200A, "ptr", 0, "ptr*", &pBitmap:=0)
Rect := Buffer(16, 0)
NumPut(  "uint",   width, Rect,  8)
NumPut(  "uint",  height, Rect, 12)
BitmapData := Buffer(16+2*A_PtrSize, 0)
NumPut(   "int",     stride, BitmapData,  8)
NumPut(   "ptr",      Scan0, BitmapData, 16)
DllCall("gdiplus\GdipBitmapLockBits"
,    "ptr", pBitmap
,    "ptr", Rect
,   "uint", 6
,    "int", 0x26200A
,    "ptr", BitmapData)
DllCall("gdiplus\GdipBitmapUnlockBits", "ptr", pBitmap, "ptr", BitmapData)
DllCall("CloseClipboard")
return pBitmap
}
static ClipboardPngToBitmap() {
stream := this.ClipboardPngToStream()
DllCall("gdiplus\GdipCreateBitmapFromStreamICM", "ptr", stream, "ptr*", &pBitmap:=0)
ObjRelease(stream)
return pBitmap
}
static ClipboardPngToStream() {
loop
if DllCall("OpenClipboard", "ptr", A_ScriptHwnd)
break
else
if A_Index < 6
Sleep (2**(A_Index-1) * 30)
else throw Error("Clipboard could not be opened.")
png := DllCall("RegisterClipboardFormat", "str", "png", "uint")
if !DllCall("IsClipboardFormatAvailable", "uint", png)
throw Error("Clipboard does not have PNG stream data.")
if !(handle := DllCall("GetClipboardData", "uint", png, "ptr"))
throw Error("Shared clipboard PNG has been deleted.")
size := DllCall("GlobalSize", "ptr", handle, "uptr")
DllCall("ole32\CreateStreamOnHGlobal", "ptr", handle, "int", False, "ptr*", &PngStream:=0, "hresult")
DllCall("ole32\CreateStreamOnHGlobal", "ptr", 0, "int", True, "ptr*", &stream:=0, "hresult")
DllCall("shlwapi\IStream_Copy", "ptr", PngStream, "ptr", stream, "uint", size, "hresult")
DllCall("CloseClipboard")
return stream
}
static SafeArrayToBitmap(image) {
stream := this.SafeArrayToStream(image)
DllCall("gdiplus\GdipCreateBitmapFromStreamICM", "ptr", stream, "ptr*", &pBitmap:=0)
ObjRelease(stream)
return pBitmap
}
static SafeArrayToStream(image) {
size := image.MaxIndex()
pvData := NumGet(ComObjValue(image), 8 + A_PtrSize, "ptr")
handle := DllCall("GlobalAlloc", "uint", 0x2, "uptr", size, "ptr")
ptr := DllCall("GlobalLock", "ptr", handle, "ptr")
DllCall("RtlMoveMemory", "ptr", ptr, "ptr", pvData, "uptr", size)
DllCall("GlobalUnlock", "ptr", handle)
DllCall("ole32\CreateStreamOnHGlobal", "ptr", handle, "int", True, "ptr*", &stream:=0, "hresult")
return stream
}
static EncodedBufferToBitmap(image) {
stream := this.EncodedBufferToStream(image)
DllCall("gdiplus\GdipCreateBitmapFromStreamICM", "ptr", stream, "ptr*", &pBitmap:=0)
ObjRelease(stream)
return pBitmap
}
static EncodedBufferToStream(image) {
handle := DllCall("GlobalAlloc", "uint", 0x2, "uptr", image.size, "ptr")
ptr := DllCall("GlobalLock", "ptr", handle, "ptr")
DllCall("RtlMoveMemory", "ptr", ptr, "ptr", image.ptr, "uptr", image.size)
DllCall("GlobalUnlock", "ptr", handle)
DllCall("ole32\CreateStreamOnHGlobal", "ptr", handle, "int", True, "ptr*", &stream:=0, "hresult")
return stream
}
static BufferToBitmap(image) {
if image.HasProp("pitch")
stride := image.pitch
else if image.HasProp("stride")
stride := image.stride
else if image.HasProp("width")
stride := image.width * 4
else if image.HasProp("height") && image.HasProp("size")
stride := image.size // image.height
else throw Error("Image buffer is missing a stride or pitch property.")
if image.HasProp("height")
height := image.height
else if stride && image.HasProp("size")
height := image.size // stride
else if image.HasProp("width") && image.HasProp("size")
height := image.size // (4 * image.width)
else throw Error("Image buffer is missing a height property.")
if image.HasProp("width")
width := image.width
else if stride
width := stride // 4
else if height && image.HasProp("size")
width := image.size // (4 * height)
else throw Error("Image buffer is missing a width property.")
if image.HasProp("size") && (abs(stride * height) > image.size)
throw Error("Image dimensions exceed the size of the buffer.")
if (height > 0)
DllCall("gdiplus\GdipCreateBitmapFromScan0", "int", width, "int", height
, "int", stride, "int", 0x26200A, "ptr", image.ptr, "ptr*", &pBitmap:=0)
else
DllCall("gdiplus\GdipCreateBitmapFromScan0", "int", width, "int", height
, "int", -stride, "int", 0x26200A, "ptr", image.ptr + (height-1)*stride, "ptr*", &pBitmap:=0)
return pBitmap
}
static read_screen() {
assert(statement, message) {
if !statement
throw ValueError(message, -1, statement)
}
assert IDXGIFactory := CreateDXGIFactory(), "Create IDXGIFactory failed."
CreateDXGIFactory() {
if !DllCall("GetModuleHandle", "str", "DXGI")
DllCall("LoadLibrary", "str", "DXGI")
if !DllCall("GetModuleHandle", "str", "D3D11")
DllCall("LoadLibrary", "str", "D3D11")
IID_IDXGIFactory1 := Buffer(16)
DllCall("ole32\IIDFromString", "wstr", "{770aae78-f26f-4dba-a829-253c83d1b387}", "ptr", IID_IDXGIFactory1, "hresult")
DllCall("DXGI\CreateDXGIFactory1", "ptr", IID_IDXGIFactory1, "ptr*", &IDXGIFactory1:=0, "hresult")
return IDXGIFactory1
}
loop {
ComCall(EnumAdapters := 7, IDXGIFactory, "uint", A_Index-1, "ptr*", &IDXGIAdapter:=0)
loop {
try ComCall(EnumOutputs := 7, IDXGIAdapter, "uint", A_Index-1, "ptr*", &IDXGIOutput:=0)
catch OSError as e
if e.number = 0x887A0002
break
else throw
ComCall(GetDesc := 7, IDXGIOutput, "ptr", DXGI_OUTPUT_DESC := Buffer(88+A_PtrSize, 0))
Width             := NumGet(DXGI_OUTPUT_DESC, 72, "int")
Height            := NumGet(DXGI_OUTPUT_DESC, 76, "int")
AttachedToDesktop := NumGet(DXGI_OUTPUT_DESC, 80, "int")
if (AttachedToDesktop = 1)
break 2
}
}
assert AttachedToDesktop, "No adapter attached to desktop."
DllCall("D3D11\D3D11CreateDevice"
,    "ptr", IDXGIAdapter
,    "int", D3D_DRIVER_TYPE_UNKNOWN := 0
,    "ptr", 0
,   "uint", 0
,    "ptr", 0
,   "uint", 0
,   "uint", D3D11_SDK_VERSION := 7
,   "ptr*", &d3d_device:=0
,   "ptr*", 0
,   "ptr*", &d3d_context:=0
,"hresult")
IDXGIOutput1 := ComObjQuery(IDXGIOutput, "{00cddea8-939b-4b83-a340-a685226666cc}")
ComCall(DuplicateOutput := 22, IDXGIOutput1, "ptr", d3d_device, "ptr*", &Duplication:=0)
ComCall(GetDesc := 7, Duplication, "ptr", DXGI_OUTDUPL_DESC := Buffer(36, 0))
DesktopImageInSystemMemory := NumGet(DXGI_OUTDUPL_DESC, 32, "uint")
Sleep 50
D3D11_TEXTURE2D_DESC := Buffer(44, 0)
NumPut("uint",                            width, D3D11_TEXTURE2D_DESC,  0)
NumPut("uint",                           height, D3D11_TEXTURE2D_DESC,  4)
NumPut("uint",                                1, D3D11_TEXTURE2D_DESC,  8)
NumPut("uint",                                1, D3D11_TEXTURE2D_DESC, 12)
NumPut("uint", DXGI_FORMAT_B8G8R8A8_UNORM := 87, D3D11_TEXTURE2D_DESC, 16)
NumPut("uint",                                1, D3D11_TEXTURE2D_DESC, 20)
NumPut("uint",                                0, D3D11_TEXTURE2D_DESC, 24)
NumPut("uint",         D3D11_USAGE_STAGING := 3, D3D11_TEXTURE2D_DESC, 28)
NumPut("uint",                                0, D3D11_TEXTURE2D_DESC, 32)
NumPut("uint", D3D11_CPU_ACCESS_READ := 0x20000, D3D11_TEXTURE2D_DESC, 36)
NumPut("uint",                                0, D3D11_TEXTURE2D_DESC, 40)
ComCall(CreateTexture2D := 5, d3d_device, "ptr", D3D11_TEXTURE2D_DESC, "ptr", 0, "ptr*", &staging_tex:=0)
local desktop_resource
Update(this, timeout := unset) {
Unbind()
static DXGI_OUTDUPL_FRAME_INFO := Buffer(48, 0)
if !IsSet(timeout) {
loop {
try ComCall(AcquireNextFrame := 8, Duplication, "uint", 0, "ptr", DXGI_OUTDUPL_FRAME_INFO, "ptr*", &desktop_resource:=0)
catch OSError as e
if e.number = 0x887A0027
continue
else throw
if NumGet(DXGI_OUTDUPL_FRAME_INFO, 0, "int64") > 0
break
ObjRelease(desktop_resource)
ComCall(ReleaseFrame := 14, Duplication)
}
} else {
try ComCall(AcquireNextFrame := 8, Duplication, "uint", timeout, "ptr", DXGI_OUTDUPL_FRAME_INFO, "ptr*", &desktop_resource:=0)
catch OSError as e
if e.number = 0x887A0027
return this
else throw
if NumGet(DXGI_OUTDUPL_FRAME_INFO, 0, "int64") = 0
return this
}
if (DesktopImageInSystemMemory = 1) {
static DXGI_MAPPED_RECT := Buffer(A_PtrSize*2, 0)
ComCall(MapDesktopSurface := 12, Duplication, "ptr", DXGI_MAPPED_RECT)
pitch := NumGet(DXGI_MAPPED_RECT, 0, "int")
pBits := NumGet(DXGI_MAPPED_RECT, A_PtrSize, "ptr")
}
else {
tex := ComObjQuery(desktop_resource, "{6f15aaf2-d208-4e89-9ab4-489535d34f9c}")
ComCall(CopyResource := 47, d3d_context, "ptr", staging_tex, "ptr", tex)
static D3D11_MAPPED_SUBRESOURCE := Buffer(8+A_PtrSize, 0)
ComCall(_Map := 14, d3d_context, "ptr", staging_tex, "uint", 0, "uint", D3D11_MAP_READ := 1, "uint", 0, "ptr", D3D11_MAPPED_SUBRESOURCE)
pBits := NumGet(D3D11_MAPPED_SUBRESOURCE, 0, "ptr")
pitch := NumGet(D3D11_MAPPED_SUBRESOURCE, A_PtrSize, "uint")
}
this.ptr := pBits
this.size := pitch * height
return this
}
Unbind() {
if IsSet(desktop_resource) && desktop_resource != 0 {
if (DesktopImageInSystemMemory = 1)
ComCall(UnMapDesktopSurface := 13, Duplication)
else
ComCall(Unmap := 15, d3d_context, "ptr", staging_tex, "uint", 0)
ObjRelease(desktop_resource)
ComCall(ReleaseFrame := 14, Duplication)
}
}
Cleanup(this) {
Unbind()
ObjRelease(staging_tex)
ObjRelease(duplication)
ObjRelease(d3d_context)
ObjRelease(d3d_device)
IDXGIOutput1 := ""
ObjRelease(IDXGIOutput)
ObjRelease(IDXGIAdapter)
ObjRelease(IDXGIFactory)
}
try dpi := DllCall("SetThreadDpiAwarenessContext", "ptr", -3, "ptr")
x := DllCall("GetSystemMetrics", "int", 76, "int")
y := DllCall("GetSystemMetrics", "int", 77, "int")
width := DllCall("GetSystemMetrics", "int", 78, "int")
height := DllCall("GetSystemMetrics", "int", 79, "int")
try DllCall("SetThreadDpiAwarenessContext", "ptr", dpi, "ptr")
return {x:x, y:y, width: width,
height: height,
Update: Update,
Cleanup : Cleanup}.update()
}
static Screenshot2ToBitmap(image) {
obj := this.read_screen()
width := obj.width
height := obj.height
pBits := obj.ptr
size := obj.size
DllCall("gdiplus\GdipCreateBitmapFromScan0"
, "int", width, "int", height, "uint", size / height, "uint", 0xE200B, "ptr", 0, "ptr*", &pBitmap:=0)
Rect := Buffer(16, 0)
NumPut(  "uint",   width, Rect,  8)
NumPut(  "uint",  height, Rect, 12)
BitmapData := Buffer(16+2*A_PtrSize, 0)
NumPut(   "int",  4 * width, BitmapData,  8)
NumPut(   "ptr",      pBits, BitmapData, 16)
DllCall("gdiplus\GdipBitmapLockBits"
,    "ptr", pBitmap
,    "ptr", Rect
,   "uint", 6
,    "int", 0xE200B
,    "ptr", BitmapData)
DllCall("gdiplus\GdipBitmapUnlockBits", "ptr", pBitmap, "ptr", BitmapData)
return pBitmap
}
static ScreenshotToBitmap(image) {
if !IsObject(image) and WinExist(image) {
try dpi := DllCall("SetThreadDpiAwarenessContext", "ptr", -3, "ptr")
WinGetClientPos &x, &y, &w, &h, image
try DllCall("SetThreadDpiAwarenessContext", "ptr", dpi, "ptr")
image := [x, y, w, h]
}
if image.Has(5) and WinExist(image[5]) {
try dpi := DllCall("SetThreadDpiAwarenessContext", "ptr", -3, "ptr")
WinGetClientPos &xr, &yr,,, image[5]
try DllCall("SetThreadDpiAwarenessContext", "ptr", dpi, "ptr")
image[1] += xr
image[2] += yr
}
hdc := DllCall("CreateCompatibleDC", "ptr", 0, "ptr")
bi := Buffer(40, 0)
NumPut(  "uint",        40, bi,  0)
NumPut(   "int",  image[3], bi,  4)
NumPut(   "int", -image[4], bi,  8)
NumPut("ushort",         1, bi, 12)
NumPut("ushort",        32, bi, 14)
hbm := DllCall("CreateDIBSection", "ptr", hdc, "ptr", bi, "uint", 0, "ptr*", &pBits:=0, "ptr", 0, "uint", 0, "ptr")
obm := DllCall("SelectObject", "ptr", hdc, "ptr", hbm, "ptr")
sdc := DllCall("GetDC", "ptr", 0, "ptr")
DllCall("gdi32\BitBlt"
, "ptr", hdc, "int", 0, "int", 0, "int", image[3], "int", image[4]
, "ptr", sdc, "int", image[1], "int", image[2], "uint", 0x00CC0020 | 0x40000000)
DllCall("ReleaseDC", "ptr", 0, "ptr", sdc)
DllCall("gdiplus\GdipCreateBitmapFromHBITMAP", "ptr", hbm, "ptr", 0, "ptr*", &pBitmap:=0)
DllCall("SelectObject", "ptr", hdc, "ptr", obm)
DllCall("DeleteObject", "ptr", hbm)
DllCall("DeleteDC",     "ptr", hdc)
return pBitmap
}
static WindowToBitmap(image) {
image := WinExist(image)
try PostMessage WM_KEYDOWN := 0x100, 0x88,,, image
catch OSError
throw Error("Administrator privileges are required to capture the window.")
PostMessage WM_KEYUP := 0x101, 0x88, 0xC0000000,, image
if DllCall("IsIconic", "ptr", image)
DllCall("ShowWindow", "ptr", image, "int", 4)
try dpi := DllCall("SetThreadDpiAwarenessContext", "ptr", -3, "ptr")
DllCall("GetClientRect", "ptr", image, "ptr", Rect := Buffer(16))
, width  := NumGet(Rect, 8, "int")
, height := NumGet(Rect, 12, "int")
try DllCall("SetThreadDpiAwarenessContext", "ptr", dpi, "ptr")
hdc := DllCall("CreateCompatibleDC", "ptr", 0, "ptr")
bi := Buffer(40, 0)
NumPut(  "uint",        40, bi,  0)
NumPut(   "int",     width, bi,  4)
NumPut(   "int",   -height, bi,  8)
NumPut("ushort",         1, bi, 12)
NumPut("ushort",        32, bi, 14)
hbm := DllCall("CreateDIBSection", "ptr", hdc, "ptr", bi, "uint", 0, "ptr*", &pBits:=0, "ptr", 0, "uint", 0, "ptr")
obm := DllCall("SelectObject", "ptr", hdc, "ptr", hbm, "ptr")
DllCall("user32\PrintWindow", "ptr", image, "ptr", hdc, "uint", 0x3)
DllCall("gdiplus\GdipCreateBitmapFromHBITMAP", "ptr", hbm, "ptr", 0, "ptr*", &pBitmap:=0)
DllCall("SelectObject", "ptr", hdc, "ptr", obm)
DllCall("DeleteObject", "ptr", hbm)
DllCall("DeleteDC",     "ptr", hdc)
return pBitmap
}
static DesktopToBitmap() {
windows := WinGetList("ahk_class WorkerW")
if (windows.length == 0)
throw Error("The hidden desktop window has not been initalized. Call ImagePutDesktop() first.")
loop windows.length
hwnd := windows[A_Index]
until DllCall("FindWindowEx", "ptr", hwnd, "ptr", 0, "str", "SHELLDLL_DefView", "ptr", 0)
if !(WorkerW := DllCall("FindWindowEx", "ptr", 0, "ptr", hwnd, "str", "WorkerW", "ptr", 0, "ptr"))
throw Error("Could not locate hidden window behind desktop.")
try dpi := DllCall("SetThreadDpiAwarenessContext", "ptr", -3, "ptr")
DllCall("GetClientRect", "ptr", WorkerW, "ptr", Rect := Buffer(16))
, width  := NumGet(Rect, 8, "int")
, height := NumGet(Rect, 12, "int")
try DllCall("SetThreadDpiAwarenessContext", "ptr", dpi, "ptr")
sdc := DllCall("GetDCEx", "ptr", WorkerW, "ptr", 0, "int", 0x403, "ptr")
hdc := DllCall("CreateCompatibleDC", "ptr", 0, "ptr")
bi := Buffer(40, 0)
NumPut(  "uint",        40, bi,  0)
NumPut(   "int",     width, bi,  4)
NumPut(   "int",   -height, bi,  8)
NumPut("ushort",         1, bi, 12)
NumPut("ushort",        32, bi, 14)
hbm := DllCall("CreateDIBSection", "ptr", hdc, "ptr", bi, "uint", 0, "ptr*", &pBits:=0, "ptr", 0, "uint", 0, "ptr")
obm := DllCall("SelectObject", "ptr", hdc, "ptr", hbm, "ptr")
DllCall("gdi32\BitBlt"
, "ptr", hdc, "int", 0, "int", 0, "int", width, "int", height
, "ptr", sdc, "int", 0, "int", 0, "uint", 0x00CC0020)
DllCall("gdiplus\GdipCreateBitmapFromHBITMAP", "ptr", hbm, "ptr", 0, "ptr*", &pBitmap:=0)
DllCall("SelectObject", "ptr", hdc, "ptr", obm)
DllCall("DeleteObject", "ptr", hbm)
DllCall("DeleteDC",     "ptr", hdc)
DllCall("ReleaseDC", "ptr", 0, "ptr", sdc)
return pBitmap
}
static WallpaperToBitmap() {
try dpi := DllCall("SetThreadDpiAwarenessContext", "ptr", -3, "ptr")
width  := DllCall("GetSystemMetrics", "int", 78, "int")
height := DllCall("GetSystemMetrics", "int", 79, "int")
try DllCall("SetThreadDpiAwarenessContext", "ptr", dpi, "ptr")
hdc := DllCall("CreateCompatibleDC", "ptr", 0, "ptr")
bi := Buffer(40, 0)
NumPut(  "uint",        40, bi,  0)
NumPut(   "int",     width, bi,  4)
NumPut(   "int",   -height, bi,  8)
NumPut("ushort",         1, bi, 12)
NumPut("ushort",        32, bi, 14)
hbm := DllCall("CreateDIBSection", "ptr", hdc, "ptr", bi, "uint", 0, "ptr*", &pBits:=0, "ptr", 0, "uint", 0, "ptr")
obm := DllCall("SelectObject", "ptr", hdc, "ptr", hbm, "ptr")
DllCall("user32\PaintDesktop", "ptr", hdc)
DllCall("gdiplus\GdipCreateBitmapFromHBITMAP", "ptr", hbm, "ptr", 0, "ptr*", &pBitmap:=0)
DllCall("SelectObject", "ptr", hdc, "ptr", obm)
DllCall("DeleteObject", "ptr", hbm)
DllCall("DeleteDC",     "ptr", hdc)
return pBitmap
}
static CursorToBitmap() {
ci := Buffer(16+A_PtrSize, 0)
NumPut("int", ci.size, ci)
DllCall("GetCursorInfo", "ptr", ci)
, hCursor := NumGet(ci,  8, "ptr")
pBitmap := this.HIconToBitmap(hCursor)
DllCall("DestroyCursor", "ptr", hCursor)
return pBitmap
}
static UrlToBitmap(image) {
stream := this.UrlToStream(image)
DllCall("gdiplus\GdipCreateBitmapFromStreamICM", "ptr", stream, "ptr*", &pBitmap:=0)
ObjRelease(stream)
return pBitmap
}
static UrlToStream(image) {
req := ComObject("WinHttp.WinHttpRequest.5.1")
req.Open("GET", image, True)
req.Send()
req.WaitForResponse()
IStream := ComObjQuery(req.ResponseStream, "{0000000C-0000-0000-C000-000000000046}"), ObjAddRef(IStream.ptr)
return IStream.ptr
}
static FileToBitmap(image) {
stream := this.FileToStream(image)
DllCall("gdiplus\GdipCreateBitmapFromStreamICM", "ptr", stream, "ptr*", &pBitmap:=0)
ObjRelease(stream)
return pBitmap
}
static FileToStream(image) {
file := FileOpen(image, "r")
file.pos := 0
handle := DllCall("GlobalAlloc", "uint", 0x2, "uptr", file.length, "ptr")
ptr := DllCall("GlobalLock", "ptr", handle, "ptr")
file.RawRead(ptr, file.length)
DllCall("GlobalUnlock", "ptr", handle)
file.Close()
DllCall("ole32\CreateStreamOnHGlobal", "ptr", handle, "int", True, "ptr*", &stream:=0, "hresult")
return stream
}
static HexToBitmap(image) {
stream := this.HexToStream(image)
DllCall("gdiplus\GdipCreateBitmapFromStreamICM", "ptr", stream, "ptr*", &pBitmap:=0)
ObjRelease(stream)
return pBitmap
}
static HexToStream(image) {
image := Trim(image)
image := RegExReplace(image, "^(0[xX])")
size := StrLen(image) / 2
handle := DllCall("GlobalAlloc", "uint", 0x2, "uptr", size, "ptr")
bin := DllCall("GlobalLock", "ptr", handle, "ptr")
flags := 0xC
DllCall("crypt32\CryptStringToBinary", "str", image, "uint", 0, "uint", flags, "ptr", bin, "uint*", size, "ptr", 0, "ptr", 0)
DllCall("GlobalUnlock", "ptr", handle)
DllCall("ole32\CreateStreamOnHGlobal", "ptr", handle, "int", True, "ptr*", &stream:=0, "hresult")
return stream
}
static Base64ToBitmap(image) {
stream := this.Base64ToStream(image)
DllCall("gdiplus\GdipCreateBitmapFromStreamICM", "ptr", stream, "ptr*", &pBitmap:=0)
ObjRelease(stream)
return pBitmap
}
static Base64ToStream(image) {
image := Trim(image)
image := RegExReplace(image, "(?i)^data:image\/[a-z]+;base64,")
size := StrLen(RTrim(image, "=")) * 3 // 4
handle := DllCall("GlobalAlloc", "uint", 0x2, "uptr", size, "ptr")
bin := DllCall("GlobalLock", "ptr", handle, "ptr")
flags := 0x1
DllCall("crypt32\CryptStringToBinary", "str", image, "uint", 0, "uint", flags, "ptr", bin, "uint*", size, "ptr", 0, "ptr", 0)
DllCall("GlobalUnlock", "ptr", handle)
DllCall("ole32\CreateStreamOnHGlobal", "ptr", handle, "int", True, "ptr*", &stream:=0, "hresult")
return stream
}
static MonitorToBitmap(image) {
try dpi := DllCall("SetThreadDpiAwarenessContext", "ptr", -3, "ptr")
if (image > 0) {
MonitorGet(image, &Left, &Top, &Right, &Bottom)
x := Left
y := Top
w := Right - Left
h := Bottom - Top
} else {
x := DllCall("GetSystemMetrics", "int", 76, "int")
y := DllCall("GetSystemMetrics", "int", 77, "int")
w := DllCall("GetSystemMetrics", "int", 78, "int")
h := DllCall("GetSystemMetrics", "int", 79, "int")
}
try DllCall("SetThreadDpiAwarenessContext", "ptr", dpi, "ptr")
return this.ScreenshotToBitmap([x,y,w,h])
}
static DCToBitmap(image) {
if !(sbm := DllCall("GetCurrentObject", "ptr", image, "uint", 7))
throw Error("The device context has no bitmap selected.")
dib := Buffer(64+5*A_PtrSize)
DllCall("GetObject", "ptr", sbm, "int", dib.size, "ptr", dib)
, width  := NumGet(dib, 4, "uint")
, height := NumGet(dib, 8, "uint")
, bpp    := NumGet(dib, 18, "ushort")
, pBits  := NumGet(dib, A_PtrSize = 4 ? 20:24, "ptr")
if (pBits = 0 || bpp != 32) {
DllCall("gdiplus\GdipCreateBitmapFromHBITMAP", "ptr", sbm, "ptr", 0, "ptr*", &pBitmap:=0)
return pBitmap
}
hdc := DllCall("CreateCompatibleDC", "ptr", 0, "ptr")
bi := Buffer(40, 0)
NumPut(  "uint",        40, bi,  0)
NumPut(   "int",     width, bi,  4)
NumPut(   "int",   -height, bi,  8)
NumPut("ushort",         1, bi, 12)
NumPut("ushort",        32, bi, 14)
hbm := DllCall("CreateDIBSection", "ptr", hdc, "ptr", bi, "uint", 0, "ptr*", &pBits:=0, "ptr", 0, "uint", 0, "ptr")
obm := DllCall("SelectObject", "ptr", hdc, "ptr", hbm, "ptr")
DllCall("gdiplus\GdipCreateBitmapFromScan0"
, "int", width, "int", height, "int", 0, "int", 0x26200A, "ptr", 0, "ptr*", &pBitmap:=0)
Rect := Buffer(16, 0)
NumPut(  "uint",   width, Rect,  8)
NumPut(  "uint",  height, Rect, 12)
BitmapData := Buffer(16+2*A_PtrSize, 0)
NumPut(   "int",  4 * width, BitmapData,  8)
NumPut(   "ptr",      pBits, BitmapData, 16)
DllCall("gdiplus\GdipBitmapLockBits"
,    "ptr", pBitmap
,    "ptr", Rect
,   "uint", 6
,    "int", 0xE200B
,    "ptr", BitmapData)
DllCall("gdi32\BitBlt"
, "ptr", hdc, "int", 0, "int", 0, "int", width, "int", height
, "ptr", image, "int", 0, "int", 0, "uint", 0x00CC0020)
DllCall("gdiplus\GdipBitmapUnlockBits", "ptr", pBitmap, "ptr", BitmapData)
DllCall("SelectObject", "ptr", hdc, "ptr", obm)
DllCall("DeleteObject", "ptr", hbm)
DllCall("DeleteDC",     "ptr", hdc)
return pBitmap
}
static HBitmapToBitmap(image) {
dib := Buffer(64+5*A_PtrSize)
DllCall("GetObject", "ptr", image, "int", dib.size, "ptr", dib)
, width  := NumGet(dib, 4, "uint")
, height := NumGet(dib, 8, "uint")
, bpp    := NumGet(dib, 18, "ushort")
, pBits  := NumGet(dib, A_PtrSize = 4 ? 20:24, "ptr")
if (pBits = 0 || bpp != 32) {
DllCall("gdiplus\GdipCreateBitmapFromHBITMAP", "ptr", image, "ptr", 0, "ptr*", &pBitmap:=0)
return pBitmap
}
hdc := DllCall("CreateCompatibleDC", "ptr", 0, "ptr")
bi := Buffer(40, 0)
NumPut(  "uint",        40, bi,  0)
NumPut(   "int",     width, bi,  4)
NumPut(   "int",   -height, bi,  8)
NumPut("ushort",         1, bi, 12)
NumPut("ushort",        32, bi, 14)
hbm := DllCall("CreateDIBSection", "ptr", hdc, "ptr", bi, "uint", 0, "ptr*", &pBits:=0, "ptr", 0, "uint", 0, "ptr")
obm := DllCall("SelectObject", "ptr", hdc, "ptr", hbm, "ptr")
DllCall("gdiplus\GdipCreateBitmapFromScan0"
, "int", width, "int", height, "int", 0, "int", 0x26200A, "ptr", 0, "ptr*", &pBitmap:=0)
Rect := Buffer(16, 0)
NumPut(  "uint",   width, Rect,  8)
NumPut(  "uint",  height, Rect, 12)
BitmapData := Buffer(16+2*A_PtrSize, 0)
NumPut(   "int",  4 * width, BitmapData,  8)
NumPut(   "ptr",      pBits, BitmapData, 16)
DllCall("gdiplus\GdipBitmapLockBits"
,    "ptr", pBitmap
,    "ptr", Rect
,   "uint", 6
,    "int", 0xE200B
,    "ptr", BitmapData)
sdc := DllCall("CreateCompatibleDC", "ptr", 0, "ptr")
old := DllCall("SelectObject", "ptr", sdc, "ptr", image, "ptr")
if (old)
DllCall("gdi32\BitBlt"
, "ptr", hdc, "int", 0, "int", 0, "int", width, "int", height
, "ptr", sdc, "int", 0, "int", 0, "uint", 0x00CC0020)
else
DllCall("GetDIBits", "ptr", hdc, "ptr", image, "uint", 0, "uint", height, "ptr", pBits, "ptr", bi, "uint", 0)
DllCall("SelectObject", "ptr", sdc, "ptr", obm)
DllCall("DeleteDC",     "ptr", sdc)
DllCall("gdiplus\GdipBitmapUnlockBits", "ptr", pBitmap, "ptr", BitmapData)
DllCall("SelectObject", "ptr", hdc, "ptr", obm)
DllCall("DeleteObject", "ptr", hbm)
DllCall("DeleteDC",     "ptr", hdc)
return pBitmap
}
static HIconToBitmap(image) {
ii := Buffer(8+3*A_PtrSize)
DllCall("GetIconInfo", "ptr", image, "ptr", ii)
, hbmMask  := NumGet(ii, 8+A_PtrSize, "ptr")
, hbmColor := NumGet(ii, 8+2*A_PtrSize, "ptr")
bm := Buffer(16+2*A_PtrSize)
DllCall("GetObject", "ptr", hbmMask, "int", bm.size, "ptr", bm)
, width  := NumGet(bm, 4, "uint")
, height := NumGet(bm, 8, "uint") / (hbmColor ? 1 : 2)
DllCall("DeleteObject", "ptr", hbmMask)
DllCall("DeleteObject", "ptr", hbmColor)
hdc := DllCall("CreateCompatibleDC", "ptr", 0, "ptr")
bi := Buffer(40, 0)
NumPut(  "uint",        40, bi,  0)
NumPut(   "int",     width, bi,  4)
NumPut(   "int",   -height, bi,  8)
NumPut("ushort",         1, bi, 12)
NumPut("ushort",        32, bi, 14)
hbm := DllCall("CreateDIBSection", "ptr", hdc, "ptr", bi, "uint", 0, "ptr*", &pBits:=0, "ptr", 0, "uint", 0, "ptr")
obm := DllCall("SelectObject", "ptr", hdc, "ptr", hbm, "ptr")
DllCall("gdiplus\GdipCreateBitmapFromScan0"
, "int", width, "int", height, "int", 0, "int", 0x26200A, "ptr", 0, "ptr*", &pBitmap:=0)
Rect := Buffer(16, 0)
NumPut(  "uint",   width, Rect,  8)
NumPut(  "uint",  height, Rect, 12)
BitmapData := Buffer(16+2*A_PtrSize, 0)
NumPut(   "int",  4 * width, BitmapData,  8)
NumPut(   "ptr",      pBits, BitmapData, 16)
DllCall("gdiplus\GdipBitmapLockBits"
,    "ptr", pBitmap
,    "ptr", Rect
,   "uint", 6
,    "int", 0xE200B
,    "ptr", BitmapData)
DllCall("user32\DrawIconEx"
, "ptr", hdc,   "int", 0, "int", 0
, "ptr", image, "int", 0, "int", 0
, "uint", 0, "ptr", 0, "uint", 0x1 | 0x2 | 0x4)
DllCall("gdiplus\GdipBitmapUnlockBits", "ptr", pBitmap, "ptr", BitmapData)
DllCall("SelectObject", "ptr", hdc, "ptr", obm)
DllCall("DeleteObject", "ptr", hbm)
DllCall("DeleteDC",     "ptr", hdc)
return pBitmap
}
static BitmapToBitmap(image) {
DllCall("gdiplus\GdipCloneImage", "ptr", image, "ptr*", &pBitmap:=0)
return pBitmap
}
static StreamToBitmap(image) {
stream := this.StreamToStream(image)
DllCall("gdiplus\GdipCreateBitmapFromStreamICM", "ptr", stream, "ptr*", &pBitmap:=0)
ObjRelease(stream)
return pBitmap
}
static StreamToStream(image) {
ComCall(Clone := 13, image, "ptr*", &stream:=0)
DllCall("shlwapi\IStream_Reset", "ptr", stream, "hresult")
return stream
}
static RandomAccessStreamToBitmap(image) {
stream := this.RandomAccessStreamToStream(image)
DllCall("gdiplus\GdipCreateBitmapFromStreamICM", "ptr", stream, "ptr*", &pBitmap:=0)
ObjRelease(stream)
return pBitmap
}
static RandomAccessStreamToStream(image) {
IID_IStream := Buffer(16)
DllCall("ole32\IIDFromString", "wstr", "{0000000C-0000-0000-C000-000000000046}", "ptr", IID_IStream, "hresult")
DllCall("shcore\CreateStreamOverRandomAccessStream", "ptr", image, "ptr", IID_IStream, "ptr*", &stream:=0, "hresult")
ComCall(Clone := 13, stream, "ptr*", &ClonedStream:=0)
return ClonedStream
}
static WicBitmapToBitmap(image) {
ComCall(GetSize := 3, image, "uint*", &width:=0, "uint*", &height:=0)
DllCall("gdiplus\GdipCreateBitmapFromScan0"
, "int", width, "int", height, "int", 0, "int", 0x26200A, "ptr", 0, "ptr*", &pBitmap:=0)
Rect := Buffer(16, 0)
NumPut(  "uint",   width, Rect,  8)
NumPut(  "uint",  height, Rect, 12)
BitmapData := Buffer(16+2*A_PtrSize, 0)
DllCall("gdiplus\GdipBitmapLockBits"
,    "ptr", pBitmap
,    "ptr", Rect
,   "uint", 2
,    "int", 0x26200A
,    "ptr", BitmapData)
Scan0 := NumGet(BitmapData, 16, "ptr")
stride := NumGet(BitmapData, 8, "int")
ComCall(CopyPixels := 7, image, "ptr", Rect, "uint", stride, "uint", stride * height, "ptr", Scan0)
DllCall("gdiplus\GdipBitmapUnlockBits", "ptr", pBitmap, "ptr", BitmapData)
return pBitmap
}
static BitmapToClipboard(pBitmap) {
loop
if DllCall("OpenClipboard", "ptr", A_ScriptHwnd)
break
else
if A_Index < 6
Sleep (2**(A_Index-1) * 30)
else throw Error("Clipboard could not be opened.")
DllCall("EmptyClipboard")
DllCall("ole32\CreateStreamOnHGlobal", "ptr", 0, "int", False, "ptr*", &stream:=0, "hresult")
DllCall("ole32\CLSIDFromString", "wstr", "{557CF406-1A04-11D3-9A73-0000F81EF32E}", "ptr", pCodec:=Buffer(16), "hresult")
DllCall("gdiplus\GdipSaveImageToStream", "ptr", pBitmap, "ptr", stream, "ptr", pCodec, "ptr", 0)
DllCall("ole32\GetHGlobalFromStream", "ptr", stream, "uint*", &handle:=0, "hresult")
ObjRelease(stream)
png := DllCall("RegisterClipboardFormat", "str", "png", "uint")
DllCall("SetClipboardData", "uint", png, "ptr", handle)
DllCall("gdiplus\GdipCreateHBITMAPFromBitmap", "ptr", pBitmap, "ptr*", &hbm:=0, "uint", 0)
dib := Buffer(64+5*A_PtrSize)
DllCall("GetObject", "ptr", hbm, "int", dib.size, "ptr", dib)
, pBits := NumGet(dib, A_PtrSize = 4 ? 20:24, "ptr")
, size  := NumGet(dib, A_PtrSize = 4 ? 44:52, "uint")
hdib := DllCall("GlobalAlloc", "uint", 0x2, "uptr", 40 + size, "ptr")
pdib := DllCall("GlobalLock", "ptr", hdib, "ptr")
DllCall("RtlMoveMemory", "ptr", pdib, "ptr", dib.ptr + (A_PtrSize = 4 ? 24:32), "uptr", 40)
DllCall("RtlMoveMemory", "ptr", pdib+40, "ptr", pBits, "uptr", size)
DllCall("GlobalUnlock", "ptr", hdib)
DllCall("DeleteObject", "ptr", hbm)
DllCall("SetClipboardData", "uint", 8, "ptr", hdib)
DllCall("CloseClipboard")
return ClipboardAll()
}
static StreamToClipboard(stream) {
DllCall("shlwapi\IStream_Size", "ptr", stream, "uint64*", &size:=0, "hresult")
DllCall("shlwapi\IStream_Reset", "ptr", stream, "hresult")
size := min(size, 2048)
bin := Buffer(size)
DllCall("shlwapi\IStream_Read", "ptr", stream, "ptr", bin, "uint", size, "hresult")
DllCall("shlwapi\IStream_Reset", "ptr", stream, "hresult")
length := 2*size + (size-1) + 1
VarSetStrCapacity(&str, length)
flags := 0x40000004
DllCall("crypt32\CryptBinaryToString", "ptr", bin, "uint", size, "uint", flags, "str", str, "uint*", &length)
extension := 0                                                              ? ""
: str ~= "(?i)66 74 79 70 61 76 69 66"                                      ? "avif"
: str ~= "(?i)^42 4d (.. ){36}00 00 .. 00 00 00"                            ? "bmp"
: str ~= "(?i)^01 00 00 00 (.. ){36}20 45 4D 46"                            ? "emf"
: str ~= "(?i)^47 49 46 38 (37|39) 61"                                      ? "gif"
: str ~= "(?i)66 74 79 70 68 65 69 63"                                      ? "heic"
: str ~= "(?i)^00 00 01 00"                                                 ? "ico"
: str ~= "(?i)^ff d8 ff"                                                    ? "jpg"
: str ~= "(?i)^25 50 44 46 2d"                                              ? "pdf"
: str ~= "(?i)^89 50 4e 47 0d 0a 1a 0a"                                     ? "png"
: str ~= "(?i)^(((?!3c|3e).. )|3c (3f|21) ((?!3c|3e).. )*3e )*+3c 73 76 67" ? "svg"
: str ~= "(?i)^(49 49 2a 00|4d 4d 00 2a)"                                   ? "tif"
: str ~= "(?i)^52 49 46 46 .. .. .. .. 57 45 42 50"                         ? "webp"
: str ~= "(?i)^d7 cd c6 9a"                                                 ? "wmf"
: ""
if !(hwnd := DllCall("FindWindow", "str", "AutoHotkey", "str", "_StreamToClipboard", "ptr")) {
hwnd := DllCall("CreateWindowEx", "uint", 0, "str", "AutoHotkey", "str", "_StreamToClipboard"
, "uint", 0, "int", 0, "int", 0, "int", 0, "int", 0, "ptr", 0, "ptr", 0, "ptr", 0, "ptr", 0, "ptr")
DllCall("SetWindowLong" (A_PtrSize=8?"Ptr":""), "ptr", hwnd, "int", -4, "ptr", CallbackCreate(StreamToClipboardProc))
}
loop
if DllCall("OpenClipboard", "ptr", hwnd)
break
else
if A_Index < 6
Sleep (2**(A_Index-1) * 30)
else throw Error("Clipboard could not be opened.")
DllCall("EmptyClipboard")
if (extension = "png") {
DllCall("shlwapi\IStream_Size", "ptr", stream, "uint64*", &size:=0, "hresult")
handle := DllCall("GlobalAlloc", "uint", 0x2, "uptr", size, "ptr")
DllCall("ole32\CreateStreamOnHGlobal", "ptr", handle, "int", False, "ptr*", &ClonedStream:=0, "hresult")
DllCall("shlwapi\IStream_Copy", "ptr", stream, "ptr", ClonedStream, "uint", size, "hresult")
DllCall("shlwapi\IStream_Reset", "ptr", stream, "hresult")
ObjRelease(ClonedStream)
png := DllCall("RegisterClipboardFormat", "str", "png", "uint")
DllCall("SetClipboardData", "uint", png, "ptr", handle)
}
if (extension) {
filepath := A_ScriptDir "\clipboard." extension
filepath := RTrim(filepath, ".")
DllCall("shlwapi\SHCreateStreamOnFileEx"
,   "wstr", filepath
,   "uint", 0x1001
,   "uint", 0x80
,    "int", True
,    "ptr", 0
,   "ptr*", &FileStream:=0
,"hresult")
DllCall("shlwapi\IStream_Size", "ptr", stream, "uint64*", &size:=0, "hresult")
DllCall("shlwapi\IStream_Copy", "ptr", stream, "ptr", FileStream, "uint", size, "hresult")
DllCall("shlwapi\IStream_Reset", "ptr", stream, "hresult")
ObjRelease(FileStream)
nDropFiles := 20 + StrPut(filepath, "UTF-16") + 2
hDropFiles := DllCall("GlobalAlloc", "uint", 0x42, "uptr", nDropFiles, "ptr")
pDropFiles := DllCall("GlobalLock", "ptr", hDropFiles, "ptr")
NumPut("uint", 20, pDropFiles + 0)
NumPut("uint", 1, pDropFiles + 16)
StrPut(filepath, pDropFiles + 20, "UTF-16")
DllCall("GlobalUnlock", "ptr", hDropFiles)
DllCall("SetClipboardData", "uint", 15, "ptr", hDropFiles)
obj := {filepath: filepath}
ptr := ObjPtr(obj)
ObjAddRef(ptr)
DllCall("SetWindowLong" (A_PtrSize=8?"Ptr":""), "ptr", hwnd, "int", -21, "ptr", ptr, "ptr")
}
if (extension ~= "^(?i:avif|bmp|emf|gif|heic|ico|jpg|png|tif|webp|wmf)$") {
DllCall("gdiplus\GdipCreateBitmapFromStreamICM", "ptr", stream, "ptr*", &pBitmap:=0)
DllCall("gdiplus\GdipCreateHBITMAPFromBitmap", "ptr", pBitmap, "ptr*", &hbm:=0, "uint", 0)
dib := Buffer(64+5*A_PtrSize)
DllCall("GetObject", "ptr", hbm, "int", dib.size, "ptr", dib)
, pBits := NumGet(dib, A_PtrSize = 4 ? 20:24, "ptr")
, size  := NumGet(dib, A_PtrSize = 4 ? 44:52, "uint")
hdib := DllCall("GlobalAlloc", "uint", 0x2, "uptr", 40 + size, "ptr")
pdib := DllCall("GlobalLock", "ptr", hdib, "ptr")
DllCall("RtlMoveMemory", "ptr", pdib, "ptr", dib.ptr + (A_PtrSize = 4 ? 24:32), "uptr", 40)
DllCall("RtlMoveMemory", "ptr", pdib+40, "ptr", pBits, "uptr", size)
DllCall("GlobalUnlock", "ptr", hdib)
DllCall("DeleteObject", "ptr", hbm)
DllCall("SetClipboardData", "uint", 8, "ptr", hdib)
}
DllCall("CloseClipboard")
return ClipboardAll()
StreamToClipboardProc(hwnd, uMsg, wParam, lParam) {
if (uMsg = 0x0307)
if obj := ObjFromPtr(DllCall("GetWindowLong" (A_PtrSize=8?"Ptr":""), "ptr", hwnd, "int", -21, "ptr"))
DllCall("DeleteFile", "str", obj.filepath)
}
}
static BitmapToEncodedBuffer(pBitmap, extension := "", quality := "") {
stream := this.BitmapToStream(pBitmap, (extension) ? extension : "png", quality)
DllCall("ole32\GetHGlobalFromStream", "ptr", stream, "ptr*", &handle:=0, "hresult")
ptr := DllCall("GlobalLock", "ptr", handle, "ptr")
size := DllCall("GlobalSize", "ptr", handle, "uptr")
buf := Buffer(size)
DllCall("RtlMoveMemory", "ptr", buf.ptr, "ptr", ptr, "uptr", size)
DllCall("GlobalUnlock", "ptr", handle)
ObjRelease(stream)
return buf
}
static StreamToEncodedBuffer(stream) {
DllCall("shlwapi\IStream_Size", "ptr", stream, "uint64*", &size:=0, "hresult")
buf := Buffer(size)
DllCall("shlwapi\IStream_Reset", "ptr", stream, "hresult")
DllCall("shlwapi\IStream_Read", "ptr", stream, "ptr", buf.ptr, "uint", size, "hresult")
DllCall("shlwapi\IStream_Reset", "ptr", stream, "hresult")
return buf
}
static BitmapToBuffer(pBitmap) {
DllCall("gdiplus\GdipGetImageWidth", "ptr", pBitmap, "uint*", &width:=0)
DllCall("gdiplus\GdipGetImageHeight", "ptr", pBitmap, "uint*", &height:=0)
size := 4 * width * height
ptr := DllCall("GlobalAlloc", "uint", 0, "uptr", size, "ptr")
Rect := Buffer(16, 0)
NumPut(  "uint",   width, Rect,  8)
NumPut(  "uint",  height, Rect, 12)
BitmapData := Buffer(16+2*A_PtrSize, 0)
NumPut(   "int",  4 * width, BitmapData,  8)
NumPut(   "ptr",        ptr, BitmapData, 16)
DllCall("gdiplus\GdipBitmapLockBits"
,    "ptr", pBitmap
,    "ptr", Rect
,   "uint", 5
,    "int", 0x26200A
,    "ptr", BitmapData)
DllCall("gdiplus\GdipBitmapUnlockBits", "ptr", pBitmap, "ptr", BitmapData)
buf := ImagePut.BitmapBuffer(ptr, size, width, height)
buf.free := [DllCall.bind("GlobalFree", "ptr", ptr)]
return buf
}
static SharedBufferToSharedBuffer(image) {
hMap := DllCall("OpenFileMapping", "uint", 0x2, "int", 0, "str", image, "ptr")
pMap := DllCall("MapViewOfFile", "ptr", hMap, "uint", 0x2, "uint", 0, "uint", 0, "uptr", 0, "ptr")
width := NumGet(pMap + 0, "uint")
height := NumGet(pMap + 4, "uint")
size := 4 * width * height
ptr := pMap + 8
buf := ImagePut.BitmapBuffer(ptr, size, width, height)
buf.free := [() => DllCall("UnmapViewOfFile", "ptr", pMap), () => DllCall("CloseHandle", "ptr", hMap)]
buf.name := image
return buf
}
static SharedBufferToBitmap(image) {
hMap := DllCall("OpenFileMapping", "uint", 0x2, "int", 0, "str", image, "ptr")
pMap := DllCall("MapViewOfFile", "ptr", hMap, "uint", 0x2, "uint", 0, "uint", 0, "uptr", 0, "ptr")
width := NumGet(pMap + 0, "uint")
height := NumGet(pMap + 4, "uint")
size := 4 * width * height
ptr := pMap + 8
DllCall("gdiplus\GdipCreateBitmapFromScan0"
, "int", width, "int", height, "uint", size / height, "uint", 0x26200A, "ptr", 0, "ptr*", &pBitmap:=0)
Rect := Buffer(16, 0)
NumPut(  "uint",   width, Rect,  8)
NumPut(  "uint",  height, Rect, 12)
BitmapData := Buffer(16+2*A_PtrSize, 0)
NumPut(   "int",  4 * width, BitmapData,  8)
NumPut(   "ptr",        ptr, BitmapData, 16)
DllCall("gdiplus\GdipBitmapLockBits"
,    "ptr", pBitmap
,    "ptr", Rect
,   "uint", 6
,    "int", 0x26200A
,    "ptr", BitmapData)
DllCall("gdiplus\GdipBitmapUnlockBits", "ptr", pBitmap, "ptr", BitmapData)
DllCall("UnmapViewOfFile", "ptr", pMap)
DllCall("CloseHandle", "ptr", hMap)
return pBitmap
}
static BitmapToSharedBuffer(pBitmap, name := "Alice") {
DllCall("gdiplus\GdipGetImageWidth", "ptr", pBitmap, "uint*", &width:=0)
DllCall("gdiplus\GdipGetImageHeight", "ptr", pBitmap, "uint*", &height:=0)
size := 4 * width * height
hMap := DllCall("CreateFileMapping", "ptr", -1, "ptr", 0, "uint", 0x4, "uint", 0, "uint", size, "str", name, "ptr")
pMap := DllCall("MapViewOfFile", "ptr", hMap, "uint", 0x2, "uint", 0, "uint", 0, "uptr", 0, "ptr")
NumPut("uint",  width, pMap + 0)
NumPut("uint", height, pMap + 4)
ptr := pMap + 8
Rect := Buffer(16, 0)
NumPut(  "uint",   width, Rect,  8)
NumPut(  "uint",  height, Rect, 12)
BitmapData := Buffer(16+2*A_PtrSize, 0)
NumPut(   "int",  4 * width, BitmapData,  8)
NumPut(   "ptr",        ptr, BitmapData, 16)
DllCall("gdiplus\GdipBitmapLockBits"
,    "ptr", pBitmap
,    "ptr", Rect
,   "uint", 5
,    "int", 0x26200A
,    "ptr", BitmapData)
DllCall("gdiplus\GdipBitmapUnlockBits", "ptr", pBitmap, "ptr", BitmapData)
buf := ImagePut.BitmapBuffer(ptr, size, width, height)
buf.free := [() => DllCall("UnmapViewOfFile", "ptr", pMap), () => DllCall("CloseHandle", "ptr", hMap)]
buf.name := name
return buf
}
class BitmapBuffer {
__New(ptr, size, width, height, stride:="") {
ImagePut.gdiplusStartup()
DllCall("gdiplus\GdipCreateBitmapFromScan0"
, "int", width, "int", height, "int", size // height, "int", 0x26200A, "ptr", ptr, "ptr*", &pBitmap:=0)
this.ptr := ptr
this.size := size
this.width := width
this.height := height
this.pBitmap := pBitmap
this.free := []
}
__Delete() {
DllCall("gdiplus\GdipDisposeImage", "ptr", this.pBitmap)
for callback in this.free
callback.call()
ImagePut.gdiplusShutdown()
}
__Item[x, y] {
get => Format("0x{:08X}", NumGet(this.ptr + 4*(y*this.width + x), "uint"))
set => ((value >> 24) || value |= 0xFF000000,
NumPut("uint", value, this.ptr + 4*(y*this.width + x)),
value)
}
__Enum(n) {
start := 0
end := this.size
switch n {
case 1: return (&c) => ((start < end) && (
c := Format("0x{:08X}", NumGet(this.ptr + start, "uint")),
start += 4,
True))
case 2: return (&i, &c) => ((start < end) && (
c := Format("0x{:08X}", NumGet(this.ptr + start, "uint")),
i := start // 4,
start += 4,
True))
case 3: return (&x, &y, &c) => ((start < end) && (
c := Format("0x{:08X}", NumGet(this.ptr + start, "uint")),
i := start // 4,
x := mod(i, this.width),
y := i // this.width,
start += 4,
True))
case 6: return (&x, &y, &c, &r, &g, &b) => ((start < end) && (
c := Format("0x{:08X}", NumGet(this.ptr + start, "uint")),
i := start // 4,
x := mod(i, this.width),
y := i // this.width,
r := c >> 16 & 0xFF,
g := c >>  8 & 0xFF,
b := c       & 0xFF,
start += 4,
True))
case 7: return (&x, &y, &c, &r, &g, &b, &a) => ((start < end) && (
c := Format("0x{:08X}", NumGet(this.ptr + start, "uint")),
i := start // 4,
x := mod(i, this.width),
y := i // this.width,
a := c >> 24 & 0xFF,
r := c >> 16 & 0xFF,
g := c >>  8 & 0xFF,
b := c       & 0xFF,
start += 4,
True))
}
}
Frequency() {
if this.HasProp(map)
return
this.map := Map()
loop this.width * this.height
if c := NumGet(this.ptr + 4*(A_Index-1), "uint")
this.map[c] := this.map.Has(c) ? this.map[c] + 1 : 1
}
Count(c*) {
this.Frequency()
acc := 0
for each, color in c {
(color >> 24) || color |= 0xFF000000
acc += this.map.get(color, 0)
}
return acc
}
Clone() {
ptr := DllCall("GlobalAlloc", "uint", 0, "uptr", this.size, "ptr")
DllCall("RtlMoveMemory", "ptr", ptr, "ptr", this.ptr, "uptr", this.size)
buf := ImagePut.BitmapBuffer(ptr, this.size, this.width, this.height)
buf.free := [DllCall.bind("GlobalFree", "ptr", ptr)]
return buf
}
Crop(x, y, w, h) {
DllCall("gdiplus\GdipGetImagePixelFormat", "ptr", this.pBitmap, "int*", &format:=0)
DllCall("gdiplus\GdipCloneBitmapAreaI", "int", x, "int", y, "int", w, "int", h, "int", format, "ptr", this.pBitmap, "ptr*", &pBitmap:=0)
try return ImagePut.BitmapToBuffer(pBitmap)
finally DllCall("gdiplus\GdipDisposeImage", "ptr", pBitmap)
}
Show(window_border := False, title := "", pos := "", style := "", styleEx := "", parent := "") {
return (window_border)
? ImagePut.BitmapToWindow(this.pBitmap, title, pos, style, styleEx, parent)
: ImagePut.show(this.pBitmap, title, pos, style, styleEx, parent)
}
Save(filepath := "", quality := "")  {
extension := "bmp"
ImagePut.select_filepath(&filepath, &extension)
if (extension != "bmp")
return ImagePut.BitmapToFile(this.pBitmap, filepath, quality)
bm := Buffer(56)
StrPut("BM", bm, "CP0")
NumPut(  "uint", 56+this.size, bm,  2)
NumPut(  "uint",            0, bm,  6)
NumPut(  "uint",           56, bm, 10)
NumPut(  "uint",           40, bm, 14)
NumPut(  "uint",   this.width, bm, 18)
NumPut(   "int", -this.height, bm, 22)
NumPut("ushort",            1, bm, 26)
NumPut("ushort",           32, bm, 28)
NumPut(  "uint",            0, bm, 30)
NumPut(  "uint",    this.size, bm, 34)
NumPut(   "int",            0, bm, 38)
NumPut(   "int",            0, bm, 42)
NumPut(  "uint",            0, bm, 46)
NumPut(  "uint",            0, bm, 50)
loop
try
if file := FileOpen(filepath, "w")
break
else throw
catch
if A_Index < 6
Sleep (2**(A_Index-1) * 30)
else throw
file.RawWrite(bm)
file.RawWrite(this)
file.Close()
return filepath
}
Base64Code(b64) {
static codes := Map()
if codes.Has(b64)
return codes[b64]
s64 := StrLen(RTrim(b64, "=")) * 3 // 4
code := DllCall("GlobalAlloc", "uint", 0, "uptr", s64, "ptr")
DllCall("crypt32\CryptStringToBinary", "str", b64, "uint", 0, "uint", 0x1, "ptr", code, "uint*", s64, "ptr", 0, "ptr", 0)
DllCall("VirtualProtect", "ptr", code, "ptr", s64, "uint", 0x40, "uint*", 0)
return codes[b64] := code
}
AVX2() {
code := this.Base64Code((A_PtrSize == 4)
? "VYnli0UIi1UQi00UO0UMcws5EHUCiQiDwATr8F3D"
: "U0UxwLgBAAAARInBD6IPuuEbcxkPuuEccxNEicEPAdBI99CoBg+UwA+2wOsCMcBbww==")
return DllCall(code, "int")
}
CPUID() {
static cpuid := 0
if not cpuid {
b64 := (A_PtrSize == 4)
? "VYnlV4t9EFaLdQhTiw+LBg+iiQaLRQyJGItFFIkPiRBbXl9dww=="
: "U4sBSYnKSYnTQYsID6JBiQJBiRtBiQhBiRFbww=="
s64 := StrLen(RTrim(b64, "=")) * 3 // 4
code := DllCall("GlobalAlloc", "uint", 0, "uptr", s64, "ptr")
DllCall("crypt32\CryptStringToBinary", "str", b64, "uint", 0, "uint", 0x1, "ptr", code, "uint*", s64, "ptr", 0, "ptr", 0)
DllCall("VirtualProtect", "ptr", code, "ptr", s64, "uint", 0x40, "uint*", 0)
DllCall(code, "uint*", &a := 1, "uint*", &b := 0, "uint*", &c := 0, "uint*", &d := 0, "cdecl")
DllCall("GlobalFree", "ptr", code)
eax := Map(0, a & 1)
ebx := Map(0, b & 1)
ecx := Map(0, c & 1)
edx := Map(0, d & 1)
loop 31 {
eax[A_Index] := !!(1 << A_Index & a)
ebx[A_Index] := !!(1 << A_Index & b)
ecx[A_Index] := !!(1 << A_Index & c)
edx[A_Index] := !!(1 << A_Index & d)
}
cpuid := {eax: eax, ebx: ebx, ecx: ecx, edx: edx}
}
return cpuid
}
ColorKey(key := "sentinel", value := 0x00000000) {
code := this.Base64Code((A_PtrSize == 4)
? "VYnli0UIi1UQi00UO0UMcws5EHUCiQiDwATr8F3D"
: "SDnRcw5EOQF1A0SJCUiDwQTr7cM=")
(key == "sentinel") && key := NumGet(this.ptr, "uint")
DllCall(code, "ptr", this.ptr, "uint", this.ptr + this.size, "uint", key, "uint", value, "cdecl")
}
SetAlpha(alpha := 0xFF) {
code := this.Base64Code((A_PtrSize == 4)
? "VYnli0UIilUQO0UMcwiIUAODwATr813D"
: "SDnRcwpEiEEDSIPBBOvxww==")
DllCall(code, "ptr", this.ptr, "ptr", this.ptr + this.size, "uchar", alpha, "cdecl")
}
TransColor(color := "sentinel", alpha := 0x00) {
code := this.Base64Code((A_PtrSize == 4)
? "VYnli0UIilUUO0UMcxWLTRAzCIHh////AHUDiFADg8AE6+Zdww=="
: "SDnRcxaLAUQxwKn///8AdQREiEkDSIPBBOvlww==")
(color == "sentinel") && color := NumGet(this.ptr, "uint")
DllCall(code, "ptr", this.ptr, "ptr", this.ptr + this.size, "uint", color, "uchar", alpha, "cdecl")
}
PixelSearch(color, variation := 0) {
if not IsObject(color) {
(color >> 24) || color |= 0xFF000000
if not IsObject(variation)
if (variation == 0)
option := 1
else
option := 2
else if (variation.length == 3)
option := 3
else if (variation.length == 6)
option := 4
else throw Error("Invalid variation parameter.")
}
else
if not IsObject(variation)
if (variation == 0)
option := 5
else
option := 6
else if (variation.length == 3)
option := 7
else throw Error("Invalid variation parameter.")
pixelsearch1 := this.Base64Code((A_PtrSize == 4)
? "VYnlVotNEItVDFOLRQhmD27RjVr0Zg9wygA52HMbDxAAZg92wWYP1/CF9nUMg8AQ6+g5CHQHg8AEOdBy9VteXcM="
: "ZkEPbtBIichIjUr0Zg9wygBIOchzIA8QAGYPdsFmRA/XyEWFyXUPSIPAEOvkRDkAdAlIg8AESDnQcvLD")
pixelsearch2 := this.Base64Code((A_PtrSize == 4)
? "VWYPduSJ5VdWU4Pk8IPsEIpFFItdEItNGItVHIt1DIt9IIhEJA6KRSSIXCQPD7bbiEwkDcHjEA+2yYhEJAsPtkUgweEIiFQkDA+2"
. "0gnYweIICcgPtk0kDQAAAP8J0Q+2VRRmD27oi0UIZg9wzQDB4hAJ0Y1W9GYPbvFmD3DWADnQczkPEAAPEBgPEDhmD97BZg/e2mYP"
. "dMFmD3TfD1TDZg92xGYP18iFyXURg8AQ68+KUAI4VCQPcwmDwAQ58HLw6yM6VCQOcvGKUAE4VCQNcug6VCQMcuKKEIn5ONFy2jpU"
. "JAty1I1l9FteX13D"
: "QVZBVUFUVVdWU0SLbCRgi0QkaESLdCRwRItUJHhEie6Jx0UPtu0PtsBBweUIRIn1RQ+29kWJ1EWJw0UPtsBEicvB4AhBweAQRQ+2"
. "0kUPtslFCfBECdBBweEQRQnoRAnIQYHIAAAA/2YPbuhIichmQQ9uyEiNSvRmD3DBAGYPcM0AZg927Ug5yHM8DxAgDyjQDyjcZg/e"
. "1GYP3tlmD3TQZg903A9U02YPdtVmRA/XwkWFwHUSSIPAEOvLikgCQTjLcwtIg8AESDnQcu/rHTjZcvGKSAFAOM5y6UA4+XLkighA"
. "OM1y3UQ44XLYW15fXUFcQV1BXsM=")
pixelsearch3 := this.Base64Code((A_PtrSize == 4)
? "VTHSieVXVlOD5PCD7BCLfQyNR/SJRCQEi0UUKdAPhBkBAACD+AF0PoP4AnQhg/gDvgMAAAAPTHQkDIl0JAyLdRBmD25klghmD3Dc"
. "AOsIx0QkDAIAAACLXRBmD25skwRmD3DVAOsIx0QkDAEAAACLdRBmD240lo0clolcJAhmD3DOAIP4AXR0g/gCi0UIdD6LTCQEOchz"
. "Lg8QAGYPdsFmD9fYDxAAidlmD3bCZg/X2A8QAAnLZg92w2YP1/AJ83V0g8AQ68qDwgPpS////4139Dnwcx8PEABmD3bBZg/XyA8Q"
. "AGYPdsJmD9fYCct1RoPAEOvdg8IC6R3///+LRQiNX/Q52HMUDxAAZg92wWYP1/CF9nUgg8AQ6+hC6fn+//+LTCQIiwyROQh0FEI5"
. "VCQMf+6DwAQ5+HMGMdLr74n4jWX0W15fXcM="
: "QVVBVFVXVlO9AwAAAEmJykiJ0THSSI1x9ESJyCnQD4QEAQAAg/gBSGPadC6D+AJ0FWZBD25smAiD+ANED03dZg9w3QDrBkG7AgAA"
. "AGZBD25smARmD3DVAOsGQbsBAAAAZkEPbgyYSY08mGYPcMkAg/gBdHOD+AJMidB0Xkg58HMxDxAADyjhZg924GZED9fsDyjiZg92"
. "4GYPdsNmD9fcZkQP1+BECetECeN1c0iDwBDryoPCA+lf////DxAADyjhZg924GYPdsJmRA/X5GYP19hECeN1SUiDwBBIOfBy24PC"
. "Auky////TInQSDnwcxUPEABmD3bBZg/X2IXbdSFIg8AQ6+b/wukO////SP/Ci3SX/DkwdBVBOdN/8EiDwARIOchzBzHS6+5Iichb"
. "Xl9dQVxBXcM=")
pixelsearch4 := this.Base64Code((A_PtrSize == 4)
? "VTHAZg925InlV1ZTg+Twg+xAi1UYKcIPhFMCAACD+gF0YIP6AnQzi10Qg/oDuQMAAAAPTflmD25sgwiLXRRmD3D9AA8pfCQwZg9u"
. "fIMIZg9w3wAPKVwkEOsFvwIAAACLXRBmD25sgwSLXRRmD258gwRmD3DdAGYPcM8ADylMJCDrBb8BAAAAi10QjQyFAAAAAAHLiVwk"
. "DItdEGYPbiwLi10UZg9uPAuNNAtmD3DNAIl0JAiLdQhmD3DvAIP6AQ+ECwEAAItNDIPpDIP6Ag+EnAAAADnOD4OMAAAADxAGDyjw"
. "DyjQZg/e9WYP3tFmD3TwZg900Q9U1g8o8GYPdtRmD97zZg9082YP19oPKFQkIGYP3tBmD3TQD1TWDyh0JDBmD3bUZg/e8GYPdHQk"
. "MGYP19IPKFQkEIlUJARmD97QZg900A9U1mYPdtRmD9fSiRQki1QkBAnaCxQkD4XLAAAAg8YQ6Wz///+DwAPpo/7//2YPdv85znNQ"
. "DxAWDyjyDyjCZg/e9WYP3sFmD3TyZg90wQ9Uxg8odCQgZg92x2YP3vJmD3TyZg/X2A8owmYP3sNmD3TDD1TGZg92x2YP19AJ2nVo"
. "g8YQ66yDwALpQ/7//4tVDGYPdvaD6gw51nMtDxAWDxAGDxA+Zg/e1WYP3sFmD3TBZg901w9UwmYPdsZmD9fIhcl1JYPGEOvPQOkC"
. "/v//OFoCczr/RCQwg8IEg8AEi0wkMDnPf+mDxgQ7dQxzRIpGATHJil4CiUwkMItUJAyIRCQgigaIRCQQi0QkCOvQOlgCcsGKTCQg"
. "OEoBcrg6SAFys4pMJBA4CnKrOghyp+sDi3UMjWX0ifBbXl9dww=="
: "QVRVV1ZTSIPsUA8pNCQPKXwkEEQPKUQkIEQPKUwkMEQPKVQkQL8DAAAAZg9220mJ00iJyzHSSY1z9IuMJKAAAAAp0Q+EMgIAAIP5"
. "AUhjwnRGg/kCdCFmQQ9ufIAIZkEPbnSBCIP5A0QPTddmD3DvAGYPcP4A6wZBugIAAABmQQ9uZIAEZkEPbnSBBGYPcNQAZg9w9gDr"
. "BkG6AQAAAGZBD24kgGYPcMwAZkEPbiSBSInYZg9w5ACD+QEPhCIBAACD+QIPhKsAAABIOfAPg5oAAAAPEABEDyjIRA8owGZED97M"
. "ZkQP3sFmRA90yGZED3TBRQ9UwUQPKMhmRA92w2ZED97KZkQPdMpmRQ/X4EQPKMBmRA/exmZED3TARQ9UwUQPKMhmRA92w2ZED97N"
. "ZkQPdM1mQQ/XyEQPKMBmRA/ex0QJ4WZBD3TAQQ9UwWYPdsNmD9foCel0C8HiAkhj0unfAAAASIPAEOld////g8ID6cf+//9mRQ92"
. "wEg58HNcRA8QCEUPKNFBDyjBZkQP3tRmD97BZkUPdNFmD3TBQQ9UwkUPKNFmQQ92wGZED97WZg/X6EEPKMFmD97CZkUPdMpmD3TC"
. "QQ9UwWZBD3bAZg/XyAnpdYRIg8AQ65+DwgLpWf7//2ZFD3bJSDnwczlEDxAARQ8o0EEPKMBmRA/e1GYP3sFmD3TBZkUPdMJBD1TA"
. "ZkEPdsFmD9fIhckPhTn///9Ig8AQ68L/wukP/v//QTh0CAJzJv/DSIPBBEE52n/uSIPABEw52HM4QIpwAkCKeAFIidEx20CKKOvg"
. "QTp0CQJy00E4fAgBcsxBOnwJAXLFQTgsCHK/QTosCXK56wNMidgPKDQkDyh8JBBEDyhEJCBEDyhMJDBEDyhUJEBIg8RQW15fXUFc"
. "ww==")
if (option == 1)
address := DllCall(pixelsearch1, "ptr", this.ptr, "ptr", this.ptr + this.size, "uint", color, "cdecl ptr")
if (option == 2) {
r := ((color & 0xFF0000) >> 16)
g := ((color & 0xFF00) >> 8)
b := ((color & 0xFF))
v := abs(variation)
address := DllCall(pixelsearch2, "ptr", this.ptr, "ptr", this.ptr + this.size
, "uchar", min(r+v, 255)
, "uchar", max(r-v, 0)
, "uchar", min(g+v, 255)
, "uchar", max(g-v, 0)
, "uchar", min(b+v, 255)
, "uchar", max(b-v, 0)
, "cdecl ptr")
}
if (option == 3) {
r := ((color & 0xFF0000) >> 16)
g := ((color & 0xFF00) >> 8)
b := ((color & 0xFF))
vr := abs(variation[1])
vg := abs(variation[2])
vb := abs(variation[3])
address := DllCall(pixelsearch2, "ptr", this.ptr, "ptr", this.ptr + this.size
, "uchar", min(r + vr, 255)
, "uchar", max(r - vr, 0)
, "uchar", min(g + vg, 255)
, "uchar", max(g - vg, 0)
, "uchar", min(b + vb, 255)
, "uchar", max(b - vb, 0)
, "cdecl ptr")
}
if (option == 4)
address := DllCall(pixelsearch2, "ptr", this.ptr, "ptr", this.ptr + this.size
, "uchar", min(max(variation[1], variation[2]), 255)
, "uchar", max(min(variation[1], variation[2]), 0)
, "uchar", min(max(variation[3], variation[4]), 255)
, "uchar", max(min(variation[3], variation[4]), 0)
, "uchar", min(max(variation[5], variation[6]), 255)
, "uchar", max(min(variation[5], variation[6]), 0)
, "cdecl ptr")
if (option == 5) {
colors := Buffer(4*color.length)
for c in color {
(c >> 24) || c |= 0xFF000000
NumPut("uint", c, colors, 4*(A_Index-1))
}
address := DllCall(pixelsearch3, "ptr", this.ptr, "ptr", this.ptr + this.size, "ptr", colors, "uint", color.length, "cdecl ptr")
}
if (option == 6) {
high := Buffer(4*color.length)
low := Buffer(4*color.length)
for c in color {
A_Offset := A_Index - 1
r := ((c & 0xFF0000) >> 16)
g := ((c & 0xFF00) >> 8)
b := ((c & 0xFF))
v := abs(variation)
NumPut("uchar", 255, high, 4*A_Offset + 3)
NumPut("uchar", min(r+v, 255), high, 4*A_Offset + 2)
NumPut("uchar", min(g+v, 255), high, 4*A_Offset + 1)
NumPut("uchar", min(b+v, 255), high, 4*A_Offset + 0)
NumPut("uchar", 0, low, 4*A_Offset + 3)
NumPut("uchar", max(r-v, 0), low, 4*A_Offset + 2)
NumPut("uchar", max(g-v, 0), low, 4*A_Offset + 1)
NumPut("uchar", max(b-v, 0), low, 4*A_Offset + 0)
}
address := DllCall(pixelsearch4, "ptr", this.ptr, "ptr", this.ptr + this.size, "ptr", high, "ptr", low, "uint", color.length, "cdecl ptr")
}
if (option == 7) {
high := Buffer(4*color.length)
low := Buffer(4*color.length)
for c in color {
A_Offset := A_Index - 1
r := ((c & 0xFF0000) >> 16)
g := ((c & 0xFF00) >> 8)
b := ((c & 0xFF))
vr := abs(variation[1])
vg := abs(variation[2])
vb := abs(variation[3])
NumPut("uchar", 255, high, 4*A_Offset + 3)
NumPut("uchar", min(r + vr, 255), high, 4*A_Offset + 2)
NumPut("uchar", min(g + vg, 255), high, 4*A_Offset + 1)
NumPut("uchar", min(b + vb, 255), high, 4*A_Offset + 0)
NumPut("uchar", 0, low, 4*A_Offset + 3)
NumPut("uchar", max(r - vr, 0), low, 4*A_Offset + 2)
NumPut("uchar", max(g - vg, 0), low, 4*A_Offset + 1)
NumPut("uchar", max(b - vb, 0), low, 4*A_Offset + 0)
}
address := DllCall(pixelsearch4, "ptr", this.ptr, "ptr", this.ptr + this.size, "ptr", high, "ptr", low, "uint", color.length, "cdecl ptr")
}
if (address == this.ptr + this.size)
return False
offset := (address - this.ptr) // 4
return [mod(offset, this.width), offset // this.width]
}
PixelSearchAll(color, variation := 0) {
if not IsObject(color) {
(color >> 24) || color |= 0xFF000000
if not IsObject(variation)
if (variation == 0)
option := 1
else
option := 2
else if (variation.length == 3)
option := 3
else if (variation.length == 6)
option := 4
else throw Error("Invalid variation parameter.")
}
else
if not IsObject(variation)
if (variation == 0)
option := 5
else
option := 6
else if (variation.length == 3)
option := 7
else throw Error("Invalid variation parameter.")
pixelsearchall1 := this.Base64Code((A_PtrSize == 4)
? "VTHSieVXZg9uVRiLRRBWU4tdFGYPcMoAjXP0OfBzDw8QAGYPdsFmD9fIhcl0BY1IEOsVjUgQicjr4TnIdPiLfRg5OHQJg8AEOdhy"
. "7usOO1UMcwaLfQiJBJdC6+lbidBeX13D"
: "VlMxwESLVCQ4ZkEPbtJmD3DKAEmNWfRJOdhNjVgQcyNBDxAAZg92wWYP1/CF9nUTTYnY6+JNOdh09kU5EHQLSYPABE05yHLt6w45"
. "0HMGicZMiQTx/8Dr51teww==")
pixelsearchall2 := this.Base64Code((A_PtrSize == 4)
? "VWYPduSJ5VdWU4Pk8IPsEItdGItNIItVKIpFHIhcJA8PttuLfRTB4xCIRCQOikUkiEwkDQ+2yY139IhUJAsPttLB4QgJ2ohEJAyK"
. "RSwJyg+2TSQPttiBygAAAP+IRCQKweEIZg9u6jHSCcsPtk0cZg9wzQDB4RAJy2YPbvNmD3DWADl1EHMri0UQDxAADxAYDxA4Zg/e"
. "wWYP3tpmD3TBZg903w9Uw2YPdsRmD9fIhcl0CItFEI1IEOsgi0UQjUgQiU0Q6705TRB09otFEIpYAjhcJA9zC4NFEAQ5fRBy5us0"
. "OlwkDnLvilgBOFwkDXLmOlwkDHLgihg4XCQLctg6XCQKctI7VQxzCYtFCItdEIkckELrwY1l9InQW15fXcM="
: "QVdBVkFVQVRVV1ZTRItUJGiLhCSIAAAARIucJJAAAABAimwkcESJ10UPttJBicYPtsBBweIQRYnfRQ+220iJy4tMJHiJ1ouUJIAA"
. "AABECdBNjVH0QYnMD7bJQYnVD7bSweEIweIICchAD7bNRAnaweEQDQAAAP8JymYPbsAxwGYPbupmD3DIAGYPcMUAZg927U050EmN"
. "UBBzQEEPECAPKNEPKNxmD97UZg/e2GYPdNFmD3TcD1TTZg921WYP18qFyXUXSYnQ68lJOdB09kGKSAJAOM9zC0mDwARNOchy6esu"
. "QDjpcvBBikgBQTjMcudEOOly4kGKCEE4znLaRDj5ctU58HMGicFMiQTL/8Drx1teX11BXEFdQV5BX8M=")
pixelsearchall3 := this.Base64Code((A_PtrSize == 4)
? "VTHSMcmJ5VdWU4Pk8IPsEItFFIPoDIlEJASLRRwp0IlEJAwPhDwBAACD+AF0PoP4AnQhg/gDuAMAAAAPTEQkCIlEJAiLRRhmD25k"
. "kAhmD3DcAOsIx0QkCAIAAACLRRhmD25skARmD3DVAOsIx0QkCAEAAACLRRiNBJCJBCSLRRhmD240kItFEGYPcM4Ag3wkDAF1C4t1"
. "FI1e9OmJAAAAg3wkDAJ0YIt8JAQ5+HMuDxAAZg92wWYP19gPEACJ32YPdsJmD9fYDxAACftmD3bDZg/X8AnzdQ2DwBDryoPCA+k2"
. "////jXAQ610PEABmD3bBZg/X8A8QAGYPdsJmD9fYCfN14YPAEIt8JAQ5+HLbg8IC6QT///8PEABmD3bBZg/X8IX2db+DwBA52HLq"
. "Quno/v//izwkizyfOTh0G0M5XCQIf++DwAQ7RRRzGjnwD4Q6////Mdvr5jtNDHMGi30IiQSPQevXjWX0ichbXl9dww=="
: "QVdBVkFVQVRVV1ZTQb4DAAAATItcJGhMiUQkWEiJzonXMckx0kmNafREi0QkcEEp0A+EKQEAAEGD+AFIY8J0MEGD+AJ0FmZBD25s"
. "gwhBg/gDRQ9N1mYPcN0A6wZBugIAAABmQQ9ubIMEZg9w1QDrBkG6AQAAAGZBD24Mg02NJINIi0QkWGYPcMkAQYP4AQ+EigAAAEGD"
. "+AJ0ZEg56HMxDxAADyjhZg924GZED9f8DyjiZg924GYPdsNmD9fcZkQP1+hECftECet1DkiDwBDryoPCA+lR////TI1oEOthDxAA"
. "DyjhZg924GYPdsJmRA/X7GYP19hECet13kiDwBBIOehy24PCAuke////DxAAZg92wWYP19iF23W+SIPAEEg56HLo/8Lp//7//0WL"
. "PJxEOTh0Hkj/w0E52n/vSIPABEw5yHMcTDnoD4Q9////Mdvr5Tn5cwdBic9KiQT+/8Hr04nIW15fXUFcQV1BXkFfww==")
pixelsearchall4 := this.Base64Code((A_PtrSize == 4)
? "VWYPdtKJ5VdWMfZTMduD5PCD7ECJXCQ0i0UgKfCJRCQ8D4R3AgAAg/gBdGOD+AJ0OIP4A7gDAAAAD0xEJDiJRCQ4i0UYZg9uZLAI"
. "i0UcZg9w7AAPKWwkIGYPbmywCGYPcN0ADykcJOsIx0QkOAIAAACLRRhmD25ksASLRRxmD25MsARmD3DcAGYPcOkA6wjHRCQ4AQAA"
. "AItdGI0EtQAAAACLVRiLfRABw2YPbiQCiVwkGItdHGYPcMwAjRQDZg9uJAOJVCQUZg9w5ACDfCQ8AYtFFHUIg+gM6SoBAACDfCQ8"
. "Ao1Q9I1Y9A+E2gAAADnfc3YPEAcPKPgPKPBmD978Zg/e8WYPdPhmD3TxD1T3Dyj4Zg928mYP3vtmD3T7Zg/Xzg8o8GYP3vVmD3Tw"
. "D1T3Dyh8JCBmD3byZg/e+GYPdHwkIGYP18YPKDQkCchmD97wZg908A9U92YPdvJmD9fWCdB1DYPHEOuGg8YD6aj+//+NRxCJRCQQ"
. "6dAAAAAPEDcPKP4PKMZmD978Zg/ewWYPdP5mD3TBD1THDyj+Zg92wmYP3v1mD3T+Zg/XyA8oxmYP3sNmD3TDD1THZg92wmYP18AJ"
. "yHWrg8cQOddysIPGAulE/v//DxA3DxAHDxA/Zg/e9GYP3sFmD3TBZg909w9UxmYPdgUAAAAAZg/X0IXSD4Vs////g8cQOcdyyUbp"
. "B/7//4tEJBA5xw+Erv7//4pHAjHJi1QkFIlMJDCIRCQfikcBiEQkHooHiEQkHYtEJBiLXCQwOVwkOH8Kg8cEO30UcsDrS4pMJB84"
. "SAJyNjpKAnIxilwkHjhYAXIoOloBciOKTCQdOAhyGzoKcheLTCQ0O00McwqLTQiLXCQ0iTyZ/0QkNP9EJDCDwASDwgTroYtEJDSN"
. "ZfRbXl9dww=="
: "QVdBVkFVQVRVV1ZTSIPseA8pdCQgDyl8JDBEDylEJEBEDylMJFBEDylUJGBFMdJmD3bSSImMJMAAAABNic5Mi4wk6AAAAEyJhCTQ"
. "AAAATIuEJOAAAABJjXb0iZQkyAAAADHSRIucJPAAAABBKdMPhHgCAABBg/sBSGPCdEtBg/sCdCZmQQ9ufIAIZkEPbnSBCEGD+wO/"
. "AwAAAA9N32YPcO8AZg9w/gDrBbsCAAAAZkEPbmSABGZBD250gQRmD3DcAGYPcPYA6wW7AQAAAGZBD24kgGYPcMwAZkEPbiSBjQSV"
. "AAAAAEiYSIlEJBBIi4Qk0AAAAGYPcOQAZkUPdslBg/sBD4RTAQAAQYP7Ag+EBQEAAEg58A+DjgAAAA8QAEQPKMhEDyjAZkQP3sxm"
. "RA/ewWZED3TIZkQPdMFFD1TBRA8oyGZED3bCZkQP3stmRA90y2ZBD9foRA8owGZED97GZkQPdMBFD1TBRA8oyGZED3bCZkQP3s1m"
. "RA90zWZBD9fIRA8owGZED97HCelmQQ90wEEPVMFmD3bCZg/X+An5dRFIg8AQ6Wn///+DwgPpsv7//0iNeBBIiXwkGOnYAAAARA8Q"
. "AEUPKMhBDyjAZkQP3sxmD97BZkUPdMhmD3TBQQ9UwUUPKMhmD3bCZkQP3s5mD9f4QQ8owGYP3sNmRQ90wWYPdMNBD1TAZg92wmYP"
. "18gJ+XWeSIPAEEg58HKjg8IC6T/+//9EDxAARQ8o0EEPKMBmRA/e1GYP3sFmD3TBZkUPdMJBD1TAZkEPdsFmD9fIhckPhVr///9I"
. "g8AQSDnwcsT/wun8/f//SIt8JBhIOfgPhIT+//8x/0CKaAJEimABRIooSItMJBCJfCQMi3wkDDn7fwtIg8AETDnwcsvrTkE4bAgC"
. "cj1BOmwJAnI2RThkCAFyL0U6ZAkBcihFOCwIciJFOiwJchxEO5QkyAAAAHMPSIu8JMAAAABFiddKiQT/Qf/C/0QkDEiDwQTrnw8o"
. "dCQgDyh8JDBEidBEDyhEJEBEDyhMJFBEDyhUJGBIg8R4W15fXUFcQV1BXkFfww==")
limit := 256
redo:
result := Buffer(A_PtrSize * limit)
if (option == 1)
count := DllCall(pixelsearchall1, "ptr", result, "uint", limit, "ptr", this.ptr, "ptr", this.ptr + this.size, "uint", color, "cdecl uint")
if (option == 2) {
r := ((color & 0xFF0000) >> 16)
g := ((color & 0xFF00) >> 8)
b := ((color & 0xFF))
v := abs(variation)
count := DllCall(pixelsearchall2, "ptr", result, "uint", limit, "ptr", this.ptr, "ptr", this.ptr + this.size
, "uchar", min(r+v, 255)
, "uchar", max(r-v, 0)
, "uchar", min(g+v, 255)
, "uchar", max(g-v, 0)
, "uchar", min(b+v, 255)
, "uchar", max(b-v, 0)
, "cdecl ptr")
}
if (option == 3) {
r := ((color & 0xFF0000) >> 16)
g := ((color & 0xFF00) >> 8)
b := ((color & 0xFF))
vr := abs(variation[1])
vg := abs(variation[2])
vb := abs(variation[3])
count := DllCall(pixelsearchall2, "ptr", result, "uint", limit, "ptr", this.ptr, "ptr", this.ptr + this.size
, "uchar", min(r + vr, 255)
, "uchar", max(r - vr, 0)
, "uchar", min(g + vg, 255)
, "uchar", max(g - vg, 0)
, "uchar", min(b + vb, 255)
, "uchar", max(b - vb, 0)
, "cdecl ptr")
}
if (option == 4)
count := DllCall(pixelsearchall2, "ptr", result, "uint", limit, "ptr", this.ptr, "ptr", this.ptr + this.size
, "uchar", min(max(variation[1], variation[2]), 255)
, "uchar", max(min(variation[1], variation[2]), 0)
, "uchar", min(max(variation[3], variation[4]), 255)
, "uchar", max(min(variation[3], variation[4]), 0)
, "uchar", min(max(variation[5], variation[6]), 255)
, "uchar", max(min(variation[5], variation[6]), 0)
, "cdecl ptr")
if (option == 5) {
colors := Buffer(4*color.length)
for c in color {
(c >> 24) || c |= 0xFF000000
NumPut("uint", c, colors, 4*(A_Index-1))
}
count := DllCall(pixelsearchall3, "ptr", result, "uint", limit, "ptr", this.ptr, "ptr", this.ptr + this.size, "ptr", colors, "uint", color.length, "cdecl ptr")
}
if (option == 6) {
high := Buffer(4*color.length)
low := Buffer(4*color.length)
for c in color {
A_Offset := A_Index - 1
r := ((c & 0xFF0000) >> 16)
g := ((c & 0xFF00) >> 8)
b := ((c & 0xFF))
v := abs(variation)
NumPut("uchar", 255, high, 4*A_Offset + 3)
NumPut("uchar", min(r+v, 255), high, 4*A_Offset + 2)
NumPut("uchar", min(g+v, 255), high, 4*A_Offset + 1)
NumPut("uchar", min(b+v, 255), high, 4*A_Offset + 0)
NumPut("uchar", 0, low, 4*A_Offset + 3)
NumPut("uchar", max(r-v, 0), low, 4*A_Offset + 2)
NumPut("uchar", max(g-v, 0), low, 4*A_Offset + 1)
NumPut("uchar", max(b-v, 0), low, 4*A_Offset + 0)
}
count := DllCall(pixelsearchall4, "ptr", result, "uint", limit, "ptr", this.ptr, "ptr", this.ptr + this.size, "ptr", high, "ptr", low, "uint", color.length, "cdecl ptr")
}
if (option == 7) {
high := Buffer(4*color.length)
low := Buffer(4*color.length)
for c in color {
A_Offset := A_Index - 1
r := ((c & 0xFF0000) >> 16)
g := ((c & 0xFF00) >> 8)
b := ((c & 0xFF))
vr := abs(variation[1])
vg := abs(variation[2])
vb := abs(variation[3])
NumPut("uchar", 255, high, 4*A_Offset + 3)
NumPut("uchar", min(r + vr, 255), high, 4*A_Offset + 2)
NumPut("uchar", min(g + vg, 255), high, 4*A_Offset + 1)
NumPut("uchar", min(b + vb, 255), high, 4*A_Offset + 0)
NumPut("uchar", 0, low, 4*A_Offset + 3)
NumPut("uchar", max(r - vr, 0), low, 4*A_Offset + 2)
NumPut("uchar", max(g - vg, 0), low, 4*A_Offset + 1)
NumPut("uchar", max(b - vb, 0), low, 4*A_Offset + 0)
}
count := DllCall(pixelsearchall4, "ptr", result, "uint", limit, "ptr", this.ptr, "ptr", this.ptr + this.size, "ptr", high, "ptr", low, "uint", color.length, "cdecl ptr")
}
if (count > limit) {
limit := count
goto redo
}
if (count == 0)
return False
xys := []
xys.count := count
loop count {
address := NumGet(result, A_PtrSize * (A_Index-1), "ptr")
offset := (address - this.ptr) // 4
xys.push([mod(offset, this.width), offset // this.width])
}
return xys
}
ImageSearch(image, variation := 0, option := "") {
if !(IsObject(image) && image.HasProp("ptr") && image.HasProp("size"))
image := ImagePutBuffer(image)
x := image.HasProp("x") ? image.x : image.width//2
y := image.HasProp("y") ? image.y : image.height//2
if (option == "") {
if (variation == 0)
option := 1
else
option := 2
}
imagesearch1 := this.Base64Code((A_PtrSize == 4)
? ""
: "QVdBVkFVQVRVV1ZTSIPsGESLlCSYAAAARQ+2YQNEidAPr4QkgAAAAInTi5QkkAAAAESJxUiJz0GJ3UWLAUQrrCSAAAAASAHQQYs0"
. "gYnoK4QkiAAAAIPAAQ+vw0yNHIFMOdkPgwQBAABED6/TiWwkcEkB0usQDx8ASIPBBEw52Q+D4wAAAEI5NJF17UWE5A+FrAAAAEiJ"
. "yDHSSCn4SMH4AvfzQTnVctGLhCSIAAAAhcB0eIuEJIAAAABFMfZEiGQkD0Ux/0SJ8kiNLIUAAAAATInISI0UkUyNJChMOeBzS0iJ"
. "LCQPH0QAAIB4AwB0CosqOSgPhYAAAABIg8AESIPCBEw54HLjSIssJEGDxwFEObwkiAAAAHQTQQHeTI0kKESJ8kiNFJFMOeBytUiJ"
. "yEiDxBhbXl9dQVxBXUFeQV/DZpBEOQEPhEv///9Ig8EETDnZcxZCOTSRdOhIg8EETDnZD4Ig////Dx8Ai2wkcA+v3UiNDJ/rtQ8f"
. "AEQPtmQkD+n1/v//")
imagesearch2 := this.Base64Code((A_PtrSize == 4)
? ""
: "QVdBVkFVQVRVV1ZTSIPsOESLnCSgAAAAi7wkqAAAAEGJ1EmJyouUJLgAAACLjCSwAAAAQSn4TImMJJgAAABIi7QkmAAAAEQPt4wkwAAAAInQRQ+vxEEPr8NPjTSCSAHIiwSGRInmRCneiXQkLE058g+DcAEAAEEPr9QPtthEieVmiVwkKA+23MHoEA+2wIlcJBxIAcpmiUQkKkiNDJUAAAAARInaSI1xAUgp1UyNLJUAAAAASIl0JBBBjVP/SI1xAkWJy0iJdCQgSMHlAjH2QffbTI08lQAAAABmDx9EAABBD7YUCg+3RCQoKdBmQTnBcwpmRDnYD4LTAAAASItEJBBBD7YUAg+3RCQcKdBmQTnBcwpmRDnYD4KyAAAASItEJCBBD7YUAg+3RCQqKdBmQTnBcwpmRDnYD4KRAAAAhf8PhKMAAABIi4QkmAAAAEyJfCQITInSMdtJic9OjQQoTDnAD4OBAAAAiVwkGOsTZpBIg8AESIPCBEw5wA+DfwAAAIB4AwB06Q+2CA+2GinZZkE5yXMGZkQ52XIsD7ZIAQ+2WgEp2WZBOclzBmZEOdlyFg+2SAIPtloCKdlmQTnJc69mRDnZc6lMiflMi3wkCIPGAUmDwgREOeZyPTH2TTnyD4L6/v//RTHSTInQSIPEOFteX11BXEFdQV5BX8MPHwCLXCQYSAHqg8MBOfsPhUn////r1Q8fQABNOfJzyTl0JCwPg7n+//9NAfpNOfJztzH26ar+//8=")
if (option == 1)
address := DllCall(imagesearch1, "ptr", this.ptr, "uint", this.width, "uint", this.height
, "ptr", image.ptr, "uint", image.width, "uint", image.height
, "uint", x, "uint", y, "cdecl ptr")
if (option == 2)
address := DllCall(imagesearch2, "ptr", this.ptr, "uint", this.width, "uint", this.height
, "ptr", image.ptr, "uint", image.width, "uint", image.height
, "uint", x, "uint", y, "ushort", variation, "cdecl ptr")
if (address == this.ptr + this.size)
return False
offset := (address - this.ptr) // 4
return [mod(offset, this.width), offset // this.width]
}
ImageSearchAll(image, variation := 0) {
if !(IsObject(image) && image.HasProp("ptr") && image.HasProp("size"))
image := ImagePutBuffer(image)
x := image.HasProp("x") ? image.x : image.width//2
y := image.HasProp("y") ? image.y : image.height//2
if (variation == 0)
option := 1
else
option := 2
imagesearchall1 := this.Base64Code((A_PtrSize == 4)
? "VYnlV1ZTg+wUi0UMi1UYi00IjTyFAAAAAItFECtFHA+vxwNFCIlF6ItFDCnQiUXkjQSVAAAAAIlF7ItF6DnBc2eLRRSLADkBdAmL"
. "RRSAeAMAdVCJyCtFCDHSwfgC93UMOVXkfD4x0otFFInLiVXwi3XwO3UcdDyLVeyJ3gHCiVXgi1XgOdBzFIB4AwB0BosWORB1D4PA"
. "BIPGBOvl/0XwAfvrzIPBBOuSi0UQD6/HA0UIicGDxBSJyFteX13D"
: "QVdBVkFVQVRVV1ZTSIPsGEUx20SLpCSYAAAAi4QkgAAAAESLlCSQAAAASIu8JIgAAABEKeBBD6/BSInLidZMicFNjSyARInIRCnQ"
. "iUQkDEqNBJUAAAAASIkEJEw56XN0iwc5AXQGgH8DAHViSInIMdJMKcBIwfgCQffxOVQkDHxNSIn4Me0x0kQ54nQyTIs8JEGJ7k6N"
. "NLFJAcdMOfhzGIB4AwB0CEWLFkQ5EHUgSIPABEmDxgTr4//CRAHN68lBOfNzB0SJ2EiJDMNB/8NIg8EE64dEidhIg8QYW15fXUFc"
. "QV1BXkFfww==")
imagesearchall2 := this.Base64Code((A_PtrSize == 4)
? ""
: "QVdBVkFVQVRVV1ZTSIPsSIuEJNgAAABEi5QkwAAAAEiLnCS4AAAAi7wk4AAAAImUJJgAAACJwkEPr8FMjWwkPEEPr9JIiYwkkAAAAIuMJNAAAABIAchIAcpIweACMcmLFJNIiUQkEESJyESJy0Qp04lUJDyLlCSwAAAAK5QkyAAAAIlcJCRBD6/RSY00kESJ0kiJdCQoSCnQif5MjSSVAAAAAEjB4AL33kiJRCQYQY1C/2aJdCQiSMHgAkiJRCQIMcBIi3QkKEk58A+D2QAAADlEJCRzDUiLRCQISQHA6b8AAABIi3QkEDHSSY0cMEYPthwqD7Y0E0Ep82ZEOd9zCGZEO1wkInJUSP/CSIP6A3XdSIuUJLgAAABNicMx7esKSItcJBj/xUkB2zusJMgAAAB0RE6NNCJMOfJz5IB6AwB0KzHbD7Y0GkUPtjwbRCn+Zjn3cw9mO3QkInMISYPABP/A6zVI/8NIg/sDdddIg8IESYPDBOvAO4wkmAAAAHMRRYsYSIucJJAAAACJykSJHJP/wU0B4EQB0EQ5yA+CIP///zHA6Rn///+JyEiDxEhbXl9dQVxBXUFeQV/D")
limit := 256
redo:
result := Buffer(A_PtrSize * limit)
count := DllCall(imagesearchall1, "ptr", result, "uint", limit
, "ptr", this.ptr, "uint", this.width, "uint", this.height
, "ptr", image.ptr, "uint", image.width, "uint", image.height
, "uint", x, "uint", y, "cdecl uint")
count := DllCall(imagesearchall2, "ptr", result, "uint", limit
, "ptr", this.ptr, "uint", this.width, "uint", this.height
, "ptr", image.ptr, "uint", image.width, "uint", image.height
, "uint", x, "uint", y,  "ushort", variation, "cdecl uint")
if (count > limit) {
limit := count
goto redo
}
if (count = 0)
return False
xys := []
xys.count := count
loop count {
address := NumGet(result, A_PtrSize * (A_Index-1), "ptr")
offset := (address - this.ptr) // 4
xys.push([mod(offset, this.width), offset // this.width])
}
return xys
}
}
static BitmapToScreenshot(pBitmap, screenshot := "", alpha := "") {
DllCall("gdiplus\GdipGetImageWidth", "ptr", pBitmap, "uint*", &width:=0)
DllCall("gdiplus\GdipGetImageHeight", "ptr", pBitmap, "uint*", &height:=0)
x := IsObject(screenshot) && screenshot.Has(1) ? screenshot[1] : 0
y := IsObject(screenshot) && screenshot.Has(2) ? screenshot[2] : 0
w := IsObject(screenshot) && screenshot.Has(3) ? screenshot[3] : width
h := IsObject(screenshot) && screenshot.Has(4) ? screenshot[4] : height
hdc := DllCall("CreateCompatibleDC", "ptr", 0, "ptr")
hbm := this.BitmapToHBitmap(pBitmap, alpha)
obm := DllCall("SelectObject", "ptr", hdc, "ptr", hbm, "ptr")
ddc := DllCall("GetDC", "ptr", 0, "ptr")
DllCall("SetStretchBltMode", "ptr", ddc, "int", 4)
DllCall("gdi32\StretchBlt"
, "ptr", ddc, "int", x, "int", y, "int", w,     "int", h
, "ptr", hdc, "int", 0, "int", 0, "int", width, "int", height
, "uint", 0x00CC0020)
DllCall("ReleaseDC", "ptr", 0, "ptr", ddc)
DllCall("SelectObject", "ptr", hdc, "ptr", obm)
DllCall("DeleteObject", "ptr", hbm)
DllCall("DeleteDC",     "ptr", hdc)
return [x,y,w,h]
}
static BitmapToWindow(pBitmap, title := "", pos := "", style := 0x82C80000, styleEx := 0x9, parent := "", playback := "", cache := "") {
WS_POPUP                  := 0x80000000
WS_CLIPCHILDREN           :=  0x2000000
WS_CAPTION                :=   0xC00000
WS_SYSMENU                :=    0x80000
WS_EX_TOPMOST             :=        0x8
WS_EX_DLGMODALFRAME       :=        0x1
WS_CHILD                  := 0x40000000
WS_VISIBLE                := 0x10000000
WS_EX_LAYERED             :=    0x80000
(style == "") && style := WS_POPUP | WS_CLIPCHILDREN | WS_CAPTION | WS_SYSMENU
(styleEx == "") && styleEx := WS_EX_TOPMOST | WS_EX_DLGMODALFRAME
DllCall("gdiplus\GdipGetImageWidth", "ptr", pBitmap, "uint*", &width:=0)
DllCall("gdiplus\GdipGetImageHeight", "ptr", pBitmap, "uint*", &height:=0)
try dpi := DllCall("SetThreadDpiAwarenessContext", "ptr", -3, "ptr")
ScreenWidth := A_ScreenWidth
ScreenHeight := A_ScreenHeight
try DllCall("SetThreadDpiAwarenessContext", "ptr", dpi, "ptr")
s := IsObject(pos) && pos.Has(3) && pos[3] ~= "^(?!0+$)\d+$" ? pos[3] / width
: IsObject(pos) && pos.Has(4) && pos[4] ~= "^(?!0+$)\d+$" ? pos[4] / height
: (width > ScreenWidth) && (width / height > ScreenWidth / ScreenHeight) ? ScreenWidth / width
: (height > ScreenHeight) && (width / height <= ScreenWidth / ScreenHeight) ? ScreenHeight / height
: 1
w := IsObject(pos) && pos.Has(3) && pos[3] ~= "^(?!0+$)\d+$" ? pos[3] : s * width
h := IsObject(pos) && pos.Has(4) && pos[4] ~= "^(?!0+$)\d+$" ? pos[4] : s * height
x := IsObject(pos) && pos.Has(1) && pos[1] ~= "^-?\d+$" ? pos[1] : 0.5*(ScreenWidth - w)
y := IsObject(pos) && pos.Has(2) && pos[2] ~= "^-?\d+$" ? pos[2] : 0.5*(ScreenHeight - h)
if IsObject(pos) && pos.Has(5) && WinExist(pos[5]) {
try dpi := DllCall("SetThreadDpiAwarenessContext", "ptr", -3, "ptr")
WinGetClientPos &xr, &yr,,, pos[5]
try DllCall("SetThreadDpiAwarenessContext", "ptr", dpi, "ptr")
x += xr
y += yr
}
x2 := Round(x + w)
y2 := Round(y + h)
x  := Round(x)
y  := Round(y)
w  := x2 - x
h  := y2 - y
rect := Buffer(16)
NumPut("int",  x, rect,  0)
NumPut("int",  y, rect,  4)
NumPut("int", x2, rect,  8)
NumPut("int", y2, rect, 12)
DllCall("AdjustWindowRectEx", "ptr", rect, "uint", style, "int", 0, "uint", styleEx)
try dpi := DllCall("SetThreadDpiAwarenessContext", "ptr", -3, "ptr")
hwnd := DllCall("CreateWindowEx"
,   "uint", styleEx
,    "str", this.WindowClass()
,    "str", title
,   "uint", style
,    "int", NumGet(rect,  0, "int")
,    "int", NumGet(rect,  4, "int")
,    "int", NumGet(rect,  8, "int") - NumGet(rect,  0, "int")
,    "int", NumGet(rect, 12, "int") - NumGet(rect,  4, "int")
,    "ptr", (parent != "") ? parent : A_ScriptHwnd
,    "ptr", 0
,    "ptr", 0
,    "ptr", 0
,    "ptr")
try DllCall("SetThreadDpiAwarenessContext", "ptr", dpi, "ptr")
DllCall("SetWindowLong", "ptr", hwnd, "int", -20, "int", styleEx | WS_EX_LAYERED)
DllCall("SetLayeredWindowAttributes", "ptr", hwnd, "uint", 0xF0F0F0, "uchar", 0, "int", 1)
child := this.Show(pBitmap, title, [0, 0, w, h], WS_CHILD | WS_VISIBLE, WS_EX_LAYERED, hwnd, playback, cache)
DllCall("SetWindowLong", "ptr", hwnd, "int", 0*A_PtrSize, "ptr", hwnd)
DllCall("SetWindowLong", "ptr", hwnd, "int", 1*A_PtrSize, "ptr", child)
DllCall("SetWindowLong", "ptr", child, "int", 0*A_PtrSize, "ptr", hwnd)
DllCall("SetWindowLong", "ptr", child, "int", 1*A_PtrSize, "ptr", child)
DllCall("ShowWindow", "ptr", hwnd, "int", 1)
return hwnd
}
static Show(pBitmap, title := "", pos := "", style := 0x90000000, styleEx := 0x80088, parent := "", playback := "", cache := "") {
WS_POPUP                  := 0x80000000
WS_VISIBLE                := 0x10000000
WS_EX_TOPMOST             :=        0x8
WS_EX_TOOLWINDOW          :=       0x80
WS_EX_LAYERED             :=    0x80000
(style == "") && style := WS_POPUP | WS_VISIBLE
(styleEx == "") && styleEx := WS_EX_TOPMOST | WS_EX_TOOLWINDOW | WS_EX_LAYERED
DllCall("gdiplus\GdipGetImageWidth", "ptr", pBitmap, "uint*", &width:=0)
DllCall("gdiplus\GdipGetImageHeight", "ptr", pBitmap, "uint*", &height:=0)
try dpi := DllCall("SetThreadDpiAwarenessContext", "ptr", -3, "ptr")
ScreenWidth := A_ScreenWidth
ScreenHeight := A_ScreenHeight
try DllCall("SetThreadDpiAwarenessContext", "ptr", dpi, "ptr")
s := IsObject(pos) && pos.Has(3) && pos[3] ~= "^(?!0+$)\d+$" ? pos[3] / width
: IsObject(pos) && pos.Has(4) && pos[4] ~= "^(?!0+$)\d+$" ? pos[4] / height
: (width > ScreenWidth) && (width / height > ScreenWidth / ScreenHeight) ? ScreenWidth / width
: (height > ScreenHeight) && (width / height <= ScreenWidth / ScreenHeight) ? ScreenHeight / height
: 1
w := IsObject(pos) && pos.Has(3) && pos[3] ~= "^(?!0+$)\d+$" ? pos[3] : s * width
h := IsObject(pos) && pos.Has(4) && pos[4] ~= "^(?!0+$)\d+$" ? pos[4] : s * height
x := IsObject(pos) && pos.Has(1) && pos[1] ~= "^-?\d+$" ? pos[1] : 0.5*(ScreenWidth - w)
y := IsObject(pos) && pos.Has(2) && pos[2] ~= "^-?\d+$" ? pos[2] : 0.5*(ScreenHeight - h)
if IsObject(pos) && pos.Has(5) && WinExist(pos[5]) {
try dpi := DllCall("SetThreadDpiAwarenessContext", "ptr", -3, "ptr")
WinGetClientPos &xr, &yr,,, pos[5]
try DllCall("SetThreadDpiAwarenessContext", "ptr", dpi, "ptr")
x += xr
y += yr
}
x2 := Round(x + w)
y2 := Round(y + h)
x  := Round(x)
y  := Round(y)
w  := x2 - x
h  := y2 - y
hdc := DllCall("CreateCompatibleDC", "ptr", 0, "ptr")
bi := Buffer(40, 0)
NumPut(  "uint",        40, bi,  0)
NumPut(   "int",         w, bi,  4)
NumPut(   "int",        -h, bi,  8)
NumPut("ushort",         1, bi, 12)
NumPut("ushort",        32, bi, 14)
hbm := DllCall("CreateDIBSection", "ptr", hdc, "ptr", bi, "uint", 0, "ptr*", &pBits:=0, "ptr", 0, "uint", 0, "ptr")
obm := DllCall("SelectObject", "ptr", hdc, "ptr", hbm, "ptr")
if (w == width && h == height) {
Rect := Buffer(16, 0)
NumPut(  "uint",   width, Rect,  8)
NumPut(  "uint",  height, Rect, 12)
BitmapData := Buffer(16+2*A_PtrSize, 0)
NumPut(   "int",  4 * width, BitmapData,  8)
NumPut(   "ptr",      pBits, BitmapData, 16)
DllCall("gdiplus\GdipBitmapLockBits"
,    "ptr", pBitmap
,    "ptr", Rect
,   "uint", 5
,    "int", 0xE200B
,    "ptr", BitmapData)
DllCall("gdiplus\GdipBitmapUnlockBits", "ptr", pBitmap, "ptr", BitmapData)
}
else {
DllCall("gdiplus\GdipCreateFromHDC", "ptr", hdc , "ptr*", &pGraphics:=0)
DllCall("gdiplus\GdipSetPixelOffsetMode",    "ptr", pGraphics, "int", 2)
DllCall("gdiplus\GdipSetCompositingMode",    "ptr", pGraphics, "int", 1)
DllCall("gdiplus\GdipSetInterpolationMode",  "ptr", pGraphics, "int", 7)
DllCall("gdiplus\GdipCreateImageAttributes", "ptr*", &ImageAttr:=0)
DllCall("gdiplus\GdipSetImageAttributesWrapMode", "ptr", ImageAttr, "int", 3, "uint", 0, "int", 0)
DllCall("gdiplus\GdipDrawImageRectRectI"
,    "ptr", pGraphics
,    "ptr", pBitmap
,    "int", 0, "int", 0, "int", w,     "int", h
,    "int", 0, "int", 0, "int", width, "int", height
,    "int", 2
,    "ptr", ImageAttr
,    "ptr", 0
,    "ptr", 0)
DllCall("gdiplus\GdipDisposeImageAttributes", "ptr", ImageAttr)
DllCall("gdiplus\GdipDeleteGraphics", "ptr", pGraphics)
}
try dpi := DllCall("SetThreadDpiAwarenessContext", "ptr", -3, "ptr")
hwnd := DllCall("CreateWindowEx"
,   "uint", styleEx | WS_EX_LAYERED
,    "str", this.WindowClass()
,    "str", title
,   "uint", style
,    "int", x
,    "int", y
,    "int", w
,    "int", h
,    "ptr", (parent != "") ? parent : A_ScriptHwnd
,    "ptr", 0
,    "ptr", 0
,    "ptr", 0
,    "ptr")
try DllCall("SetThreadDpiAwarenessContext", "ptr", dpi, "ptr")
DllCall("UpdateLayeredWindow"
,    "ptr", hwnd
,    "ptr", 0
,    "ptr", 0
,"uint64*", w | h << 32
,    "ptr", hdc
, "int64*", 0
,   "uint", 0
,  "uint*", 0xFF << 16 | 0x01 << 24
,   "uint", 2)
DllCall("SetWindowLong", "ptr", hwnd, "int", 0*A_PtrSize, "ptr", hwnd)
DllCall("SetWindowLong", "ptr", hwnd, "int", 1*A_PtrSize, "ptr", hwnd)
DllCall("SetWindowLong", "ptr", hwnd, "int", 2*A_PtrSize, "ptr", hdc)
obj := {scale: 5
, scales: [0.125, 0.25, 0.5, 0.75, 1, 1.25, 1.5, 2, 3, 4, 6, 8, 12]}
ObjAddRef(ObjPtr(obj))
DllCall("SetWindowLong" (A_PtrSize=8?"Ptr":""), "ptr", hwnd, "int", 3*A_PtrSize, "ptr", ObjPtr(obj))
DllCall("gdiplus\GdipImageGetFrameDimensionsCount", "ptr", pBitmap, "uint*", &dims:=0)
DllCall("gdiplus\GdipImageGetFrameDimensionsList", "ptr", pBitmap, "ptr", dimIDs := Buffer(16*dims), "uint", dims)
DllCall("gdiplus\GdipImageGetFrameCount", "ptr", pBitmap, "ptr", dimIDs, "uint*", &number:=0)
DllCall("gdiplus\GdipGetPropertyItemSize", "ptr", pBitmap, "uint", 0x5100, "uint*", &nDelays:=0)
if (number > 1 && nDelays > 0) {
pDelays := DllCall("GlobalAlloc", "uint", 0, "uptr", nDelays, "ptr")
DllCall("gdiplus\GdipGetPropertyItem", "ptr", pBitmap, "uint", 0x5100, "uint", nDelays, "ptr", pDelays)
type := NumGet(pDelays + 8, "ushort") == 4 ? "gif" : "webp"
p := NumGet(pDelays + 8 + A_PtrSize, "ptr")
delays := Map(0, NumGet(p, "uint"))
loop number
delays[A_Index] := NumGet(p + 4*A_Index, "uint")
for each, delay in delays
if (A_Index = 1)
interval := delay
else
while delay {
temp := mod(interval, delay)
interval := delay
delay := temp
}
if (type = "gif")
interval *= 10
pTimeProc := this.SyncWindowProc(hwnd, 0x8000)
obj.type := type
obj.w := w
obj.h := h
obj.frame := 0
obj.number := number
obj.accumulate := 0
obj.delays := delays
obj.interval := interval
obj.pTimeProc := pTimeProc
obj.dimIDs := dimIDs
if (!cache && w == width && h == height) {
DllCall("gdiplus\GdipCloneImage", "ptr", pBitmap, "ptr*", &pBitmapClone:=0)
DllCall("gdiplus\GdipImageForceValidation", "ptr", pBitmapClone)
obj.pBitmap := pBitmapClone
obj.pBits := pBits
ImagePut.gdiplusStartup()
}
else {
cache := Map(0, hdc)
loop number {
frame := A_Index
DllCall("gdiplus\GdipImageSelectActiveFrame", "ptr", pBitmap, "ptr", dimIDs, "uint", frame)
DllCall("gdiplus\GdipGetImageWidth", "ptr", pBitmap, "uint*", &width:=0)
DllCall("gdiplus\GdipGetImageHeight", "ptr", pBitmap, "uint*", &height:=0)
hdc := DllCall("CreateCompatibleDC", "ptr", 0, "ptr")
bi := Buffer(40, 0)
NumPut(  "uint",        40, bi,  0)
NumPut(   "int",         w, bi,  4)
NumPut(   "int",        -h, bi,  8)
NumPut("ushort",         1, bi, 12)
NumPut("ushort",        32, bi, 14)
hbm := DllCall("CreateDIBSection", "ptr", hdc, "ptr", bi, "uint", 0, "ptr*", &pBits:=0, "ptr", 0, "uint", 0, "ptr")
obm := DllCall("SelectObject", "ptr", hdc, "ptr", hbm, "ptr")
DllCall("gdiplus\GdipCreateFromHDC", "ptr", hdc , "ptr*", &pGraphics:=0)
DllCall("gdiplus\GdipSetPixelOffsetMode",    "ptr", pGraphics, "int", 2)
DllCall("gdiplus\GdipSetCompositingMode",    "ptr", pGraphics, "int", 1)
DllCall("gdiplus\GdipSetInterpolationMode",  "ptr", pGraphics, "int", 7)
DllCall("gdiplus\GdipCreateImageAttributes", "ptr*", &ImageAttr:=0)
DllCall("gdiplus\GdipSetImageAttributesWrapMode", "ptr", ImageAttr, "int", 3, "uint", 0, "int", 0)
DllCall("gdiplus\GdipDrawImageRectRectI"
,    "ptr", pGraphics
,    "ptr", pBitmap
,    "int", 0, "int", 0, "int", w,     "int", h
,    "int", 0, "int", 0, "int", width, "int", height
,    "int", 2
,    "ptr", ImageAttr
,    "ptr", 0
,    "ptr", 0)
DllCall("gdiplus\GdipDisposeImageAttributes", "ptr", ImageAttr)
DllCall("gdiplus\GdipDeleteGraphics", "ptr", pGraphics)
cache[frame] := hdc
}
obj.cache := cache
}
if (playback == "" || playback == True)
DllCall("PostMessage", "ptr", hwnd, "uint", 0x8001, "uptr", 0, "ptr", 0)
}
return hwnd
}
static WindowClass(style := 0x8) {
cls := this.prototype.__class
wc := Buffer(A_PtrSize = 4 ? 48:80)
hInstance := DllCall("GetModuleHandle", "ptr", 0, "ptr")
if DllCall("GetClassInfoEx", "ptr", hInstance, "str", cls, "ptr", wc)
return cls
pWndProc := CallbackCreate(WindowProc)
hCursor := DllCall("LoadCursor", "ptr", 0, "ptr", 32512, "ptr")
hBrush := DllCall("GetStockObject", "int", 5, "ptr")
_ := (A_PtrSize = 4)
NumPut(  "uint",     wc.size, wc,         0)
NumPut(  "uint",       style, wc,         4)
NumPut(   "ptr",    pWndProc, wc,         8)
NumPut(   "int",           0, wc, _ ? 12:16)
NumPut(   "int",          40, wc, _ ? 16:20)
NumPut(   "ptr",           0, wc, _ ? 20:24)
NumPut(   "ptr",           0, wc, _ ? 24:32)
NumPut(   "ptr",     hCursor, wc, _ ? 28:40)
NumPut(   "ptr",      hBrush, wc, _ ? 32:48)
NumPut(   "ptr",           0, wc, _ ? 36:56)
NumPut(   "ptr", StrPtr(cls), wc, _ ? 40:64)
NumPut(   "ptr",           0, wc, _ ? 44:72)
DllCall("RegisterClassEx", "ptr", wc, "ushort")
return cls
WindowProc(hwnd, uMsg, wParam, lParam) {
static active_windows := Persistent()
if (uMsg = 0x1)
Persistent(++active_windows)
if (uMsg = 0x2) {
Persistent(--active_windows)
if (hwnd != DllCall("GetWindowLong", "ptr", hwnd, "int", 1*A_PtrSize, "ptr"))
return
obm := DllCall("CreateBitmap", "int", 0, "int", 0, "uint", 1, "uint", 1, "ptr", 0, "ptr")
if hdc := DllCall("GetWindowLong", "ptr", hwnd, "int", 2*A_PtrSize, "ptr") {
hbm := DllCall("SelectObject", "ptr", hdc, "ptr", obm, "ptr")
DllCall("DeleteObject", "ptr", hbm)
DllCall("DeleteDC", "ptr", hdc)
}
if ptr := DllCall("GetWindowLong" (A_PtrSize=8?"Ptr":""), "ptr", hwnd, "int", 3*A_PtrSize, "ptr") {
obj := ObjFromPtr(ptr)
DllCall("SetWindowLong" (A_PtrSize=8?"Ptr":""), "ptr", hwnd, "int", 3*A_PtrSize, "ptr", 0)
if timer := DllCall("GetWindowLong", "ptr", hwnd, "int", 4*A_PtrSize, "ptr")
DllCall("winmm\timeKillEvent", "uint", timer)
if obj.HasProp("pTimeProc")
DllCall("GlobalFree", "ptr", obj.pTimeProc)
if obj.HasProp("pBitmap") {
DllCall("gdiplus\GdipDisposeImage", "ptr", obj.pBitmap)
ImagePut.gdiplusShutdown()
}
if obj.HasProp("cache") {
for each, hdc in obj.cache {
hbm := DllCall("SelectObject", "ptr", hdc, "ptr", obm, "ptr")
DllCall("DeleteObject", "ptr", hbm)
DllCall("DeleteDC", "ptr", hdc)
}
}
}
}
if (uMsg = 0x1 || uMsg = 0x2)
goto default
parent := DllCall("GetWindowLong", "ptr", hwnd, "int", 0*A_PtrSize, "ptr")
child := DllCall("GetWindowLong", "ptr", hwnd, "int", 1*A_PtrSize, "ptr")
hdc := DllCall("GetWindowLong", "ptr", child, "int", 2*A_PtrSize, "ptr")
if ptr := DllCall("GetWindowLong" (A_PtrSize=8?"Ptr":""), "ptr", child, "int", 3*A_PtrSize, "ptr")
obj := ObjFromPtrAddRef(ptr)
timer := DllCall("GetWindowLong", "ptr", child, "int", 4*A_PtrSize, "ptr")
if (uMsg = 0x201)
return DllCall("DefWindowProc", "ptr", obj.scales[obj.scale] > 1 ? child : parent, "uint", 0xA1, "uptr", 2, "ptr", 0, "ptr")
if (uMsg = 0x202)
DllCall("GetWindowLong", "ptr", child, "int", 4*A_PtrSize, "ptr")
? uMsg := 0x8002
: uMsg := 0x8001
if (uMsg = 0x205)
return DllCall("DestroyWindow", "ptr", parent)
if (uMsg = 0x207) {
hdc := DllCall("GetWindowLong", "ptr", child, "int", 2*A_PtrSize, "ptr")
hbm := DllCall("GetCurrentObject", "ptr", hdc, "uint", 7)
dib := Buffer(64+5*A_PtrSize)
DllCall("GetObject", "ptr", hbm, "int", dib.size, "ptr", dib)
, width  := NumGet(dib, 4, "uint")
, height := NumGet(dib, 8, "uint")
, pBits  := NumGet(dib, A_PtrSize = 4 ? 20:24, "ptr")
xy := Buffer(4)
NumPut("uint", lParam, xy)
x := NumGet(xy, 0, "short")
y := NumGet(xy, 2, "short")
(x < 0) && x := 0
(x >= width) && x := width-1
(y < 0) && y := 0
(y >= height) && y := height-1
c := Format("0x{:08X}", NumGet(pBits + 4*(y*width + x), "uint"))
background_color := RegExReplace(c, "^0x..(..)(..)(..)$", "0x$3$2$1")
text_color := (0.3*(255&c>>16) + 0.59*(255&c>>8) + 0.11*(255&c)) >= 128 ? 0x000000 : 0xFFFFFF
tt := Tooltip(" (" x ", " y ") `n " SubStr(c, 3) " ",,, 16)
DllCall("UxTheme\SetWindowTheme", "ptr", tt, "ptr", 0, "ptr", Buffer(2, 0), "hresult")
DllCall("SendMessage", "ptr", tt, "uint", 1043, "ptr", background_color, "ptr", 0)
DllCall("SendMessage", "ptr", tt, "uint", 1044, "ptr", text_color, "ptr", 0)
SetTimer Reset_Tooltip, -7000
return
Reset_Tooltip() {
Tooltip(,,, 16)
}
}
if (uMsg = 0x020A) {
uMsg := 0x8003
Sleep 100
}
if (uMsg = 0x8003) {
wBuf := Buffer(4)
NumPut("uint", wParam, wBuf)
keystate := NumGet(wBuf, 0, "short")
wheeldelta := NumGet(wBuf, 2, "short")
xy := Buffer(4)
NumPut("uint", lParam, xy)
x := NumGet(xy, 0, "short")
y := NumGet(xy, 2, "short")
sdc := DllCall("GetWindowLong", "ptr", child, "int", 2*A_PtrSize, "ptr")
sbm := DllCall("GetCurrentObject", "ptr", sdc, "uint", 7)
dib := Buffer(64+5*A_PtrSize)
DllCall("GetObject", "ptr", sbm, "int", dib.size, "ptr", dib)
, width  := NumGet(dib, 4, "uint")
, height := NumGet(dib, 8, "uint")
, pBits  := NumGet(dib, A_PtrSize = 4 ? 20:24, "ptr")
scale := obj.scale
(wheeldelta > 1) ? scale++ : scale--
(scale < 1) && scale := 1
(scale > obj.scales.length) && scale := obj.scales.length
if (parent != child)
if obj.scales[scale] < 1
for i, _scale in obj.scales
if (_scale = 1)
scale := i
if (scale = obj.scale)
return
obj.scale := scale
s := obj.scales[scale]
x := Ceil(x * s) - x
y := Ceil(y * s) - y
w := Ceil(width * s)
h := Ceil(height * s)
hdc := DllCall("CreateCompatibleDC", "ptr", 0, "ptr")
bi := Buffer(40, 0)
NumPut(  "uint",        40, bi,  0)
NumPut(   "int",         w, bi,  4)
NumPut(   "int",        -h, bi,  8)
NumPut("ushort",         1, bi, 12)
NumPut("ushort",        32, bi, 14)
hbm := DllCall("CreateDIBSection", "ptr", hdc, "ptr", bi, "uint", 0, "ptr*", &pBits:=0, "ptr", 0, "uint", 0, "ptr")
obm := DllCall("SelectObject", "ptr", hdc, "ptr", hbm, "ptr")
DllCall("SetStretchBltMode", "ptr", hdc, "int", 3)
DllCall("StretchBlt", "ptr", hdc, "int", 0, "int", 0, "int", w, "int", h, "ptr", sdc, "int", 0, "int", 0, "int", width, "int", height, "uint", 0xCC0020)
pptDst := Buffer(8, 0)
NumPut("int", x, pptDst, 0)
NumPut("int", y, pptDst, 4)
DllCall("UpdateLayeredWindow"
,    "ptr", child
,    "ptr", 0
,    "ptr", 0
,"uint64*", w | h << 32
,    "ptr", hdc
, "int64*", 0
,   "uint", 0
,  "uint*", 0xFF << 16 | 0x01 << 24
,   "uint", 2)
DllCall("SelectObject", "ptr", hdc, "ptr", obm, "ptr")
DllCall("DeleteObject", "ptr", hbm)
DllCall("DeleteDC", "ptr", hdc)
}
if (uMsg = 0x8000) {
Critical
if !ptr
return
type := obj.type
w := obj.w
h := obj.h
frame := obj.frame
number := obj.number
accumulate := obj.accumulate
delays := obj.delays
interval := obj.interval
pTimeProc := obj.pTimeProc
dimIDs := obj.dimIDs
obj.HasProp("pBitmap") && pBitmap := obj.pBitmap
obj.HasProp("pBits") && pBits := obj.pBits
obj.HasProp("cache") && cache := obj.cache
}
if (uMsg = 0x8000 && wParam == 0) {
index := mod(frame + 1, number)
delay := delays[index]
if (type = "gif") {
delay *= 10
delay := max(delay, 10)
(delay == 10) && delay := 100
}
accumulate += interval
obj.accumulate := accumulate
if (accumulate == delay)
wParam := 1
}
if (uMsg = 0x8000 && wParam != 0) {
frame := mod(mod(frame + wParam, number) + number, number)
obj.frame := frame
obj.accumulate := 0
if not obj.HasProp("cache") {
DllCall("gdiplus\GdipImageSelectActiveFrame", "ptr", pBitmap, "ptr", dimIDs, "uint", frame)
DllCall("gdiplus\GdipGetImageWidth", "ptr", pBitmap, "uint*", &width:=0)
DllCall("gdiplus\GdipGetImageHeight", "ptr", pBitmap, "uint*", &height:=0)
Rect := Buffer(16, 0)
NumPut(  "uint",   width, Rect,  8)
NumPut(  "uint",  height, Rect, 12)
BitmapData := Buffer(16+2*A_PtrSize, 0)
NumPut(   "int",  4 * width, BitmapData,  8)
NumPut(   "ptr",      pBits, BitmapData, 16)
DllCall("gdiplus\GdipBitmapLockBits"
,    "ptr", pBitmap
,    "ptr", Rect
,   "uint", 5
,    "int", 0xE200B
,    "ptr", BitmapData)
DllCall("gdiplus\GdipBitmapUnlockBits", "ptr", pBitmap, "ptr", BitmapData)
hdc := DllCall("GetWindowLong", "ptr", child, "int", 2*A_PtrSize, "ptr")
}
else {
hdc := cache[frame]
DllCall("SetWindowLong", "ptr", child, "int", 2*A_PtrSize, "ptr", hdc)
}
DllCall("UpdateLayeredWindow"
,    "ptr", child
,    "ptr", 0
,    "ptr", 0
,"uint64*", w | h << 32
,    "ptr", hdc
, "int64*", 0
,   "uint", 0
,  "uint*", 0xFF << 16 | 0x01 << 24
,   "uint", 2)
}
if (uMsg = 0x8001 || uMsg = 0x8002) {
if (wParam) {
obj.frame := 0
obj.accumulate := 0
}
}
if (uMsg = 0x8001) {
if timer := DllCall("GetWindowLong", "ptr", child, "int", 4*A_PtrSize, "ptr")
return
if obj.HasProp("pTimeProc") {
timer := DllCall("winmm\timeSetEvent"
, "uint", obj.interval
, "uint", obj.interval
,  "ptr", obj.pTimeProc
, "uptr", 0
, "uint", 1
, "uint")
DllCall("SetWindowLong", "ptr", child, "int", 4*A_PtrSize, "ptr", timer)
}
}
if (uMsg = 0x8002) {
if (timer := DllCall("GetWindowLong", "ptr", child, "int", 4*A_PtrSize, "ptr")) {
DllCall("winmm\timeKillEvent", "uint", timer)
DllCall("SetWindowLong", "ptr", child, "int", 4*A_PtrSize, "ptr", 0)
}
}
default:
return DllCall("DefWindowProc", "ptr", hwnd, "uint", uMsg, "uptr", wParam, "ptr", lParam, "ptr")
}
}
static SyncWindowProc(hwnd, uMsg, wParam := 0, lParam := 0) {
hModule := DllCall("GetModuleHandle", "str", "user32.dll", "ptr")
SendMessageW := DllCall("GetProcAddress", "ptr", hModule, "astr", "SendMessageW", "ptr")
pcb := DllCall("GlobalAlloc", "uint", 0, "uptr", 71, "ptr")
DllCall("VirtualProtect", "ptr", pcb, "ptr", 71, "uint", 0x40, "uint*", 0)
if (A_PtrSize = 8) {
assembly := "
            ( Join`s Comments
            48 89 4c 24 08                 ; mov [rsp+8], rcx
            48 89 54 24 10                 ; mov [rsp+16], rdx
            4c 89 44 24 18                 ; mov [rsp+24], r8
            4c 89 4c 24 20                 ; mov [rsp+32], r9
            48 83 ec 28                    ; sub rsp, 40
            49 b9 00 00 00 00 00 00 00 00  ; mov r9, .. (lParam)
            49 b8 00 00 00 00 00 00 00 00  ; mov r8, .. (wParam)
            ba 00 00 00 00                 ; mov edx, .. (uMsg)
            b9 00 00 00 00                 ; mov ecx, .. (hwnd)
            48 b8 00 00 00 00 00 00 00 00  ; mov rax, .. (SendMessageW)
            ff d0                          ; call rax
            48 83 c4 28                    ; add rsp, 40
            c3                             ; ret
)"
DllCall("crypt32\CryptStringToBinary", "str", assembly, "uint", 0, "uint", 0x4, "ptr", pcb, "uint*", 71, "ptr", 0, "ptr", 0)
NumPut("ptr", SendMessageW, pcb + 56)
NumPut("int", hwnd, pcb + 50)
NumPut("int", uMsg, pcb + 45)
NumPut("ptr", wParam, pcb + 36)
NumPut("ptr", lParam, pcb + 26)
}
else {
assembly := "
            ( Join`s Comments
            68 00 00 00 00                 ; push .. (lParam)
            68 00 00 00 00                 ; push .. (wParam)
            68 00 00 00 00                 ; push .. (uMsg)
            68 00 00 00 00                 ; push .. (hwnd)
            b8 00 00 00 00                 ; mov eax, &SendMessageW
            ff d0                          ; call eax
            c3                             ; ret
)"
DllCall("crypt32\CryptStringToBinary", "str", assembly, "uint", 0, "uint", 0x4, "ptr", pcb, "uint*", 28, "ptr", 0, "ptr", 0)
NumPut("int", SendMessageW, pcb + 21)
NumPut("int", hwnd, pcb + 16)
NumPut("int", uMsg, pcb + 11)
NumPut("int", wParam, pcb + 6)
NumPut("int", lParam, pcb + 1)
}
return pcb
}
static BitmapToDesktop(pBitmap) {
DllCall("gdiplus\GdipGetImageWidth", "ptr", pBitmap, "uint*", &width:=0)
DllCall("gdiplus\GdipGetImageHeight", "ptr", pBitmap, "uint*", &height:=0)
hdc := DllCall("CreateCompatibleDC", "ptr", 0, "ptr")
hbm := this.BitmapToHBitmap(pBitmap)
obm := DllCall("SelectObject", "ptr", hdc, "ptr", hbm, "ptr")
DllCall("SendMessage", "ptr", WinExist("ahk_class Progman"), "uint", 0x052C, "ptr", 0x0000000D, "ptr", 0)
DllCall("SendMessage", "ptr", WinExist("ahk_class Progman"), "uint", 0x052C, "ptr", 0x0000000D, "ptr", 1)
windows := WinGetList("ahk_class WorkerW")
loop windows.length
hwnd := windows[A_Index]
until DllCall("FindWindowEx", "ptr", hwnd, "ptr", 0, "str", "SHELLDLL_DefView", "ptr", 0)
if !(WorkerW := DllCall("FindWindowEx", "ptr", 0, "ptr", hwnd, "str", "WorkerW", "ptr", 0, "ptr"))
throw Error("Could not locate hidden window behind desktop.")
DllCall("SetWindowPos", "ptr", WorkerW, "ptr", 1
, "int", Round((A_ScreenWidth - width) / 2)
, "int", Round((A_ScreenHeight - height) / 2)
, "int", width, "int", height, "uint", 0)
ddc := DllCall("GetDCEx", "ptr", WorkerW, "ptr", 0, "int", 0x403, "ptr")
DllCall("gdi32\BitBlt"
, "ptr", ddc, "int", 0, "int", 0, "int", width, "int", height
, "ptr", hdc, "int", 0, "int", 0, "uint", 0x00CC0020)
DllCall("ReleaseDC", "ptr", 0, "ptr", ddc)
DllCall("SelectObject", "ptr", hdc, "ptr", obm)
DllCall("DeleteObject", "ptr", hbm)
DllCall("DeleteDC",     "ptr", hdc)
return "desktop"
}
static BitmapToWallpaper(pBitmap) {
filepath := this.BitmapToFile(pBitmap)
length := DllCall("GetFullPathName", "str", filepath, "uint", 0, "ptr", 0, "ptr", 0, "uint")
VarSetStrCapacity(&buf, length)
DllCall("GetFullPathName", "str", filepath, "uint", length, "str", buf, "ptr", 0, "uint")
loop
if FileExist(filepath)
break
else
if A_Index < 6
Sleep (2**(A_Index-1) * 30)
else throw Error("Unable to create temporary image file.")
DllCall("SystemParametersInfo", "uint", SPI_SETDESKWALLPAPER := 0x14, "uint", 0, "str", buf, "uint", 2)
DeleteFile := DllCall.Bind("DeleteFile", "str", filepath)
SetTimer DeleteFile, -2000
return "wallpaper"
}
static BitmapToCursor(pBitmap, xHotspot := "", yHotspot := "") {
DllCall("gdiplus\GdipCreateHICONFromBitmap", "ptr", pBitmap, "ptr*", &hIcon:=0)
if (xHotspot ~= "^\d+$" || yHotspot ~= "^\d+$") {
ii := Buffer(8+3*A_PtrSize)
DllCall("GetIconInfo", "ptr", hIcon, "ptr", ii)
NumPut("uint", False, ii, 0)
(xHotspot ~= "^\d+$") && NumPut("uint", xHotspot, ii, 4)
(yHotspot ~= "^\d+$") && NumPut("uint", yHotspot, ii, 8)
DllCall("DestroyIcon", "ptr", hIcon)
hIcon := DllCall("CreateIconIndirect", "ptr", ii, "ptr")
DllCall("DeleteObject", "ptr", NumGet(ii, 8+A_PtrSize, "ptr"))
DllCall("DeleteObject", "ptr", NumGet(ii, 8+2*A_PtrSize, "ptr"))
}
Loop Parse, "32512,32513,32514,32515,32516,32631,32642,32643,32644,32645,32646,32648,32649,32650,32651,32671,32672", ","
if hCursor := DllCall("CopyImage", "ptr", hIcon, "uint", 2, "int", 0, "int", 0, "uint", 0, "ptr")
if !DllCall("SetSystemCursor", "ptr", hCursor, "int", A_LoopField)
DllCall("DestroyCursor", "ptr", hCursor)
DllCall("DestroyIcon", "ptr", hIcon)
return "A_Cursor"
}
static BitmapToExplorer(pBitmap, default := "") {
if (hwnd := WinExist("ahk_class ExploreWClass")) || (hwnd := WinExist("ahk_class CabinetWClass")) {
tab := this.GetCurrentExplorerTab(hwnd)
if tab {
switch Type(tab.Document) {
case "ShellFolderView":
directory := tab.Document.Folder.Self.Path
default:
directory := tab.LocationURL
}
}
}
else if (default != "")
directory := default
else
return
return this.BitmapToFile(pBitmap, directory)
}
static StreamToExplorer(stream, default := "") {
if (hwnd := WinExist("ahk_class ExploreWClass")) || (hwnd := WinExist("ahk_class CabinetWClass")) {
tab := this.GetCurrentExplorerTab(hwnd)
if tab {
switch Type(tab.Document) {
case "ShellFolderView":
directory := tab.Document.Folder.Self.Path
default:
directory := tab.LocationURL
}
}
}
else if (default != "")
directory := default
else
return
return this.StreamToFile(stream, directory)
}
static GetCurrentExplorerTab(hwnd) {
activeTab := 0
try activeTab := ControlGetHwnd("ShellTabWindowClass1", hwnd)
catch
try activeTab := ControlGetHwnd("TabWindowClass1", hwnd)
for w in ComObject("Shell.Application").Windows {
if w.hwnd != hwnd
continue
if activeTab {
static IID_IShellBrowser := "{000214E2-0000-0000-C000-000000000046}"
shellBrowser := ComObjQuery(w, IID_IShellBrowser, IID_IShellBrowser)
ComCall(3, shellBrowser, "uint*", &thisTab := 0)
if thisTab != activeTab
continue
}
return w
}
return false
}
static BitmapToFile(pBitmap, filepath := "", quality := "") {
extension := "png"
this.select_filepath(&filepath, &extension)
this.select_codec(pBitmap, extension, quality, &pCodec, &ep)
loop
if !DllCall("gdiplus\GdipSaveImageToFile", "ptr", pBitmap, "wstr", filepath, "ptr", pCodec, "ptr", ep)
break
else
if A_Index < 6
Sleep (2**(A_Index-1) * 30)
else throw Error("Could not save file to disk.")
return filepath
}
static StreamToFile(stream, filepath := "") {
DllCall("shlwapi\IStream_Size", "ptr", stream, "uint64*", &size:=0, "hresult")
DllCall("shlwapi\IStream_Reset", "ptr", stream, "hresult")
size := min(size, 2048)
bin := Buffer(size)
DllCall("shlwapi\IStream_Read", "ptr", stream, "ptr", bin, "uint", size, "hresult")
DllCall("shlwapi\IStream_Reset", "ptr", stream, "hresult")
length := 2*size + (size-1) + 1
VarSetStrCapacity(&str, length)
flags := 0x40000004
DllCall("crypt32\CryptBinaryToString", "ptr", bin, "uint", size, "uint", flags, "str", str, "uint*", &length)
extension := 0                                                              ? ""
: str ~= "(?i)66 74 79 70 61 76 69 66"                                      ? "avif"
: str ~= "(?i)^42 4d (.. ){36}00 00 .. 00 00 00"                            ? "bmp"
: str ~= "(?i)^01 00 00 00 (.. ){36}20 45 4D 46"                            ? "emf"
: str ~= "(?i)^47 49 46 38 (37|39) 61"                                      ? "gif"
: str ~= "(?i)66 74 79 70 68 65 69 63"                                      ? "heic"
: str ~= "(?i)^00 00 01 00"                                                 ? "ico"
: str ~= "(?i)^ff d8 ff"                                                    ? "jpg"
: str ~= "(?i)^25 50 44 46 2d"                                              ? "pdf"
: str ~= "(?i)^89 50 4e 47 0d 0a 1a 0a"                                     ? "png"
: str ~= "(?i)^(((?!3c|3e).. )|3c (3f|21) ((?!3c|3e).. )*3e )*+3c 73 76 67" ? "svg"
: str ~= "(?i)^(49 49 2a 00|4d 4d 00 2a)"                                   ? "tif"
: str ~= "(?i)^52 49 46 46 .. .. .. .. 57 45 42 50"                         ? "webp"
: str ~= "(?i)^d7 cd c6 9a"                                                 ? "wmf"
: ""
this.select_filepath(&filepath, &extension)
DllCall("shlwapi\SHCreateStreamOnFileEx"
,   "wstr", filepath
,   "uint", 0x1001
,   "uint", 0x80
,    "int", True
,    "ptr", 0
,   "ptr*", &FileStream:=0
,"hresult")
DllCall("shlwapi\IStream_Size", "ptr", stream, "uint64*", &size:=0, "hresult")
DllCall("shlwapi\IStream_Copy", "ptr", stream, "ptr", FileStream, "uint", size, "hresult")
DllCall("shlwapi\IStream_Reset", "ptr", stream, "hresult")
ObjRelease(FileStream)
return filepath
}
static BitmapToHex(pBitmap, extension := "", quality := "") {
stream := this.BitmapToStream(pBitmap, extension, quality)
DllCall("ole32\GetHGlobalFromStream", "ptr", stream, "ptr*", &hbin:=0, "hresult")
bin := DllCall("GlobalLock", "ptr", hbin, "ptr")
size := DllCall("GlobalSize", "ptr", hbin, "uptr")
length := 2 * size
str := Buffer(length)
static code := 0
if !code {
b64 := (A_PtrSize == 4)
? "VYnlVotFDIt1EFOLTRSLXQgBxjnwcyCKEIPBAkDA6gQPttKKFBOIUf6KUP+D4g+KFBOIUf/r3FteXcM="
: "SQHQTDnCcyWKAkmDwQJI/8LA6AQPtsCKBAFBiEH+ikL/g+APigQBQYhB/+vWww=="
s64 := StrLen(RTrim(b64, "=")) * 3 // 4
code := DllCall("GlobalAlloc", "uint", 0, "uptr", s64, "ptr")
DllCall("crypt32\CryptStringToBinary", "str", b64, "uint", 0, "uint", 0x1, "ptr", code, "uint*", s64, "ptr", 0, "ptr", 0)
DllCall("VirtualProtect", "ptr", code, "ptr", s64, "uint", 0x40, "uint*", 0)
}
hex := Buffer(16)
StrPut("0123456789abcdef", hex, "CP0")
DllCall(code, "ptr", hex, "ptr", bin, "uptr", size, "ptr", str, "uptr", length, "cdecl")
DllCall("GlobalUnlock", "ptr", hbin)
ObjRelease(stream)
return StrGet(str, length, "CP0")
}
static StreamToHex(stream) {
DllCall("shlwapi\IStream_Size", "ptr", stream, "uint64*", &size:=0, "hresult")
DllCall("shlwapi\IStream_Reset", "ptr", stream, "hresult")
DllCall("shlwapi\IStream_Read", "ptr", stream, "ptr", bin := Buffer(size), "uint", size, "hresult")
DllCall("shlwapi\IStream_Reset", "ptr", stream, "hresult")
length := 2 * size
str := Buffer(length)
static code := 0
if !code {
b64 := (A_PtrSize == 4)
? "VYnlVotFDIt1EFOLTRSLXQgBxjnwcyCKEIPBAkDA6gQPttKKFBOIUf6KUP+D4g+KFBOIUf/r3FteXcM="
: "SQHQTDnCcyWKAkmDwQJI/8LA6AQPtsCKBAFBiEH+ikL/g+APigQBQYhB/+vWww=="
s64 := StrLen(RTrim(b64, "=")) * 3 // 4
code := DllCall("GlobalAlloc", "uint", 0, "uptr", s64, "ptr")
DllCall("crypt32\CryptStringToBinary", "str", b64, "uint", 0, "uint", 0x1, "ptr", code, "uint*", s64, "ptr", 0, "ptr", 0)
DllCall("VirtualProtect", "ptr", code, "ptr", s64, "uint", 0x40, "uint*", 0)
}
hex := Buffer(16)
StrPut("0123456789abcdef", hex, "CP0")
DllCall(code, "ptr", hex, "ptr", bin, "uptr", size, "ptr", str, "uptr", length, "cdecl")
return StrGet(str, length, "CP0")
}
static BitmapToBase64(pBitmap, extension := "", quality := "") {
stream := this.BitmapToStream(pBitmap, extension, quality)
DllCall("ole32\GetHGlobalFromStream", "ptr", stream, "ptr*", &handle:=0, "hresult")
bin := DllCall("GlobalLock", "ptr", handle, "ptr")
size := DllCall("GlobalSize", "ptr", handle, "uptr")
length := 4 * Ceil(size / 3) + 1
VarSetStrCapacity(&str, length)
flags := 0x40000001
DllCall("crypt32\CryptBinaryToString", "ptr", bin, "uint", size, "uint", flags, "str", str, "uint*", &length)
DllCall("GlobalUnlock", "ptr", handle)
ObjRelease(stream)
return str
}
static StreamToBase64(stream) {
DllCall("shlwapi\IStream_Size", "ptr", stream, "uint64*", &size:=0, "hresult")
DllCall("shlwapi\IStream_Reset", "ptr", stream, "hresult")
DllCall("shlwapi\IStream_Read", "ptr", stream, "ptr", bin := Buffer(size), "uint", size, "hresult")
DllCall("shlwapi\IStream_Reset", "ptr", stream, "hresult")
length := 4 * Ceil(size / 3) + 1
VarSetStrCapacity(&str, length)
flags := 0x40000001
DllCall("crypt32\CryptBinaryToString", "ptr", bin, "uint", size, "uint", flags, "str", str, "uint*", &length)
return str
}
static BitmapToUri(pBitmap, extension := "", quality := "") {
extension := RegExReplace(extension, "^(\*?\.)?")
extension :=  extension ~= "^(avif|avifs)$"           ? "avif"
: extension ~= "^(bmp|dib|rle)$"          ? "bmp"
: extension ~= "^(gif)$"                  ? "gif"
: extension ~= "^(heic|heif|hif)$"        ? "heic"
: extension ~= "^(jpg|jpeg|jpe|jfif)$"    ? "jpeg"
: extension ~= "^(png)$"                  ? "png"
: extension ~= "^(tif|tiff)$"             ? "tiff"
: "png"
return "data:image/" extension ";base64," this.BitmapToBase64(pBitmap, extension, quality)
}
static StreamToUri(stream) {
DllCall("shlwapi\IStream_Size", "ptr", stream, "uint64*", &size:=0, "hresult")
DllCall("shlwapi\IStream_Reset", "ptr", stream, "hresult")
size := min(size, 2048)
bin := Buffer(size)
DllCall("shlwapi\IStream_Read", "ptr", stream, "ptr", bin, "uint", size, "hresult")
DllCall("shlwapi\IStream_Reset", "ptr", stream, "hresult")
length := 2*size + (size-1) + 1
VarSetStrCapacity(&str, length)
flags := 0x40000004
DllCall("crypt32\CryptBinaryToString", "ptr", bin, "uint", size, "uint", flags, "str", str, "uint*", &length)
mime := 0                                                                   ? ""
: str ~= "(?i)66 74 79 70 61 76 69 66"                                      ? "image/avif"
: str ~= "(?i)^42 4d (.. ){36}00 00 .. 00 00 00"                            ? "image/bmp"
: str ~= "(?i)^01 00 00 00 (.. ){36}20 45 4D 46"                            ? "image/emf"
: str ~= "(?i)^47 49 46 38 (37|39) 61"                                      ? "image/gif"
: str ~= "(?i)66 74 79 70 68 65 69 63"                                      ? "image/heic"
: str ~= "(?i)^00 00 01 00"                                                 ? "image/x-icon"
: str ~= "(?i)^ff d8 ff"                                                    ? "image/jpeg"
: str ~= "(?i)^25 50 44 46 2d"                                              ? "application/pdf"
: str ~= "(?i)^89 50 4e 47 0d 0a 1a 0a"                                     ? "image/png"
: str ~= "(?i)^(((?!3c|3e).. )|3c (3f|21) ((?!3c|3e).. )*3e )*+3c 73 76 67" ? "image/svg+xml"
: str ~= "(?i)^(49 49 2a 00|4d 4d 00 2a)"                                   ? "image/tiff"
: str ~= "(?i)^52 49 46 46 .. .. .. .. 57 45 42 50"                         ? "image/webp"
: str ~= "(?i)^d7 cd c6 9a"                                                 ? "image/wmf"
: ""
if (mime == "") {
DllCall("urlmon\FindMimeFromData"
,    "ptr", 0
,    "ptr", 0
,    "ptr", bin
,   "uint", size
,    "ptr", 0
,   "uint", 0x20
,   "ptr*", &MimeOut:=0
,   "uint", 0
,"hresult")
mime := StrGet(MimeOut, "UTF-16")
DllCall("ole32\CoTaskMemFree", "ptr", MimeOut)
}
return "data:" mime ";base64," this.StreamToBase64(stream)
}
static BitmapToDC(pBitmap, alpha := "") {
if (alpha != "") {
DllCall("gdiplus\GdipCreateHBITMAPFromBitmap", "ptr", pBitmap, "ptr*", &hbm:=0, "uint", alpha)
return hbm
}
DllCall("gdiplus\GdipGetImageWidth", "ptr", pBitmap, "uint*", &width:=0)
DllCall("gdiplus\GdipGetImageHeight", "ptr", pBitmap, "uint*", &height:=0)
hdc := DllCall("CreateCompatibleDC", "ptr", 0, "ptr")
bi := Buffer(40, 0)
NumPut(  "uint",        40, bi,  0)
NumPut(   "int",     width, bi,  4)
NumPut(   "int",   -height, bi,  8)
NumPut("ushort",         1, bi, 12)
NumPut("ushort",        32, bi, 14)
hbm := DllCall("CreateDIBSection", "ptr", hdc, "ptr", bi, "uint", 0, "ptr*", &pBits:=0, "ptr", 0, "uint", 0, "ptr")
obm := DllCall("SelectObject", "ptr", hdc, "ptr", hbm, "ptr")
Rect := Buffer(16, 0)
NumPut(  "uint",   width, Rect,  8)
NumPut(  "uint",  height, Rect, 12)
BitmapData := Buffer(16+2*A_PtrSize, 0)
NumPut(   "int",  4 * width, BitmapData,  8)
NumPut(   "ptr",      pBits, BitmapData, 16)
DllCall("gdiplus\GdipBitmapLockBits"
,    "ptr", pBitmap
,    "ptr", Rect
,   "uint", 5
,    "int", 0xE200B
,    "ptr", BitmapData)
DllCall("gdiplus\GdipBitmapUnlockBits", "ptr", pBitmap, "ptr", BitmapData)
return hdc
}
static BitmapToHBitmap(pBitmap, alpha := "") {
if (alpha != "") {
DllCall("gdiplus\GdipCreateHBITMAPFromBitmap", "ptr", pBitmap, "ptr*", &hbm:=0, "uint", alpha)
return hbm
}
DllCall("gdiplus\GdipGetImageWidth", "ptr", pBitmap, "uint*", &width:=0)
DllCall("gdiplus\GdipGetImageHeight", "ptr", pBitmap, "uint*", &height:=0)
hdc := DllCall("CreateCompatibleDC", "ptr", 0, "ptr")
bi := Buffer(40, 0)
NumPut(  "uint",        40, bi,  0)
NumPut(   "int",     width, bi,  4)
NumPut(   "int",   -height, bi,  8)
NumPut("ushort",         1, bi, 12)
NumPut("ushort",        32, bi, 14)
hbm := DllCall("CreateDIBSection", "ptr", hdc, "ptr", bi, "uint", 0, "ptr*", &pBits:=0, "ptr", 0, "uint", 0, "ptr")
obm := DllCall("SelectObject", "ptr", hdc, "ptr", hbm, "ptr")
Rect := Buffer(16, 0)
NumPut(  "uint",   width, Rect,  8)
NumPut(  "uint",  height, Rect, 12)
BitmapData := Buffer(16+2*A_PtrSize, 0)
NumPut(   "int",  4 * width, BitmapData,  8)
NumPut(   "ptr",      pBits, BitmapData, 16)
DllCall("gdiplus\GdipBitmapLockBits"
,    "ptr", pBitmap
,    "ptr", Rect
,   "uint", 5
,    "int", 0xE200B
,    "ptr", BitmapData)
DllCall("gdiplus\GdipBitmapUnlockBits", "ptr", pBitmap, "ptr", BitmapData)
DllCall("SelectObject", "ptr", hdc, "ptr", obm)
DllCall("DeleteDC",     "ptr", hdc)
return hbm
}
static BitmapToHIcon(pBitmap) {
DllCall("gdiplus\GdipCreateHICONFromBitmap", "ptr", pBitmap, "ptr*", &hIcon:=0)
return hIcon
}
static BitmapToStream(pBitmap, extension := "", quality := "") {
this.select_codec(pBitmap, extension, quality, &pCodec, &ep)
DllCall("ole32\CreateStreamOnHGlobal", "ptr", 0, "int", True, "ptr*", &stream:=0, "hresult")
DllCall("gdiplus\GdipSaveImageToStream", "ptr", pBitmap, "ptr", stream, "ptr", pCodec, "ptr", ep)
return stream
}
static BitmapToRandomAccessStream(pBitmap, extension := "", quality := "") {
stream := this.BitmapToStream(pBitmap, extension, quality)
IRandomAccessStream := this.StreamToRandomAccessStream(stream)
ObjRelease(stream)
return IRandomAccessStream
}
static StreamToRandomAccessStream(stream) {
IID_IRandomAccessStream := Buffer(16)
DllCall("ole32\IIDFromString", "wstr", "{905A0FE1-BC53-11DF-8C49-001E4FC686DA}", "ptr", IID_IRandomAccessStream , "hresult")
DllCall("shcore\CreateRandomAccessStreamOverStream", "ptr", stream, "uint", 1, "ptr", IID_IRandomAccessStream, "ptr*", &IRandomAccessStream:=0, "hresult")
return IRandomAccessStream
}
static BitmapToWicBitmap(pBitmap) {
DllCall("gdiplus\GdipGetImageWidth", "ptr", pBitmap, "uint*", &width:=0)
DllCall("gdiplus\GdipGetImageHeight", "ptr", pBitmap, "uint*", &height:=0)
IWICImagingFactory := ComObject("{CACAF262-9370-4615-A13B-9F5539DA4C0A}", "{EC5EC8A9-C395-4314-9C77-54D7A935FF70}")
GUID_WICPixelFormat32bppBGRA := Buffer(16)
DllCall("ole32\CLSIDFromString", "wstr", "{6fddc324-4e03-4bfe-b185-3d77768dc90f}", "ptr", GUID_WICPixelFormat32bppBGRA, "hresult")
ComCall(CreateBitmap := 17, IWICImagingFactory, "uint", width, "uint", height, "ptr", GUID_WICPixelFormat32bppBGRA, "int", 1, "ptr*", &wicbitmap:=0)
Rect := Buffer(16, 0)
NumPut(  "uint",   width, Rect,  8)
NumPut(  "uint",  height, Rect, 12)
ComCall(Lock := 8, wicbitmap, "ptr", Rect, "uint", 0x1, "ptr*", &IWICBitmapLock:=0)
ComCall(GetDataPointer := 5, IWICBitmapLock, "uint*", &size:=0, "ptr*", &Scan0:=0)
BitmapData := Buffer(16+2*A_PtrSize, 0)
NumPut(   "int",  4 * width, BitmapData,  8)
NumPut(   "ptr",      Scan0, BitmapData, 16)
DllCall("gdiplus\GdipBitmapLockBits"
,    "ptr", pBitmap
,    "ptr", Rect
,   "uint", 5
,    "int", 0x26200A
,    "ptr", BitmapData)
DllCall("gdiplus\GdipBitmapUnlockBits", "ptr", pBitmap, "ptr", BitmapData)
ObjRelease(IWICBitmapLock)
IWICImagingFactory := ""
return wicbitmap
}
static StreamToSafeArray(stream) {
DllCall("shlwapi\IStream_Size", "ptr", stream, "uint64*", &size:=0, "hresult")
safearray := ComObjArray(0x11, size)
pvData := NumGet(ComObjValue(safearray), 8 + A_PtrSize, "ptr")
DllCall("shlwapi\IStream_Reset", "ptr", stream, "hresult")
DllCall("shlwapi\IStream_Read", "ptr", stream, "ptr", pvData, "uint", size, "hresult")
DllCall("shlwapi\IStream_Reset", "ptr", stream, "hresult")
return safearray
}
static BitmapToSafeArray(pBitmap, extension := "", quality := "") {
handle := DllCall("GlobalAlloc", "uint", 0x2, "uptr", 0, "ptr")
DllCall("ole32\CreateStreamOnHGlobal", "ptr", handle, "int", True, "ptr*", &stream:=0, "hresult")
this.select_codec(pBitmap, extension, quality, &pCodec, &ep)
DllCall("gdiplus\GdipSaveImageToStream", "ptr", pBitmap, "ptr", stream, "ptr", pCodec, "ptr", ep)
ptr := DllCall("GlobalLock", "ptr", handle, "ptr")
size := DllCall("GlobalSize", "ptr", handle, "uptr")
safearray := ComObjArray(0x11, size)
pvData := NumGet(ComObjValue(safearray), 8 + A_PtrSize, "ptr")
DllCall("RtlMoveMemory", "ptr", pvData, "ptr", ptr, "uptr", size)
DllCall("GlobalUnlock", "ptr", handle)
ObjRelease(stream)
return safearray
}
static ParseWebp(stream, &pDelays, &pCount) {
DllCall("shlwapi\IStream_Size", "ptr", stream, "uint64*", &end:=0, "hresult")
fourcc := Buffer(4)
offset := 0
current := 0
StrPut("VP8X", VP8X := Buffer(4), "cp1252")
ComCall(Seek := 5, stream, "uint64", 12, "uint", 0, "uint64*", &current)
DllCall("shlwapi\IStream_Read", "ptr", stream, "ptr", fourcc, "uint", 4, "hresult")
DllCall("shlwapi\IStream_Read", "ptr", stream, "uint*", &offset, "uint", 4, "hresult")
if (4 != DllCall("ntdll\RtlCompareMemory", "ptr", fourcc, "ptr", VP8X, "uptr", 4, "uptr"))
return
DllCall("shlwapi\IStream_Read", "ptr", stream, "uchar*", &flags:=0, "uint", 1, "hresult")
if not flags & 0x2
return
StrPut("ANIM", ANIM := Buffer(4), "cp1252")
ComCall(Seek := 5, stream, "uint64", offset - 1, "uint", 1, "uint64*", &current)
DllCall("shlwapi\IStream_Read", "ptr", stream, "ptr", fourcc, "uint", 4, "hresult")
DllCall("shlwapi\IStream_Read", "ptr", stream, "uint*", &offset, "uint", 4, "hresult")
if (4 != DllCall("ntdll\RtlCompareMemory", "ptr", fourcc, "ptr", ANIM, "uptr", 4, "uptr"))
return
pCount := DllCall("GlobalAlloc", "uint", 0, "uptr", 8 + 3*A_PtrSize, "ptr")
NumPut(   "uint",    0x5101, pCount + 0)
NumPut(   "uint",         1, pCount + 4)
NumPut( "ushort",         3, pCount + 8)
NumPut(    "ptr", pCount + 8 + 2*A_PtrSize, pCount + 8 + A_PtrSize)
ComCall(Seek := 5, stream, "uint64", 4, "uint", 1, "uint64*", &current)
DllCall("shlwapi\IStream_Read", "ptr", stream, "ushort*", pCount + 8 + 2*A_PtrSize, "uint", 2, "hresult")
ComCall(Seek := 5, stream, "uint64", offset - 6, "uint", 1, "uint64*", &current)
StrPut("ANMF", ANMF := Buffer(4), "cp1252")
hDelays := DllCall("GlobalAlloc", "uint", 0x42, "uptr", 8 + 2*A_PtrSize, "ptr")
pDelays := DllCall("GlobalLock", "ptr", hDelays, "ptr")
NumPut(   "uint",    0x5100, pDelays + 0)
NumPut( "ushort",    0xCAFE, pDelays + 8)
DllCall("GlobalUnlock", "ptr", hDelays)
DllCall("ole32\CreateStreamOnHGlobal", "ptr", hDelays, "int", False, "ptr*", &sDelays:=0, "hresult")
ComCall(Seek := 5, sDelays, "uint64", 0, "uint", 2, "ptr", 0)
while current < end {
DllCall("shlwapi\IStream_Read", "ptr", stream, "ptr", fourcc, "uint", 4, "hresult")
DllCall("shlwapi\IStream_Read", "ptr", stream, "uint*", &offset, "uint", 4, "hresult")
alignment := offset&1
if (4 == DllCall("ntdll\RtlCompareMemory", "ptr", fourcc, "ptr", ANMF, "uptr", 4, "uptr")) {
ComCall(Seek := 5, stream, "uint64", 12, "uint", 1, "uint64*", &current)
DllCall("shlwapi\IStream_Copy", "ptr", stream, "ptr", sDelays, "uint", 3, "hresult")
DllCall("shlwapi\IStream_Write", "ptr", sDelays, "uchar*", 0, "uint", 1, "hresult")
offset -= 15
}
ComCall(Seek := 5, stream, "uint64", offset + alignment, "uint", 1, "uint64*", &current)
}
ObjRelease(sDelays)
nDelays := DllCall("GlobalSize", "ptr", hDelays, "uptr") - 8 - 2*A_PtrSize
pDelays := DllCall("GlobalLock", "ptr", hDelays, "ptr")
NumPut(   "uint", nDelays, pDelays + 4)
NumPut(    "ptr", pDelays + 8 + 2*A_PtrSize, pDelays + 8 + A_PtrSize)
}
static RenderPdf(&IStreamIn, index := "") {
(index == "") && index := 1
IID_IRandomAccessStream := Buffer(16)
DllCall("ole32\IIDFromString", "wstr", "{905A0FE1-BC53-11DF-8C49-001E4FC686DA}", "ptr", IID_IRandomAccessStream, "hresult")
DllCall("shcore\CreateRandomAccessStreamOverStream", "ptr", IStreamIn, "uint", 1, "ptr", IID_IRandomAccessStream, "ptr*", &IRandomAccessStreamIn:=0, "hresult")
IID_IPdfDocumentStatics := Buffer(16)
DllCall("ole32\IIDFromString", "wstr", "{433A0B5F-C007-4788-90F2-08143D922599}", "ptr", IID_IPdfDocumentStatics, "hresult")
DllCall("combase\WindowsCreateString", "wstr", "Windows.Data.Pdf.PdfDocument", "uint", 28, "ptr*", &hString:=0, "hresult")
DllCall("combase\RoGetActivationFactory", "ptr", hString, "ptr", IID_IPdfDocumentStatics, "ptr*", &PdfDocumentStatics:=0, "hresult")
DllCall("combase\WindowsDeleteString", "ptr", hString, "hresult")
ComCall(LoadFromStreamAsync := 8, PdfDocumentStatics, "ptr", IRandomAccessStreamIn, "ptr*", &PdfDocument:=0)
this.WaitForAsync(&PdfDocument)
ComCall(get_PageCount := 7, PdfDocument, "uint*", &count:=0)
index := (index > 0) ? index - 1 : (index < 0) ? count + index : 0
if (index < 0 || index > count) {
ObjRelease(PdfDocument)
ObjRelease(PdfDocumentStatics)
this.ObjReleaseClose(&IRandomAccessStreamIn)
ObjRelease(IStreamIn)
throw Error("The maximum number of pages in this pdf is " count ".")
}
ComCall(GetPage := 6, PdfDocument, "uint", index, "ptr*", &PdfPage:=0)
DllCall("ole32\CreateStreamOnHGlobal", "ptr", 0, "uint", True, "ptr*", &IStreamOut:=0)
DllCall("shcore\CreateRandomAccessStreamOverStream", "ptr", IStreamOut, "uint", BSOS_DEFAULT := 0, "ptr", IID_IRandomAccessStream, "ptr*", &IRandomAccessStreamOut:=0)
ComCall(RenderToStreamAsync := 6, PdfPage, "ptr", IRandomAccessStreamOut, "ptr*", &AsyncInfo:=0)
this.WaitForAsync(&AsyncInfo)
this.ObjReleaseClose(&IRandomAccessStreamOut)
this.ObjReleaseClose(&PdfPage)
ObjRelease(PdfDocument)
ObjRelease(PdfDocumentStatics)
this.ObjReleaseClose(&IRandomAccessStreamIn)
ObjRelease(IStreamIn)
DllCall("shlwapi\IStream_Reset", "ptr", IStreamOut, "hresult")
return IStreamIn := IStreamOut
}
static WaitForAsync(&Object) {
AsyncInfo := ComObjQuery(Object, IAsyncInfo := "{00000036-0000-0000-C000-000000000046}")
while !ComCall(_Status := 7, AsyncInfo, "uint*", &status:=0)
and (status = 0)
Sleep 10
if (status != 1) {
ComCall(_ErrorCode := 8, AsyncInfo, "uint*", &ErrorCode:=0)
throw Error("AsyncInfo status error: " ErrorCode)
}
ComCall(GetResults := 8, Object, "ptr*", &ObjectResult:=0, "cdecl")
ObjRelease(Object)
Object := ObjectResult
ComCall(Close := 10, AsyncInfo)
AsyncInfo := ""
}
static ObjReleaseClose(&Object) {
if Object {
if (Close := ComObjQuery(Object, IClosable := "{30D5A829-7FA4-4026-83BB-D75BAE4EA99E}")) {
ComCall(_Close := 6, Close)
Close := ""
}
try return ObjRelease(Object)
finally Object := ""
}
}
static RenderSvg(&IStream, width, height) {
IWICImagingFactory := ComObject("{CACAF262-9370-4615-A13B-9F5539DA4C0A}", "{EC5EC8A9-C395-4314-9C77-54D7A935FF70}")
GUID_WICPixelFormat32bppPBGRA := Buffer(16)
DllCall("ole32\CLSIDFromString", "wstr", "{6fddc324-4e03-4bfe-b185-3d77768dc910}", "ptr", GUID_WICPixelFormat32bppPBGRA, "hresult")
ComCall(CreateBitmap := 17, IWICImagingFactory, "uint", width, "uint", height, "ptr", GUID_WICPixelFormat32bppPBGRA, "int", 2, "ptr*", &IWICBitmap:=0)
IID_ID2D1Factory:=Buffer(16)
DllCall("ole32\IIDFromString", "wstr", "{06152247-6f50-465a-9245-118bfd3b6007}", "ptr", IID_ID2D1Factory, "hresult")
DllCall("GetModuleHandleA",  "AStr",  "d2d1") || DllCall("LoadLibraryA",  "AStr",  "d2d1")
DllCall("d2d1\D2D1CreateFactory", "Int", 0, "ptr", IID_ID2D1Factory, "ptr", 0, "ptr*", &ID2D1Factory:=0)
D2D1_RENDER_TARGET_PROPERTIES:=Buffer(0x1c, 0)
ComCall(CreateWicBitmapRenderTarget := 13, ID2D1Factory, "ptr", IWICBitmap, "ptr", D2D1_RENDER_TARGET_PROPERTIES, "ptr*", &ID2D1RenderTarget:=0)
D2D1_SIZE_F:=Buffer(8)
NumPut("float", width, D2D1_SIZE_F, 0x0)
NumPut("float", height, D2D1_SIZE_F, 0x4)
ComCall(115, ID2D1RenderTarget, "ptr", IStream, "uint64", NumGet(D2D1_SIZE_F, "uint64"), "ptr*", &ID2D1SvgDocument:=0)
ComCall(BeginDraw := 48, ID2D1RenderTarget, "char")
ComCall(DrawSvgDocument := 116, ID2D1RenderTarget, "ptr", ID2D1SvgDocument, "char")
ComCall(EndDraw := 49, ID2D1RenderTarget, "ptr", 0, "ptr", 0)
static pData
cbStride:=4*width
pData:=Buffer(cbStride * height)
ComCall(7, IWICBitmap, "ptr", 0, "uint", cbStride, "uint", pData.Size, "ptr", pData)
ObjRelease(IStream)
DllCall("gdiplus\GdipCreateBitmapFromScan0", "uint", width, "uint", height, "Int", cbStride, "uint", 0xE200B, "ptr", pData, "ptr*", &pBitmap:=0)
return pBitmap
}
static select_codec(pBitmap, extension, quality, &pCodec, &ep) {
extension := RegExReplace(extension, "^(\*?\.)?")
extension :=  extension ~= "^(avif|avifs)$"           ? "avif"
: extension ~= "^(bmp|dib|rle)$"          ? "bmp"
: extension ~= "^(gif)$"                  ? "gif"
: extension ~= "^(heic|heif|hif)$"        ? "heic"
: extension ~= "^(jpg|jpeg|jpe|jfif)$"    ? "jpeg"
: extension ~= "^(png)$"                  ? "png"
: extension ~= "^(tif|tiff)$"             ? "tiff"
: "png"
pCodec := Buffer(16)
switch extension {
case "avif": MsgBox("AVIF is not supported by GDI+.")
case "bmp":  DllCall("ole32\CLSIDFromString", "wstr", "{557CF400-1A04-11D3-9A73-0000F81EF32E}", "ptr", pCodec, "hresult")
case "gif":  DllCall("ole32\CLSIDFromString", "wstr", "{557CF402-1A04-11D3-9A73-0000F81EF32E}", "ptr", pCodec, "hresult")
case "heic": DllCall("ole32\CLSIDFromString", "wstr", "{557CF408-1A04-11D3-9A73-0000F81EF32E}", "ptr", pCodec, "hresult")
case "jpeg": DllCall("ole32\CLSIDFromString", "wstr", "{557CF401-1A04-11D3-9A73-0000F81EF32E}", "ptr", pCodec, "hresult")
case "png":  DllCall("ole32\CLSIDFromString", "wstr", "{557CF406-1A04-11D3-9A73-0000F81EF32E}", "ptr", pCodec, "hresult")
case "tiff": DllCall("ole32\CLSIDFromString", "wstr", "{557CF405-1A04-11D3-9A73-0000F81EF32E}", "ptr", pCodec, "hresult")
}
ep := 0
if (extension = "jpeg") && (quality ~= "^\d+$") {
ep := Buffer(24+2*A_PtrSize + 4)
offset := ep.ptr + 24+2*A_PtrSize
NumPut(  "uptr",       1, ep,              0)
DllCall("ole32\CLSIDFromString", "wstr", "{1D5BE4B5-FA4A-452D-9CDD-5DB35105E7EB}", "ptr", ep.ptr+A_PtrSize, "hresult")
NumPut(  "uint",       1, ep,   16+A_PtrSize)
NumPut(  "uint",       4, ep,   20+A_PtrSize)
NumPut(   "ptr",  offset, ep,   24+A_PtrSize)
NumPut(  "uint", quality, ep, 24+2*A_PtrSize)
}
}
static select_filepath(&filepath, &extension) {
default := extension
filepath := RegExReplace(filepath, "/", "\")
filepath := RegExReplace(filepath, "[*?\x22<>|\x00-\x1F]")
SplitPath filepath,, &directory, &extension, &filename
if DirExist(filepath)
directory := (directory != "")
? ((filename != "")
? directory "\" filename
: directory)
: (filepath ~= "^\\")
? "\" filename
: ".\" filename
, filename := ""
if (directory != "" && !DirExist(directory))
DirCreate(directory)
(directory == "") && directory := "."
outputs := "^(?i:avif|avifs|bmp|dib|rle|gif|heic|heif|hif|jpg|jpeg|jpe|jfif|png|tif|tiff)$"
if (extension == "" && filename ~= outputs)
extension := filename, filename := ""
if !(extension ~= outputs) {
if (extension != "")
filename .= "." extension
extension := default
}
if (filename == "") {
colon := Chr(0xA789)
filename := FormatTime(, "yyyy-MM-dd HH" colon "mm" colon "ss")
filepath := directory "\" filename "." extension
while FileExist(filepath)
filepath := directory "\" filename " (" A_Index ")." extension
}
else if (filename == "0" or filename == "1") {
filepath := directory "\" filename "." extension
while FileExist(filepath)
filepath := directory "\" A_Index "." extension
}
else filepath := directory "\" filename "." extension
}
static gdiplusStartup() {
return this.gdiplus(1)
}
static gdiplusShutdown(cotype := "") {
return this.gdiplus(-1, cotype)
}
static gdiplus(vary := 0, cotype := "") {
static pToken := 0
static instances := 0
if not IsSet(pToken) || not IsSet(instances)
return
if (instances = 0 && vary = 1) {
DllCall("LoadLibrary", "str", "gdiplus")
si := Buffer(A_PtrSize = 4 ? 20:32, 0)
NumPut("uint", 0x2, si)
NumPut("uint", 0x4, si, A_PtrSize = 4 ? 16:24)
DllCall("gdiplus\GdiplusStartup", "ptr*", &pToken:=0, "ptr", si, "ptr", 0)
}
if (instances = 1 && vary = -1) {
DllCall("gdiplus\GdiplusShutdown", "ptr", pToken)
DllCall("FreeLibrary", "ptr", DllCall("GetModuleHandle", "str", "gdiplus", "ptr"))
if (cotype = "bitmap") {
assert := (18 != DllCall("gdiplus\GdipCreateImageAttributes", "ptr*", &ImageAttr:=0))
DllCall("gdiplus\GdipDisposeImageAttributes", "ptr", ImageAttr)
if not assert
throw Error("Bitmap is out of scope. `n`nIf you wish to handle raw pointers to GDI+ bitmaps, add the line"
. "`n`n`t`t" this.prototype.__class ".gdiplusStartup()"
. "`n`nto the top of your script. If using Gdip_All.ahk use pToken := Gdip_Startup()."
. "`nAlternatively, use pic := ImagePutBuffer(image) and pic.pBitmap instead."
. "`nYou can copy this message by pressing Ctrl + C.", -4)
}
}
instances += vary
if (instances < 0)
throw Error("Missing gdiplusStartup().")
return instances
}
static Dimensions(image) {
this.gdiplusStartup()
try type := this.DontVerifyImageType(&image)
catch
type := this.ImageType(image)
pBitmap := this.ImageToBitmap(type, image)
DllCall("gdiplus\GdipGetImageWidth", "ptr", pBitmap, "uint*", &width:=0)
DllCall("gdiplus\GdipGetImageHeight", "ptr", pBitmap, "uint*", &height:=0)
DllCall("gdiplus\GdipDisposeImage", "ptr", pBitmap)
this.gdiplusShutdown()
return [width, height]
}
class Destroy extends ImagePut {
static call(image) {
this.gdiplusStartup()
try type := this.DontVerifyImageType(&image)
catch
type := this.ImageType(image)
this.Destroy(type, image)
this.gdiplusShutdown()
return
}
static Destroy(type, image) {
switch type {
case "clipboard":
if !DllCall("OpenClipboard", "ptr", A_ScriptHwnd)
throw Error("Clipboard could not be opened.")
DllCall("EmptyClipboard")
DllCall("CloseClipboard")
case "screenshot":
DllCall("InvalidateRect", "ptr", 0, "ptr", 0, "int", 0)
case "window":
image := WinExist(image)
DllCall("DestroyWindow", "ptr", image)
case "wallpaper":
DllCall("SystemParametersInfo", "uint", SPI_SETDESKWALLPAPER := 0x14, "uint", 0, "ptr", 0, "uint", 2)
case "cursor":
DllCall("SystemParametersInfo", "uint", SPI_SETCURSORS := 0x57, "uint", 0, "ptr", 0, "uint", 0)
case "file":
FileDelete image
case "dc":
if (DllCall("GetObjectType", "ptr", image, "uint") == 3) {
hwnd := DllCall("WindowFromDC", "ptr", image, "ptr")
DllCall("ReleaseDC", "ptr", hwnd, "ptr", image)
}
if (DllCall("GetObjectType", "ptr", image, "uint") == 10) {
obm := DllCall("CreateBitmap", "int", 0, "int", 0, "uint", 1, "uint", 1, "ptr", 0, "ptr")
hbm := DllCall("SelectObject", "ptr", image, "ptr", obm, "ptr")
DllCall("DeleteObject", "ptr", hbm)
DllCall("DeleteDC", "ptr", image)
}
case "hBitmap":
DllCall("DeleteObject", "ptr", image)
case "hIcon":
DllCall("DestroyIcon", "ptr", image)
case "bitmap":
DllCall("gdiplus\GdipDisposeImage", "ptr", image)
case "RandomAccessStream", "stream", "wicBitmap":
ObjRelease(image)
}
}
}
}
class ImageEqual extends ImagePut {
static call(images*) {
if (images.length == 0)
return False
this.gdiplusStartup()
image := images[1]
try type := this.DontVerifyImageType(&image)
catch
type := this.ImageType(image)
if !(pBitmap1 := this.ImageToBitmap(type, image))
throw Error("Conversion to bitmap failed. The pointer value is zero.")
if (images.length == 1) {
if DllCall("gdiplus\GdipCloneImage", "ptr", pBitmap1, "ptr*", &pBitmapClone:=0)
throw Error("Validation failed. Unable to access and clone the bitmap.")
DllCall("gdiplus\GdipDisposeImage", "ptr", pBitmapClone)
goto Good_Ending
}
for image in images {
if (A_Index != 1) {
try type := this.DontVerifyImageType(&image)
catch
type := this.ImageType(image)
pBitmap2 := this.ImageToBitmap(type, image)
if !this.BitmapEqual(pBitmap1, pBitmap2)
goto Bad_Ending
DllCall("gdiplus\GdipDisposeImage", "ptr", pBitmap2)
}
}
Good_Ending:
DllCall("gdiplus\GdipDisposeImage", "ptr", pBitmap1)
this.gdiplusShutdown()
return True
Bad_Ending:
DllCall("gdiplus\GdipDisposeImage", "ptr", pBitmap2)
DllCall("gdiplus\GdipDisposeImage", "ptr", pBitmap1)
this.gdiplusShutdown()
return False
}
static BitmapEqual(SourceBitmap1, SourceBitmap2, PixelFormat := 0x26200A) {
DllCall("gdiplus\GdipGetImageType", "ptr", SourceBitmap1, "ptr*", &type1:=0)
DllCall("gdiplus\GdipGetImageType", "ptr", SourceBitmap2, "ptr*", &type2:=0)
if (type1 != 1 || type2 != 1)
throw Error("The GDI+ pointer is not a bitmap.")
if (SourceBitmap1 == SourceBitmap2)
return True
DllCall("gdiplus\GdipGetImageWidth", "ptr", SourceBitmap1, "uint*", &width1:=0)
DllCall("gdiplus\GdipGetImageWidth", "ptr", SourceBitmap2, "uint*", &width2:=0)
DllCall("gdiplus\GdipGetImageHeight", "ptr", SourceBitmap1, "uint*", &height1:=0)
DllCall("gdiplus\GdipGetImageHeight", "ptr", SourceBitmap2, "uint*", &height2:=0)
DllCall("gdiplus\GdipGetImagePixelFormat", "ptr", SourceBitmap1, "int*", &format1:=0)
DllCall("gdiplus\GdipGetImagePixelFormat", "ptr", SourceBitmap2, "int*", &format2:=0)
if !(width1 && width2 && height1 && height2)
throw Error("Get bitmap width and height failed.")
if (width1 != width2 || height1 != height2)
return False
pBitmap1 := pBitmap2 := 0
loop 2
if DllCall("gdiplus\GdipCloneImage", "ptr", SourceBitmap%A_Index%, "ptr*", &pBitmap%A_Index%)
throw Error("Cloning Bitmap" A_Index " failed.")
DllCall("gdiplus\GdipGetImagePixelFormat", "ptr", pBitmap1, "int*", &format3:=0)
if (format1 != format3)
throw Error("Report this error to the developer.")
Rect := Buffer(16, 0)
NumPut(  "uint",   width1, Rect,  8)
NumPut(  "uint",  height1, Rect, 12)
BitmapData1 := Buffer(16+2*A_PtrSize)
BitmapData2 := Buffer(16+2*A_PtrSize)
loop 2
DllCall("gdiplus\GdipBitmapLockBits"
,    "ptr", pBitmap%A_Index%
,    "ptr", Rect
,   "uint", 1
,    "int", PixelFormat
,    "ptr", BitmapData%A_Index%)
stride1 := NumGet(BitmapData1, 8, "int")
stride2 := NumGet(BitmapData2, 8, "int")
Scan01 := NumGet(BitmapData1, 16, "ptr")
Scan02 := NumGet(BitmapData2, 16, "ptr")
size := stride1 * height1
byte := DllCall("ntdll\RtlCompareMemory", "ptr", Scan01, "ptr", Scan02, "uptr", size, "uptr")
DllCall("gdiplus\GdipBitmapUnlockBits", "ptr", pBitmap1, "ptr", BitmapData1)
DllCall("gdiplus\GdipBitmapUnlockBits", "ptr", pBitmap2, "ptr", BitmapData2)
DllCall("gdiplus\GdipDisposeImage", "ptr", pBitmap1)
DllCall("gdiplus\GdipDisposeImage", "ptr", pBitmap2)
return (byte == size) ? True : False
}
}
if (A_Args.length > 0 and A_LineFile == A_ScriptFullPath)
{
WinSetTitle WinGetTitle(A_ScriptHwnd) . A_ScriptHwnd, A_ScriptHwnd
filepath := ""
for each, arg in A_Args {
filepath .= arg . A_Space
if FileExist(Trim(filepath)) {
SplitPath filepath, &filename
ImageShow({file: filepath}, filename)
filepath := ""
}
}
}
class ImagePainter {
__New() {
this.bgColor := "010101"
this.window := ""
this.windowVisible := false
this.margin := { x: 0, y: 0 }
this.current := { image: "", name: "", x: "", y: "", w: 0, h: 0 }
this.prev := { image: "", name: "", x: "", y: "", w: 0, h: 0 }
}
Clear() {
this.current := { image: "", name: "", x: "", y: "", w: 0, h: 0 }
}
ClearAll() {
this.Clear()
this.prev := { image: "", name: "", x: "", y: "", w: 0, h: 0 }
}
StorePrev() {
this.prev := this.current.Clone()
}
Paint() {
if !this._hasValidState()
return
imageChanged := this._hasImageChanged()
if this._canSkipRepaint(imageChanged)
return
if (this.window != "" and imageChanged)
this.RemoveWindow()
if !this._loadDimensions(imageChanged)
return
if !this._ensureWindow()
return
this._showAtPosition()
}
RemoveWindow() {
if this.window != "" {
this.window.Destroy()
this.window := ""
this.windowVisible := false
}
}
HideWindow() {
if this.window != "" {
this.window.Hide()
this.windowVisible := false
}
}
_hasValidState() {
if (this.current.image == "" or !this.current.image)
return false
if (this.current.x == "" or this.current.y == "")
return false
return true
}
_hasImageChanged() {
if (this.current.name != this.prev.name or this.current.image != this.prev.image)
return true
if (this.current.image != "" and FileExist(this.current.image)) {
modTime := FileGetTime(this.current.image)
if (this.current.HasOwnProp("modTime") and this.current.modTime != modTime) {
this.current.modTime := modTime
return true
}
this.current.modTime := modTime
}
return false
}
_canSkipRepaint(imageChanged) {
if (this.window == "" or !this.windowVisible)
return false
return (this.current.x == this.prev.x and
this.current.y == this.prev.y and
!imageChanged)
}
_loadDimensions(imageChanged) {
if (!imageChanged and this.current.w > 0 and this.current.h > 0)
return true
try {
if (FileExist(this.current.image) && RegExMatch(this.current.image, "i)\.png$")) {
raw := FileRead(this.current.image, "RAW")
if (raw.Size < 24)
throw Error("Invalid badge PNG")
this.current.w := (NumGet(raw, 16, "UChar") << 24) | (NumGet(raw, 17, "UChar") << 16) | (NumGet(raw, 18, "UChar") << 8) | NumGet(raw, 19, "UChar")
this.current.h := (NumGet(raw, 20, "UChar") << 24) | (NumGet(raw, 21, "UChar") << 16) | (NumGet(raw, 22, "UChar") << 8) | NumGet(raw, 23, "UChar")
} else {
this.current.w := ImageWidth(this.current.image)
this.current.h := ImageHeight(this.current.image)
}
return true
} catch as err {
this.lastError := "dimensions: " err.Message
this.Clear()
return false
}
}
_ensureWindow() {
if this.window != ""
return true
try {
this._initWindow()
return true
} catch as err {
this.lastError := "window: " err.Message
this.window := ""
this.Clear()
return false
}
}
_initWindow() {
if (this.window != "")
this.window.Destroy()
sizeConstraints := " +MinSize" this.current.w "x" this.current.h
. " +MaxSize" this.current.w "x" this.current.h
this.window := Gui("+LastFound -Caption +AlwaysOnTop +ToolWindow -Border -DPIScale -Resize" sizeConstraints)
this.window.MarginX := 0
this.window.MarginY := 0
this.window.Title := "Language Indicator badge"
this.window.BackColor := this.bgColor
WinSetTransColor(this.bgColor, this.window)
if (FileExist(this.current.image) && RegExMatch(this.current.image, "i)\.png$")) {
this.window.Add("Picture", "x0 y0 w" this.current.w " h" this.current.h, this.current.image)
} else {
display := this.window.Add("Text", "xm+0")
display.move(, , this.current.w, this.current.h)
windowStyles := WS_CHILD | WS_VISIBLE | WS_EX_LAYERED
ImageShow(this.current.image, , [0, 0], windowStyles, , display.hwnd)
}
}
_showAtPosition() {
halfHeight := Floor(this.current.h / 2)
posX := this.current.x + this.margin.x
posY := this.current.y - halfHeight + this.margin.y
this.window.Show("X" posX " Y" posY " AutoSize NA")
this.windowVisible := true
}
}
WS_CHILD := 0x40000000
WS_VISIBLE := 0x10000000
WS_EX_LAYERED := 0x8000000
#requires AutoHotkey v2.0
#requires AutoHotkey v2.0
class Jsons {
static Load(&src, args*) {
key := "", is_key := false
stack := [tree := []]
next := '"{[01234567890-tfn'
pos := 0
while ((ch := SubStr(src, ++pos, 1)) != "") {
if InStr(" `t`n`r", ch)
continue
if !InStr(next, ch, true) {
testArr := StrSplit(SubStr(src, 1, pos), "`n")
ln := testArr.Length
col := pos - InStr(src, "`n", , -(StrLen(src) - pos + 1))
msg := Format("{}: line {} col {} (char {})"
, (next == "") ? ["Extra data", ch := SubStr(src, pos)][1]
: (next == "'") ? "Unterminated string starting at"
: (next == "\") ? "Invalid \escape"
: (next == ":") ? "Expecting ':' delimiter"
: (next == '"') ? "Expecting object key enclosed in double quotes"
: (next == '"}') ? "Expecting object key enclosed in double quotes or object closing '}'"
: (next == ",}") ? "Expecting ',' delimiter or object closing '}'"
: (next == ",]") ? "Expecting ',' delimiter or array closing ']'"
: ["Expecting JSON value(string, number, [true, false, null], object or array)"
, ch := SubStr(src, pos, (SubStr(src, pos) ~= "[\]\},\s]|$") - 1)][1]
, ln, col, pos)
throw Error(msg, -1, ch)
}
obj := stack[1]
is_array := (obj is Array)
if i := InStr("{[", ch) {
val := (i = 1) ? Map() : Array()
is_array ? obj.Push(val) : obj[key] := val
stack.InsertAt(1, val)
next := '"' ((is_key := (ch == "{")) ? "}" : "{[]0123456789-tfn")
} else if InStr("}]", ch) {
stack.RemoveAt(1)
next := (stack[1] == tree) ? "" : (stack[1] is Array) ? ",]" : ",}"
} else if InStr(",:", ch) {
is_key := (!is_array && ch == ",")
next := is_key ? '"' : '"{[0123456789-tfn'
} else {
if (ch == '"') {
i := pos
while i := InStr(src, '"', , i + 1) {
val := StrReplace(SubStr(src, pos + 1, i - pos - 1), "\\", "\u005C")
if (SubStr(val, -1) != "\")
break
}
if !i ? (pos--, next := "'") : 0
continue
pos := i
val := StrReplace(val, "\/", "/")
val := StrReplace(val, '\"', '"')
, val := StrReplace(val, "\b", "`b")
, val := StrReplace(val, "\f", "`f")
, val := StrReplace(val, "\n", "`n")
, val := StrReplace(val, "\r", "`r")
, val := StrReplace(val, "\t", "`t")
i := 0
while i := InStr(val, "\", , i + 1) {
if (SubStr(val, i + 1, 1) != "u") ? (pos -= StrLen(SubStr(val, i)), next := "\") : 0
continue 2
xxxx := Abs("0x" . SubStr(val, i + 2, 4))
if (xxxx < 0x100)
val := SubStr(val, 1, i - 1) . Chr(xxxx) . SubStr(val, i + 6)
}
if is_key {
key := val, next := ":"
continue
}
} else {
val := SubStr(src, pos, i := RegExMatch(src, "[\]\},\s]|$", , pos) - pos)
if IsInteger(val)
val += 0
else if IsFloat(val)
val += 0
else if (val == "true" || val == "false")
val := (val == "true")
else if (val == "null")
val := ""
else if is_key {
pos--, next := "#"
continue
}
pos += i - 1
}
is_array ? obj.Push(val) : obj[key] := val
next := obj == tree ? "" : is_array ? ",]" : ",}"
}
}
return tree[1]
}
static Dump(obj, indent := "", lvl := 1) {
if IsObject(obj) {
if obj.__Class = "Object" {
obj := Jsons.ConvertObjectToMap(obj)
} else if not (obj is Array || obj is Map || obj is String || obj is Number) && obj.__Class != "BoundaryFunc"  {
obj := Jsons.ConvertObjectToMap(obj)
}
If !(obj is Array || obj is Map || obj is String || obj is Number)
throw Error("Object type not supported.", -1, Format("<Object at 0x{:p}>", ObjPtr(obj)))
if IsInteger(indent)
{
if (indent < 0)
throw Error("Indent parameter must be a postive integer.", -1, indent)
spaces := indent, indent := ""
Loop spaces
indent .= " "
}
indt := ""
Loop indent ? lvl : 0
indt .= indent
is_array := (obj is Array)
lvl += 1, out := ""
for k, v in obj {
if !is_array
out .= (ObjGetCapacity([k]) ? Jsons.Dump(k) : escape_str(k)) (indent ? ": " : ":")
out .= Jsons.Dump(v, indent, lvl)
. (indent ? ",`n" . indt : ",")
}
if (out != "") {
out := Trim(out, ",`n" . indent)
if (indent != "")
out := "`n" . indt . out . "`n" . SubStr(indt, StrLen(indent) + 1)
}
return is_array ? "[" . out . "]" : "{" . out . "}"
} Else If (obj is Number)
return obj
Else
return escape_str(obj)
escape_str(obj) {
obj := StrReplace(obj, "\", "\\")
obj := StrReplace(obj, "`t", "\t")
obj := StrReplace(obj, "`r", "\r")
obj := StrReplace(obj, "`n", "\n")
obj := StrReplace(obj, "`b", "\b")
obj := StrReplace(obj, "`f", "\f")
obj := StrReplace(obj, "/", "\/")
obj := StrReplace(obj, '"', '\"')
return '"' obj '"'
}
}
static ConvertObjectToMap(InputObject) {
if IsObject(InputObject) {
if InputObject.__Class = "Map" {
return InputObject
}
else {
return Jsons.convertObj(InputObject)
}
}
else {
return InputObject
}
}
static convertObj(obj) {
convertedObject := Map()
for k, v in obj.OwnProps() {
if v.base.__Class != "BoundFunc" {
convertedObject.Set(k, v)
}
}
return convertedObject
}
}
Log(val, x := 400, y := 200, t := -1000) {
CoordMode("ToolTip", "Screen")
if (Type(val) == "String") {
ToolTip(val, x, y)
} else {
ToolTip(Jsons.Dump(val, 2), x, y)
}
SetTimer () => ToolTip(), t
}
if !IsSet(ttstt)
global ttstt := { counter: 1 }
ttcfg := {
initPos: { x: 200, y: 100 },
shift: 40
}
Logg(val, x := "", y := "", t := -1000) {
global ttstt
pos := { x: x, y: y }
if (x == "" and y == "") {
pos.x := ttcfg.initPos.x
pos.y := ttcfg.initPos.y + ttstt.counter * ttcfg.shift
}
if (Type(val) == "String") {
ToolTip(val, pos.x, pos.y, ttstt.counter)
} else {
ToolTip(Jsons.Dump(val, 2), pos.x, pos.y, ttstt.counter)
}
cc := ttstt.counter
ttstt.counter += 1
if (ttstt.counter > 20)
ttstt.counter := 1
SetTimer(() => ToolTip(, , , cc), t)
}
global base64images := Map(
"transparent", "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABAQMAAAAl21bKAAAAA1BMVEUAAACnej3aAAAAAXRSTlMAQObYZgAAAApJREFUCNdjYAAAAAIAAeIhvDMAAAAASUVORK5CYII=",
"arrow_white_9px", "iVBORw0KGgoAAAANSUhEUgAAAAkAAAAJCAYAAADgkQYQAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAA3ZpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDkuMS1jMDAyIDc5LmRiYTNkYTNiNSwgMjAyMy8xMi8xNS0xMDo0MjozNyAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wTU09Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iIHhtbG5zOnN0UmVmPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VSZWYjIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtcE1NOk9yaWdpbmFsRG9jdW1lbnRJRD0ieG1wLmRpZDo0Y2RhMzdhYy1jYjBlLTkzNDEtODA2Ni0yOGVmZDRmNDkwZTMiIHhtcE1NOkRvY3VtZW50SUQ9InhtcC5kaWQ6OUY5NkE3NjQyM0MxMTFFRjlDNzVFNDQ0NTQwRkI0RDQiIHhtcE1NOkluc3RhbmNlSUQ9InhtcC5paWQ6OUY5NkE3NjMyM0MxMTFFRjlDNzVFNDQ0NTQwRkI0RDQiIHhtcDpDcmVhdG9yVG9vbD0iQWRvYmUgUGhvdG9zaG9wIDI1LjYgKFdpbmRvd3MpIj4gPHhtcE1NOkRlcml2ZWRGcm9tIHN0UmVmOmluc3RhbmNlSUQ9InhtcC5paWQ6MzVlOWQ4NDktNzdmYy0xMDRkLWI0NWYtNmY4NzZkZGM0YTIyIiBzdFJlZjpkb2N1bWVudElEPSJ4bXAuZGlkOjRjZGEzN2FjLWNiMGUtOTM0MS04MDY2LTI4ZWZkNGY0OTBlMyIvPiA8L3JkZjpEZXNjcmlwdGlvbj4gPC9yZGY6UkRGPiA8L3g6eG1wbWV0YT4gPD94cGFja2V0IGVuZD0iciI/Pk6FwAYAAABVSURBVHjajI0BCsAwCAOT/rL9/z+cbs2oboUGghoPhZlBdnV3ND3lFbBnSOAHkFbwF6ggJ4CdSKJ5HdGE63Jmg7riQboYgM831XCgFXrf6o0WlwADAKgRYPvybfeRAAAAAElFTkSuQmCC",
"arrow_red_9px", "iVBORw0KGgoAAAANSUhEUgAAAAkAAAAJCAYAAADgkQYQAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAA3ZpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDkuMS1jMDAyIDc5LmRiYTNkYTNiNSwgMjAyMy8xMi8xNS0xMDo0MjozNyAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wTU09Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iIHhtbG5zOnN0UmVmPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VSZWYjIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtcE1NOk9yaWdpbmFsRG9jdW1lbnRJRD0ieG1wLmRpZDo0Y2RhMzdhYy1jYjBlLTkzNDEtODA2Ni0yOGVmZDRmNDkwZTMiIHhtcE1NOkRvY3VtZW50SUQ9InhtcC5kaWQ6OUZBQzFCRjEyM0MxMTFFRjlDNzVFNDQ0NTQwRkI0RDQiIHhtcE1NOkluc3RhbmNlSUQ9InhtcC5paWQ6OUZBOUI5QUEyM0MxMTFFRjlDNzVFNDQ0NTQwRkI0RDQiIHhtcDpDcmVhdG9yVG9vbD0iQWRvYmUgUGhvdG9zaG9wIDI1LjYgKFdpbmRvd3MpIj4gPHhtcE1NOkRlcml2ZWRGcm9tIHN0UmVmOmluc3RhbmNlSUQ9InhtcC5paWQ6MzVlOWQ4NDktNzdmYy0xMDRkLWI0NWYtNmY4NzZkZGM0YTIyIiBzdFJlZjpkb2N1bWVudElEPSJ4bXAuZGlkOjRjZGEzN2FjLWNiMGUtOTM0MS04MDY2LTI4ZWZkNGY0OTBlMyIvPiA8L3JkZjpEZXNjcmlwdGlvbj4gPC9yZGY6UkRGPiA8L3g6eG1wbWV0YT4gPD94cGFja2V0IGVuZD0iciI/PtG5M/EAAABDSURBVHjaYvz//z8DIcACIj4yMiKLgXTBBfiBhjChafqPRoMBExYFGHwmHApQFLJAOYxYFDNisw4nIEoRIzHhBBBgANMiEQopu/+SAAAAAElFTkSuQmCC",
"arrow_green_9px", "iVBORw0KGgoAAAANSUhEUgAAAAkAAAAJCAYAAADgkQYQAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAA3ZpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDkuMS1jMDAyIDc5LmRiYTNkYTNiNSwgMjAyMy8xMi8xNS0xMDo0MjozNyAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wTU09Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iIHhtbG5zOnN0UmVmPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VSZWYjIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtcE1NOk9yaWdpbmFsRG9jdW1lbnRJRD0ieG1wLmRpZDo0Y2RhMzdhYy1jYjBlLTkzNDEtODA2Ni0yOGVmZDRmNDkwZTMiIHhtcE1NOkRvY3VtZW50SUQ9InhtcC5kaWQ6MTlGMzhDQkEyM0MzMTFFRjk5RkM4ODM2ODc5NUY1QUEiIHhtcE1NOkluc3RhbmNlSUQ9InhtcC5paWQ6MTlGMzhDQjkyM0MzMTFFRjk5RkM4ODM2ODc5NUY1QUEiIHhtcDpDcmVhdG9yVG9vbD0iQWRvYmUgUGhvdG9zaG9wIDI1LjYgKFdpbmRvd3MpIj4gPHhtcE1NOkRlcml2ZWRGcm9tIHN0UmVmOmluc3RhbmNlSUQ9InhtcC5paWQ6MzVlOWQ4NDktNzdmYy0xMDRkLWI0NWYtNmY4NzZkZGM0YTIyIiBzdFJlZjpkb2N1bWVudElEPSJ4bXAuZGlkOjRjZGEzN2FjLWNiMGUtOTM0MS04MDY2LTI4ZWZkNGY0OTBlMyIvPiA8L3JkZjpEZXNjcmlwdGlvbj4gPC9yZGY6UkRGPiA8L3g6eG1wbWV0YT4gPD94cGFja2V0IGVuZD0iciI/PkHOFRQAAAA9SURBVHjaYvz//z8DIcCELsA4h/E/XkUwBegKmXCZgMxnwmUFisnIDkdW/D/lPyNOhxPlO6zWEhNOAAEGAGnYGFIcFGGPAAAAAElFTkSuQmCC",
"arrow_blue_9px", "iVBORw0KGgoAAAANSUhEUgAAAAkAAAAJCAYAAADgkQYQAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAA3ZpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDkuMS1jMDAyIDc5LmRiYTNkYTNiNSwgMjAyMy8xMi8xNS0xMDo0MjozNyAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wTU09Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iIHhtbG5zOnN0UmVmPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VSZWYjIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtcE1NOk9yaWdpbmFsRG9jdW1lbnRJRD0ieG1wLmRpZDo0Y2RhMzdhYy1jYjBlLTkzNDEtODA2Ni0yOGVmZDRmNDkwZTMiIHhtcE1NOkRvY3VtZW50SUQ9InhtcC5kaWQ6RjNEMzU0NUMyM0MyMTFFRjg1OEFCMDZDRjNFQTJGNkYiIHhtcE1NOkluc3RhbmNlSUQ9InhtcC5paWQ6RjNEMzU0NUIyM0MyMTFFRjg1OEFCMDZDRjNFQTJGNkYiIHhtcDpDcmVhdG9yVG9vbD0iQWRvYmUgUGhvdG9zaG9wIDI1LjYgKFdpbmRvd3MpIj4gPHhtcE1NOkRlcml2ZWRGcm9tIHN0UmVmOmluc3RhbmNlSUQ9InhtcC5paWQ6MzVlOWQ4NDktNzdmYy0xMDRkLWI0NWYtNmY4NzZkZGM0YTIyIiBzdFJlZjpkb2N1bWVudElEPSJ4bXAuZGlkOjRjZGEzN2FjLWNiMGUtOTM0MS04MDY2LTI4ZWZkNGY0OTBlMyIvPiA8L3JkZjpEZXNjcmlwdGlvbj4gPC9yZGY6UkRGPiA8L3g6eG1wbWV0YT4gPD94cGFja2V0IGVuZD0iciI/PgU9tU0AAABESURBVHjaYvz//z8DIcACIlTzUMRAuhhhnNuTGBiY0DT9R6PBgAmLAgw+Ew4FKApZoBxGLIoZsVmHExCliJGYcAIIMADDkxAKQ2rHlAAAAABJRU5ErkJggg==",
"arrow_white_12px", "iVBORw0KGgoAAAANSUhEUgAAAAwAAAAMCAYAAABWdVznAAAACXBIWXMAAAsTAAALEwEAmpwYAAAGmWlUWHRYTUw6Y29tLmFkb2JlLnhtcAAAAAAAPD94cGFja2V0IGJlZ2luPSLvu78iIGlkPSJXNU0wTXBDZWhpSHpyZVN6TlRjemtjOWQiPz4gPHg6eG1wbWV0YSB4bWxuczp4PSJhZG9iZTpuczptZXRhLyIgeDp4bXB0az0iQWRvYmUgWE1QIENvcmUgOS4xLWMwMDIgNzkuYTZhNjM5NiwgMjAyNC8wMy8xMi0wNzo0ODoyMyAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wTU09Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iIHhtbG5zOnN0UmVmPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VSZWYjIiB4bWxuczpzdEV2dD0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL3NUeXBlL1Jlc291cmNlRXZlbnQjIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtbG5zOmRjPSJodHRwOi8vcHVybC5vcmcvZGMvZWxlbWVudHMvMS4xLyIgeG1sbnM6cGhvdG9zaG9wPSJodHRwOi8vbnMuYWRvYmUuY29tL3Bob3Rvc2hvcC8xLjAvIiB4bXBNTTpPcmlnaW5hbERvY3VtZW50SUQ9InhtcC5kaWQ6NGNkYTM3YWMtY2IwZS05MzQxLTgwNjYtMjhlZmQ0ZjQ5MGUzIiB4bXBNTTpEb2N1bWVudElEPSJ4bXAuZGlkOjYyMTUwQkU5MjNDMzExRUZBREJFQjYyNkJBQUIzRTY1IiB4bXBNTTpJbnN0YW5jZUlEPSJ4bXAuaWlkOmIwYmRjOTBlLWE5OTgtZGM0Mi1hZTgxLWM5YTU4N2UxYzhjOSIgeG1wOkNyZWF0b3JUb29sPSJBZG9iZSBQaG90b3Nob3AgMjUuNiAoV2luZG93cykiIHhtcDpDcmVhdGVEYXRlPSIyMDI1LTAyLTI2VDEzOjM4OjA4LTA4OjAwIiB4bXA6TW9kaWZ5RGF0ZT0iMjAyNS0wMi0yNlQxNDowNjoxNi0wODowMCIgeG1wOk1ldGFkYXRhRGF0ZT0iMjAyNS0wMi0yNlQxNDowNjoxNi0wODowMCIgZGM6Zm9ybWF0PSJpbWFnZS9wbmciIHBob3Rvc2hvcDpDb2xvck1vZGU9IjMiPiA8eG1wTU06RGVyaXZlZEZyb20gc3RSZWY6aW5zdGFuY2VJRD0ieG1wLmlpZDozNWU5ZDg0OS03N2ZjLTEwNGQtYjQ1Zi02Zjg3NmRkYzRhMjIiIHN0UmVmOmRvY3VtZW50SUQ9InhtcC5kaWQ6NGNkYTM3YWMtY2IwZS05MzQxLTgwNjYtMjhlZmQ0ZjQ5MGUzIi8+IDx4bXBNTTpIaXN0b3J5PiA8cmRmOlNlcT4gPHJkZjpsaSBzdEV2dDphY3Rpb249InNhdmVkIiBzdEV2dDppbnN0YW5jZUlEPSJ4bXAuaWlkOjM4MTQzYzk2LTFiY2ItYjY0Ny1iZThlLWRkNjNjZDg3MmI5OSIgc3RFdnQ6d2hlbj0iMjAyNS0wMi0yNlQxMzo0MjozNC0wODowMCIgc3RFdnQ6c29mdHdhcmVBZ2VudD0iQWRvYmUgUGhvdG9zaG9wIDI1LjkgKFdpbmRvd3MpIiBzdEV2dDpjaGFuZ2VkPSIvIi8+IDxyZGY6bGkgc3RFdnQ6YWN0aW9uPSJzYXZlZCIgc3RFdnQ6aW5zdGFuY2VJRD0ieG1wLmlpZDpiMGJkYzkwZS1hOTk4LWRjNDItYWU4MS1jOWE1ODdlMWM4YzkiIHN0RXZ0OndoZW49IjIwMjUtMDItMjZUMTQ6MDY6MTYtMDg6MDAiIHN0RXZ0OnNvZnR3YXJlQWdlbnQ9IkFkb2JlIFBob3Rvc2hvcCAyNS45IChXaW5kb3dzKSIgc3RFdnQ6Y2hhbmdlZD0iLyIvPiA8L3JkZjpTZXE+IDwveG1wTU06SGlzdG9yeT4gPC9yZGY6RGVzY3JpcHRpb24+IDwvcmRmOlJERj4gPC94OnhtcG1ldGE+IDw/eHBhY2tldCBlbmQ9InIiPz5JvylbAAAAbklEQVQokaWSUQrAIAxDk+EZuzPmlNnH3LCd6McCQrEvUqO0jSqSBgDbrL02gyW9dTW1GRwRaS+ZbKOPZUmukuQb69wKnpm2cDUBQPTiOSVp7AEIjrH2C9bUUrzH5xE2+m04SWJcAM404uxrrHQBjd6r0ZaLwd8AAAAASUVORK5CYII=",
"arrow_red_12px", "iVBORw0KGgoAAAANSUhEUgAAAAwAAAAMCAYAAABWdVznAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAA3ZpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDkuMS1jMDAyIDc5LmRiYTNkYTNiNSwgMjAyMy8xMi8xNS0xMDo0MjozNyAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wTU09Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iIHhtbG5zOnN0UmVmPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VSZWYjIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtcE1NOk9yaWdpbmFsRG9jdW1lbnRJRD0ieG1wLmRpZDo0Y2RhMzdhYy1jYjBlLTkzNDEtODA2Ni0yOGVmZDRmNDkwZTMiIHhtcE1NOkRvY3VtZW50SUQ9InhtcC5kaWQ6OUZBNEY1MUEyM0MxMTFFRjlDNzVFNDQ0NTQwRkI0RDQiIHhtcE1NOkluc3RhbmNlSUQ9InhtcC5paWQ6OUZBNEY1MTkyM0MxMTFFRjlDNzVFNDQ0NTQwRkI0RDQiIHhtcDpDcmVhdG9yVG9vbD0iQWRvYmUgUGhvdG9zaG9wIDI1LjYgKFdpbmRvd3MpIj4gPHhtcE1NOkRlcml2ZWRGcm9tIHN0UmVmOmluc3RhbmNlSUQ9InhtcC5paWQ6MzVlOWQ4NDktNzdmYy0xMDRkLWI0NWYtNmY4NzZkZGM0YTIyIiBzdFJlZjpkb2N1bWVudElEPSJ4bXAuZGlkOjRjZGEzN2FjLWNiMGUtOTM0MS04MDY2LTI4ZWZkNGY0OTBlMyIvPiA8L3JkZjpEZXNjcmlwdGlvbj4gPC9yZGY6UkRGPiA8L3g6eG1wbWV0YT4gPD94cGFja2V0IGVuZD0iciI/PgJ+bhsAAABfSURBVHjaYvz//z8DKYAFRHxkZEQX3wSl/ZAF+YGGM2ExBKTYF4o3oUsy4VAMAxiamPAoxqqJiYBiDE2M6KEEDID/aB5lxOcHDAAKQeRQZGIgEZCsgZHUmCbZBoAAAwBSZRrtE2xryQAAAABJRU5ErkJggg==",
"arrow_green_12px", "iVBORw0KGgoAAAANSUhEUgAAAAwAAAAMCAYAAABWdVznAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAA3ZpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDkuMS1jMDAyIDc5LmRiYTNkYTNiNSwgMjAyMy8xMi8xNS0xMDo0MjozNyAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wTU09Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iIHhtbG5zOnN0UmVmPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VSZWYjIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtcE1NOk9yaWdpbmFsRG9jdW1lbnRJRD0ieG1wLmRpZDo0Y2RhMzdhYy1jYjBlLTkzNDEtODA2Ni0yOGVmZDRmNDkwZTMiIHhtcE1NOkRvY3VtZW50SUQ9InhtcC5kaWQ6MTlFRUM4MTgyM0MzMTFFRjk5RkM4ODM2ODc5NUY1QUEiIHhtcE1NOkluc3RhbmNlSUQ9InhtcC5paWQ6MTlFRUM4MTcyM0MzMTFFRjk5RkM4ODM2ODc5NUY1QUEiIHhtcDpDcmVhdG9yVG9vbD0iQWRvYmUgUGhvdG9zaG9wIDI1LjYgKFdpbmRvd3MpIj4gPHhtcE1NOkRlcml2ZWRGcm9tIHN0UmVmOmluc3RhbmNlSUQ9InhtcC5paWQ6MzVlOWQ4NDktNzdmYy0xMDRkLWI0NWYtNmY4NzZkZGM0YTIyIiBzdFJlZjpkb2N1bWVudElEPSJ4bXAuZGlkOjRjZGEzN2FjLWNiMGUtOTM0MS04MDY2LTI4ZWZkNGY0OTBlMyIvPiA8L3JkZjpEZXNjcmlwdGlvbj4gPC9yZGY6UkRGPiA8L3g6eG1wbWV0YT4gPD94cGFja2V0IGVuZD0iciI/Pr9D0iUAAABOSURBVHjaYvz//z8DKYAJmyDjHMZNIEyUBqhCXxDGpokJh2IYwNDEhEcxVk1MBBRjaGJEDyWgBIrA/5T/jARDieRgpaoGRqrEND4AEGAAo+4clZiKLkEAAAAASUVORK5CYII=",
"arrow_blue_12px", "iVBORw0KGgoAAAANSUhEUgAAAAwAAAAMCAYAAABWdVznAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAA3ZpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDkuMS1jMDAyIDc5LmRiYTNkYTNiNSwgMjAyMy8xMi8xNS0xMDo0MjozNyAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wTU09Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iIHhtbG5zOnN0UmVmPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VSZWYjIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtcE1NOk9yaWdpbmFsRG9jdW1lbnRJRD0ieG1wLmRpZDo0Y2RhMzdhYy1jYjBlLTkzNDEtODA2Ni0yOGVmZDRmNDkwZTMiIHhtcE1NOkRvY3VtZW50SUQ9InhtcC5kaWQ6RjNDRThGQkQyM0MyMTFFRjg1OEFCMDZDRjNFQTJGNkYiIHhtcE1NOkluc3RhbmNlSUQ9InhtcC5paWQ6RjNDRThGQkMyM0MyMTFFRjg1OEFCMDZDRjNFQTJGNkYiIHhtcDpDcmVhdG9yVG9vbD0iQWRvYmUgUGhvdG9zaG9wIDI1LjYgKFdpbmRvd3MpIj4gPHhtcE1NOkRlcml2ZWRGcm9tIHN0UmVmOmluc3RhbmNlSUQ9InhtcC5paWQ6MzVlOWQ4NDktNzdmYy0xMDRkLWI0NWYtNmY4NzZkZGM0YTIyIiBzdFJlZjpkb2N1bWVudElEPSJ4bXAuZGlkOjRjZGEzN2FjLWNiMGUtOTM0MS04MDY2LTI4ZWZkNGY0OTBlMyIvPiA8L3JkZjpEZXNjcmlwdGlvbj4gPC9yZGY6UkRGPiA8L3g6eG1wbWV0YT4gPD94cGFja2V0IGVuZD0iciI/Pqy+8sQAAABTSURBVHjaYvz//z8DKYAFRKjmYYhvgtJ+yIK3JzEwMGExBKTYF4o3oUsy4VAMAxiamPAoxqqJiYBiDE0sWDyHHmyM+PxAENBeAyOpMU2yDQABBgCe+xJbzIQ5JwAAAABJRU5ErkJggg==",
"circle_red_9px", "iVBORw0KGgoAAAANSUhEUgAAAAkAAAAJCAYAAADgkQYQAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAA3ZpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDkuMS1jMDAyIDc5LmRiYTNkYTNiNSwgMjAyMy8xMi8xNS0xMDo0MjozNyAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wTU09Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iIHhtbG5zOnN0UmVmPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VSZWYjIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtcE1NOk9yaWdpbmFsRG9jdW1lbnRJRD0ieG1wLmRpZDo0Y2RhMzdhYy1jYjBlLTkzNDEtODA2Ni0yOGVmZDRmNDkwZTMiIHhtcE1NOkRvY3VtZW50SUQ9InhtcC5kaWQ6OUZBOUI5QTcyM0MxMTFFRjlDNzVFNDQ0NTQwRkI0RDQiIHhtcE1NOkluc3RhbmNlSUQ9InhtcC5paWQ6OUZBOUI5QTYyM0MxMTFFRjlDNzVFNDQ0NTQwRkI0RDQiIHhtcDpDcmVhdG9yVG9vbD0iQWRvYmUgUGhvdG9zaG9wIDI1LjYgKFdpbmRvd3MpIj4gPHhtcE1NOkRlcml2ZWRGcm9tIHN0UmVmOmluc3RhbmNlSUQ9InhtcC5paWQ6MzVlOWQ4NDktNzdmYy0xMDRkLWI0NWYtNmY4NzZkZGM0YTIyIiBzdFJlZjpkb2N1bWVudElEPSJ4bXAuZGlkOjRjZGEzN2FjLWNiMGUtOTM0MS04MDY2LTI4ZWZkNGY0OTBlMyIvPiA8L3JkZjpEZXNjcmlwdGlvbj4gPC9yZGY6UkRGPiA8L3g6eG1wbWV0YT4gPD94cGFja2V0IGVuZD0iciI/Pnw0+9IAAABPSURBVHjaYvz//z8DIcDEQARAUfSRkXETEP8H0SiqQNaB8AcGhk1A/B8Jb4LJMcLcBDIB3Rr+//8Z0a3bjKZmM4Z1aFZuQhZnpFoQAAQYADM+P8ufPPnPAAAAAElFTkSuQmCC",
"circle_green_9px", "iVBORw0KGgoAAAANSUhEUgAAAAkAAAAJCAYAAADgkQYQAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAA3ZpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDkuMS1jMDAyIDc5LmRiYTNkYTNiNSwgMjAyMy8xMi8xNS0xMDo0MjozNyAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wTU09Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iIHhtbG5zOnN0UmVmPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VSZWYjIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtcE1NOk9yaWdpbmFsRG9jdW1lbnRJRD0ieG1wLmRpZDo0Y2RhMzdhYy1jYjBlLTkzNDEtODA2Ni0yOGVmZDRmNDkwZTMiIHhtcE1NOkRvY3VtZW50SUQ9InhtcC5kaWQ6MTlGMzhDQjYyM0MzMTFFRjk5RkM4ODM2ODc5NUY1QUEiIHhtcE1NOkluc3RhbmNlSUQ9InhtcC5paWQ6MTlGMzhDQjUyM0MzMTFFRjk5RkM4ODM2ODc5NUY1QUEiIHhtcDpDcmVhdG9yVG9vbD0iQWRvYmUgUGhvdG9zaG9wIDI1LjYgKFdpbmRvd3MpIj4gPHhtcE1NOkRlcml2ZWRGcm9tIHN0UmVmOmluc3RhbmNlSUQ9InhtcC5paWQ6MzVlOWQ4NDktNzdmYy0xMDRkLWI0NWYtNmY4NzZkZGM0YTIyIiBzdFJlZjpkb2N1bWVudElEPSJ4bXAuZGlkOjRjZGEzN2FjLWNiMGUtOTM0MS04MDY2LTI4ZWZkNGY0OTBlMyIvPiA8L3JkZjpEZXNjcmlwdGlvbj4gPC9yZGY6UkRGPiA8L3g6eG1wbWV0YT4gPD94cGFja2V0IGVuZD0iciI/PoNi/LQAAABKSURBVHjaYvz//z8DIcDEQARAUcQ4h3ETEP8H0VgVQSV8oVxfZIXIJvmi2eKLTdFmNEUIPsh3MMwwm2ETEP8H0cjijFQLAoAAAwBkBiWi1M0JOgAAAABJRU5ErkJggg==",
"circle_blue_9px", "iVBORw0KGgoAAAANSUhEUgAAAAkAAAAJCAYAAADgkQYQAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAA3ZpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDkuMS1jMDAyIDc5LmRiYTNkYTNiNSwgMjAyMy8xMi8xNS0xMDo0MjozNyAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wTU09Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iIHhtbG5zOnN0UmVmPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VSZWYjIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtcE1NOk9yaWdpbmFsRG9jdW1lbnRJRD0ieG1wLmRpZDo0Y2RhMzdhYy1jYjBlLTkzNDEtODA2Ni0yOGVmZDRmNDkwZTMiIHhtcE1NOkRvY3VtZW50SUQ9InhtcC5kaWQ6RjNEMzU0NTgyM0MyMTFFRjg1OEFCMDZDRjNFQTJGNkYiIHhtcE1NOkluc3RhbmNlSUQ9InhtcC5paWQ6RjNEMzU0NTcyM0MyMTFFRjg1OEFCMDZDRjNFQTJGNkYiIHhtcDpDcmVhdG9yVG9vbD0iQWRvYmUgUGhvdG9zaG9wIDI1LjYgKFdpbmRvd3MpIj4gPHhtcE1NOkRlcml2ZWRGcm9tIHN0UmVmOmluc3RhbmNlSUQ9InhtcC5paWQ6MzVlOWQ4NDktNzdmYy0xMDRkLWI0NWYtNmY4NzZkZGM0YTIyIiBzdFJlZjpkb2N1bWVudElEPSJ4bXAuZGlkOjRjZGEzN2FjLWNiMGUtOTM0MS04MDY2LTI4ZWZkNGY0OTBlMyIvPiA8L3JkZjpEZXNjcmlwdGlvbj4gPC9yZGY6UkRGPiA8L3g6eG1wbWV0YT4gPD94cGFja2V0IGVuZD0iciI/PtcZQw0AAABJSURBVHjaYvz//z8DIcDEQARggTFU88DUJiD2BeLNQOx3exKmSTAFDFB6EzbrfNFs8cWmaDOaos3YFPkhSWyG8sGAkWpBABBgANUWEA3dJYkxAAAAAElFTkSuQmCC",
"circle_red_12px", "iVBORw0KGgoAAAANSUhEUgAAAAwAAAAMCAYAAABWdVznAAAACXBIWXMAAAsTAAALEwEAmpwYAAAGq2lUWHRYTUw6Y29tLmFkb2JlLnhtcAAAAAAAPD94cGFja2V0IGJlZ2luPSLvu78iIGlkPSJXNU0wTXBDZWhpSHpyZVN6TlRjemtjOWQiPz4gPHg6eG1wbWV0YSB4bWxuczp4PSJhZG9iZTpuczptZXRhLyIgeDp4bXB0az0iQWRvYmUgWE1QIENvcmUgOS4xLWMwMDIgNzkuYTZhNjM5NiwgMjAyNC8wMy8xMi0wNzo0ODoyMyAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wTU09Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iIHhtbG5zOnN0UmVmPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VSZWYjIiB4bWxuczpzdEV2dD0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL3NUeXBlL1Jlc291cmNlRXZlbnQjIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtbG5zOmRjPSJodHRwOi8vcHVybC5vcmcvZGMvZWxlbWVudHMvMS4xLyIgeG1sbnM6cGhvdG9zaG9wPSJodHRwOi8vbnMuYWRvYmUuY29tL3Bob3Rvc2hvcC8xLjAvIiB4bXBNTTpPcmlnaW5hbERvY3VtZW50SUQ9InhtcC5kaWQ6NGNkYTM3YWMtY2IwZS05MzQxLTgwNjYtMjhlZmQ0ZjQ5MGUzIiB4bXBNTTpEb2N1bWVudElEPSJhZG9iZTpkb2NpZDpwaG90b3Nob3A6Zjg3MTNjNjEtNjFiYy0wZDQ2LWJmOGMtY2Y2NDk4NjllMzNlIiB4bXBNTTpJbnN0YW5jZUlEPSJ4bXAuaWlkOjY0ODYwMjYyLWM2YzItNTA0Mi1hZDI1LTFlOWEwNDg1ZjJhNiIgeG1wOkNyZWF0b3JUb29sPSJBZG9iZSBQaG90b3Nob3AgMjUuNiAoV2luZG93cykiIHhtcDpDcmVhdGVEYXRlPSIyMDI0LTA2LTA1VDIyOjA5OjQ2LTA3OjAwIiB4bXA6TW9kaWZ5RGF0ZT0iMjAyNS0wMi0yN1QxMjoyMzowOS0wODowMCIgeG1wOk1ldGFkYXRhRGF0ZT0iMjAyNS0wMi0yN1QxMjoyMzowOS0wODowMCIgZGM6Zm9ybWF0PSJpbWFnZS9wbmciIHBob3Rvc2hvcDpDb2xvck1vZGU9IjMiPiA8eG1wTU06RGVyaXZlZEZyb20gc3RSZWY6aW5zdGFuY2VJRD0ieG1wLmlpZDozNWU5ZDg0OS03N2ZjLTEwNGQtYjQ1Zi02Zjg3NmRkYzRhMjIiIHN0UmVmOmRvY3VtZW50SUQ9InhtcC5kaWQ6NGNkYTM3YWMtY2IwZS05MzQxLTgwNjYtMjhlZmQ0ZjQ5MGUzIi8+IDx4bXBNTTpIaXN0b3J5PiA8cmRmOlNlcT4gPHJkZjpsaSBzdEV2dDphY3Rpb249InNhdmVkIiBzdEV2dDppbnN0YW5jZUlEPSJ4bXAuaWlkOjg3YjhmMzY2LTk1MTEtN2Q0Ny1iYWFiLTg2NDQ4ODlmY2ZjZCIgc3RFdnQ6d2hlbj0iMjAyNS0wMi0yNlQyMDozMzo0My0wODowMCIgc3RFdnQ6c29mdHdhcmVBZ2VudD0iQWRvYmUgUGhvdG9zaG9wIDI1LjkgKFdpbmRvd3MpIiBzdEV2dDpjaGFuZ2VkPSIvIi8+IDxyZGY6bGkgc3RFdnQ6YWN0aW9uPSJzYXZlZCIgc3RFdnQ6aW5zdGFuY2VJRD0ieG1wLmlpZDo2NDg2MDI2Mi1jNmMyLTUwNDItYWQyNS0xZTlhMDQ4NWYyYTYiIHN0RXZ0OndoZW49IjIwMjUtMDItMjdUMTI6MjM6MDktMDg6MDAiIHN0RXZ0OnNvZnR3YXJlQWdlbnQ9IkFkb2JlIFBob3Rvc2hvcCAyNS45IChXaW5kb3dzKSIgc3RFdnQ6Y2hhbmdlZD0iLyIvPiA8L3JkZjpTZXE+IDwveG1wTU06SGlzdG9yeT4gPC9yZGY6RGVzY3JpcHRpb24+IDwvcmRmOlJERj4gPC94OnhtcG1ldGE+IDw/eHBhY2tldCBlbmQ9InIiPz7Id1I4AAAAVUlEQVQokc2RQQrAMAgEd/qBftn+OL5geykhkVxCLhX2IiMyim3t1LVFHw8kKCES/CUS5gnbPU2KJrkkRoZROmF5gdvua46lnwUz94pD9YhWGP73uBdrlU3RVcqQaQAAAABJRU5ErkJggg==",
"circle_green_12px", "iVBORw0KGgoAAAANSUhEUgAAAAwAAAAMCAYAAABWdVznAAAACXBIWXMAAAsTAAALEwEAmpwYAAAGq2lUWHRYTUw6Y29tLmFkb2JlLnhtcAAAAAAAPD94cGFja2V0IGJlZ2luPSLvu78iIGlkPSJXNU0wTXBDZWhpSHpyZVN6TlRjemtjOWQiPz4gPHg6eG1wbWV0YSB4bWxuczp4PSJhZG9iZTpuczptZXRhLyIgeDp4bXB0az0iQWRvYmUgWE1QIENvcmUgOS4xLWMwMDIgNzkuYTZhNjM5NiwgMjAyNC8wMy8xMi0wNzo0ODoyMyAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wTU09Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iIHhtbG5zOnN0UmVmPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VSZWYjIiB4bWxuczpzdEV2dD0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL3NUeXBlL1Jlc291cmNlRXZlbnQjIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtbG5zOmRjPSJodHRwOi8vcHVybC5vcmcvZGMvZWxlbWVudHMvMS4xLyIgeG1sbnM6cGhvdG9zaG9wPSJodHRwOi8vbnMuYWRvYmUuY29tL3Bob3Rvc2hvcC8xLjAvIiB4bXBNTTpPcmlnaW5hbERvY3VtZW50SUQ9InhtcC5kaWQ6NGNkYTM3YWMtY2IwZS05MzQxLTgwNjYtMjhlZmQ0ZjQ5MGUzIiB4bXBNTTpEb2N1bWVudElEPSJhZG9iZTpkb2NpZDpwaG90b3Nob3A6MTliYTYxNjAtZjE5Ny1hNjQzLWIzNmMtMDAzMTRhZDVlYjAzIiB4bXBNTTpJbnN0YW5jZUlEPSJ4bXAuaWlkOjU2Y2E2MjZiLTA5ZDMtMjc0NS05MmZkLWQ4YzdjYTM1NjZhZSIgeG1wOkNyZWF0b3JUb29sPSJBZG9iZSBQaG90b3Nob3AgMjUuNiAoV2luZG93cykiIHhtcDpDcmVhdGVEYXRlPSIyMDI0LTA2LTA1VDIyOjA5OjQ2LTA3OjAwIiB4bXA6TW9kaWZ5RGF0ZT0iMjAyNS0wMi0yN1QxMjoyMjoxNi0wODowMCIgeG1wOk1ldGFkYXRhRGF0ZT0iMjAyNS0wMi0yN1QxMjoyMjoxNi0wODowMCIgZGM6Zm9ybWF0PSJpbWFnZS9wbmciIHBob3Rvc2hvcDpDb2xvck1vZGU9IjMiPiA8eG1wTU06RGVyaXZlZEZyb20gc3RSZWY6aW5zdGFuY2VJRD0ieG1wLmlpZDozNWU5ZDg0OS03N2ZjLTEwNGQtYjQ1Zi02Zjg3NmRkYzRhMjIiIHN0UmVmOmRvY3VtZW50SUQ9InhtcC5kaWQ6NGNkYTM3YWMtY2IwZS05MzQxLTgwNjYtMjhlZmQ0ZjQ5MGUzIi8+IDx4bXBNTTpIaXN0b3J5PiA8cmRmOlNlcT4gPHJkZjpsaSBzdEV2dDphY3Rpb249InNhdmVkIiBzdEV2dDppbnN0YW5jZUlEPSJ4bXAuaWlkOjg3YjhmMzY2LTk1MTEtN2Q0Ny1iYWFiLTg2NDQ4ODlmY2ZjZCIgc3RFdnQ6d2hlbj0iMjAyNS0wMi0yNlQyMDozMzo0My0wODowMCIgc3RFdnQ6c29mdHdhcmVBZ2VudD0iQWRvYmUgUGhvdG9zaG9wIDI1LjkgKFdpbmRvd3MpIiBzdEV2dDpjaGFuZ2VkPSIvIi8+IDxyZGY6bGkgc3RFdnQ6YWN0aW9uPSJzYXZlZCIgc3RFdnQ6aW5zdGFuY2VJRD0ieG1wLmlpZDo1NmNhNjI2Yi0wOWQzLTI3NDUtOTJmZC1kOGM3Y2EzNTY2YWUiIHN0RXZ0OndoZW49IjIwMjUtMDItMjdUMTI6MjI6MTYtMDg6MDAiIHN0RXZ0OnNvZnR3YXJlQWdlbnQ9IkFkb2JlIFBob3Rvc2hvcCAyNS45IChXaW5kb3dzKSIgc3RFdnQ6Y2hhbmdlZD0iLyIvPiA8L3JkZjpTZXE+IDwveG1wTU06SGlzdG9yeT4gPC9yZGY6RGVzY3JpcHRpb24+IDwvcmRmOlJERj4gPC94OnhtcG1ldGE+IDw/eHBhY2tldCBlbmQ9InIiPz4V5gy5AAAAW0lEQVQoka2QUQ6AMAhDH8aj7h7CPXZX/FkiW5hmi/2CpgWKuDsrOJbUO4YzNlIFQIGrUQaol+fscUMU02rthsbQUiX9gBeX2YZPjAZLNB2XZYgC4y3Dzkn/G26aRBcRbOYNOAAAAABJRU5ErkJggg==",
"circle_blue_12px", "iVBORw0KGgoAAAANSUhEUgAAAAwAAAAMCAYAAABWdVznAAAACXBIWXMAAAsTAAALEwEAmpwYAAAGq2lUWHRYTUw6Y29tLmFkb2JlLnhtcAAAAAAAPD94cGFja2V0IGJlZ2luPSLvu78iIGlkPSJXNU0wTXBDZWhpSHpyZVN6TlRjemtjOWQiPz4gPHg6eG1wbWV0YSB4bWxuczp4PSJhZG9iZTpuczptZXRhLyIgeDp4bXB0az0iQWRvYmUgWE1QIENvcmUgOS4xLWMwMDIgNzkuYTZhNjM5NiwgMjAyNC8wMy8xMi0wNzo0ODoyMyAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wTU09Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iIHhtbG5zOnN0UmVmPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VSZWYjIiB4bWxuczpzdEV2dD0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL3NUeXBlL1Jlc291cmNlRXZlbnQjIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtbG5zOmRjPSJodHRwOi8vcHVybC5vcmcvZGMvZWxlbWVudHMvMS4xLyIgeG1sbnM6cGhvdG9zaG9wPSJodHRwOi8vbnMuYWRvYmUuY29tL3Bob3Rvc2hvcC8xLjAvIiB4bXBNTTpPcmlnaW5hbERvY3VtZW50SUQ9InhtcC5kaWQ6NGNkYTM3YWMtY2IwZS05MzQxLTgwNjYtMjhlZmQ0ZjQ5MGUzIiB4bXBNTTpEb2N1bWVudElEPSJhZG9iZTpkb2NpZDpwaG90b3Nob3A6OThhNWExNjktYzQ4NS1lNjQxLWI3MmMtMGQyNGI1YmNiODRjIiB4bXBNTTpJbnN0YW5jZUlEPSJ4bXAuaWlkOmQ1M2MzN2IzLTEzMjctMWE0Yi1hYWM3LWI4ODIyN2FiZjQ1NyIgeG1wOkNyZWF0b3JUb29sPSJBZG9iZSBQaG90b3Nob3AgMjUuNiAoV2luZG93cykiIHhtcDpDcmVhdGVEYXRlPSIyMDI0LTA2LTA1VDIyOjA5OjQ2LTA3OjAwIiB4bXA6TW9kaWZ5RGF0ZT0iMjAyNS0wMi0yNlQyMDozMzo0My0wODowMCIgeG1wOk1ldGFkYXRhRGF0ZT0iMjAyNS0wMi0yNlQyMDozMzo0My0wODowMCIgZGM6Zm9ybWF0PSJpbWFnZS9wbmciIHBob3Rvc2hvcDpDb2xvck1vZGU9IjMiPiA8eG1wTU06RGVyaXZlZEZyb20gc3RSZWY6aW5zdGFuY2VJRD0ieG1wLmlpZDozNWU5ZDg0OS03N2ZjLTEwNGQtYjQ1Zi02Zjg3NmRkYzRhMjIiIHN0UmVmOmRvY3VtZW50SUQ9InhtcC5kaWQ6NGNkYTM3YWMtY2IwZS05MzQxLTgwNjYtMjhlZmQ0ZjQ5MGUzIi8+IDx4bXBNTTpIaXN0b3J5PiA8cmRmOlNlcT4gPHJkZjpsaSBzdEV2dDphY3Rpb249InNhdmVkIiBzdEV2dDppbnN0YW5jZUlEPSJ4bXAuaWlkOjg3YjhmMzY2LTk1MTEtN2Q0Ny1iYWFiLTg2NDQ4ODlmY2ZjZCIgc3RFdnQ6d2hlbj0iMjAyNS0wMi0yNlQyMDozMzo0My0wODowMCIgc3RFdnQ6c29mdHdhcmVBZ2VudD0iQWRvYmUgUGhvdG9zaG9wIDI1LjkgKFdpbmRvd3MpIiBzdEV2dDpjaGFuZ2VkPSIvIi8+IDxyZGY6bGkgc3RFdnQ6YWN0aW9uPSJzYXZlZCIgc3RFdnQ6aW5zdGFuY2VJRD0ieG1wLmlpZDpkNTNjMzdiMy0xMzI3LTFhNGItYWFjNy1iODgyMjdhYmY0NTciIHN0RXZ0OndoZW49IjIwMjUtMDItMjZUMjA6MzM6NDMtMDg6MDAiIHN0RXZ0OnNvZnR3YXJlQWdlbnQ9IkFkb2JlIFBob3Rvc2hvcCAyNS45IChXaW5kb3dzKSIgc3RFdnQ6Y2hhbmdlZD0iLyIvPiA8L3JkZjpTZXE+IDwveG1wTU06SGlzdG9yeT4gPC9yZGY6RGVzY3JpcHRpb24+IDwvcmRmOlJERj4gPC94OnhtcG1ldGE+IDw/eHBhY2tldCBlbmQ9InIiPz4FarcEAAAAT0lEQVQokWP8//8/AymAiSTV5GhgQRdQzWNoYGBgqIdyG29PYmjAaQOaYgYGBoZ6qBhOJ9UzYAIUMYo93YhFDYoYigaoB5EVYHiacfBFHAD1hhQTX9h1rgAAAABJRU5ErkJggg==",
)
UseBase64Image(name := "") {
if (!name or name == "")
return { image: "", name: name }
if base64images.Has(name) {
image := { image: CleanBase64(base64images.Get(name)), name: name }
return image
} else {
for key, value in base64images {
if key ~= "^" . name {
image := { image: CleanBase64(value), name: key }
return image
}
}
}
return { image: "", name: name }
}
CleanBase64(b64str) {
if InStr(b64str, ",") {
parts := StrSplit(b64str, ",", 2)
if parts.Length == 2 and InStr(parts[1], "data") and StrLen(parts[2]) > 2
return parts[2]
}
return b64str
}
#requires AutoHotkey v2.0
UseCached(fn, timeout := 100) {
if (timeout < 1)
return fn
cache := ""
lastCallTime := 0
return () => (
currentTime := A_TickCount,
(cache == "" || (currentTime - lastCallTime) > timeout)
? (cache := fn(), lastCallTime := currentTime, cache)
: cache
)
}
class IndicatorBase {
static SHUTDOWN_REASONS := "^(?i:Logoff|Shutdown)$"
__New(cfg) {
this.cfg := cfg
this.inputState := InputState()
this.markPainter := ImagePainter()
this.markPainter.margin := this.cfg.markMargin
this.currentMarkObj := ""
this.folderExistsCache := UseCached(
() => DirExist(this.cfg.files.folder),
this.cfg.files.folderExistCheckPeriod
)
}
Run() {
SetTimer(() => this.Check(), this.cfg.inputCheckPeriod)
SetTimer(() => this.Repaint(), this.cfg.markRepaintPeriod)
OnExit((reason, code) => this.OnExit(reason, code))
}
Check() {
this.inputState.Update()
this.FolderExists()
? this.UseMarkFile()
: this.UseMarkEmbedded()
}
Repaint() {
if (this.currentMarkObj == "")
return
this.PaintMark(this.currentMarkObj)
}
FolderExists() {
return this.folderExistsCache.Call()
}
UseMarkEmbedded() {
markName := MarkResolver.GetMarkName(this.inputState.locale, this.inputState.capslock)
if (markName == "") {
this.currentMarkObj := ""
this.markPainter.RemoveWindow()
return
}
this.currentMarkObj := UseBase64Image(markName)
this.PaintMark(this.currentMarkObj)
}
UseMarkFile() {
markName := MarkResolver.GetMarkName(this.inputState.locale, this.inputState.capslock)
if (markName == "") {
this.currentMarkObj := ""
this.markPainter.RemoveWindow()
return
}
markFile := MarkResolver.GetMarkFile(this.cfg.files, this.inputState.locale, this.inputState.capslock)
this.currentMarkObj := { name: markName, image: markFile }
this.PaintMark(this.currentMarkObj)
}
PaintMark(markObj) {
throw Error("PaintMark must be implemented by subclass")
}
GetPosition() {
throw Error("GetPosition must be implemented by subclass")
}
OnExit(reason, code) {
if !(reason ~= IndicatorBase.SHUTDOWN_REASONS)
this.markPainter.RemoveWindow()
}
}
#requires AutoHotkey v2.0
#Requires AutoHotkey v2.0
class ActiveMonitor {
static id := -1
static monitorCount := 0
static activeWindow := 0
static monRect := { l: -1, t: -1, r: -1, b: -1 }
static winRect := { l: -1, t: -1, r: -1, b: -1, cx: -1, cy: -1 }
static winScaled := { l: -1, t: -1, r: -1, b: -1, cx: -1, cy: -1 }
static init(&monL?, &monT?, &monR?, &monB?) {
this.activeWindow := this.getActiveWinRect()
this.id := this.getActiveMonitor()
monL := this.monRect.l
monT := this.monRect.t
monR := this.monRect.r
monB := this.monRect.b
return this.id
}
static status() {
s1 := "monitor id: " this.id "`n"
s2 := "monitor count: " this.monitorCount "`n"
s3 := "monitor rect: " Jsons.Dump(this.monRect) "`n"
s4 := "active window: " this.activeWindow "`n"
s5 := "active window rect: " Jsons.Dump(this.winRect) "`n"
s6 := "active window scaled: " Jsons.Dump(this.winScaled) "`n"
return s1 s2 s3 s4 s5 s6
}
static getActiveWinRect() {
try {
activeWindow := this.getActiveHWND()
scale := this.getActiveWinScale()
winW := -1, winH := -1
this.getActiveWinPosEx(&wl, &wt, &winW, &winH)
wr := wl + winW
wb := wt + winH
this.winRect.l := wl
this.winRect.t := wt
this.winRect.r := wr
this.winRect.b := wb
this.winRect.cx := Round((this.winRect.r + this.winRect.l) / 2)
this.winRect.cy := Round((this.winRect.b + this.winRect.t) / 2)
this.winScaled.l := wl
this.winScaled.t := wt
this.winScaled.r := Round(wl + winW * scale)
this.winScaled.b := Round(wt + winH * scale)
this.winScaled.cx := Round((this.winScaled.r + this.winScaled.l) / 2)
this.winScaled.cy := Round((this.winScaled.b + this.winScaled.t) / 2)
return activeWindow
} catch as e {
Log(e)
return false
}
}
static getActiveMonitor() {
this.activeWindow := this.getActiveWinRect()
if (this.activeWindow) {
this.id := this.posToMonitor(this.winScaled.cx, this.winScaled.cy)
return this.id
}
if (this.id > 0)
return this.id
return 1
}
static posToMonitor(posX, posY) {
this.monitorCount := SysGet(SM_CMONITORS := 80)
monitor := 1
while true {
if (monitor > this.monitorCount) {
break
}
MonitorGet(monitor, &ml, &mt, &mr, &mb)
if (posX >= ml and posX < mr and posY >= mt and posY < mb) {
this.id := monitor
this.monRect.l := ml
this.monRect.t := mt
this.monRect.r := mr
this.monRect.b := mb
return this.id
}
monitor++
}
return this.id
}
static getActiveHWND() {
hwnd := -1
try {
hwnd := WinGetID("A")
} catch as e {
hwnd := 0
}
return hwnd
}
static getActiveWinScale() {
hwnd := this.getActiveHWND()
if winDpi := DllCall("GetDpiForWindow", "ptr", hwnd, "uint")
return A_ScreenDPI / winDpi
return 1
}
static getActiveWinPosEx(&X, &Y, &Width?, &Height?, &Offset_X?, &Offset_Y?) {
hWindow := this.getActiveHWND()
Static S_OK := 0x0,
DWMWA_EXTENDED_FRAME_BOUNDS := 9
RECTPlus := Buffer(24, 0)
try {
DWMRC := DllCall("dwmapi\DwmGetWindowAttribute",
"Ptr", hWindow,
"UInt", DWMWA_EXTENDED_FRAME_BOUNDS,
"Ptr", RECTPlus,
"UInt", 16,
"UInt")
} catch as e {
return false
}
X := NumGet(RECTPlus, 0, "Int")
Y := NumGet(RECTPlus, 4, "Int")
R := NumGet(RECTPlus, 8, "Int")
B := NumGet(RECTPlus, 12, "Int")
Width := R - X
Height := B - Y
OffSet_X := 0
OffSet_Y := 0
RECT := Buffer(16, 0)
DllCall("GetWindowRect", "Ptr", hWindow, "Ptr", RECT)
GWR_Width := NumGet(RECT, 8, "Int") - NumGet(RECT, 0, "Int")
GWR_Height := NumGet(RECT, 12, "Int") - NumGet(RECT, 4, "Int")
NumPut("Int", Offset_X := (Width - GWR_Width) // 2, RECTPlus, 16)
NumPut("Int", Offset_Y := (Height - GWR_Height) // 2, RECTPlus, 20)
return RECTPlus
}
}
GetCaretRect(&left?, &top?, &right?, &bottom?, &cartetDetectMethod?) {
hwnd := getActiveHWND()
className := getClassName(hwnd)
isTelegram := InStr(className, "51515")
if getCaretPosFromGui() and !isTelegram {
cartetDetectMethod .= " (className:" . classname . ")"
handleMaxInt(&left, &top, &right, &bottom)
return true
}
if className ~= "^(?:Windows|Microsoft)\.UI\..+"
fns := [getCaretPosFromUIA, getCaretPosFromHook, getCaretPosFromMSAA_2]
else if className ~= "^HwndWrapper\[PowerShell_ISE\.exe;;[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\]"
fns := [getCaretPosFromWpfCaret, getCaretPosFromHook]
else
fns := [getCaretPosFromMSAA_2, getCaretPosFromUIA, getCaretPosFromWpfCaret, getCaretPosFromHook]
for fn in fns {
if fn() {
cartetDetectMethod .= " (className:" . classname . ")"
handleMaxInt(&left, &top, &right, &bottom)
return true
}
}
cartetDetectMethod := "failure (className:" . classname . ")"
return false
getCaretPosFromGui() {
x64 := A_PtrSize == 8
guiThreadInfo := Buffer(x64 ? 72 : 48)
NumPut("uint", guiThreadInfo.Size, guiThreadInfo)
if DllCall("GetGUIThreadInfo", "uint", 0, "ptr", guiThreadInfo) {
if _hwnd := NumGet(guiThreadInfo, x64 ? 48 : 28, "ptr") {
getRect(guiThreadInfo.Ptr + (x64 ? 56 : 32), &left, &top, &right, &bottom)
scaleRect(getWinScale(_hwnd), &left, &top, &right, &bottom)
clientToScreenRect(_hwnd, &left, &top, &right, &bottom)
cartetDetectMethod := "getCaretPosFromGui"
return true
}
_hwnd := NumGet(guiThreadInfo, x64 ? 16 : 12, "ptr")
}
return false
}
getCaretPosFromUIA() {
try {
uia := ComObject("{E22AD333-B25F-460C-83D0-0581107395C9}", "{30CBE57D-D9D0-452A-AB13-7AC5AC4825EE}")
ComCall(20, uia, "ptr*", cacheRequest := ComValue(13, 0))
if !cacheRequest.Ptr
return false
ComCall(4, cacheRequest, "ptr", 10014)
ComCall(4, cacheRequest, "ptr", 10024)
ComCall(12, uia, "ptr", cacheRequest, "ptr*", focusedEle := ComValue(13, 0))
if !focusedEle.Ptr
return false
static IID_IUIAutomationTextPattern2 := guidFromString("{506a921a-fcc9-409f-b23b-37eb74106872}")
range := ComValue(13, 0)
ComCall(15, focusedEle, "int", 10024, "ptr", IID_IUIAutomationTextPattern2, "ptr*", textPattern := ComValue(13, 0))
if textPattern.Ptr {
ComCall(10, textPattern, "int*", &isActive := 0, "ptr*", range)
if range.Ptr
goto getRangeInfo
}
static IID_IUIAutomationTextPattern := guidFromString("{32eba289-3583-42c9-9c59-3b6d9a1e9b6a}")
ComCall(15, focusedEle, "int", 10014, "ptr", IID_IUIAutomationTextPattern, "ptr*", textPattern)
if textPattern.Ptr {
ComCall(5, textPattern, "ptr*", ranges := ComValue(13, 0))
if ranges.Ptr {
ComCall(3, ranges, "int*", &len := 0)
if len > 0 {
ComCall(4, ranges, "int", len - 1, "ptr*", range)
if range.Ptr {
ComCall(15, range, "int", 0, "ptr", range, "int", 1)
goto getRangeInfo
}
}
}
}
return false
getRangeInfo:
psa := 0
ComCall(6, range, "int", 0)
ComCall(10, range, "ptr*", &psa)
if psa {
rects := ComValue(0x2005, psa, 1)
if rects.MaxIndex() >= 3 {
rects[2] := 0
goto end
}
}
ComCall(6, range, "int", 3)
ComCall(10, range, "ptr*", &psa)
if psa {
rects := ComValue(0x2005, psa, 1)
if rects.MaxIndex() >= 3 {
rects[0] := rects[0] + rects[2]
rects[2] := 0
goto end
}
}
return false
end:
left := Round(rects[0])
top := Round(rects[1])
right := left + Round(rects[2])
bottom := top + Round(rects[3])
w := right - left
cartetDetectMethod := "getCaretPosFromUIA"
return true
}
return false
}
getCaretPosFromWpfCaret() {
try {
uia := ComObject("{E22AD333-B25F-460C-83D0-0581107395C9}", "{30CBE57D-D9D0-452A-AB13-7AC5AC4825EE}")
ComCall(8, uia, "ptr*", focusedEle := ComValue(13, 0))
if !focusedEle.Ptr
return false
ComCall(20, uia, "ptr*", cacheRequest := ComValue(13, 0))
if !cacheRequest.Ptr
return false
ComCall(17, uia, "ptr*", rawViewCondition := ComValue(13, 0))
if !rawViewCondition.Ptr
return false
ComCall(9, cacheRequest, "ptr", rawViewCondition)
ComCall(3, cacheRequest, "int", 30001)
var := Buffer(24, 0)
ref := ComValue(0x400C, var.Ptr)
ref[] := ComValue(8, "WpfCaret")
ComCall(23, uia, "int", 30012, "ptr", var, "ptr*", condition := ComValue(13, 0))
if !condition.Ptr
return false
ComCall(7, focusedEle, "int", 4, "ptr", condition, "ptr", cacheRequest, "ptr*", wpfCaret := ComValue(13, 0))
if !wpfCaret.Ptr
return false
ComCall(75, wpfCaret, "ptr", rect := Buffer(16))
getRect(rect, &left, &top, &right, &bottom)
cartetDetectMethod := "getCaretPosFromWpfCaret"
return true
}
return false
}
getCaretPosFromHook() {
static WM_GET_CARET_POS := DllCall("RegisterWindowMessageW", "str", "WM_GET_CARET_POS", "uint")
if !tid := DllCall("GetWindowThreadProcessId", "ptr", hwnd, "ptr*", &pid := 0, "uint")
return false
static cachedLeft := 0, cachedTop := 0, cachedRight := 0, cachedBottom := 0
static cachedHwnd := 0, selectionLikely := false
if GetKeyState("Shift", "P") or GetKeyState("LButton", "P")
selectionLikely := true
if (cachedHwnd != hwnd)
selectionLikely := false
if selectionLikely and !GetKeyState("Shift", "P") and !GetKeyState("LButton", "P") and !GetKeyState("Ctrl", "P") {
vk := 0x08
while vk <= 0x5A {
if (vk != 0x10 and vk != 0x11 and vk != 0x12 and vk != 0x14
and DllCall("GetAsyncKeyState", "int", vk, "short") & 0x8000) {
selectionLikely := false
break
}
vk++
}
}
skipIme := GetKeyState("Shift", "P") or GetKeyState("Ctrl", "P") or GetKeyState("LButton", "P") or selectionLikely
if !skipIme {
try SendMessage(0x010f, 0, 0, hwnd)
} else if (cachedHwnd == hwnd and (cachedBottom - cachedTop) > 0) {
left := cachedLeft, top := cachedTop
right := cachedRight, bottom := cachedBottom
cartetDetectMethod := "getCaretPosFromHook (cached)"
return true
}
if !hProcess := DllCall("OpenProcess", "uint", 1082, "int", false, "uint", pid, "ptr")
return false
hProcess := {
Ptr: hProcess,
__Delete: (_) => DllCall("CloseHandle", "ptr", _)
}
isX64 := isX64Process(hProcess)
if isX64 && A_PtrSize == 4
return false
if !moduleBaseMap := getModulesBases(hProcess, ["kernel32.dll", "user32.dll", "combase.dll"])
return false
if isX64 {
shellcode := compile(true)
} else {
shellcode := compile(false)
}
if !mem := DllCall("VirtualAllocEx", "ptr", hProcess, "ptr", 0, "ptr", shellcode.Size, "uint", 0x1000, "uint", 0x40, "ptr")
return false
mem := {
Ptr: mem,
__Delete: (_) => DllCall("VirtualFreeEx", "ptr", hProcess, "ptr", _, "uptr", 0, "uint", 0x8000)
}
link(isX64, shellcode, mem.Ptr, moduleBaseMap["user32.dll"], moduleBaseMap["combase.dll"], hwnd, tid, WM_GET_CARET_POS, &pThreadProc, &pRect)
if !DllCall("WriteProcessMemory", "ptr", hProcess, "ptr", mem, "ptr", shellcode, "uptr", shellcode.Size, "ptr", 0)
return false
DllCall("FlushInstructionCache", "ptr", hProcess, "ptr", mem, "uptr", shellcode.Size)
if !hThread := DllCall("CreateRemoteThread", "ptr", hProcess, "ptr", 0, "uptr", 0, "ptr", pThreadProc, "ptr", mem, "uint", 0, "uint*", &remoteTid := 0, "ptr")
return false
hThread := {
Ptr: hThread,
__Delete: (_) => DllCall("CloseHandle", "ptr", _)
}
if msgWaitForSingleObject(hThread)
return false
if !DllCall("GetExitCodeThread", "ptr", hThread, "uint*", exitCode := 0) || exitCode !== 0
return false
rect := Buffer(16)
if !DllCall("ReadProcessMemory", "ptr", hProcess, "ptr", pRect, "ptr", rect, "uptr", rect.Size, "uptr*", &bytesRead := 0) || bytesRead !== rect.Size
return false
getRect(rect, &left, &top, &right, &bottom)
scaleRect(getWinScale(hwnd), &left, &top, &right, &bottom)
fixDPIScaleHook(&left, &top, &right, &bottom)
right := left + 1
cellH := bottom - top
top := top - cellH // 2 - 2
bottom := top + cellH
cachedLeft := left, cachedTop := top
cachedRight := right, cachedBottom := bottom
cachedHwnd := hwnd
cartetDetectMethod := "getCaretPosFromHook"
return true
static isX64Process(hProcess) {
DllCall("IsWow64Process", "ptr", hProcess, "int*", &isWow64 := 0)
if isWow64
return false
if A_PtrSize == 8
return true
DllCall("IsWow64Process", "ptr", DllCall("GetCurrentProcess", "ptr"), "int*", &isWow64)
return isWow64
}
static getModulesBases(hProcess, modules) {
hModules := Buffer(A_PtrSize * 350)
if !DllCall("K32EnumProcessModulesEx", "ptr", hProcess, "ptr", hModules, "uint", hModules.Size, "uint*", &needed := 0, "uint", 3)
return
moduleBaseMap := Map()
moduleBaseMap.CaseSense := false
for v in modules
moduleBaseMap[v] := 0
cnt := modules.Length
loop Min(350, needed) {
hModule := NumGet(hModules, A_PtrSize * (A_Index - 1), "ptr")
VarSetStrCapacity(&name, 12)
if DllCall("K32GetModuleBaseNameW", "ptr", hProcess, "ptr", hModule, "str", &name, "uint", 13) {
if moduleBaseMap.Has(name) {
moduleInfo := Buffer(24)
if !DllCall("K32GetModuleInformation", "ptr", hProcess, "ptr", hModule, "ptr", moduleInfo, "uint", moduleInfo.Size)
return
if !base := NumGet(moduleInfo, "ptr")
return
moduleBaseMap[name] := base
cnt--
}
}
} until cnt == 0
if cnt == 0 {
return moduleBaseMap
}
}
static compile(x64) {
if x64
shellcodeBase64 := "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABrnppSh2UjT6uenH1oPjxQAeiAqiEg0hGT4ABgsGe4blNldFdpbmRvd3NIb29rRXhXAAAAVW5ob29rV2luZG93c0hvb2tFeABDYWxsTmV4dEhvb2tFeAAAAAAAAFNlbmRNZXNzYWdlVGltZW91dFcAQ29DcmVhdGVJbnN0YW5jZQAAAAAAAAAASIlcJAhIiXQkEFdIg+wgSYvYSIvyi/mFyXgjSIXbdB6LBQb///9BOUAQdRJIjQ3d/v//6JgBAACJBfL+//9Iiw3L/v//SI0VdP///+jnAgAASIXAdRBIi1wkMEiLdCQ4SIPEIF/DTIvLTIvGi9czyUiLXCQwSIt0JDhIg8QgX0j/4MzMzMzMzDPAw8zMzMzMQFNWSIPsSIvySIvZSIXJdQy4VwAHgEiDxEheW8NIi0kISI1UJGBIiVQkKEG4/////0iNVCQwSIl8JEAz/0iJVCQgiXwkYIvWSIsBRI1PAf9QKIXAeHJIOXwkMHRrOXwkYHRlSItLCEiNVCR4SIl8JHhIiwH/UEiL+IXAeDJIi0wkeEiFyXQoSIsBSI1UJHBMi0QkMEyNSxBIiVQkIIvW/1AgSItMJHiL+EiLAf9QEEiLTCQwSIsB/1AQi8dIi3wkQEiDxEheW8NIi3wkQLgBAAAASIPESF5bw8zMzMzMzMxIhcl0VEiF0nRPTYXAdEpIiwJIhcB1HUi4wAAAAAAAAEZIOUIIdCxJxwAAAAAAuAJAAIDDSbkD6ICqISDSEUk7wXXkSLiT4ABgsGe4bkg5Qgh11EmJCDPAw7hXAAeAw8xAU0iD7EBIi9lIjZHYAAAASItJCOhPAQAASIXAdQu4AQAAAEiDxEBbwzPJx0QkWAEAAABIjVQkaEiJTCRoSIlUJCBMjUt4M9JIiUwkYEiJTCQwiUwkUEiNS2hEjUIX/9CFwA+I7wAAAEiLTCRoSIXJD4ThAAAASIsBSI1UJFD/UBiFwA+IhQAAAEiLTCRoSI1UJGBIiwH/UDiFwHhxSItMJGBIhcl0bEiLAUiNVCQw/1AwhcB4WEiLTCQwSIXJdGZIjUNISIlLMEiJQyhMjUMoSI0Vyf7//0G5AwAAAEiJEEiNBdH9//9IiUNQSI1UJFhIiUNYSI0Fxf3//0iJQ2BIiwFIiVQkIItUJFD/UBhIi0wkYEiLVCQwSIXSdA5IiwJIi8r/UBBIi0wkYEiFyXQGSIsB/1AQSItMJGhIhcl0BkiLAf9QEItEJFj32BvAg+AESIPEQFvDuAQAAABIg8RAW8PMzMzMzMxIiVwkCEiJbCQQSIl0JBhIiXwkIEyL2kyL0UiFyXRwSIXSdGtIY0E8g7wIjAAAAAB0XYuMCIgAAACFyXRSRYtMCiBJjQQKi3AkTQPKi2gcSQPyi3gYSQPqD7YaRTPA/89BixFJA9I6GnUZD7bLSYvDSSvThMl0Lw+2SAFI/8A6DAJ08EH/wEmDwQREO8d20TPASItcJAhIi2wkEEiLdCQYSIt8JCDDSWPAD7cMRotEjQBJA8Lr28zMSIlcJAhIiWwkEEiJdCQYSIl8JCBBVkiD7EBIixlIjZGIAAAASIv5SIvL6Bn///9IjZfEAAAASIvLSIvw6Af///9IjZecAAAASIvLSIvo6PX+//9Mi/BIhfZ0ZUiF7XRgSIXAdFtEi08YSI0VoPv//0UzwEGNSAT/1kiL8EiFwHUFjUYC6z+LVxwzwEiLTxBFM8lIiUQkMEUzwMdEJCjIAAAAiUQkIP/VSIvOSIvYQf/WSIXbdQWNQwPrCotHIOsFuAEAAABIi1wkUEiLbCRYSIt0JGBIi3wkaEiDxEBBXsM="
else
shellcodeBase64 := "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAGuemlKHZSNPq56cfWg+PFAB6ICqISDSEZPgAGCwZ7huU2V0V2luZG93c0hvb2tFeFcAAABVbmhvb2tXaW5kb3dzSG9va0V4AENhbGxOZXh0SG9va0V4AAAAAAAAU2VuZE1lc3NhZ2VUaW1lb3V0VwBDb0NyZWF0ZUluc3RhbmNlAAAAAFZX6MkCAACDfCQMAIvwi3wkFHwYhf90FItPCDtOEHUMVuhqAQAAg8QEiUYUjYaIAAAAUP826J4CAACDxAiFwHUFX17CDABX/3QkFP90JBRqAP/QX17CDAAzwMIEAMzMzIPsFFaLdCQchfZ1DLhXAAeAXoPEFMIIAItOBI1UJARSjVQkEMdEJAgAAAAAUosBagFq//90JDBR/1AUhcB4bIN8JAwAdGWDfCQEAHRei04EjVQkHFfHRCQgAAAAAFKLAVH/UCSL+IX/eC2LVCQghdJ0JYsCi0gQjUQkDFCNRghQ/3QkGP90JDBS/9GL+ItEJCBQiwj/UQiLRCQQUIsI/1EIi8dfXoPEFMIIALgBAAAAXoPEFMIIAMyLTCQIVot0JAiF9nRfhcl0W4tUJBCF0nRTiwELQQR1IYF5CMAAAAB1CYF5DAAAAEZ0MscCAAAAALgCQACAXsIMAIE5A+iAqnXpgXkEISDSEXXggXkIk+AAYHXXgXkMsGe4bnXOiTIzwF7CDAC4VwAHgF7CDADMzMyD7BBWi3QkGI2GsAAAAFD/dgToMQEAAIvIg8QIhcl1CI1BAV6DxBDDjUQkBMdEJAQAAAAAUI1GUMdEJBwAAAAAUGoXagCNRkDHRCQYAAAAAFDHRCQgAAAAAMdEJCQBAAAA/9GFwA+IywAAAItMJASFyQ+EvwAAAIsBjVQkDFdSUf9QDIXAeHCLTCQIjVQkHFJRiwH/UByFwHhdi0wkHIXJdFmLAY1UJAxSUf9QGIXAeEaLfCQMhf90UI1OMIl+HLjcAQAAiU4YA8aNVhiJAYvGBRwBAACNTCQUUYlGNIlGOLgkAQAAagMDxlL/dCQciUY8iwdX/1AMi0wkHItUJAyF0nQKiwJS/1AIi0wkHF+FyXQGiwFR/1AIi0wkBIXJdAaLAVH/UAiLRCQQ99heG8CD4ASDxBDDuAQAAABeg8QQw7gAAAAAw8zMg+wIU1VWV4t8JByF/w+EgQAAAItcJCCF23R5i0c8g3w4fAB0b4tEOHiFwHRni0w4JDP2i1Q4IAPPi2w4GAPXiUwkEItMOBwDz4lUJByJTCQUTYorixSyA9c6KnUTis2LwyvThMl0FIpIAUA6DAJ080Y79Xcfi1QkHOvZi0QkEItMJBQPtwRwiwSBA8dfXl1bg8QIw19eXTPAW4PECMPMzFNVVleLfCQUizeNR2BQVuhM////iUQkHI2HnAAAAFBW6Dv///+L2I1HdFBW6C////+LTCQsg8QYi+iFyXRshdt0aIXtdGSLxwWUAwAAiXgBuMQAAAD/dwwDx2oAUGoE/9GJRCQUhcB1DF9eXbgCAAAAW8IEAGoAaMgAAABqAGoAagD/dxD/dwj/0/90JBSL8P/VhfZ1Cl+NRgNeXVvCBACLRxRfXl1bwgQAX15duAEAAABbwgQA"
len := StrLen(shellcodeBase64)
shellcode := Buffer(len * 0.75)
if !DllCall("crypt32\CryptStringToBinary", "str", shellcodeBase64, "uint", len, "uint", 1, "ptr", shellcode, "uint*", shellcode.Size, "ptr", 0, "ptr", 0)
return
return shellcode
}
static link(x64, shellcode, shellcodeBase, user32Base, combaseBase, hwnd, tid, msg, &pThreadProc, &pRect) {
if x64 {
NumPut("uint64", user32Base, shellcode, 0)
NumPut("uint64", combaseBase, shellcode, 8)
NumPut("uint64", hwnd, shellcode, 16)
NumPut("uint", tid, shellcode, 24)
NumPut("uint", msg, shellcode, 28)
pThreadProc := shellcodeBase + 0x4e0
pRect := shellcodeBase + 56
}
else {
NumPut("uint", user32Base, shellcode, 0)
NumPut("uint", combaseBase, shellcode, 4)
NumPut("uint", hwnd, shellcode, 8)
NumPut("uint", tid, shellcode, 12)
NumPut("uint", msg, shellcode, 16)
pThreadProc := shellcodeBase + 0x43c
pRect := shellcodeBase + 32
}
}
static msgWaitForSingleObject(handle) {
while 1 == res := DllCall("MsgWaitForMultipleObjects", "uint", 1, "ptr*", handle, "int", false, "uint", -1, "uint", 7423) {
msg := Buffer(A_PtrSize == 8 ? 48 : 28)
while DllCall("PeekMessageW", "ptr", msg, "ptr", 0, "uint", 0, "uint", 0, "uint", 1) {
DllCall("TranslateMessage", "ptr", msg)
DllCall("DispatchMessageW", "ptr", msg)
}
}
return res
}
}
getCaretPosFromMSAA_2() {
if (!hOleacc := DllCall("LoadLibraryW", "Str", "oleacc.dll", "Ptr"))
return false
idObject := 0xFFFFFFF8
IID_IAccessible := -16 + NumPut("int64", idObject == 0xFFFFFFF0 ? 0x46000000000000C0 : 0x719B3800AA000C81
, NumPut("int64", idObject == 0xFFFFFFF0 ? 0x0000000000020400 : 0x11CF3C3D618736E0
, IID := Buffer(16)))
if DllCall("oleacc\AccessibleObjectFromWindow"
, "ptr", hwnd
, "uint", idObject &= 0xFFFFFFFF
, "ptr", IID_IAccessible
, "ptr*", oAcc := ComValue(9, 0)) == 0 {
x := Buffer(4), y := Buffer(4), w := Buffer(4), h := Buffer(4)
try {
oAcc.accLocation(ComValue(0x4003, x.ptr, 1), ComValue(0x4003, y.ptr, 1), ComValue(0x4003, w.ptr, 1), ComValue(0x4003, h.ptr, 1), 0)
} catch as e {
return false
}
X := NumGet(x, 0, "int"),
Y := NumGet(y, 0, "int"),
W := NumGet(w, 0, "int"),
H := NumGet(h, 0, "int")
if (W < 1)
H := 0
if (X | Y) != 0 {
left := X
right := left + W
top := Y
bottom := top + H
fixDPIScaleMSAA(&left, &top, &right, &bottom)
cartetDetectMethod := "getCaretPosFromMSAA_2"
return true
}
}
return false
}
getCaretPosFromMSAA_1() {
if !hOleacc := DllCall("LoadLibraryW", "str", "oleacc.dll", "ptr") {
return false
}
hOleacc := { Ptr: hOleacc, __Delete: (_) => DllCall("FreeLibrary", "ptr", _) }
static IID_IAccessible := guidFromString("{618736e0-3c3d-11cf-810c-00aa00389b71}")
if !DllCall("oleacc\AccessibleObjectFromWindow"
, "ptr", hwnd
, "uint", 0xfffffff8
, "ptr", IID_IAccessible
, "ptr*", accCaret := ComValue(13, 0), "int") {
if A_PtrSize == 8 {
varChild := Buffer(24, 0)
NumPut("ushort", 3, varChild)
hr := ComCall(22, accCaret, "int*", &x := 0, "int*", &y := 0, "int*", &w := 0, "int*", &h := 0, "ptr", varChild, "int")
} else {
hr := ComCall(22, accCaret, "int*", &x := 0, "int*", &y := 0, "int*", &w := 0, "int*", &h := 0, "int64", 3, "int64", 0, "int")
}
if !hr {
pt := x | y << 32
DllCall("ScreenToClient", "ptr", hwnd, "int64*", &pt)
left := pt & 0xffffffff
top := pt >> 32
right := left + w
bottom := top + h
scaleRect(getWinScale(hwnd), &left, &top, &right, &bottom)
clientToScreenRect(hwnd, &left, &top, &right, &bottom)
fixDPIScaleMSAA(&left, &top, &right, &bottom)
cartetDetectMethod := "getCaretPosFromMSAA_1"
return true
}
}
return false
}
static guidFromString(str) {
DllCall("ole32\CLSIDFromString", "str", str, "ptr", buf := Buffer(16), "hresult")
return buf
}
static getRect(buf, &left, &top, &right, &bottom) {
left := NumGet(buf, 0, "int")
top := NumGet(buf, 4, "int")
right := NumGet(buf, 8, "int")
bottom := NumGet(buf, 12, "int")
}
static getWinScale(hwnd := getActiveHWND()) {
if winDpi := DllCall("GetDpiForWindow", "ptr", hwnd, "uint")
return A_ScreenDPI / winDpi
return 1
}
static scaleRect(scale, &left, &top, &right, &bottom) {
left := Round(left * scale)
top := Round(top * scale)
right := Round(right * scale)
bottom := Round(bottom * scale)
}
static fixDPIScaleMSAA(&left, &top, &right, &bottom) {
scale := getWinScale()
monitor := ActiveMonitor.init(&monL, &monT, &monR, &monB)
l := Round((left - monL) * scale)
t := Round((top - monT) * scale)
r := Round((right - monL) * scale)
b := Round((bottom - monT) * scale)
left := monL + l
top := monT + t
right := monL + r
bottom := monT + b
}
static fixDPIScaleHook(&left, &top, &right, &bottom) {
scale := getWinScale()
left := Round(left / scale)
top := Round(top / scale)
right := Round(right / scale)
bottom := Round(bottom / scale)
}
static clientToScreenRect(hwnd, &left, &top, &right, &bottom) {
w := right - left
h := bottom - top
pt := left | top << 32
DllCall("ClientToScreen", "ptr", hwnd, "int64*", &pt)
left := pt & 0xffffffff
top := pt >> 32
right := left + w
bottom := top + h
}
static getClassName(hwnd := getActiveHWND()) {
className := ""
try {
className := WinGetClass(hwnd)
} catch as e {
className := "unknown"
}
return className
}
static getActiveHWND() {
hwnd := 0
try {
hwnd := WinGetID("A")
} catch as e {
hwnd := 0
}
return hwnd
}
}
global maxInt := 4294967296
global halfMaxInt := 2147483648
handleMaxInt(&num1, &num2, &num3, &num4) {
global halfMaxInt, maxInt
if (num1 > halfMaxInt)
num1 := num1 - maxint
if (num2 > halfMaxInt)
num2 := num2 - maxint
if (num3 > halfMaxInt)
num3 := num3 - maxint
if (num4 > halfMaxInt)
num4 := num4 - maxint
return true
}
#Requires AutoHotkey v2.0
DebugCaretPosition(l, t, r, b, detectMethod) {
win := ActiveMonitor.getActiveWinRect()
winRect := ActiveMonitor.winRect
posData := ""
if (win) {
winCenterX := Round((winRect.r + winRect.l) / 2)
winCenterY := Round((winRect.b + winRect.t) / 2)
isCaretOutside := false
if (l < winRect.l or r > winRect.r or t < winRect.t or b > winRect.b)
isCaretOutside := true
if (isCaretOutside) {
posData .= "(outside of window!) "
}
}
method := 'detection method:  ' detectMethod "`n"
monitorID := ActiveMonitor.init(&monL, &monT, &monR, &monB)
posData .= "caret:  l=" l "  t=" t "  W=" r - l "  H=" b - t "`n"
scale := ActiveMonitor.getActiveWinScale()
monitorData := "active monitor:  id=" monitorID "  scale=" scale "  l=" monL "  t=" monT "  r=" monR "  b=" monB "`n"
windowData := "window:  l=" winRect.l "  t=" winRect.t "  r=" winRect.r "  b=" winRect.b "`n"
virtualScreen := _virtualScreenData() "`n"
Log(method posData monitorData windowData virtualScreen)
}
_virtualScreenData() {
monsX := SysGet(76)
monsY := SysGet(77)
monsW := SysGet(78)
monsH := SysGet(79)
mons := "virtual screen:  x=" monsX "  y=" monsY "  w=" monsW "  h=" monsH "`n"
return mons
}
#requires AutoHotkey v2.0
#requires AutoHotkey v2.0
class AnyKeyState {
static pressed := false
static _initialized := false
static _hook := ""
static Init() {
if this._initialized
return
this._initialized := true
this._hook := InputHook("V")
this._hook.KeyOpt("{All}", "N")
this._hook.OnKeyDown := (*) => AnyKeyState.pressed := true
this._hook.OnKeyUp   := (*) => AnyKeyState.pressed := false
this._hook.Start()
Hotkey "~*LButton",     (*) => AnyKeyState.pressed := true
Hotkey "~*RButton",     (*) => AnyKeyState.pressed := true
Hotkey "~*MButton",     (*) => AnyKeyState.pressed := true
Hotkey "~*XButton1",    (*) => AnyKeyState.pressed := true
Hotkey "~*XButton2",    (*) => AnyKeyState.pressed := true
Hotkey "~*LButton Up",  (*) => AnyKeyState.pressed := false
Hotkey "~*RButton Up",  (*) => AnyKeyState.pressed := false
Hotkey "~*MButton Up",  (*) => AnyKeyState.pressed := false
Hotkey "~*XButton1 Up", (*) => AnyKeyState.pressed := false
Hotkey "~*XButton2 Up", (*) => AnyKeyState.pressed := false
}
}
GetAnyKeyState() {
AnyKeyState.Init()
return AnyKeyState.pressed
}
class WhileIdleCache {
__New(fn, refreshAfter) {
this.fn := fn
this.refreshAfter := refreshAfter
this.cache := ""
this.cachedAt := 0
}
Call() {
if this._needsRefresh() {
this.cache := (this.fn)()
this.cachedAt := A_TickCount
}
return this.cache
}
_needsRefresh() {
if this.cache == ""
return true
if GetAnyKeyState()
return true
return (A_TickCount - this.cachedAt) > this.refreshAfter
}
}
UseCachedWhileIdle(fn, refreshAfter := 100) {
return WhileIdleCache(fn, refreshAfter)
}
class CaretIndicator extends IndicatorBase {
static DefaultConfig := {
debug: false,
debugCaretPosition: false,
files: {
capslockSuffix: "-capslock",
folderExistCheckPeriod: 1000,
folder: A_ScriptDir . "\carets\",
extensions: [".png", ".gif"]
},
markMargin: { x: 1, y: -1 },
inputCheckPeriod: 100,
markRepaintPeriod: 16,
positionCacheTtl: 1000,
}
__New(cfg?) {
if !IsSet(cfg)
cfg := CaretIndicator.DefaultConfig
super.__New(cfg)
this.getCachedPosition := UseCachedWhileIdle(
() => this.ComputePosition(),
this.cfg.positionCacheTtl
)
}
UseMarkFile() {
markFile := MarkResolver.GetMarkFile(this.cfg.files, this.inputState.locale, this.inputState.capslock)
if (markFile == "") {
this.currentMarkObj := ""
this.markPainter.RemoveWindow()
return
}
SplitPath(markFile, &markName)
this.currentMarkObj := { name: markName, image: markFile }
this.PaintMark(this.currentMarkObj)
}
GetPosition() {
return this.getCachedPosition.Call()
}
ComputePosition() {
left := -1, top := -1, bottom := -1, right := -1
detectMethod := ""
GetCaretRect(&left, &top, &right, &bottom, &detectMethod)
w := right - left
h := bottom - top
return { left: left, top: top, right: right, bottom: bottom, w: w, h: h, detectMethod: detectMethod }
}
PaintMark(markObj) {
if (!markObj.image or 2 > StrLen(markObj.image)) {
this.markPainter.RemoveWindow()
this.markPainter.Clear()
return
}
pos := this.GetPosition()
if this.cfg.debugCaretPosition
DebugCaretPosition(pos.left, pos.top, pos.right, pos.bottom, pos.detectMethod)
if (InStr(pos.detectMethod, "failure") or (pos.w < 1 and pos.h < 1)) {
this.markPainter.HideWindow()
return
}
this.markPainter.StorePrev()
this.markPainter.current.name := markObj.name
this.markPainter.current.image := markObj.image
this.markPainter.current.x := pos.left
this.markPainter.current.y := pos.top
this.markPainter.Paint()
}
}
#requires AutoHotkey v2.0
#requires AutoHotkey v2.0
#requires AutoHotkey v2.0
TickCount() {
DllCall("QueryPerformanceFrequency", "Int64*", &freq := 0)
DllCall("QueryPerformanceCounter", "Int64*", &counter := 0)
return Floor(counter / (freq / 1000))
}
zeroSpeed := { x: 0, y: 0, period: 100 }
zeroPos := { x: -1, y: -1, time: 0, speed: zeroSpeed }
global mouseState := {
maxPredictionDelay: 50 + 16,
maxPredictionSpeed: 24,
curr: zeroPos,
prev: zeroPos,
hoveredWindow: 0,
}
GetMousePos(predictionAmount := 0) {
global mouseState
GetMouseData()
if predictionAmount <= 0 {
return {
x: mouseState.curr.x,
y: mouseState.curr.y
}
}
p0 := mouseState.curr
p1 := mouseState.prev
prediction := {
x: p0.speed.x * 0.65 + p1.speed.x * 0.35,
y: p0.speed.y * 0.65 + p1.speed.y * 0.35
}
factor := predictionAmount * 1.25
return {
x: p0.x + Flooor(prediction.x * factor),
y: p0.y + Flooor(prediction.y * factor)
}
}
GetMouseData() {
global mouseState
CoordMode "Mouse", "Screen"
MouseGetPos(&mx, &my, &wnd)
time := TickCount()
pos := { x: mx, y: my, time: time }
speed := GetSpeed(pos, mouseState.curr)
mouseState.prev := mouseState.curr
mouseState.curr := { x: pos.x, y: pos.y, time: time, speed: speed, hoveredWindow: wnd }
return mouseState.curr
}
GetSpeed(posCurr, posPrev) {
period := posCurr.time - posPrev.time
if (period < 1 or period > mouseState.maxPredictionDelay)
return zeroSpeed
x := posCurr.x - posPrev.x
y := posCurr.y - posPrev.y
maxSpeed := mouseState.maxPredictionSpeed
if (x > maxSpeed)
x := maxSpeed
if (y > maxSpeed)
y := maxSpeed
if (x < maxSpeed * -1)
x := maxSpeed * -1
if (y < maxSpeed * -1)
y := maxSpeed * -1
return { x: x, y: y, period: period }
}
Flooor(n) {
if n > 0
return Floor(n)
return -1 * Floor(Abs(n))
}
#requires AutoHotkey v2.0
GetCursorSize(&w, &h) {
w := 32, h := 32
cursorInfo := Buffer(16 + A_PtrSize, 0)
NumPut("uint", cursorInfo.Size, cursorInfo, 0)
if !DllCall("GetCursorInfo", "ptr", cursorInfo)
return false
hCursor := NumGet(cursorInfo, 8, "ptr")
if !hCursor
return false
iconInfo := Buffer(8 + A_PtrSize * 3, 0)
if !DllCall("GetIconInfo", "ptr", hCursor, "ptr", iconInfo)
return false
hbmMask := NumGet(iconInfo, 8 + A_PtrSize, "ptr")
hbmColor := NumGet(iconInfo, 8 + A_PtrSize * 2, "ptr")
bmp := Buffer(24, 0)
hBitmap := hbmColor ? hbmColor : hbmMask
if DllCall("GetObject", "ptr", hBitmap, "int", 24, "ptr", bmp) {
w := NumGet(bmp, 4, "int")
h := NumGet(bmp, 8, "int")
}
if hbmMask
DllCall("DeleteObject", "ptr", hbmMask)
if hbmColor
DllCall("DeleteObject", "ptr", hbmColor)
return true
}
GetDefaultCursorSize(&w, &h) {
w := SysGet(13)
h := SysGet(14)
}
GetCursorScale() {
try {
size := RegRead("HKCU\Control Panel\Cursors", "CursorBaseSize")
return size / 32
} catch {
return 1
}
}
GetScaledCursorSize(&w, &h) {
GetDefaultCursorSize(&baseW, &baseH)
scale := GetCursorScale()
w := Round(baseW * scale)
h := Round(baseH * scale)
}
class CursorIndicator extends IndicatorBase {
static DefaultConfig := {
debug: false,
files: {
capslockSuffix: "-capslock",
folderExistCheckPeriod: 1000,
folder: A_ScriptDir . "\cursors\",
extensions: [".cur", ".ani", ".ico", ".png"]
},
markMargin: { x: 10, y: -10, useCursorSize: true },
mousePositionPrediction: 0.5,
target: {
cursorId: 32513,
cursorName: "IBeam"
},
inputCheckPeriod: 100,
markRepaintPeriod: 6,
}
__New(cfg?) {
if !IsSet(cfg)
cfg := CursorIndicator.DefaultConfig
super.__New(cfg)
this.modifiedCursorsCount := 0
if (cfg.markMargin.useCursorSize)
this.markPainter.margin := this.GetCursorSizeMargin()
}
Check() {
if (A_Cursor != this.cfg.target.cursorName) {
this.RevertCursors()
this.currentMarkObj := ""
this.markPainter.HideWindow()
return
}
this.inputState.Update()
this.FolderExists()
? this.UseFile()
: this.UseMarkEmbedded()
}
Repaint() {
if (this.currentMarkObj == "")
return
if (A_Cursor != this.cfg.target.cursorName) {
this.markPainter.HideWindow()
return
}
this.PaintMark(this.currentMarkObj)
}
UseFile() {
filePath := MarkResolver.GetMarkFile(this.cfg.files, this.inputState.locale, this.inputState.capslock)
if (filePath == "") {
this.currentMarkObj := ""
this.RevertCursors()
this.markPainter.HideWindow()
return
}
SplitPath(filePath, , , &ext)
if (ext = "png")
this.UseMarkPngFile(filePath)
else
this.UseCursorFile(filePath)
}
UseMarkPngFile(filePath) {
this.RevertCursors()
SplitPath(filePath, &fileName)
this.currentMarkObj := { name: fileName, image: filePath }
this.PaintMark(this.currentMarkObj)
}
UseCursorFile(cursorFile := "") {
this.currentMarkObj := ""
if (cursorFile == "") {
this.RevertCursors()
return
}
this.markPainter.HideWindow()
this.SetCursorFromFile(cursorFile)
}
GetPosition() {
return GetMousePos(this.cfg.mousePositionPrediction)
}
GetCursorSizeMargin() {
GetScaledCursorSize(&w, &h)
marginX := Round(w / 6) + this.cfg.markMargin.x
marginY := Round(h / 4) + this.cfg.markMargin.y
return { x: marginX, y: -marginY }
}
PaintMark(markObj, cursor := "IBeam") {
if (cursor != 0 and cursor != A_Cursor) {
this.markPainter.HideWindow()
this.markPainter.Clear()
return
}
if (!markObj.image or 10 > StrLen(markObj.image)) {
this.markPainter.RemoveWindow()
this.markPainter.Clear()
return
}
pos := this.GetPosition()
if (pos.x == -1 or pos.y == -1) {
this.markPainter.HideWindow()
this.markPainter.Clear()
return
}
this.markPainter.StorePrev()
this.markPainter.current.name := markObj.name
this.markPainter.current.image := markObj.image
this.markPainter.current.x := pos.x
this.markPainter.current.y := pos.y
this.markPainter.Paint()
}
SetCursorFromFile(filePath := "") {
if (!filePath or filePath == "")
return
if FileExist(filePath) {
SplitPath(filePath, , , &ext)
if !(ext = "cur" or ext = "ani" or ext = "ico")
return
} else {
return
}
cursorHandle := DllCall("LoadCursorFromFile", "Str", filePath)
DllCall("SetSystemCursor", "Uint", cursorHandle, "Int", this.cfg.target.cursorId)
this.modifiedCursorsCount += 1
}
RevertCursors() {
if this.modifiedCursorsCount == 0
return
SPI_SETCURSORS := 0x57
DllCall("SystemParametersInfo", "UInt", SPI_SETCURSORS, "UInt", 0, "UInt", 0, "UInt", 0)
this.modifiedCursorsCount := 0
}
OnExit(reason, code) {
if !(reason ~= IndicatorBase.SHUTDOWN_REASONS)
this.RevertCursors()
super.OnExit(reason, code)
}
}
#requires AutoHotkey v2.0
merge(base, override) {
for key, value in override.OwnProps() {
base.%key% := value
}
return base
}
class LanguageIndicator {
static Version := "0.78"
__New(cfg?) {
defaultCfg := {
caret: {
inputCheckPeriod: 50,
markRepaintPeriod: 16,
markMargin: { x: 1, y: -1 }
},
cursor: {
inputCheckPeriod: 50,
markRepaintPeriod: 6,
markMargin: { x: 2, y: -2, useCursorSize: true }
}
}
this.cfg := IsSet(cfg) ? cfg : defaultCfg
this.caretIndicator := CaretIndicator(merge(CaretIndicator.DefaultConfig, this.cfg.caret))
this.cursorIndicator := CursorIndicator(merge(CursorIndicator.DefaultConfig, this.cfg.cursor))
}
Run() {
this.caretIndicator.Run()
this.cursorIndicator.Run()
}
}
global app := LanguageIndicator()
app.Run()
A_IconTip := "Language Indicator v" . LanguageIndicator.Version
; Optional verification mode; ordinary startup does not create a log.
if (A_Args.Length > 0 && A_Args[1] = "--diagnostics")
SetTimer(WriteBadgeDiagnostics, 500)
WriteBadgeDiagnostics() {
global app, languageProbe
try {
c := app.caretIndicator
p := c.markPainter
pos := c.GetPosition()
visible := p.window != "" ? DllCall("IsWindowVisible", "Ptr", p.window.Hwnd) : 0
entry := {raw: languageProbe, error: p.HasOwnProp("lastError") ? p.lastError : "", time: A_Now, process: WinGetProcessName("A"), locale: c.inputState.locale, capslock: c.inputState.capslock, image: p.current.image, x: p.current.x, y: p.current.y, width: p.current.w, height: p.current.h, visible: visible, detection: pos.detectMethod}
f := FileOpen(A_ScriptDir "\badge-test.json", "w", "UTF-8-RAW")
f.Write(Jsons.Dump(entry))
f.Close()
}
}
