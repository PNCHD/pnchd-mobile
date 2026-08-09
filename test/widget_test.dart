import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:pnchd_mobile/main.dart';

void main() {
  setUpAll(() async {
    // EmptyLocalStorage skips session persistence so this doesn't need the
    // platform plugins Supabase.initialize would otherwise reach for.
    await Supabase.initialize(
      url: 'https://example.supabase.co',
      publishableKey: 'test-publishable-key',
      authOptions: const FlutterAuthClientOptions(
        localStorage: EmptyLocalStorage(),
      ),
    );
  });

  testWidgets('App builds and shows the Supabase connection status', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.textContaining('Supabase client connected'), findsOneWidget);
  });
}
