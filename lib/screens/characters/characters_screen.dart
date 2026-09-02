import 'package:flutter/material.dart';

import '../../models/character.dart';
import '../../theme/app_colors.dart';
import '../../widgets/app_header.dart';
import '../../widgets/system_chrome_style.dart';
import 'widgets/character_card.dart';
import 'widgets/character_filters.dart';
import 'widgets/character_search_field.dart';

class CharactersScreen extends StatefulWidget {
  final List<Character> characters;
  final VoidCallback onThemeToggle;

  const CharactersScreen({
    required this.characters,
    required this.onThemeToggle,
    super.key,
  });

  @override
  State<CharactersScreen> createState() => _CharactersScreenState();
}

class _CharactersScreenState extends State<CharactersScreen> {
  final _searchController = TextEditingController();
  CharacterStatusFilter _filter = CharacterStatusFilter.all;
  String _query = '';

  List<Character> get _filtered {
    final query = _query.trim().toLowerCase();
    return widget.characters.where((character) {
      final matchesName =
          query.isEmpty || character.name.toLowerCase().contains(query);
      final matchesStatus =
          _filter == CharacterStatusFilter.all ||
          character.status.toLowerCase() == _filter.name;
      return matchesName && matchesStatus;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width.clamp(320.0, 430.0);
    final colors = Theme.of(context).colorScheme;
    final characters = _filtered;

    return SystemChromeStyle(
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: CustomScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            slivers: [
              SliverPadding(
                padding: EdgeInsets.fromLTRB(
                  width * 0.052,
                  width * 0.032,
                  width * 0.052,
                  width * 0.05,
                ),
                sliver: SliverList.list(
                  children: [
                    AppHeader(onThemeToggle: widget.onThemeToggle),
                    SizedBox(height: width * 0.03),
                    Text(
                      'Characters',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: colors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Explore the multiverse',
                      style: TextStyle(
                        color: context.mutedText,
                        fontSize: width * 0.051,
                      ),
                    ),
                    SizedBox(height: width * 0.05),
                    CharacterSearchField(
                      controller: _searchController,
                      characters: widget.characters,
                      onChanged: (value) => setState(() => _query = value),
                    ),
                    SizedBox(height: width * 0.04),
                    CharacterFilters(
                      selected: _filter,
                      onChanged: (filter) => setState(() => _filter = filter),
                    ),
                  ],
                ),
              ),
              if (characters.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        widget.characters.isEmpty
                            ? 'No characters in this episode.'
                            : 'No characters found.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: context.mutedText,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                    width * 0.052,
                    0,
                    width * 0.052,
                    28,
                  ),
                  sliver: SliverGrid.builder(
                    itemCount: characters.length,
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: width * 0.47,
                      mainAxisSpacing: width * 0.035,
                      crossAxisSpacing: width * 0.035,
                      childAspectRatio: 0.62,
                    ),
                    itemBuilder: (context, index) {
                      return CharacterCard(character: characters[index]);
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
