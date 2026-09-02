import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:rickmort/services/episode_service.dart';

void main() {
  test('EpisodeService parses a successful response', () async {
    final service = EpisodeService(
      client: MockClient((request) async {
        expect(request.url.path, '/episode/1');

        return http.Response(
          jsonEncode({
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
                'image':
                    'https://rickandmortyapi.com/api/character/avatar/1.jpeg',
                'created': '2017-11-04T18:48:46.250Z',
              },
            ],
          }),
          200,
        );
      }),
    );

    final episode = await service.findById(1);

    expect(episode.name, 'Pilot');
    expect(episode.characters.first.name, 'Rick Sanchez');
  });

  test('EpisodeService throws when episode is not found', () {
    final service = EpisodeService(
      client: MockClient((_) async => http.Response('Not found', 404)),
    );

    expect(service.findById(404), throwsA(isA<EpisodeNotFoundException>()));
  });

  test('EpisodeService throws when API fails', () {
    final service = EpisodeService(
      client: MockClient((_) async => http.Response('Server error', 500)),
    );

    expect(service.findById(1), throwsA(isA<SocketException>()));
  });
}
