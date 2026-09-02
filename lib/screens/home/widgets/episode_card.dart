import 'package:flutter/material.dart';

import '../../../models/episode.dart';
import '../../../theme/app_colors.dart';
import '../utils/episode_formatters.dart';

class EpisodeCard extends StatelessWidget {
  final Episode episode;
  final VoidCallback onCharactersTap;

  const EpisodeCard({
    required this.episode,
    required this.onCharactersTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width.clamp(320.0, 430.0);
    final colors = Theme.of(context).colorScheme;
    final muted = context.mutedText;
    final isDark = context.isDark;

    return Container(
      padding: EdgeInsets.all(width * 0.036),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border.all(color: colors.outlineVariant),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.18 : 0.08),
            blurRadius: 18,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _EpisodeBanner(episode: episode),
          SizedBox(height: width * 0.04),
          _Badge(text: episode.badge),
          SizedBox(height: width * 0.03),
          Text(
            episode.name,
            style: TextStyle(
              color: colors.onSurface,
              fontSize: width * 0.058,
              height: 1.12,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: width * 0.034),
          Row(
            children: [
              Icon(
                Icons.calendar_month_outlined,
                size: width * 0.055,
                color: muted,
              ),
              SizedBox(width: width * 0.028),
              Expanded(
                child: Text(
                  'Air date: ${formatAirDate(episode.airDate)}',
                  style: TextStyle(color: muted, fontSize: width * 0.041),
                ),
              ),
            ],
          ),
          SizedBox(height: width * 0.05),
          SizedBox(
            width: double.infinity,
            height: width * 0.128,
            child: FilledButton(
              onPressed: onCharactersTap,
              style: FilledButton.styleFrom(
                backgroundColor: isDark
                    ? AppColors.portalGreen
                    : AppColors.darkButton,
                foregroundColor: isDark ? AppColors.darkButton : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.groups_2_outlined, size: width * 0.064),
                  SizedBox(width: width * 0.035),
                  Expanded(
                    child: Text(
                      'View characters',
                      style: TextStyle(
                        fontSize: width * 0.045,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  Icon(Icons.chevron_right_rounded, size: width * 0.07),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EpisodeBanner extends StatelessWidget {
  final Episode episode;

  const _EpisodeBanner({required this.episode});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width.clamp(320.0, 430.0);
    final colors = Theme.of(context).colorScheme;
    final muted = context.mutedText;

    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Container(
        height: width * 0.36,
        padding: EdgeInsets.symmetric(horizontal: width * 0.048),
        decoration: BoxDecoration(
          color: context.isDark
              ? AppColors.darkSoftSurface
              : const Color(0xFFF1F2F1),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              right: width * 0.045,
              top: width * 0.04,
              child: Icon(
                Icons.auto_awesome_rounded,
                color: colors.outlineVariant,
                size: width * 0.06,
              ),
            ),
            Positioned(
              right: -width * 0.035,
              top: width * 0.025,
              bottom: width * 0.025,
              child: Opacity(
                opacity: context.isDark ? 0.8 : 0.96,
                child: Image.asset(
                  'assets/images/portal-empty.png',
                  width: width * 0.34,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(right: width * 0.28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SEASON ${episode.season}',
                      style: TextStyle(
                        color: muted,
                        fontWeight: FontWeight.w700,
                        fontSize: width * 0.041,
                      ),
                    ),
                    SizedBox(height: width * 0.02),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'EPISODE ${episode.number}',
                        style: TextStyle(
                          color: colors.onSurface,
                          fontWeight: FontWeight.w800,
                          fontSize: width * 0.086,
                          height: 1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;

  const _Badge({required this.text});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width.clamp(320.0, 430.0);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.03,
        vertical: width * 0.018,
      ),
      decoration: BoxDecoration(
        color: context.isDark
            ? AppColors.darkSoftSurface
            : const Color(0xFFF0F1F0),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: context.mutedText,
          fontSize: width * 0.039,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
