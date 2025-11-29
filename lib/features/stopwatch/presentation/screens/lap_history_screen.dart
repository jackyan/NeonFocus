import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/themes/glow_theme.dart';
import '../../domain/stopwatch_model.dart';

/// Independent lap history screen that shows as a modal
class LapHistoryScreen extends StatelessWidget {
  final List<Lap> laps;
  final NeonTheme theme;

  const LapHistoryScreen({
    Key? key,
    required this.laps,
    required this.theme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      height: screenHeight * 0.33, // 1/3 of screen height
      decoration: BoxDecoration(
        color: const Color(0xFF0A0E27),
        borderRadius: const BorderRadius.all(Radius.circular(20)), // All corners rounded
        border: Border.all(
          color: theme.glowColor.withOpacity(0.3),
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

          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.lapHistory,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: theme.glowColor,
                    letterSpacing: 2,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: theme.glowColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.close,
                      color: theme.glowColor,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: laps.isEmpty
                ? _buildEmptyState(l10n)
                : Column(
                    children: [
                      // Statistics
                      _buildStatistics(l10n),
                      const SizedBox(height: 12),
                      // Lap list
                      Expanded(
                        child: _buildLapList(l10n),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.timer_outlined,
            size: 64,
            color: theme.glowColor.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.noLaps,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatistics(AppLocalizations l10n) {
    if (laps.isEmpty) return const SizedBox.shrink();

    final lapSeconds = laps.map((lap) => lap.lapSeconds).toList();
    final fastest = lapSeconds.reduce((a, b) => a < b ? a : b);
    final slowest = lapSeconds.reduce((a, b) => a > b ? a : b);
    final average = lapSeconds.reduce((a, b) => a + b) ~/ lapSeconds.length;
    final total = lapSeconds.reduce((a, b) => a + b);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: theme.glowColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.glowColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(l10n.fastest, _formatSeconds(fastest)),
          _buildStatItem(l10n.slowest, _formatSeconds(slowest)),
          _buildStatItem(l10n.average, _formatSeconds(average)),
          _buildStatItem(l10n.totalTime, _formatSeconds(total)),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 9,
            color: Colors.white.withOpacity(0.6),
            fontWeight: FontWeight.w300,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 11,
            color: theme.glowColor,
            fontWeight: FontWeight.bold,
            fontFamily: 'Orbitron',
          ),
        ),
      ],
    );
  }

  Widget _buildLapList(AppLocalizations l10n) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      itemCount: laps.length,
      itemBuilder: (context, index) {
        final lap = laps[laps.length - 1 - index]; // Reverse order (newest first)
        
        return Container(
          margin: const EdgeInsets.only(bottom: 6),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: theme.glowColor.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.lapNumber(lap.lapNumber),
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                ),
              ),
              Text(
                _formatSeconds(lap.lapSeconds),
                style: TextStyle(
                  fontSize: 13,
                  color: theme.glowColor,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Orbitron',
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatSeconds(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
