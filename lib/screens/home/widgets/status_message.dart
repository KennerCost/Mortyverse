import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';

class StatusMessage extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String text;

  const StatusMessage({
    required this.icon,
    required this.color,
    required this.text,
    super.key,
  });

  const StatusMessage.success(String text, {Key? key})
    : this(
        key: key,
        icon: Icons.check_circle_outline_rounded,
        color: AppColors.successGreen,
        text: text,
      );

  StatusMessage.error(String text, {Key? key})
    : this(
        key: key,
        icon: Icons.error_outline_rounded,
        color: Colors.red.shade600,
        text: text,
      );

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width.clamp(320.0, 430.0);

    return Row(
      children: [
        Icon(icon, color: color, size: width * 0.06),
        SizedBox(width: width * 0.03),
        Expanded(
          child: Text(
            text,
            style: TextStyle(color: context.mutedText, fontSize: width * 0.044),
          ),
        ),
      ],
    );
  }
}
