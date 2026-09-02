import 'package:flutter/material.dart';

import '../../../models/character.dart';
import '../../../theme/app_colors.dart';

class CharacterSearchField extends StatefulWidget {
  final TextEditingController controller;
  final List<Character> characters;
  final ValueChanged<String> onChanged;

  const CharacterSearchField({
    required this.controller,
    required this.characters,
    required this.onChanged,
    super.key,
  });

  @override
  State<CharacterSearchField> createState() => _CharacterSearchFieldState();
}

class _CharacterSearchFieldState extends State<CharacterSearchField> {
  final _focusNode = FocusNode();
  String _query = '';

  List<Character> get _suggestions {
    final query = _query.trim().toLowerCase();
    if (query.isEmpty || !_focusNode.hasFocus) return [];

    return widget.characters.where((character) {
      return character.name.toLowerCase().contains(query);
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _query = widget.controller.text;
    _focusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _change(String value) {
    setState(() => _query = value);
    widget.onChanged(value);
  }

  void _select(Character character) {
    widget.controller
      ..text = character.name
      ..selection = TextSelection.collapsed(offset: character.name.length);
    _change(character.name);
    _focusNode.unfocus();
  }

  void _clear() {
    widget.controller.clear();
    _change('');
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width.clamp(320.0, 430.0);
    final colors = Theme.of(context).colorScheme;
    final suggestions = _suggestions;

    return Column(
      children: [
        SizedBox(
          height: width * 0.112,
          child: TextField(
            controller: widget.controller,
            focusNode: _focusNode,
            onChanged: _change,
            textInputAction: TextInputAction.search,
            style: TextStyle(color: colors.onSurface, fontSize: width * 0.044),
            decoration: InputDecoration(
              hintText: 'Search character',
              hintStyle: TextStyle(color: context.mutedText),
              prefixIcon: Icon(
                Icons.search_rounded,
                color: context.mutedText,
                size: width * 0.065,
              ),
              suffixIcon: _query.isEmpty
                  ? null
                  : IconButton(
                      onPressed: _clear,
                      icon: Icon(Icons.close_rounded, color: context.mutedText),
                    ),
              contentPadding: EdgeInsets.zero,
              enabledBorder: _border(colors.outlineVariant),
              focusedBorder: _border(colors.onSurface),
              border: _border(colors.outlineVariant),
            ),
          ),
        ),
        if (suggestions.isNotEmpty) ...[
          const SizedBox(height: 8),
          Container(
            constraints: BoxConstraints(maxHeight: width * 0.55),
            decoration: BoxDecoration(
              color: colors.surface,
              border: Border.all(color: colors.outlineVariant),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(
                    alpha: context.isDark ? 0.18 : 0.07,
                  ),
                  blurRadius: 14,
                  offset: const Offset(0, 7),
                ),
              ],
            ),
            child: ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(vertical: 6),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              itemCount: suggestions.length,
              separatorBuilder: (_, _) => Divider(
                height: 1,
                color: colors.outlineVariant.withValues(alpha: 0.55),
              ),
              itemBuilder: (context, index) {
                final character = suggestions[index];

                return ListTile(
                  dense: true,
                  leading: CircleAvatar(
                    backgroundColor: colors.outlineVariant,
                    backgroundImage: NetworkImage(character.image),
                  ),
                  title: Text(
                    character.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: colors.onSurface,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  subtitle: Text(
                    character.status,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: context.mutedText),
                  ),
                  onTap: () => _select(character),
                );
              },
            ),
          ),
        ],
      ],
    );
  }

  OutlineInputBorder _border(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: color),
    );
  }
}
