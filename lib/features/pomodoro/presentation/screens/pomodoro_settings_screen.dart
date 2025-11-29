import 'package:flutter/material.dart';
import '../../../../core/themes/glow_theme.dart';
import '../../../../core/services/audio_service.dart';

/// Pomodoro settings bottom sheet (covers half screen) - with state management
class PomodoroSettingsScreen extends StatefulWidget {
  final NeonTheme currentTheme;
  final bool autoStart;
  final bool vibration;
  final bool gravityEnabled;
  final Function(bool) onAutoStartToggle;
  final Function(bool) onVibrationToggle;
  final Function(bool) onGravityToggle;
  final Function(NeonTheme) onThemeChanged;
  final AudioService audioService;
  final Ambience currentAmbience;
  final Function(Ambience) onAmbienceChanged;

  const PomodoroSettingsScreen({
    Key? key,
    required this.currentTheme,
    required this.autoStart,
    required this.vibration,
    required this.gravityEnabled,
    required this.onAutoStartToggle,
    required this.onVibrationToggle,
    required this.onGravityToggle,
    required this.onThemeChanged,
    required this.audioService,
    required this.currentAmbience,
    required this.onAmbienceChanged,
  }) : super(key: key);

  @override
  State<PomodoroSettingsScreen> createState() => _PomodoroSettingsScreenState();
}

class _PomodoroSettingsScreenState extends State<PomodoroSettingsScreen> {
  late bool _autoStart;
  late bool _vibration;
  late bool _gravityEnabled;
  late NeonTheme _selectedTheme;
  late double _effectVolume;
  late double _ambienceVolume;
  late Ambience _selectedAmbience;

  @override
  void initState() {
    super.initState();
    _autoStart = widget.autoStart;
    _vibration = widget.vibration;
    _gravityEnabled = widget.gravityEnabled;
    _selectedTheme = widget.currentTheme;
    _effectVolume = widget.audioService.effectVolume;
    _ambienceVolume = widget.audioService.ambienceVolume;
    _selectedAmbience = widget.currentAmbience;
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      height: screenHeight * 0.5, // Half screen
      decoration: BoxDecoration(
        color: const Color(0xFF0A0E27),
        borderRadius: BorderRadius.circular(20), // All corners rounded
        border: Border.all(
          color: _selectedTheme.glowColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Drag handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Scrollable content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    'TIMER SETTINGS',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _selectedTheme.glowColor,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Pomodoro Section
                  _buildSectionTitle('POMODORO', _selectedTheme),
                  const SizedBox(height: 15),
                  _buildToggleItem(
                    'Auto Start',
                    _autoStart,
                    (value) {
                      setState(() => _autoStart = value);
                      widget.onAutoStartToggle(value);
                    },
                    _selectedTheme,
                  ),
                  _buildToggleItem(
                    'Vibration Alert',
                    _vibration,
                    (value) {
                      setState(() => _vibration = value);
                      widget.onVibrationToggle(value);
                    },
                    _selectedTheme,
                  ),
                  _buildToggleItem(
                    'Gravity Interaction',
                    _gravityEnabled,
                    (value) {
                      setState(() => _gravityEnabled = value);
                      widget.onGravityToggle(value);
                    },
                    _selectedTheme,
                    subtitle: 'Flip phone to start/pause',
                  ),

                  const SizedBox(height: 30),

                  // Sound Effects Section
                  _buildSectionTitle('SOUND EFFECTS', _selectedTheme),
                  const SizedBox(height: 15),
                  _buildVolumeSlider(
                    'Effect Volume',
                    _effectVolume,
                    (value) {
                      setState(() => _effectVolume = value);
                      widget.audioService.setEffectVolume(value);
                    },
                    _selectedTheme,
                  ),

                  const SizedBox(height: 30),

                  // Ambient Sound Section
                  _buildSectionTitle('AMBIENT SOUND', _selectedTheme),
                  const SizedBox(height: 15),
                  _buildAmbienceSelector(),
                  const SizedBox(height: 15),
                  if (_selectedAmbience != Ambience.none)
                    _buildVolumeSlider(
                      'Ambience Volume',
                      _ambienceVolume,
                      (value) {
                        setState(() => _ambienceVolume = value);
                        widget.audioService.setAmbienceVolume(value);
                      },
                      _selectedTheme,
                    ),

                  const SizedBox(height: 30),

                  // Theme Section
                  _buildSectionTitle('THEME', _selectedTheme),
                  const SizedBox(height: 15),
                  _buildThemeSelector(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, NeonTheme theme) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: theme.glowColor.withOpacity(0.7),
        letterSpacing: 2,
      ),
    );
  }

  Widget _buildToggleItem(
    String label,
    bool value,
    Function(bool) onChanged,
    NeonTheme theme, {
    String? subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                if (subtitle != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.white.withOpacity(0.5),
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          // Custom slim switch (elegant: 2/3 thickness)
          GestureDetector(
            onTap: () => onChanged(!value),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 54,
              height: 16,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: value
                    ? Colors.green.withOpacity(0.8)
                    : Colors.grey.withOpacity(0.5),
              ),
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 200),
                alignment: value ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  width: 12,
                  height: 12,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeSelector() {
    return SizedBox(
      height: 50,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: NeonTheme.allThemes.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final theme = NeonTheme.allThemes[index];
          final isSelected = theme.id == _selectedTheme.id;
          return GestureDetector(
            onTap: () {
              setState(() => _selectedTheme = theme);
              widget.onThemeChanged(theme);
            },
            child: Container(
              width: 90,
              height: 50,
              decoration: BoxDecoration(
                color: theme.backgroundColor,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isSelected
                      ? theme.glowColor
                      : theme.glowColor.withOpacity(0.3),
                  width: isSelected ? 3 : 1,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: theme.glowColor.withOpacity(0.5),
                          blurRadius: 12,
                          spreadRadius: 2,
                        ),
                      ]
                    : null,
              ),
              child: Center(
                // Miniature clock preview (landscape mode: 09:35:26) - same as CLOCK settings
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '09',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Orbitron',
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: theme.glowColor.withOpacity(0.9),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 3),
                    Text(
                      '35',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Orbitron',
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: theme.glowColor.withOpacity(0.9),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 3),
                    Text(
                      '26',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Orbitron',
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: theme.glowColor.withOpacity(0.9),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildVolumeSlider(
    String label,
    double value,
    Function(double) onChanged,
    NeonTheme theme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.white,
            fontWeight: FontWeight.w300,
          ),
        ),
        const SizedBox(height: 8),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: theme.glowColor,
            inactiveTrackColor: theme.glowColor.withOpacity(0.3),
            thumbColor: theme.glowColor,
            overlayColor: theme.glowColor.withOpacity(0.2),
            trackHeight: 3,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
          ),
          child: Slider(
            value: value,
            min: 0.0,
            max: 1.0,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildAmbienceSelector() {
    return SizedBox(
      height: 80,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: Ambience.values.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final ambience = Ambience.values[index];
          final isSelected = ambience == _selectedAmbience;
          final isPremium = ambience.isPremium;

          return GestureDetector(
            onTap: () {
              setState(() => _selectedAmbience = ambience);
              widget.onAmbienceChanged(ambience);
              if (ambience != Ambience.none) {
                widget.audioService.startAmbience(ambience);
              } else {
                widget.audioService.stopAmbience();
              }
            },
            child: Container(
              width: 90,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _selectedTheme.backgroundColor,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isSelected
                      ? _selectedTheme.glowColor
                      : _selectedTheme.glowColor.withOpacity(0.3),
                  width: isSelected ? 3 : 1,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: _selectedTheme.glowColor.withOpacity(0.5),
                          blurRadius: 12,
                          spreadRadius: 2,
                        ),
                      ]
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _getAmbienceIcon(ambience),
                    color: Colors.white,
                    size: 24,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    ambience.nameEn,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (isPremium)
                    Container(
                      margin: const EdgeInsets.only(top: 2),
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                      decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'PRO',
                        style: TextStyle(
                          fontSize: 8,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  IconData _getAmbienceIcon(Ambience ambience) {
    switch (ambience) {
      case Ambience.none:
        return Icons.volume_off_outlined;
      case Ambience.rain:
        return Icons.water_drop_outlined;
      case Ambience.cafe:
        return Icons.local_cafe_outlined;
      case Ambience.whiteNoise:
        return Icons.graphic_eq_outlined;
      case Ambience.forest:
        return Icons.park_outlined;
      case Ambience.ocean:
        return Icons.waves_outlined;
      case Ambience.lofi:
        return Icons.music_note_outlined;
    }
  }
}
