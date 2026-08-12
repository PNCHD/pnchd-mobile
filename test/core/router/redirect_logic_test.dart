import 'package:flutter_test/flutter_test.dart';
import 'package:pnchd_mobile/core/models/profile.dart';
import 'package:pnchd_mobile/core/router/redirect_logic.dart';

const _owner = Profile(id: 'u1', role: ProfileRole.owner, organizationId: 'o1');
const _client = Profile(id: 'u2', role: ProfileRole.client, organizationId: 'o1');
const _driver = Profile(id: 'u3', role: ProfileRole.driver, organizationId: 'o1');

void main() {
  group('signed out', () {
    test('redirects to onboarding from any other path', () {
      expect(resolveRedirect(null, '/dashboard'), '/onboarding');
    });

    test('stays put once already on onboarding', () {
      expect(resolveRedirect(null, '/onboarding'), isNull);
    });
  });

  group('signed in, on onboarding', () {
    test('owner bounces to /dashboard', () {
      expect(resolveRedirect(_owner, '/onboarding'), '/dashboard');
    });

    test('client bounces to /client', () {
      expect(resolveRedirect(_client, '/onboarding'), '/client');
    });

    test('driver bounces to /driver', () {
      expect(resolveRedirect(_driver, '/onboarding'), '/driver');
    });
  });

  group('signed in, on their own area', () {
    test('owner on a contractor path stays put', () {
      expect(resolveRedirect(_owner, '/projects'), isNull);
      expect(resolveRedirect(_owner, '/settings/billing'), isNull);
    });

    test('client on /client stays put', () {
      expect(resolveRedirect(_client, '/client'), isNull);
    });

    test('driver on /driver stays put', () {
      expect(resolveRedirect(_driver, '/driver'), isNull);
    });
  });

  group('signed in, wrong area', () {
    test('client hitting a contractor path gets bounced to /client', () {
      expect(resolveRedirect(_client, '/dashboard'), '/client');
    });

    test('driver hitting a contractor path gets bounced to /driver', () {
      expect(resolveRedirect(_driver, '/settings/account'), '/driver');
    });

    test('owner hitting /client gets bounced to /dashboard', () {
      expect(resolveRedirect(_owner, '/client'), '/dashboard');
    });
  });
}
