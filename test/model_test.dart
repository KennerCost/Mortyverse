import 'package:flutter_test/flutter_test.dart';
import 'package:rickmort/models/episode.dart';

void main() {
  test('Episode parses basic API data', () {
    final episode = Episode.fromJson({
      'id': 1,
      'name': 'Pilot',
      'air_date': 'December 2, 2013',
      'episode': 'S01E01',
      'characters': [
        {
          'name': 'Rick Sanchez',
          'status': 'Alive',
          'species': 'Human',
          'gender': 'Male',
          'origin': 'Earth (C-137)',
          'image': 'https://rickandmortyapi.com/api/character/avatar/1.jpeg',
          'created': '2017-11-04T18:48:46.250Z',
        },
      ],
    });

    expect(episode.id, 1);
    expect(episode.name, 'Pilot');
    expect(episode.season, '01');
    expect(episode.number, '01');
    expect(episode.badge, 'S01 - E01');
    expect(episode.characters.first.name, 'Rick Sanchez');
    expect(episode.characters.first.gender, 'Male');
  });
}
