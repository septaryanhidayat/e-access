import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class StatusChip extends StatelessWidget {
  final String status;
  final double fontSize;

  const StatusChip({
    super.key,
    required this.status,
    this.fontSize = 11,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;

    final lower = status.toLowerCase();
    if (lower == 'hadir' || lower == 'completed' || lower == 'lulus' || lower == 'aktif') {
      bg = const Color(0xFF10B981).withAlpha(40);
      fg = const Color(0xFF10B981);
    } else if (lower == 'izin' || lower == 'in_progress' || lower == 'terjadwal') {
      bg = const Color(0xFFF59E0B).withAlpha(40);
      fg = const Color(0xFFF59E0B);
    } else if (lower == 'sakit') {
      bg = AppColors.electricBlue.withAlpha(40);
      fg = AppColors.electricBlue;
    } else if (lower == 'alpa' || lower == 'belum' || lower == 'nonaktif') {
      bg = AppColors.error.withAlpha(40);
      fg = AppColors.error;
    } else {
      bg = AppColors.textSecondary.withAlpha(40);
      fg = AppColors.textSecondary;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: fg.withAlpha(80)),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: fg,
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
