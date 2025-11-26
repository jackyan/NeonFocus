# Ambient Soundscapes

This directory should contain looping ambient sound files for focus sessions.

## Required Ambience Files

Place the following `.mp3` files in this directory:

### Free Soundscapes
1. **rain.mp3** - Rain sounds (gentle rainfall)
2. **cafe.mp3** - Coffee shop ambience (background chatter, dishes)
3. **white_noise.mp3** - White noise (static, consistent)

### Premium Soundscapes (NeonFocus Pro)
4. **forest.mp3** - Forest sounds (birds, wind in trees)
5. **ocean.mp3** - Ocean waves (rhythmic waves on beach)
6. **lofi.mp3** - Lo-Fi music (chill beats, instrumental)

## Recommended Sources

### Free Sound Libraries
- **MyNoise.net** - https://mynoise.net/ (download custom mixes)
- **Ambient-Mixer** - https://www.ambient-mixer.com/
- **Freesound.org** - https://freesound.org/
- **YouTube Audio Library** - Free ambient tracks

### Curated Playlists
- Search for "1 hour rain sounds loop"
- "coffee shop ambience"
- "white noise 1 hour"
- "forest ambience"
- "ocean waves"
- "lofi beats to study"

## Audio Specifications

- **Format**: MP3 (44.1kHz or 48kHz)
- **Duration**: 2-10 minutes (will loop seamlessly)
- **File Size**: Keep under 5MB each for performance
- **Volume**: Normalized, no sudden peaks
- **Loop Points**: Ensure seamless looping (fade in/out if needed)

## Creating Seamless Loops

For best experience:
1. Use audio editor (Audacity, GarageBand)
2. Trim to remove silence at start/end
3. Apply crossfade at loop point
4. Test that end transitions smoothly to beginning

## Temporary Solution

If you want to run the app without sounds:
- The app will work without these files
- Selecting an ambience won't produce sound
- Audio errors are caught and logged silently

## Creating Placeholder Files (For Testing)

```bash
# Linux/macOS - Create empty files
touch rain.mp3 cafe.mp3 white_noise.mp3 forest.mp3 ocean.mp3 lofi.mp3
```

Note: Empty files will prevent asset loading errors but won't produce sound.

## License Considerations

Ensure all audio files are:
- Royalty-free for commercial use
- Properly licensed (Creative Commons, purchased, or self-created)
- Attributed if required by license

Keep license information in `AUDIO_LICENSES.txt` in this directory.
