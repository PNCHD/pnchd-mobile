import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:pnchd_mobile/app.dart';
import 'package:pnchd_mobile/features/onboarding/onboarding_screen.dart';

/// In-memory stand-in for pkce token storage. Supabase.initialize defaults
/// `pkceAsyncStorage` to a SharedPreferences-backed implementation
/// regardless of the `localStorage` override above — it's a separate
/// storage concern (PKCE flow state, not session persistence) — so without
/// this, the test would still hit platform plugins that don't exist here.
class _InMemoryGotrueAsyncStorage extends GotrueAsyncStorage {
  final _store = <String, String>{};

  @override
  Future<String?> getItem({required String key}) async => _store[key];

  @override
  Future<void> setItem({required String key, required String value}) async {
    _store[key] = value;
  }

  @override
  Future<void> removeItem({required String key}) async => _store.remove(key);
}

void main() {
  setUpAll(() async {
    // EmptyLocalStorage skips session persistence so this doesn't need the
    // platform plugins Supabase.initialize would otherwise reach for.
    await Supabase.initialize(
      url: 'https://example.supabase.co',
      publishableKey: 'test-publishable-key',
      authOptions: FlutterAuthClientOptions(
        localStorage: const EmptyLocalStorage(),
        pkceAsyncStorage: _InMemoryGotrueAsyncStorage(),
      ),
    );
  });

  testWidgets('Redirects to onboarding when signed out', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: App()));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.byType(OnboardingScreen), findsOneWidget);
  });
}
