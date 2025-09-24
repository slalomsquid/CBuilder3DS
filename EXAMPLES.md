# Examples and Tutorials

This guide provides practical examples and step-by-step tutorials for creating 3DS homebrew applications with the C Builder.

## 🎯 Tutorial Overview

We'll cover:
1. **Hello World** - Basic application setup
2. **Graphics Tutorial** - Drawing on screen
3. **Input Tutorial** - Handling user input
4. **Audio Tutorial** - Playing sounds
5. **File I/O Tutorial** - Reading and writing files
6. **Advanced Example** - Complete mini-game

## 📚 Prerequisites

Before starting these tutorials:
- ✅ Complete the [Setup Guide](SETUP.md)
- ✅ Have devkitARM and libctru installed
- ✅ Understand basic C programming
- ✅ Have a 3DS with CFW for testing (optional)

## 🚀 Tutorial 1: Hello World

Let's create your first 3DS homebrew application.

### Step 1: Prepare the Project

1. **Clone or download** the 3DS C Builder
2. **Replace assets** with your own:
   - `banner.png` (256x128) - Your app banner
   - `icon.png` (48x48) - Your app icon
   - `audio.wav` - Banner audio (optional)

### Step 2: Write the Code

Replace the contents of `source/main.c`:

```c
#include <3ds.h>
#include <stdio.h>

int main(int argc, char **argv)
{
    // Initialize graphics
    gfxInitDefault();
    
    // Initialize console on top screen
    consoleInit(GFX_TOP, NULL);
    
    // Print welcome message
    printf("\x1b[16;20HHello, 3DS World!");
    printf("\x1b[18;20HThis is my first homebrew app!");
    printf("\x1b[30;16HPress START to exit.");
    
    // Main loop
    while (aptMainLoop())
    {
        // Scan for input
        hidScanInput();
        
        // Check if START button was pressed
        u32 kDown = hidKeysDown();
        if (kDown & KEY_START) break;
        
        // Flush and swap framebuffers
        gfxFlushBuffers();
        gfxSwapBuffers();
        
        // Wait for VBlank
        gspWaitForVBlank();
    }
    
    // Cleanup
    gfxExit();
    return 0;
}
```

### Step 3: Build and Test

```bash
# Build the application
build.bat "HelloWorld" "Hello 3DS World" "Your Name"

# Or manually
make
bannertool.exe makebanner -i banner.png -a audio.wav -o banner.bnr
bannertool.exe makesmdh -s "HelloWorld" -l "Hello 3DS World" -p "Your Name" -i icon.png -o icon.icn
makerom -f cia -o HelloWorld.cia -DAPP_ENCRYPTED=false -rsf template.rsf -target t -exefslogo -elf homebrew.elf -icon icon.icn -banner banner.bnr
```

### Step 4: Test on 3DS

1. **Copy `HelloWorld.cia`** to your 3DS SD card
2. **Install using FBI** or similar CIA installer
3. **Launch from home menu**
4. **Press START** to exit

**Expected Result**: A simple text display with "Hello, 3DS World!" message.

## 🎨 Tutorial 2: Graphics and Drawing

Let's create a simple graphics application that draws shapes and colors.

### Step 1: Create Graphics Header

Create `include/graphics.h`:

```c
#ifndef GRAPHICS_H
#define GRAPHICS_H

#include <3ds.h>

// Color definitions
#define COLOR_RED     0xFF0000FF
#define COLOR_GREEN   0xFF00FF00
#define COLOR_BLUE    0xFFFF0000
#define COLOR_WHITE   0xFFFFFFFF
#define COLOR_BLACK   0xFF000000

// Function declarations
void init_graphics(void);
void draw_rectangle(int x, int y, int width, int height, u32 color);
void draw_circle(int center_x, int center_y, int radius, u32 color);
void clear_screen(u32 color);
void update_display(void);

#endif
```

### Step 2: Implement Graphics Functions

Create `source/graphics.c`:

```c
#include "graphics.h"

void init_graphics(void)
{
    gfxInitDefault();
    gfxSet3D(false); // Disable 3D for simplicity
}

void draw_rectangle(int x, int y, int width, int height, u32 color)
{
    for (int dy = 0; dy < height; dy++)
    {
        for (int dx = 0; dx < width; dx++)
        {
            gfxDrawPixel(GFX_BOTTOM, x + dx, y + dy, color);
        }
    }
}

void draw_circle(int center_x, int center_y, int radius, u32 color)
{
    for (int y = -radius; y <= radius; y++)
    {
        for (int x = -radius; x <= radius; x++)
        {
            if (x * x + y * y <= radius * radius)
            {
                gfxDrawPixel(GFX_BOTTOM, center_x + x, center_y + y, color);
            }
        }
    }
}

void clear_screen(u32 color)
{
    gfxFillScreen(GFX_BOTTOM, color);
}

void update_display(void)
{
    gfxFlushBuffers();
    gfxSwapBuffers();
    gspWaitForVBlank();
}
```

### Step 3: Update Main Application

Update `source/main.c`:

```c
#include <3ds.h>
#include <stdio.h>
#include "graphics.h"

int main(int argc, char **argv)
{
    // Initialize graphics
    init_graphics();
    
    // Initialize console on top screen
    consoleInit(GFX_TOP, NULL);
    printf("\x1b[16;20HGraphics Demo");
    printf("\x1b[30;16HPress START to exit.");
    
    // Animation variables
    int rect_x = 50;
    int rect_y = 50;
    int circle_x = 200;
    int circle_y = 100;
    int direction = 1;
    
    // Main loop
    while (aptMainLoop())
    {
        // Scan for input
        hidScanInput();
        u32 kDown = hidKeysDown();
        if (kDown & KEY_START) break;
        
        // Clear screen
        clear_screen(COLOR_BLACK);
        
        // Draw animated rectangle
        draw_rectangle(rect_x, rect_y, 50, 30, COLOR_RED);
        
        // Draw animated circle
        draw_circle(circle_x, circle_y, 25, COLOR_BLUE);
        
        // Animate rectangle
        rect_x += direction;
        if (rect_x > 200 || rect_x < 0) direction = -direction;
        
        // Animate circle
        circle_y += 2;
        if (circle_y > 200) circle_y = 0;
        
        // Update display
        update_display();
    }
    
    gfxExit();
    return 0;
}
```

### Step 4: Build and Test

```bash
build.bat "GraphicsDemo" "Graphics Demo App" "Your Name"
```

**Expected Result**: Animated red rectangle and blue circle on the bottom screen.

## 🎮 Tutorial 3: Input Handling

Let's create an application that responds to different button inputs.

### Step 1: Create Input Header

Create `include/input.h`:

```c
#ifndef INPUT_H
#define INPUT_H

#include <3ds.h>

// Input state structure
typedef struct {
    u32 keys_down;
    u32 keys_held;
    u32 keys_up;
    circlePosition circle_pos;
    circlePosition c_stick_pos;
} input_state_t;

// Function declarations
void update_input(input_state_t* input);
void handle_input(input_state_t* input);
const char* get_key_name(u32 key);

#endif
```

### Step 2: Implement Input Functions

Create `source/input.c`:

```c
#include "input.h"
#include <stdio.h>

void update_input(input_state_t* input)
{
    hidScanInput();
    input->keys_down = hidKeysDown();
    input->keys_held = hidKeysHeld();
    input->keys_up = hidKeysUp();
    
    // Get circle pad position
    hidCircleRead(&input->circle_pos);
    
    // Get C-stick position
    hidCstickRead(&input->c_stick_pos);
}

void handle_input(input_state_t* input)
{
    // Handle button presses
    if (input->keys_down & KEY_A) {
        printf("\x1b[2;2HA button pressed!");
    }
    if (input->keys_down & KEY_B) {
        printf("\x1b[3;2HB button pressed!");
    }
    if (input->keys_down & KEY_X) {
        printf("\x1b[4;2HX button pressed!");
    }
    if (input->keys_down & KEY_Y) {
        printf("\x1b[5;2HY button pressed!");
    }
    
    // Handle D-pad
    if (input->keys_held & KEY_DUP) {
        printf("\x1b[6;2HD-pad UP held");
    }
    if (input->keys_held & KEY_DDOWN) {
        printf("\x1b[7;2HD-pad DOWN held");
    }
    if (input->keys_held & KEY_DLEFT) {
        printf("\x1b[8;2HD-pad LEFT held");
    }
    if (input->keys_held & KEY_DRIGHT) {
        printf("\x1b[9;2HD-pad RIGHT held");
    }
    
    // Handle circle pad
    if (input->circle_pos.dx != 0 || input->circle_pos.dy != 0) {
        printf("\x1b[10;2HCircle Pad: %d, %d", input->circle_pos.dx, input->circle_pos.dy);
    }
    
    // Handle C-stick
    if (input->c_stick_pos.dx != 0 || input->c_stick_pos.dy != 0) {
        printf("\x1b[11;2HC-Stick: %d, %d", input->c_stick_pos.dx, input->c_stick_pos.dy);
    }
}

const char* get_key_name(u32 key)
{
    switch (key) {
        case KEY_A: return "A";
        case KEY_B: return "B";
        case KEY_X: return "X";
        case KEY_Y: return "Y";
        case KEY_L: return "L";
        case KEY_R: return "R";
        case KEY_ZL: return "ZL";
        case KEY_ZR: return "ZR";
        case KEY_SELECT: return "SELECT";
        case KEY_START: return "START";
        case KEY_DUP: return "D-UP";
        case KEY_DDOWN: return "D-DOWN";
        case KEY_DLEFT: return "D-LEFT";
        case KEY_DRIGHT: return "D-RIGHT";
        default: return "UNKNOWN";
    }
}
```

### Step 3: Update Main Application

Update `source/main.c`:

```c
#include <3ds.h>
#include <stdio.h>
#include "input.h"

int main(int argc, char **argv)
{
    gfxInitDefault();
    consoleInit(GFX_TOP, NULL);
    
    printf("\x1b[1;1HInput Demo - Press buttons!");
    printf("\x1b[30;16HPress START to exit.");
    
    input_state_t input = {0};
    
    while (aptMainLoop())
    {
        // Update input state
        update_input(&input);
        
        // Handle START to exit
        if (input.keys_down & KEY_START) break;
        
        // Clear previous input display
        printf("\x1b[2;1H                    ");
        printf("\x1b[3;1H                    ");
        printf("\x1b[4;1H                    ");
        printf("\x1b[5;1H                    ");
        printf("\x1b[6;1H                    ");
        printf("\x1b[7;1H                    ");
        printf("\x1b[8;1H                    ");
        printf("\x1b[9;1H                    ");
        printf("\x1b[10;1H                    ");
        printf("\x1b[11;1H                    ");
        
        // Handle and display input
        handle_input(&input);
        
        // Update display
        gfxFlushBuffers();
        gfxSwapBuffers();
        gspWaitForVBlank();
    }
    
    gfxExit();
    return 0;
}
```

**Expected Result**: Real-time display of button presses and analog stick positions.

## 🎵 Tutorial 4: Audio Playback

Let's add sound effects to our application.

### Step 1: Create Audio Header

Create `include/audio.h`:

```c
#ifndef AUDIO_H
#define AUDIO_H

#include <3ds.h>

// Audio function declarations
void init_audio(void);
void play_beep(void);
void play_click(void);
void cleanup_audio(void);

#endif
```

### Step 2: Implement Audio Functions

Create `source/audio.c`:

```c
#include "audio.h"
#include <3ds.h>

void init_audio(void)
{
    // Initialize CSND service
    csndInit();
}

void play_beep(void)
{
    // Play a simple beep sound
    // Note: This is a simplified example
    // In a real application, you'd load and play actual audio files
    CSND_SetPlayState(0x8, 0);
    CSND_SetPlayState(0x8, 1);
}

void play_click(void)
{
    // Play a click sound
    CSND_SetPlayState(0x9, 0);
    CSND_SetPlayState(0x9, 1);
}

void cleanup_audio(void)
{
    csndExit();
}
```

### Step 3: Update Main Application

Update `source/main.c` to include audio:

```c
#include <3ds.h>
#include <stdio.h>
#include "input.h"
#include "audio.h"

int main(int argc, char **argv)
{
    gfxInitDefault();
    consoleInit(GFX_TOP, NULL);
    
    // Initialize audio
    init_audio();
    
    printf("\x1b[1;1HAudio Demo - Press buttons for sounds!");
    printf("\x1b[30;16HPress START to exit.");
    
    input_state_t input = {0};
    
    while (aptMainLoop())
    {
        update_input(&input);
        
        if (input.keys_down & KEY_START) break;
        
        // Play sounds on button press
        if (input.keys_down & KEY_A) {
            play_beep();
            printf("\x1b[2;2HA button - BEEP!");
        }
        if (input.keys_down & KEY_B) {
            play_click();
            printf("\x1b[3;2HB button - CLICK!");
        }
        
        gfxFlushBuffers();
        gfxSwapBuffers();
        gspWaitForVBlank();
    }
    
    cleanup_audio();
    gfxExit();
    return 0;
}
```

## 🎮 Tutorial 5: Complete Mini-Game Example

Let's create a simple "Catch the Square" game that combines all concepts.

### Step 1: Create Game Header

Create `include/game.h`:

```c
#ifndef GAME_H
#define GAME_H

#include <3ds.h>

// Game state
typedef struct {
    int player_x, player_y;
    int target_x, target_y;
    int score;
    int game_time;
    bool game_over;
} game_state_t;

// Game functions
void init_game(game_state_t* game);
void update_game(game_state_t* game, input_state_t* input);
void draw_game(game_state_t* game);
void reset_game(game_state_t* game);

#endif
```

### Step 2: Implement Game Logic

Create `source/game.c`:

```c
#include "game.h"
#include "graphics.h"
#include "input.h"
#include "audio.h"

void init_game(game_state_t* game)
{
    game->player_x = 100;
    game->player_y = 100;
    game->target_x = 150;
    game->target_y = 150;
    game->score = 0;
    game->game_time = 300; // 5 seconds at 60 FPS
    game->game_over = false;
}

void update_game(game_state_t* game, input_state_t* input)
{
    if (game->game_over) {
        if (input->keys_down & KEY_A) {
            reset_game(game);
        }
        return;
    }
    
    // Move player with circle pad
    if (input->circle_pos.dx > 50) game->player_x += 2;
    if (input->circle_pos.dx < -50) game->player_x -= 2;
    if (input->circle_pos.dy > 50) game->player_y += 2;
    if (input->circle_pos.dy < -50) game->player_y -= 2;
    
    // Keep player on screen
    if (game->player_x < 0) game->player_x = 0;
    if (game->player_x > 240) game->player_x = 240;
    if (game->player_y < 0) game->player_y = 0;
    if (game->player_y > 200) game->player_y = 200;
    
    // Check collision
    int dx = game->player_x - game->target_x;
    int dy = game->player_y - game->target_y;
    if (dx * dx + dy * dy < 400) { // 20 pixel radius
        game->score++;
        play_beep();
        
        // Move target to random position
        game->target_x = 20 + (rand() % 200);
        game->target_y = 20 + (rand() % 160);
    }
    
    // Update timer
    game->game_time--;
    if (game->game_time <= 0) {
        game->game_over = true;
    }
}

void draw_game(game_state_t* game)
{
    clear_screen(COLOR_BLACK);
    
    if (!game->game_over) {
        // Draw player (blue square)
        draw_rectangle(game->player_x - 10, game->player_y - 10, 20, 20, COLOR_BLUE);
        
        // Draw target (red square)
        draw_rectangle(game->target_x - 10, game->target_y - 10, 20, 20, COLOR_RED);
    } else {
        // Draw game over screen
        draw_rectangle(50, 80, 140, 40, COLOR_WHITE);
    }
}

void reset_game(game_state_t* game)
{
    init_game(game);
}
```

### Step 3: Complete Main Application

Update `source/main.c`:

```c
#include <3ds.h>
#include <stdio.h>
#include "input.h"
#include "audio.h"
#include "game.h"
#include "graphics.h"

int main(int argc, char **argv)
{
    gfxInitDefault();
    consoleInit(GFX_TOP, NULL);
    
    init_graphics();
    init_audio();
    
    printf("\x1b[1;1HCatch the Square!");
    printf("\x1b[2;1HUse Circle Pad to move");
    printf("\x1b[3;1HCatch red squares!");
    printf("\x1b[30;16HPress START to exit");
    
    game_state_t game;
    input_state_t input = {0};
    
    init_game(&game);
    
    while (aptMainLoop())
    {
        update_input(&input);
        
        if (input.keys_down & KEY_START) break;
        
        update_game(&game, &input);
        draw_game(&game);
        
        // Display score and time
        printf("\x1b[5;1HScore: %d", game.score);
        printf("\x1b[6;1HTime: %d", game.game_time / 60);
        
        if (game.game_over) {
            printf("\x1b[8;1HGame Over!");
            printf("\x1b[9;1HPress A to restart");
        }
        
        update_display();
    }
    
    cleanup_audio();
    gfxExit();
    return 0;
}
```

## 🚀 Building All Examples

To build any of these examples:

```bash
# Hello World
build.bat "HelloWorld" "Hello 3DS World" "Your Name"

# Graphics Demo
build.bat "GraphicsDemo" "Graphics Demo" "Your Name"

# Input Demo
build.bat "InputDemo" "Input Demo" "Your Name"

# Audio Demo
build.bat "AudioDemo" "Audio Demo" "Your Name"

# Mini-Game
build.bat "CatchSquare" "Catch the Square" "Your Name"
```

## 📚 Additional Resources

### libctru Documentation
- **[Official libctru](https://github.com/devkitPro/libctru)** - Complete API reference
- **[3DS Homebrew Development](https://3dbrew.org/)** - Technical documentation

### Example Projects
- **[devkitPro Examples](https://github.com/devkitPro/3ds-examples)** - Official examples
- **[GBATemp Homebrew](https://gbatemp.net/forums/3ds-homebrew.196/)** - Community projects

### Tools and Utilities
- **[3DS Homebrew Launcher](https://github.com/fincs/new-hbmenu)** - Testing environment
- **[FBI](https://github.com/Steveice10/FBI)** - CIA installer

---

**Happy coding! These examples should give you a solid foundation for 3DS homebrew development! 🎮**
