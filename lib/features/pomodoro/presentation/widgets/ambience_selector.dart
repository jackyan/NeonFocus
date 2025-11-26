import 'package:flutter/material.dart';
import '../../../../core/services/audio_service.dart';
import '../../../../core/themes/glow_theme.dart';

/// Ambience selector widget with cyberpunk aesthetic
class AmbienceSelector extends StatefulWidget {
  final Ambience currentAmbience;
  final Color glowColor;
  final ValueChanged<Ambience> onAmbienceChanged;
  final bool isPremiumUser;

  const AmbienceSelector({
    Key? key,
    required this.currentAmbience,
    required this.glowColor,
    required this.onAmbienceChanged,
    this.isPremiumUser = false,
  }) : super(key: key);

  @override
  State<AmbienceSelector> createState() => _AmbienceSelectorState();
}

class _AmbienceSelectorState extends State<AmbienceSelector> {
  final AudioService _audioService = AudioService();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: widget.glowColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'AMBIENT SOUNDSCAPE',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: widget.glowColor.withOpacity(0.8),
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: Ambience.values.map((ambience) {
              return _buildAmbienceChip(ambience);
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAmbienceChip(Ambience ambience) {
    final isSelected = widget.currentAmbience == ambience;
    final isLocked = ambience.isPremium && !widget.isPremiumUser;
    final canSelect = !isLocked || widget.isPremiumUser;

    return GestureDetector(
      onTap: canSelect
          ? () {
              widget.onAmbienceChanged(ambience);
              if (ambience != Ambience.none) {
                _audioService.startAmbience(ambience);
              } else {
                _audioService.stopAmbience();
              }
            }
          : () {
              // Show premium dialog
              _showPremiumDialog(ambience);
            },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? widget.glowColor.withOpacity(0.2)
              : Colors.black.withOpacity(0.3),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? widget.glowColor
                : widget.glowColor.withOpacity(0.2),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: widget.glowColor.withOpacity(0.3),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isLocked) ...[
              Icon(
                Icons.lock,
                size: 14,
                color: widget.glowColor.withOpacity(0.5),
              ),
              const SizedBox(width: 4),
            ],
            Text(
              ambience.nameEn.toUpperCase(),
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected
                    ? Colors.white
                    : widget.glowColor.withOpacity(0.7),
                letterSpacing: 1,
              ),
            ),
            if (ambience.isPremium && !isLocked) ...[
              const SizedBox(width: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFD700).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: const Color(0xFFFFD700),
                    width: 0.5,
                  ),
                ),
                child: const Text(
                  'PRO',
                  style: TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFFD700),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showPremiumDialog(Ambience ambience) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF0A0E27),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: widget.glowColor.withOpacity(0.3),
            width: 1,
          ),
        ),
        title: Row(
          children: [
            Icon(Icons.workspace_premium, color: widget.glowColor),
            const SizedBox(width: 8),
            Text(
              'PREMIUM FEATURE',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: widget.glowColor,
              ),
            ),
          ],
        ),
        content: Text(
          '"${ambience.nameEn}" is a premium soundscape.\nUpgrade to NeonFocus Pro to unlock all ambient sounds.',
          style: TextStyle(
            fontSize: 14,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'LATER',
              style: TextStyle(
                color: widget.glowColor.withOpacity(0.6),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigate to premium upgrade screen
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.glowColor,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'UPGRADE',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
