import 'package:flutter_test/flutter_test.dart';

import 'package:rickmort/main.dart';

void main() {
  testWidgets('Mortyverse shows episode search home', (tester) async {
    await tester.pumpWidget(const MortyverseApp());
    await tester.pump(const Duration(milliseconds: 1600));
    await tester.pump();

    expect(find.text('Episodes'), findsOneWidget);
    expect(find.text('Explore the multiverse'), findsOneWidget);
    expect(find.text('Find an episode'), findsOneWidget);
    expect(find.text('Search'), findsOneWidget);
  });
}
