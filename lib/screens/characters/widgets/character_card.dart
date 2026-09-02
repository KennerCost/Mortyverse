import 'package:flutter/material.dart';

import '../../../models/character.dart';
import '../../../theme/app_colors.dart';
import '../utils/character_formatters.dart';

class CharacterCard extends StatelessWidget {
  final Character character;

  const CharacterCard({required this.character, super.key});

  void _showDetails(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final height = MediaQuery.sizeOf(context).height;

    showDialog<void>(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: colors.surface,
          insetPadding: const EdgeInsets.symmetric(horizontal: 22),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: height * 0.82),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: AspectRatio(
                          aspectRatio: 1.25,
                          child: Image.network(
                            character.image,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, progress) {
                              if (progress == null) return child;
                              return const _ImagePlaceholder(
                                icon: Icons.image_outlined,
                              );
                            },
                            errorBuilder: (_, _, _) => const _ImagePlaceholder(
                              icon: Icons.person_outline,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 8,
                        top: 8,
                        child: IconButton.filled(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close_rounded),
                          style: IconButton.styleFrom(
                            backgroundColor: colors.surface,
                            foregroundColor: colors.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    character.name,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: colors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: context.isDark
                          ? AppColors.darkSoftSurface
                          : const Color(0xFFF4F6F4),
                      border: Border.all(color: colors.outlineVariant),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        _DetailLine(
                          'Status',
                          character.status,
                          dotColor: statusColor(character.status),
                        ),
                        _DetailLine('Origin', character.origin),
                        _DetailLine('Species', character.species),
                        _DetailLine('Gender', character.gender),
                        _DetailLine('Created', character.created),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width.clamp(320.0, 430.0);
    final colors = Theme.of(context).colorScheme;

    return InkWell(
      onTap: () => _showDetails(context),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: colors.surface,
          border: Border.all(color: colors.outlineVariant),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(
                alpha: context.isDark ? 0.18 : 0.06,
              ),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(13),
                child: Image.network(
                  character.image,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return const _ImagePlaceholder(icon: Icons.image_outlined);
                  },
                  errorBuilder: (_, _, _) {
                    return const _ImagePlaceholder(
                      icon: Icons.broken_image_outlined,
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: width * 0.02),
            Text(
              character.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: colors.onSurface,
                fontSize: width * 0.038,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: width * 0.014),
            _InfoLine(
              label: 'Status',
              value: character.status,
              dotColor: statusColor(character.status),
            ),
            _InfoLine(label: 'Origin', value: character.origin),
          ],
        ),
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  final String label;
  final String value;
  final Color? dotColor;

  const _InfoLine({required this.label, required this.value, this.dotColor});

  @override
  Widget build(BuildContext context) {
    final muted = context.mutedText;

    return Padding(
      padding: const EdgeInsets.only(top: 3),
      child: Row(
        children: [
          if (dotColor != null) ...[
            Container(
              width: 7,
              height: 7,
              decoration: BoxDecoration(
                color: dotColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 5),
          ],
          Text(
            '$label: ',
            style: TextStyle(
              color: muted,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
          Expanded(
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: muted, fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailLine extends StatelessWidget {
  final String label;
  final String value;
  final Color? dotColor;

  const _DetailLine(this.label, this.value, {this.dotColor});

  @override
  Widget build(BuildContext context) {
    final text = value.trim().isEmpty ? '-' : value;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (dotColor != null) ...[
            Padding(
              padding: const EdgeInsets.only(top: 7),
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: dotColor,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          SizedBox(
            width: dotColor == null ? 76 : 60,
            child: Text(
              '$label:',
              style: TextStyle(
                color: context.mutedText,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            ),
          ),
        ],
      ),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  final IconData icon;

  const _ImagePlaceholder({required this.icon});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Center(
        child: Icon(
          icon,
          color: Theme.of(context).colorScheme.outline,
          size: 32,
        ),
      ),
    );
  }
}
