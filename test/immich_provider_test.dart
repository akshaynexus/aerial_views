import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:aerial_views/aerial_views.dart';
import 'package:aerial_views/src/providers/immich_provider.dart';

import 'immich_provider_test.mocks.dart';

@GenerateMocks([ImmichProvider])
void main() {
  group('ImmichProvider', () {
    test('constructs with prefs', () {
      const prefs = ImmichMediaPrefs(
        url: 'http://localhost:2283',
        apiKey: 'test-key',
        authType: ImmichAuthType.apiKey,
      );
      final provider = ImmichProvider(prefs: prefs);
      expect(provider, isA<ImmichProvider>());
    });

    test('validateInput returns error for empty url', () async {
      const prefs = ImmichMediaPrefs(url: '');
      final provider = ImmichProvider(prefs: prefs);

      expect(
        () => provider.fetch(),
        throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('Hostname and port not specified'),
        )),
      );
    });

    test('validateInput returns error for empty pathName with sharedLink', () async {
      const prefs = ImmichMediaPrefs(
        url: 'http://localhost:2283',
        authType: ImmichAuthType.sharedLink,
        pathName: '',
      );
      final provider = ImmichProvider(prefs: prefs);

      expect(
        () => provider.fetch(),
        throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('Path name is empty'),
        )),
      );
    });

    test('validateInput returns error for empty apiKey with apiKey auth', () async {
      const prefs = ImmichMediaPrefs(
        url: 'http://localhost:2283',
        authType: ImmichAuthType.apiKey,
        apiKey: '',
      );
      final provider = ImmichProvider(prefs: prefs);

      expect(
        () => provider.fetch(),
        throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('API key is empty'),
        )),
      );
    });
  });

  group('ImmichMediaPrefs', () {
    test('implements equality', () {
      const prefs1 = ImmichMediaPrefs(url: 'http://test.com', apiKey: 'key1');
      const prefs2 = ImmichMediaPrefs(url: 'http://test.com', apiKey: 'key1');
      expect(prefs1.url, prefs2.url);
      expect(prefs1.apiKey, prefs2.apiKey);
    });
  });
}
