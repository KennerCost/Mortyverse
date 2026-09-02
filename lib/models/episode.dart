import 'character.dart';

class Episode {
  final int id;
  final String name;
  final String airDate;
  final String episode;
  final List<Character> characters;

  const Episode({
    required this.id,
    required this.name,
    required this.airDate,
    required this.episode,
    required this.characters,
  });

  factory Episode.fromJson(Map<String, dynamic> json) {
    final charactersJson = json['characters'] as List? ?? const [];

    return Episode(
      id: json['id'] as int,
      name: json['name'] as String,
      airDate: json['air_date'] as String,
      episode: json['episode'] as String,
      characters: charactersJson
          .map((item) => Character.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  RegExpMatch? get _episodeMatch {
    return RegExp(r'^S(\d+)E(\d+)$').firstMatch(episode);
  }

  String get season => _episodeMatch?.group(1)?.padLeft(2, '0') ?? '--';
  String get number => _episodeMatch?.group(2)?.padLeft(2, '0') ?? '--';
  String get badge => 'S$season - E$number';
}
