import 'package:flutter/material.dart';
import '../../../../core/services/audio_service.dart';

/// Volume control widget for effects and ambience
class VolumeControl extends StatefulWidget {
  final Color glowColor;
  final bool showEffectVolume;
  final bool showAmbienceVolume;

  const VolumeControl({
    Key? key,
    required this.glowColor,
    this.showEffectVolume = true,
    this.showAmbienceVolume = true,
  }) : super(key: key);

  @override
  State<VolumeControl> createState() => _VolumeControlState();
}

class _VolumeControlState extends State<VolumeControl> {
  final AudioService _audioService = AudioService();
  late double _effectVolume;
  late double _ambienceVolume;

  @override
  void initState() {
    super.initState();
    _effectVolume = _audioService.effectVolume;
    _ambienceVolume = _audioService.ambienceVolume;
  }

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
            'VOLUME CONTROL',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: widget.glowColor.withOpacity(0.8),
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 16),
          if (widget.showAmbienceVolume) ...[
            _buildVolumeSlider(
              label: 'AMBIENCE',
              icon: Icons.music_note,
              volume: _ambienceVolume,
              onChanged: (value) {
                setState(() => _ambienceVolume = value);
                _audioService.setAmbienceVolume(value);
              },
            ),
            if (widget.showEffectVolume) const SizedBox(height: 16),
          ],
          if (widget.showEffectVolume)
            _buildVolumeSlider(
              label: 'EFFECTS',
              icon: Icons.volume_up,
              volume: _effectVolume,
              onChanged: (value) {
                setState(() => _effectVolume = value);
                _audioService.setEffectVolume(value);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildVolumeSlider({
    required String label,
    required IconData icon,
    required double volume,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 16,
                  color: widget.glowColor.withOpacity(0.7),
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: widget.glowColor.withOpacity(0.7),
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
            Text(
              '${(volume * 100).round()}%',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SliderTheme(
          data: SliderThemeData(
            trackHeight: 3,
            thumbShape: const RoundSliderThumbShape(
              enabledThumbRadius: 6,
            ),
            overlayShape: const RoundSliderOverlayShape(
              overlayRadius: 14,
            ),
            activeTrackColor: widget.glowColor,
            inactiveTrackColor: widget.glowColor.withOpacity(0.2),
            thumbColor: Colors.white,
            overlayColor: widget.glowColor.withOpacity(0.2),
          ),
          child: Slider(
            value: volume,
            min: 0.0,
            max: 1.0,
            divisions: 20,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}

/// Compact volume control with icon buttons
class CompactVolumeControl extends StatefulWidget {
  final Color glowColor;

  const CompactVolumeControl({
    Key? key,
    required this.glowColor,
  }) : super(key: key);

  @override
  State<CompactVolumeControl> createState() => _CompactVolumeControlState();
}

class _CompactVolumeControlState extends State<CompactVolumeControl> {
  final AudioService _audioService = AudioService();
  bool _effectMuted = false;
  bool _ambienceMuted = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildMuteButton(
          icon: _ambienceMuted ? Icons.music_off : Icons.music_note,
          isMuted: _ambienceMuted,
          onTap: () {
            setState(() => _ambienceMuted = !_ambienceMuted);
            _audioService.toggleAmbienceMute();
          },
        ),
        const SizedBox(width: 12),
        _buildMuteButton(
          icon: _effectMuted ? Icons.volume_off : Icons.volume_up,
          isMuted: _effectMuted,
          onTap: () {
            setState(() => _effectMuted = !_effectMuted);
            _audioService.toggleEffectMute();
          },
        ),
      ],
    );
  }

  Widget _buildMuteButton({
    required IconData icon,
    required bool isMuted,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isMuted
              ? Colors.black.withOpacity(0.3)
              : widget.glowColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isMuted
                ? widget.glowColor.withOpacity(0.2)
                : widget.glowColor.withOpacity(0.5),
            width: 1,
          ),
          boxShadow: !isMuted
              ? [
                  BoxShadow(
                    color: widget.glowColor.withOpacity(0.2),
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        child: Icon(
          icon,
          size: 20,
          color: isMuted
              ? widget.glowColor.withOpacity(0.4)
              : widget.glowColor.withOpacity(0.9),
        ),
      ),
    );
  }
}
