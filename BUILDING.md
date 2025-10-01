# Building Guide

This guide explains the complete build process for 3DS C Builder, from source code to distributable files.

## 🔄 Build Process Overview

The 3DS C Builder follows a multi-stage build process:

```
Source Code → Compilation → Asset Creation → ROM Packaging → Distribution Files
     ↓              ↓              ↓              ↓              ↓
   main.c    →   homebrew.elf  →  banner.bnr  →  MyApp.cia   →  Ready to Install
              →   homebrew.3dsx →  icon.icn   →  MyApp.3ds   →  Ready to Distribute
```

## 📋 Build Requirements

Before building, ensure you have:

- ✅ devkitARM installed and in PATH
- ✅ libctru library available
- ✅ Make tool installed
- ✅ Required assets (banner.png, icon.png, audio.wav)
- ✅ All source files in the `source/` directory

## 🛠️ Build Methods

### Method 1: Automated Build Script (Recommended)

The easiest way to build your project:

```bash
# Windows Command Prompt or PowerShell
build.bat "MyApp" "My Awesome 3DS App" "Your Name"
```

**Parameters:**
- `"MyApp"` - Short name (used for filenames)
- `"My Awesome 3DS App"` - Long name (displayed in 3DS menu)
- `"Your Name"` - Author name

**What it does:**
1. Compiles your source code
2. Creates banner and icon assets
3. Packages into CIA and 3DS formats
4. Outputs ready-to-use files

### Method 2: Manual Build Process

For more control or troubleshooting:

#### Step 1: Compile Source Code
```bash
make
```

**Outputs:**
- `homebrew.elf` - Executable and Linkable Format
- `homebrew.3dsx` - 3DS Executable (for Homebrew Launcher)
- `build/` directory with object files

#### Step 2: Create Banner Asset
```bash
bannertool.exe makebanner -i banner.png -a audio.wav -o banner.bnr
```

**Requirements:**
- `banner.png` - 256x128 pixels, PNG format
- `audio.wav` - WAV format, 16-bit recommended
- `banner.bnr` - Generated banner file

#### Step 3: Create Icon Asset
```bash
bannertool.exe makesmdh -s "MyApp" -l "My Awesome 3DS App" -p "Your Name" -i icon.png -o icon.icn
```

**Requirements:**
- `icon.png` - 48x48 pixels, PNG format
- `icon.icn` - Generated icon with metadata

#### Step 4: Package CIA File
```bash
makerom -f cia -o MyApp.cia -DAPP_ENCRYPTED=false -rsf template.rsf -target t -exefslogo -elf homebrew.elf -icon icon.icn -banner banner.bnr
```

**Parameters:**
- `-f cia` - Output format (CIA)
- `-o MyApp.cia` - Output filename
- `-DAPP_ENCRYPTED=false` - Unencrypted for homebrew
- `-rsf template.rsf` - ROM configuration file
- `-target t` - Target platform (3DS)
- `-exefslogo` - Include Nintendo logo
- `-elf homebrew.elf` - Input executable
- `-icon icon.icn` - Icon file
- `-banner banner.bnr` - Banner file

#### Step 5: Package 3DS File
```bash
makerom -f cci -o MyApp.3ds -DAPP_ENCRYPTED=true -rsf template.rsf -target t -exefslogo -elf homebrew.elf -icon icon.icn -banner banner.bnr
```

**Parameters:**
- `-f cci` - Output format (3DS cartridge)
- `-DAPP_ENCRYPTED=true` - Encrypted for distribution

## 📁 Output Files Explained

### Development Files

| File | Purpose | Usage |
|------|---------|-------|
| `homebrew.elf` | Debug executable | Development, debugging, analysis |
| `homebrew.3dsx` | Homebrew executable | Testing with Homebrew Launcher |

### Distribution Files

| File | Purpose | Usage |
|------|---------|-------|
| `MyApp.cia` | Installable package | Installing on 3DS with CFW |
| `MyApp.3ds` | Cartridge image | Distribution, backup creation |

### Asset Files

| File | Purpose | Created From |
|------|---------|--------------|
| `banner.bnr` | Application banner | `banner.png` + `audio.wav` |
| `icon.icn` | Application icon | `icon.png` + metadata |

## ⚙️ Build Configuration

### Makefile Configuration

The `Makefile` controls the compilation process:

```makefile
# Target name
TARGET := homebrew

# Directories
BUILD := build
SOURCES := source
INCLUDES := include

# Compiler flags
CFLAGS := -g -Wall -O2 -mword-relocations -ffunction-sections
ARCH := -march=armv6k -mtune=mpcore -mfloat-abi=hard -mtp=soft

# Libraries
LIBS := -lctru -lm
```

**Key Settings:**
- `TARGET` - Name of your application
- `SOURCES` - Directory containing C source files
- `INCLUDES` - Directory containing header files
- `CFLAGS` - Compiler optimization and warning flags

### ROM Configuration (template.rsf)

The `template.rsf` file controls ROM packaging:

```yaml
BasicInfo:
  Title: "Your App Name"
  CompanyCode: "00"
  ProductCode: "CTR-P-XXXX"
  ContentType: Application
  Logo: Homebrew

TitleInfo:
  UniqueId: 0xFAA5C  # CHANGE THIS!
  Category: Application

CardInfo:
  MediaSize: 128MB
  MediaType: Card1
  CardDevice: None
```

**Important Settings:**
- `UniqueId` - Must be unique for each app
- `ProductCode` - Should be unique identifier
- `MediaSize` - Storage requirements
- `Title` - Display name

## 🎨 Asset Requirements

### Banner (banner.png)
- **Size**: 256x128 pixels
- **Format**: PNG
- **Content**: Your app's visual banner
- **Usage**: Displayed in 3DS menu

### Icon (icon.png)
- **Size**: 48x48 pixels
- **Format**: PNG
- **Content**: Your app's icon
- **Usage**: Displayed in 3DS menu

### Audio (audio.wav)
- **Format**: WAV
- **Bit Depth**: 16-bit recommended
- **Sample Rate**: 22kHz recommended
- **Usage**: Played when banner is displayed

## 🔧 Advanced Build Options

### Custom Build Targets

Add custom targets to your Makefile:

```makefile
# Debug build
debug: CFLAGS += -DDEBUG -g3
debug: all

# Release build
release: CFLAGS += -DNDEBUG -O3
release: all

# Clean build
clean-all: clean
	rm -f *.cia *.3ds *.bnr *.icn
```

### Multiple Source Files

To add more source files:

1. **Add files to `source/` directory**
2. **Create corresponding headers in `include/`**
3. **Include headers in your source files**

Example:
```c
// source/main.c
#include "my_header.h"

int main() {
    my_function();
    return 0;
}
```

```c
// include/my_header.h
#ifndef MY_HEADER_H
#define MY_HEADER_H

void my_function(void);

#endif
```

### Custom Libraries

To link additional libraries:

1. **Add library to `LIBS` in Makefile**
2. **Add include path to `INCLUDES`**
3. **Ensure library is available in devkitARM**

Example:
```makefile
LIBS := -lctru -lm -lmycustomlib
INCLUDES := include /path/to/mylib/include
```

## 🐛 Build Troubleshooting

### Common Build Errors

**"Please set DEVKITARM in your environment"**
- devkitARM is not installed or not in PATH
- Restart terminal after installation
- Check environment variables

**"No rule to make target"**
- Source file doesn't exist
- Check file paths in Makefile
- Ensure files are in correct directories

**"undefined reference to"**
- Missing library or function
- Check library linking in Makefile
- Verify function declarations

**"bannertool: command not found"**
- bannertool.exe is not in PATH
- Ensure it's in your project directory
- Check file permissions

**"makerom: command not found"**
- makerom.exe is not in PATH
- Ensure it's in your project directory
- Check file permissions

### Build Optimization

**Faster Builds:**
- Use `make -j4` for parallel compilation
- Keep object files in `build/` directory
- Only rebuild changed files

**Smaller Output:**
- Use `-Os` instead of `-O2` for size optimization
- Strip debug symbols: `arm-none-eabi-strip`
- Remove unused functions: `-ffunction-sections -Wl,--gc-sections`

**Debugging:**
- Use `-g` flag for debug symbols
- Use `.elf` files with debuggers
- Add `printf` statements for debugging

## 📊 Build Output Analysis

### File Sizes
- **Typical .3dsx**: 50KB - 500KB
- **Typical .cia**: 100KB - 1MB
- **Typical .3ds**: 100KB - 1MB

### Performance Considerations
- **Startup time**: Keep initialization minimal
- **Memory usage**: Monitor heap usage
- **CPU usage**: Optimize main loop

## 🚀 Deployment

### Testing Your Build

1. **Copy .3dsx to SD card** for Homebrew Launcher testing
2. **Install .cia file** on 3DS with CFW
3. **Test all functionality** before distribution

### Distribution

- **CIA files**: For easy installation
- **3DS files**: For cartridge-style distribution
- **Source code**: For open source projects

---

**Your 3DS homebrew is now built and ready! 🎮**
