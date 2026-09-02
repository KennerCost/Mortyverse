import 'package:flutter_test/flutter_test.dart';
import 'package:rickmort/services/episode_service.dart';

void main() {
  test(
    'EpisodeService fetches an episode from the API',
    () async {
      final episode = await EpisodeService().findById(1);

      expect(episode.id, 1);
      expect(episode.name, isNotEmpty);
      expect(episode.airDate, isNotEmpty);
      expect(episode.episode, startsWith('S'));
      expect(episode.characters, isNotEmpty);

      final character = episode.characters.first;
      expect(character.name, isNotEmpty);
      expect(character.status, isNotEmpty);
      expect(character.gender, isNotEmpty);
      expect(character.origin, isNotEmpty);
      expect(character.image, startsWith('http'));
    },
    timeout: const Timeout(Duration(seconds: 10)),
  );
}
