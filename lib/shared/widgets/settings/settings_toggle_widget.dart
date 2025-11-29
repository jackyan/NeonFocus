import 'package:flutter/material.dart';
import '../../../core/themes/glow_theme.dart';

/// Reusable settings toggle widget for all settings screens
class SettingsToggleWidget extends StatelessWidget {
  final String label;
  final String? subtitle;
  final bool value;
  final Function(bool) onChanged;
  final NeonTheme theme;

  const SettingsToggleWidget({
    Key? key,
    required this.label,
    this.subtitle,
    required this.value,
    required this.onChanged,
    required this.theme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                      subtitle!,
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
}
