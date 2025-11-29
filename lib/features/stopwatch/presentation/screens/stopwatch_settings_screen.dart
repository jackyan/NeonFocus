import 'package:flutter/material.dart';
import '../../../../core/themes/glow_theme.dart';
import '../../../../core/services/audio_service.dart';

/// Stopwatch settings bottom sheet (covers half screen) - with state management
class StopwatchSettingsScreen extends StatefulWidget {
  final NeonTheme currentTheme;
  final Function(NeonTheme) onThemeChanged;
  final AudioService audioService;

  const StopwatchSettingsScreen({
    Key? key,
    required this.currentTheme,
    required this.onThemeChanged,
    required this.audioService,
  }) : super(key: key);

  @override
  State<StopwatchSettingsScreen> createState() => _StopwatchSettingsScreenState();
}

class _StopwatchSettingsScreenState extends State<StopwatchSettingsScreen> {
  late NeonTheme _selectedTheme;
  late double _effectVolume;

  @override
  void initState() {
    super.initState();
    _selectedTheme = widget.currentTheme;
    _effectVolume = widget.audioService.effectVolume;
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
                    'STOPWATCH SETTINGS',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _selectedTheme.glowColor,
                      letterSpacing: 2,
                    ),
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
}
