import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';

Color statusColor(String status) {
  return switch (status.toLowerCase()) {
    'alive' => AppColors.successGreen,
    'dead' => AppColors.deadRed,
    _ => AppColors.unknownGray,
  };
}
