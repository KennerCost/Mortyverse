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

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  Iterable<String> _options(TextEditingValue value) {
    final query = value.text.trim().toLowerCase();
    final names = widget.characters.map((character) => character.name);
    if (query.isEmpty) return names;
    return names.where((name) => name.toLowerCase().contains(query));
  }

  void _clear() {
    widget.controller.clear();
    widget.onChanged('');
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width.clamp(320.0, 430.0);
    final colors = Theme.of(context).colorScheme;

    return RawAutocomplete<String>(
      textEditingController: widget.controller,
      focusNode: _focusNode,
      optionsBuilder: _options,
      onSelected: (name) {
        widget.controller
          ..text = name
          ..selection = TextSelection.collapsed(offset: name.length);
        widget.onChanged(name);
        _focusNode.unfocus();
      },
      fieldViewBuilder: (context, controller, focusNode, onSubmit) {
        return SizedBox(
          height: width * 0.112,
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            onChanged: widget.onChanged,
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
              suffixIcon: controller.text.isEmpty
                  ? Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: context.mutedText,
                    )
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
        );
      },
      optionsViewBuilder: (context, onSelected, options) {
        final names = options.toList();

        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            color: colors.surface,
            elevation: 8,
            borderRadius: BorderRadius.circular(14),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: width - (width * 0.104),
                maxHeight: 250,
              ),
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 6),
                primary: false,
                physics: const ClampingScrollPhysics(),
                itemCount: names.length,
                separatorBuilder: (_, _) => Divider(
                  height: 1,
                  color: colors.outlineVariant.withValues(alpha: 0.55),
                ),
                itemBuilder: (context, index) {
                  final name = names[index];

                  return InkWell(
                    onTap: () => onSelected(name),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 13,
                      ),
                      child: Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: colors.onSurface,
                          fontSize: width * 0.04,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  OutlineInputBorder _border(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: color),
    );
  }
}
