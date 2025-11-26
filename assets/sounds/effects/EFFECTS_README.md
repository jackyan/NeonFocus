# Sound Effects

This directory should contain UI and timer sound effect files.

## Required Effect Files

Place the following `.mp3` files in this directory:

1. **ui_click.mp3** - Button click sound (short, crisp)
2. **ui_swipe.mp3** - Swipe gesture sound (whoosh effect)
3. **timer_start.mp3** - Timer start sound (energetic beep)
4. **timer_complete.mp3** - Timer completion sound (success chime)
5. **digit_flip.mp3** - Digit flip transition sound (mechanical click)

## Recommended Sources

### Free Sound Libraries
- **Freesound.org** - https://freesound.org/
- **Zapsplat** - https://www.zapsplat.com/
- **Mixkit** - https://mixkit.co/free-sound-effects/

### Search Keywords
- "UI click", "button click"
- "swipe", "whoosh"
- "timer beep", "countdown"
- "success", "achievement", "complete"
- "flip", "mechanical click"

## Audio Specifications

- **Format**: MP3 (44.1kHz recommended)
- **Duration**: 0.1s - 2s per effect
- **File Size**: Keep under 50KB each
- **Volume**: Normalized to prevent clipping

## Temporary Solution

If you want to run the app without sounds:
- The app will work without these files
- Audio errors are caught and logged silently
- No sound will play but the app remains functional

## Creating Placeholder Files (For Testing)

```bash
# Linux/macOS - Create empty files
touch ui_click.mp3 ui_swipe.mp3 timer_start.mp3 timer_complete.mp3 digit_flip.mp3
```

Note: Empty files will prevent asset loading errors but won't produce sound.
