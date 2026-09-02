import 'dart:io';

import 'package:flutter/material.dart';

import '../../models/episode.dart';
import '../../services/episode_service.dart';
import '../../theme/app_colors.dart';
import '../../widgets/app_header.dart';
import '../../widgets/system_chrome_style.dart';
import '../characters/characters_screen.dart';
import 'widgets/episode_card.dart';
import 'widgets/search_section.dart';
import 'widgets/status_message.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback onThemeToggle;

  const HomeScreen({required this.onThemeToggle, super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _controller = TextEditingController();
  final _service = EpisodeService();

  Episode? _episode;
  String? _error;
  bool _loading = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _search() async {
    final id = int.tryParse(_controller.text.trim());
    if (id == null || id <= 0) {
      setState(() {
        _episode = null;
        _error = 'Enter a positive whole number.';
      });
      return;
    }
    if (_loading) return;

    setState(() {
      _loading = true;
      _episode = null;
      _error = null;
    });

    try {
      final episode = await _service.findById(id);
      if (mounted) setState(() => _episode = episode);
    } on EpisodeNotFoundException {
      if (mounted) setState(() => _error = 'Episode not found.');
    } on SocketException catch (error) {
      final isTimeout = error.message.toLowerCase().contains('timeout');
      if (mounted) {
        setState(() {
          _error = isTimeout
              ? 'API did not respond. Try again later.'
              : 'API connection error.';
        });
      }
    } catch (_) {
      if (mounted) setState(() => _error = 'Unable to search right now.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _openCharacters() {
    final episode = _episode;
    if (episode == null) return;

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => CharactersScreen(
          characters: episode.characters,
          onThemeToggle: widget.onThemeToggle,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width.clamp(320.0, 430.0);
    final colors = Theme.of(context).colorScheme;
    final muted = context.mutedText;
    final hasResult = _episode != null;

    return SystemChromeStyle(
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: EdgeInsets.fromLTRB(
              width * 0.052,
              width * 0.032,
              width * 0.052,
              28,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppHeader(onThemeToggle: widget.onThemeToggle),
                SizedBox(height: width * 0.03),
                Text(
                  'Episodes',
                  style: Theme.of(
                    context,
                  ).textTheme.displaySmall?.copyWith(color: colors.onSurface),
                ),
                const SizedBox(height: 10),
                Text(
                  'Explore the multiverse',
                  style: TextStyle(color: muted, fontSize: width * 0.046),
                ),
                SizedBox(height: width * 0.052),
                SearchSection(
                  controller: _controller,
                  loading: _loading,
                  onSearch: _search,
                ),
                if (_error != null) ...[
                  SizedBox(height: width * 0.055),
                  StatusMessage.error(_error!),
                  SizedBox(height: width * 0.07),
                  _ErrorHomeState(width: width),
                ],
                if (!hasResult && _error == null) ...[
                  SizedBox(height: width * 0.15),
                  _EmptyHomeState(width: width, muted: muted),
                ],
                if (hasResult) ...[
                  SizedBox(height: width * 0.07),
                  const StatusMessage.success('Episode found'),
                  SizedBox(height: width * 0.045),
                  EpisodeCard(
                    episode: _episode!,
                    onCharactersTap: _openCharacters,
                  ),
                  SizedBox(height: width * 0.045),
                  Row(
                    children: [
                      Icon(Icons.groups_2_outlined, color: muted, size: 25),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          'Explore this episode characters',
                          style: TextStyle(color: muted, fontSize: 17),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ErrorHomeState extends StatelessWidget {
  final double width;

  const _ErrorHomeState({required this.width});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Image.asset(
          'assets/images/rickpickle-badrequest.png',
          width: width * 0.54,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

class _EmptyHomeState extends StatelessWidget {
  final double width;
  final Color muted;

  const _EmptyHomeState({required this.width, required this.muted});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        children: [
          Image.asset(
            'assets/images/portal-empty.png',
            width: width * 0.38,
            height: width * 0.38,
            fit: BoxFit.contain,
          ),
          SizedBox(height: width * 0.07),
          Text(
            'Your next adventure starts here',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: colors.onSurface,
              fontSize: width * 0.048,
              fontWeight: FontWeight.w700,
              height: 1.2,
            ),
          ),
          SizedBox(height: width * 0.035),
          Text(
            'Enter an episode number to\nmeet its characters.',
            textAlign: TextAlign.center,
            style: TextStyle(color: muted, fontSize: width * 0.04, height: 1.5),
          ),
        ],
      ),
    );
  }
}
