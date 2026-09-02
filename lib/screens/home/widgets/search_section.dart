import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../theme/app_colors.dart';

class SearchSection extends StatelessWidget {
  final TextEditingController controller;
  final bool loading;
  final VoidCallback onSearch;

  const SearchSection({
    required this.controller,
    required this.loading,
    required this.onSearch,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width.clamp(320.0, 430.0);
    final colors = Theme.of(context).colorScheme;
    final isDark = context.isDark;
    final height = width * 0.112;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Find an episode',
          style: TextStyle(
            color: colors.onSurface,
            fontSize: width * 0.048,
            fontWeight: FontWeight.w800,
          ),
        ),
        SizedBox(height: width * 0.018),
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: height,
                child: TextField(
                  controller: controller,
                  enabled: !loading,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.search,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onSubmitted: (_) => onSearch(),
                  style: TextStyle(
                    color: colors.onSurface,
                    fontSize: width * 0.047,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Ex.: 17',
                    hintStyle: TextStyle(
                      color: context.mutedText,
                      fontSize: width * 0.044,
                      fontWeight: FontWeight.w500,
                    ),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      size: width * 0.073,
                      color: context.mutedText,
                    ),
                    contentPadding: EdgeInsets.zero,
                    enabledBorder: _border(colors.outlineVariant),
                    focusedBorder: _border(colors.onSurface),
                    border: _border(colors.outlineVariant),
                  ),
                ),
              ),
            ),
            SizedBox(width: width * 0.03),
            SizedBox(
              height: height,
              width: width * 0.24,
              child: FilledButton(
                onPressed: loading ? null : onSearch,
                style: FilledButton.styleFrom(
                  backgroundColor: isDark
                      ? AppColors.portalGreen
                      : AppColors.darkButton,
                  foregroundColor: isDark ? AppColors.darkButton : Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(17),
                  ),
                ),
                child: loading
                    ? SizedBox.square(
                        dimension: width * 0.05,
                        child: CircularProgressIndicator(
                          color: isDark ? AppColors.darkButton : Colors.white,
                          strokeWidth: 2.4,
                        ),
                      )
                    : FittedBox(
                        child: Text(
                          'Search',
                          style: TextStyle(
                            fontSize: width * 0.045,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  OutlineInputBorder _border(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(17),
      borderSide: BorderSide(color: color),
    );
  }
}
