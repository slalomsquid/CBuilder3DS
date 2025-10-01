# Setup Guide

This guide will walk you through setting up your development environment for 3DS C Builder.

## 📋 System Requirements

- **Operating System**: Windows 10/11 (recommended), Linux, or macOS
- **RAM**: 4GB minimum, 8GB recommended
- **Storage**: 2GB free space for tools and dependencies
- **Internet**: Required for downloading development tools

## 🛠️ Step-by-Step Installation

### 1. Install devkitPro

devkitPro is the essential toolchain for 3DS homebrew development.

#### Windows Installation

1. **Download devkitPro Installer**
   - Go to [devkitPro.org](https://devkitpro.org/wiki/Getting_Started)
   - Download the Windows installer

2. **Run the Installer**
   - Run as Administrator
   - Select "devkitARM" during installation
   - Choose installation directory (default: `C:\devkitPro`)
   - **Important**: Add to PATH when prompted

3. **Verify Installation**
   Open Command Prompt and run:
   ```cmd
   arm-none-eabi-gcc --version
   ```
   You should see version information if installed correctly.

#### Linux Installation

1. **Add devkitPro Repository**
   ```bash
   # For Ubuntu/Debian
   sudo apt-get update
   sudo apt-get install curl
   curl -sSL https://apt.devkitpro.org/install-devkitpro-pacman | sudo bash
   ```

2. **Install devkitARM**
   ```bash
   sudo dkp-pacman -S devkitARM
   ```

3. **Add to PATH**
   Add to your `~/.bashrc` or `~/.zshrc`:
   ```bash
   export DEVKITPRO=/opt/devkitpro
   export DEVKITARM=$DEVKITPRO/devkitARM
   export PATH=$DEVKITARM/bin:$PATH
   ```

#### macOS Installation

1. **Install Homebrew** (if not already installed)
   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

2. **Install devkitPro**
   ```bash
   brew install devkitpro/devkitpro/devkitarm
   ```

3. **Add to PATH**
   Add to your `~/.zshrc` or `~/.bash_profile`:
   ```bash
   export DEVKITPRO=/opt/devkitpro
   export DEVKITARM=$DEVKITPRO/devkitARM
   export PATH=$DEVKITARM/bin:$PATH
   ```

### 2. Install libctru

libctru is the 3DS homebrew library that provides system APIs.

#### Automatic Installation (Recommended)

libctru is usually included with devkitPro, but you can verify:

```bash
# Check if libctru is available
ls $DEVKITPRO/libctru
```

#### Manual Installation (if needed)

```bash
# Clone and build libctru
git clone https://github.com/devkitPro/libctru.git
cd libctru
make
sudo make install
```

### 3. Install Additional Tools

#### Make (Build System)

**Windows:**
- Make is included with devkitPro
- Alternative: Install via [Chocolatey](https://chocolatey.org/): `choco install make`

**Linux:**
```bash
sudo apt-get install make  # Ubuntu/Debian
sudo yum install make      # CentOS/RHEL
```

**macOS:**
```bash
brew install make
```

#### Git (Version Control)

**Windows:**
- Download from [git-scm.com](https://git-scm.com/download/win)

**Linux:**
```bash
sudo apt-get install git  # Ubuntu/Debian
sudo yum install git      # CentOS/RHEL
```

**macOS:**
```bash
brew install git
```

### 4. Verify Your Installation

Create a test file to verify everything works:

```bash
# Create test directory
mkdir 3ds-test
cd 3ds-test

# Create simple test program
cat > test.c << 'EOF'
#include <3ds.h>
#include <stdio.h>

int main(int argc, char **argv) {
    gfxInitDefault();
    consoleInit(GFX_TOP, NULL);
    printf("Hello from 3DS!\n");
    gfxExit();
    return 0;
}
EOF

# Create simple Makefile
cat > Makefile << 'EOF'
TARGET := test
SOURCES := .
include $(DEVKITARM)/3ds_rules

$(TARGET).3dsx: $(TARGET).elf
$(TARGET).elf: $(SOURCES)/test.o
EOF

# Build test
make

# Check if files were created
ls -la *.3dsx *.elf
```

If you see `test.3dsx` and `test.elf` files, your setup is working correctly!

## 🔧 Environment Configuration

### Windows Environment Variables

Add these to your system PATH:
```
C:\devkitPro\devkitARM\bin
C:\devkitPro\tools\bin
```

### Linux/macOS Environment Variables

Add to your shell configuration file (`~/.bashrc`, `~/.zshrc`, etc.):
```bash
export DEVKITPRO=/opt/devkitpro
export DEVKITARM=$DEVKITPRO/devkitARM
export PATH=$DEVKITARM/bin:$PATH
export PATH=$DEVKITPRO/tools/bin:$PATH
```

## 🎮 3DS Setup (Optional)

To test your homebrew applications, you'll need:

### Custom Firmware (CFW)
- **Luma3DS**: Most popular CFW
- **Installation**: Follow [3ds.hacks.guide](https://3ds.hacks.guide/)

### Homebrew Launcher
- **new-hbmenu**: Modern homebrew launcher
- **Installation**: Usually included with CFW

## 🐛 Troubleshooting Setup

### Common Issues

**"arm-none-eabi-gcc: command not found"**
- devkitARM is not in your PATH
- Restart your terminal after installation
- Verify environment variables are set correctly

**"Please set DEVKITARM in your environment"**
- DEVKITARM environment variable is not set
- Add `export DEVKITARM=/opt/devkitpro/devkitARM` to your shell config

**Build fails with "No such file or directory"**
- Check that all tools are properly installed
- Verify file paths in Makefile are correct
- Ensure you're in the correct directory

**Permission denied errors (Linux/macOS)**
- Use `sudo` for system-wide installations
- Check file permissions on your project directory

### Getting Help

If you're still having issues:

1. **Check the logs**: Look for specific error messages
2. **Verify versions**: Ensure all tools are compatible versions
3. **Clean installation**: Try reinstalling devkitPro
4. **Community support**: Ask on [devkitPro Discord](https://discord.gg/devkitpro) or [GBATemp](https://gbatemp.net/)

## ✅ Next Steps

Once your setup is complete:

1. **Clone the 3DS C Builder repository**
2. **Follow the [Quick Start Guide](README.md#-quick-start)**
3. **Create your first 3DS homebrew application**
4. **Test it on your 3DS (if you have CFW)**

## 📚 Additional Resources

- **[devkitPro Wiki](https://devkitpro.org/wiki/Getting_Started)** - Official setup guide
- **[libctru Documentation](https://github.com/devkitPro/libctru)** - API reference
- **[3DS Homebrew Development](https://3dbrew.org/)** - Technical documentation
- **[GBATemp 3DS Homebrew](https://gbatemp.net/forums/3ds-homebrew.196/)** - Community forum

---

**Your development environment is now ready for 3DS homebrew development! 🎮**
