import 'package:flutter/material.dart';
import '../../../core/themes/glow_theme.dart';

/// Reusable volume control widget for all settings screens
class VolumeControlWidget extends StatelessWidget {
  final String label;
  final double value;
  final Function(double)? onChanged;
  final NeonTheme theme;
  final bool enabled;

  const VolumeControlWidget({
    Key? key,
    required this.label,
    required this.value,
    required this.onChanged,
    required this.theme,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: enabled ? Colors.white : Colors.white.withOpacity(0.4),
            fontWeight: FontWeight.w300,
          ),
        ),
        const SizedBox(height: 8),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: enabled
                ? theme.glowColor
                : theme.glowColor.withOpacity(0.3),
            inactiveTrackColor: theme.glowColor.withOpacity(0.3),
            thumbColor: enabled
                ? theme.glowColor
                : theme.glowColor.withOpacity(0.3),
            overlayColor: theme.glowColor.withOpacity(0.2),
            trackHeight: 3,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
            disabledActiveTrackColor: theme.glowColor.withOpacity(0.2),
            disabledInactiveTrackColor: theme.glowColor.withOpacity(0.1),
            disabledThumbColor: theme.glowColor.withOpacity(0.2),
          ),
          child: Slider(
            value: value,
            min: 0.0,
            max: 1.0,
            onChanged: enabled ? onChanged : null,
          ),
        ),
      ],
    );
  }
}
