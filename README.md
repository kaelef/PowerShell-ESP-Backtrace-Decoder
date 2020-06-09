# PowerShell-ESP-Backtrace-Decoder
Simple PowerShell script to decode ESP backtrace output

This is inspired by https://github.com/me-no-dev/EspExceptionDecoder and https://github.com/littleyoda/EspStackTraceDecoder

Simply reads ESP backtrace output either as a command line argument or through the pipeline and builds a string of arguments with which to execute the Xtensa addr2line utility.

This should work on any system with PowerShell or PowerShell Core and the addr2line utility, although it's only been tested on Windows.  Both ESP8266 and ESP32 projects should work, although only ESP32 has been tested.

## Usage

##### Providing backtrace text in a file as an argument:

```
.\decode-btrace.ps1 -addr2line <addr2line_path> -elf <elf_path> -trace <backtrace_path>
```

addr2line is provided as part of the Espressive SDK's. On systems running PlatformIO it's usually in `<user_profile>\.platformio\packages\toolchain-xtensa32\bin\xtensa-esp32-elf-addr2line.exe`

The ELF file is the compiled binary file.  On systems running PlatformIO, it's usually in `<project_dir>\.pio\build\esp32\firmware.elf`

The backtrace file is any file that contains your backtrace output. The only section that matters is the actual backtrace line(s). e.g.:
```
Backtrace: 0x40152014:0x3ffaf1c0 0x40140bfd:0x3ffaf1e0 0x40141122:0x3ffaf200 0x40141c5b:0x3ffaf220 0x40141b3d:0x3ffaf240 0x40141d48:0x3ffaf260 0x4013c75c:0x3ffaf280 0x4008d499:0x3ffaf2b0
```

##### Providing backtrace text in pipeline:

```
"backtrace-text" | decode-btrace.ps1 -addr2line <addr2line_path> -elf <elf_path>
```

