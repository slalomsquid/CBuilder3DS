# File Structure Documentation

This document provides a comprehensive overview of every file and directory in the 3DS C Builder project.

## 📁 Directory Structure

```
CBuilder3DS/
├── 📁 source/                 # Source code directory
├── 📁 include/               # Header files directory
├── 📁 build/                 # Build output directory
├── 📄 README.md              # Project overview and quick start
├── 📄 SETUP.md               # Detailed setup instructions
├── 📄 BUILDING.md            # Build process documentation
├── 📄 FILE_STRUCTURE.md      # This file
├── 📄 LICENSE                # Project license
├── 📄 Makefile               # Build configuration
├── 📄 build.bat              # Automated build script
├── 📄 template.rsf           # ROM configuration template
├── 🖼️ banner.png             # Application banner image
├── 🖼️ icon.png               # Application icon image
├── 🎵 audio.wav              # Application audio file
├── 🔧 bannertool.exe         # Asset creation tool
├── 🔧 makerom.exe            # ROM packaging tool
├── 📦 banner.bnr             # Generated banner file
├── 📦 icon.icn               # Generated icon file
├── 📦 homebrew.3dsx          # Generated 3DS executable
├── 📦 homebrew.elf           # Generated ELF executable
└── 📁 .git/                  # Git repository data
```

## 📂 Directory Details

### `/source/` - Source Code Directory
**Purpose**: Contains all C source code files for your 3DS application.

**Contents**:
- `main.c` - Main application source code
- Additional `.c` files as needed

**Usage**: Add your C source files here. The Makefile automatically includes all `.c` files in this directory.

**Example Structure**:
```
source/
├── main.c           # Main application entry point
├── graphics.c       # Graphics-related functions
├── input.c          # Input handling functions
└── utils.c          # Utility functions
```

### `/include/` - Header Files Directory
**Purpose**: Contains header files (`.h`) for your application.

**Contents**: Currently empty, but you can add:
- `graphics.h` - Graphics function declarations
- `input.h` - Input handling declarations
- `utils.h` - Utility function declarations

**Usage**: Add header files here and include them in your source files using `#include "filename.h"`.

### `/build/` - Build Output Directory
**Purpose**: Contains intermediate build files and object files.

**Contents**:
- `*.o` - Object files (compiled source)
- `*.d` - Dependency files
- `*.lst` - Assembly listing files
- `*.map` - Memory map files

**Usage**: This directory is automatically created and managed by the build system. You typically don't need to modify files here.

## 📄 Core Files

### `README.md`
**Purpose**: Main project documentation and quick start guide.

**Contents**:
- Project overview
- Prerequisites
- Quick start instructions
- Usage examples
- Troubleshooting

**When to modify**: Update when adding new features or changing the build process.

### `SETUP.md`
**Purpose**: Detailed setup instructions for development environment.

**Contents**:
- System requirements
- Step-by-step installation
- Environment configuration
- Troubleshooting setup issues

**When to modify**: Update when setup requirements change or new tools are needed.

### `BUILDING.md`
**Purpose**: Comprehensive build process documentation.

**Contents**:
- Build process overview
- Manual and automated build methods
- Configuration options
- Troubleshooting build issues

**When to modify**: Update when build process changes or new build options are added.

### `FILE_STRUCTURE.md`
**Purpose**: This file - documents the project structure.

**Contents**:
- Directory explanations
- File purposes
- Usage guidelines

**When to modify**: Update when project structure changes.

### `LICENSE`
**Purpose**: Project license information.

**Contents**: License text specifying how the project can be used, modified, and distributed.

**When to modify**: Update when license terms change.

## ⚙️ Configuration Files

### `Makefile`
**Purpose**: Build system configuration for compiling C source code.

**Key Sections**:
```makefile
# Target configuration
TARGET := homebrew
BUILD := build
SOURCES := source
INCLUDES := include

# Compiler settings
CFLAGS := -g -Wall -O2 -mword-relocations -ffunction-sections
ARCH := -march=armv6k -mtune=mpcore -mfloat-abi=hard -mtp=soft

# Libraries
LIBS := -lctru -lm
```

**When to modify**:
- Adding new source directories
- Changing compiler flags
- Adding new libraries
- Modifying build targets

### `template.rsf`
**Purpose**: ROM configuration template for packaging applications.

**Key Sections**:
```yaml
BasicInfo:
  Title: "Your App Name"
  CompanyCode: "00"
  ProductCode: "CTR-P-XXXX"
  UniqueId: 0xFAA5C  # MUST BE UNIQUE!

CardInfo:
  MediaSize: 128MB
  MediaType: Card1

SystemControlInfo:
  SaveDataSize: 128KB
  StackSize: 0x40000
```

**When to modify**:
- Changing app metadata
- Modifying system permissions
- Adjusting memory requirements
- Setting unique identifiers

### `build.bat`
**Purpose**: Automated build script for Windows.

**What it does**:
1. Prompts for app name, long name, and author
2. Runs `make` to compile source code
3. Creates banner and icon assets
4. Packages into CIA and 3DS formats

**Parameters**:
```bash
build.bat [short_name] [long_name] [author_name]
```

**When to modify**:
- Adding new build steps
- Changing asset creation process
- Modifying packaging options

## 🎨 Asset Files

### `banner.png`
**Purpose**: Visual banner displayed in the 3DS menu.

**Requirements**:
- Size: 256x128 pixels
- Format: PNG
- Content: Your app's visual representation

**Usage**: Replaced with your own banner image. Used by `bannertool.exe` to create `banner.bnr`.

### `icon.png`
**Purpose**: Icon displayed in the 3DS menu.

**Requirements**:
- Size: 48x48 pixels
- Format: PNG
- Content: Your app's icon

**Usage**: Replaced with your own icon image. Used by `bannertool.exe` to create `icon.icn`.

### `audio.wav`
**Purpose**: Audio played when the banner is displayed.

**Requirements**:
- Format: WAV
- Bit depth: 16-bit recommended
- Sample rate: 22kHz recommended

**Usage**: Replaced with your own audio file. Used by `bannertool.exe` to create `banner.bnr`.

## 🔧 Tool Files

### `bannertool.exe`
**Purpose**: Creates banner and icon assets for 3DS applications.

**Usage**:
```bash
# Create banner
bannertool.exe makebanner -i banner.png -a audio.wav -o banner.bnr

# Create icon
bannertool.exe makesmdh -s "ShortName" -l "Long Name" -p "Author" -i icon.png -o icon.icn
```

**Source**: Part of the devkitPro toolchain.

### `makerom.exe`
**Purpose**: Packages applications into CIA and 3DS formats.

**Usage**:
```bash
# Create CIA file
makerom -f cia -o MyApp.cia -DAPP_ENCRYPTED=false -rsf template.rsf -target t -exefslogo -elf homebrew.elf -icon icon.icn -banner banner.bnr

# Create 3DS file
makerom -f cci -o MyApp.3ds -DAPP_ENCRYPTED=true -rsf template.rsf -target t -exefslogo -elf homebrew.elf -icon icon.icn -banner banner.bnr
```

**Source**: Part of the devkitPro toolchain.

## 📦 Generated Files

### `banner.bnr`
**Purpose**: Binary banner file used in final ROM packages.

**Created by**: `bannertool.exe makebanner`
**Contains**: Banner image and audio data
**Usage**: Included in CIA and 3DS files

### `icon.icn`
**Purpose**: Binary icon file with metadata.

**Created by**: `bannertool.exe makesmdh`
**Contains**: Icon image and application metadata
**Usage**: Included in CIA and 3DS files

### `homebrew.3dsx`
**Purpose**: 3DS executable for Homebrew Launcher.

**Created by**: `make` command
**Usage**: Testing and development
**Installation**: Copy to SD card for Homebrew Launcher

### `homebrew.elf`
**Purpose**: ELF executable for debugging and analysis.

**Created by**: `make` command
**Usage**: Development, debugging, analysis
**Tools**: Can be used with debuggers and analysis tools

## 🔄 File Relationships

### Build Dependencies
```
source/main.c → build/main.o → homebrew.elf → homebrew.3dsx
banner.png + audio.wav → banner.bnr
icon.png → icon.icn
homebrew.elf + banner.bnr + icon.icn + template.rsf → MyApp.cia
homebrew.elf + banner.bnr + icon.icn + template.rsf → MyApp.3ds
```

### Input/Output Flow
```
Input Files:
├── source/*.c (your code)
├── include/*.h (headers)
├── banner.png (banner image)
├── icon.png (icon image)
├── audio.wav (banner audio)
└── template.rsf (ROM config)

Output Files:
├── homebrew.3dsx (for testing)
├── homebrew.elf (for debugging)
├── MyApp.cia (for installation)
└── MyApp.3ds (for distribution)
```

## 📝 File Modification Guidelines

### Files You Should Modify
- `source/main.c` - Your application code
- `include/*.h` - Your header files
- `banner.png` - Your banner image
- `icon.png` - Your icon image
- `audio.wav` - Your banner audio
- `template.rsf` - ROM configuration (especially UniqueId)

### Files You Should NOT Modify
- `Makefile` - Unless you understand the build system
- `bannertool.exe` - Binary tool
- `makerom.exe` - Binary tool
- `build/*` - Generated files
- `*.bnr`, `*.icn` - Generated assets

### Files You Can Modify (Advanced Users)
- `Makefile` - For custom build configurations
- `build.bat` - For custom build scripts
- `template.rsf` - For advanced ROM configuration

## 🚀 Adding New Files

### Adding Source Files
1. Create `.c` file in `source/` directory
2. Create corresponding `.h` file in `include/` directory
3. Include the header in your source files
4. The Makefile will automatically include new `.c` files

### Adding Assets
1. Replace `banner.png` with your banner (256x128)
2. Replace `icon.png` with your icon (48x48)
3. Replace `audio.wav` with your audio
4. Run the build process to generate new assets

### Adding Configuration
1. Modify `template.rsf` for ROM settings
2. Modify `Makefile` for build settings
3. Modify `build.bat` for build script changes

---

**This file structure provides everything needed for 3DS homebrew development! 🎮**
