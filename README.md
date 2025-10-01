# 3DS C Builder

Thanks to Manurocker95 for the original https://github.com/Manurocker95/CIABUILDER as well as 3DSGuy for https://github.com/3DSGuy/Project_CTR/releases/tag/makerom-v0.18.4 and https://github.com/devkitpro for https://github.com/devkitPro/3ds-examples

A comprehensive build system for creating Nintendo 3DS homebrew applications in C. This project simplifies the process of compiling C code into multiple 3DS formats (.3dsx, .elf, .3ds, and .cia) with automated asset creation and packaging.

## 🎯 What This Project Does

This build system takes your C source code and automatically:
- Compiles it using devkitARM and libctru
- Creates application assets (banner, icon, audio)
- Packages everything into multiple 3DS formats
- Generates both development (.3dsx) and distribution (.3ds/.cia) files

## 📋 Prerequisites

Before using this builder, you need to install:

### Required Tools
- **[devkitARM](https://devkitpro.org/wiki/Getting_Started/devkitARM)** - The ARM development toolchain
- **[libctru](https://github.com/devkitPro/libctru)** - 3DS homebrew library
- **Make** - Build automation tool
- **Windows Command Prompt or PowerShell** (for the build script)

### Optional Tools
- **3DS Homebrew Launcher** - For testing .3dsx files
- **Custom Firmware** - For installing .cia files

## 🚀 Quick Start

1. **Clone this repository:**
   ```bash
   git clone https://github.com/slalomsquid/CBuilder3DS.git
   cd CBuilder3DS
   ```

2. **Set up your development environment:**
   - Install devkitARM and ensure it's in your PATH
   - Verify installation: `arm-none-eabi-gcc --version`

3. **Prepare your assets:**
   - Replace `banner.png` with your app's banner (256x128 pixels)
   - Replace `icon.png` with your app's icon (48x48 pixels)
   - Replace `audio.wav` with your app's audio (optional)

4. **Write your C code:**
   - Edit `source/main.c` with your application logic
   - Add additional source files to the `source/` directory as needed

5. **Build your application:**
   ```bash
   # On Windows
   build.bat "MyApp" "My Awesome 3DS App" "Your Name"
   
   # Or manually
   make
   bannertool.exe makebanner -i banner.png -a audio.wav -o banner.bnr
   bannertool.exe makesmdh -s "MyApp" -l "My Awesome 3DS App" -p "Your Name" -i icon.png -o icon.icn
   makerom -f cia -o MyApp.cia -DAPP_ENCRYPTED=false -rsf template.rsf -target t -exefslogo -elf homebrew.elf -icon icon.icn -banner banner.bnr
   makerom -f cci -o MyApp.3ds -DAPP_ENCRYPTED=true -rsf template.rsf -target t -exefslogo -elf homebrew.elf -icon icon.icn -banner banner.bnr
   ```

## 📁 Project Structure

```
CBuilder3DS/
├── source/                 # Your C source code
│   └── main.c             # Main application file
├── include/               # Header files (currently empty)
├── build/                 # Build output directory
├── banner.png             # Application banner (256x128)
├── icon.png               # Application icon (48x48)
├── audio.wav              # Application audio
├── template.rsf           # ROM configuration template
├── Makefile               # Build configuration
├── build.bat              # Automated build script
├── bannertool.exe         # Asset creation tool
├── makerom.exe            # ROM packaging tool
└── README.md              # This file
```

## 🔧 Build Process Explained

### 1. Compilation (`make`)
- Compiles your C source code using devkitARM
- Links with libctru library
- Generates `.elf` and `.3dsx` files

### 2. Asset Creation
- **Banner**: Creates `banner.bnr` from `banner.png` and `audio.wav`
- **Icon**: Creates `icon.icn` from `icon.png` with metadata

### 3. ROM Packaging
- **CIA**: Creates installable `.cia` file (unencrypted for homebrew)
- **3DS**: Creates cartridge `.3ds` file (encrypted for distribution)

## 📝 Configuration

### Customizing Your App
Edit `template.rsf` to modify:
- **Title**: Application name
- **Company Code**: Your organization identifier
- **Product Code**: Unique product identifier
- **Unique ID**: Application identifier (change from default!)
- **Media Size**: Storage requirements
- **System Permissions**: What your app can access

### Build Script Parameters
```bash
build.bat [short_name] [long_name] [author_name]
```
- `short_name`: Short identifier (e.g., "MyApp")
- `long_name`: Full application name (e.g., "My Awesome 3DS App")
- `author_name`: Your name or organization

## 🎮 Output Formats

| Format | Extension | Purpose | Usage |
|--------|-----------|---------|-------|
| **3DSX** | `.3dsx` | Development | Testing with Homebrew Launcher |
| **ELF** | `.elf` | Debugging | Development and debugging |
| **CIA** | `.cia` | Installation | Installing on 3DS with CFW |
| **3DS** | `.3ds` | Distribution | Cartridge-style distribution |

## 🛠️ Development Tips

### Adding Source Files
1. Add your `.c` files to the `source/` directory
2. Add corresponding `.h` files to the `include/` directory
3. The Makefile will automatically include them

### Asset Requirements
- **Banner**: 256x128 pixels, PNG format
- **Icon**: 48x48 pixels, PNG format
- **Audio**: WAV format, 16-bit, 22kHz recommended

### Debugging
- Use `.3dsx` files for quick testing
- Use `.elf` files with debuggers
- Check build logs in the `build/` directory

## 🐛 Troubleshooting

### Common Issues

**"Please set DEVKITARM in your environment"**
- Install devkitARM and add it to your PATH
- Restart your command prompt after installation

**Build fails with "command not found"**
- Ensure all tools (make, bannertool, makerom) are in your PATH
- Check that devkitARM is properly installed

**Assets not appearing in final build**
- Verify file formats (PNG for images, WAV for audio)
- Check file sizes and dimensions
- Ensure files are in the project root directory

**CIA installation fails**
- Verify your 3DS has custom firmware installed
- Check that the Unique ID in `template.rsf` is unique
- Ensure all required system services are available

## 📚 Learning Resources

- **[libctru Documentation](https://github.com/devkitPro/libctru)** - 3DS homebrew library
- **[devkitPro Examples](https://github.com/devkitPro/3ds-examples)** - Sample projects
- **[3DS Homebrew Development](https://3dbrew.org/)** - Technical documentation
- **[Homebrew Launcher](https://github.com/fincs/new-hbmenu)** - Testing environment

## 🤝 Contributing

We welcome contributions! Please:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This project is licensed under the terms specified in the [LICENSE](LICENSE) file.

## 🙏 Acknowledgments

- **[Manurocker95](https://github.com/Manurocker95/CIABUILDER)** - Original CIA builder inspiration
- **[3DSGuy](https://github.com/3DSGuy/Project_CTR)** - makerom tool
- **[devkitPro](https://github.com/devkitPro)** - 3DS development tools and examples
- **[Aurelio Mannara](https://github.com/aureliomannara)** - libctru Hello World example

## 📞 Support

If you encounter issues or have questions:
- Check the [Troubleshooting](#-troubleshooting) section
- Search existing [Issues](https://github.com/slalomsquid/CBuilder3DS/issues)
- Create a new issue with detailed information about your problem

---

**Happy 3DS homebrew development! 🎮**