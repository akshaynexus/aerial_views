import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:aerial_views/aerial_views.dart';
import 'package:aerial_views/src/providers/immich_api.dart';
import 'package:aerial_views/src/providers/immich_repository.dart';

import 'immich_repository_test.mocks.dart';

@GenerateMocks([ImmichApi])
void main() {
  late MockImmichApi mockApi;
  late ImmichRepository repository;

  setUp(() {
    mockApi = MockImmichApi();
    const prefs = ImmichMediaPrefs(
      url: 'http://localhost:2283',
      apiKey: 'test-key',
      authType: ImmichAuthType.apiKey,
      mediaType: ProviderMediaType.videos,
      includeFavorites: 'DISABLED',
      includeRandom: 'DISABLED',
      includeRecent: 'DISABLED',
    );
    repository = ImmichRepository(prefs: prefs, api: mockApi);
  });

  group('filterByMediaType', () {
    test('filters videos when mediaType is videos', () {
      const assets = [
        ImmichAsset(id: '1', type: 'VIDEO', originalPath: '/video.mp4'),
        ImmichAsset(id: '2', type: 'IMAGE', originalPath: '/image.jpg'),
        ImmichAsset(id: '3', type: 'VIDEO', originalPath: '/clip.mov'),
      ];
      final filtered = repository.filterByMediaType(assets);
      expect(filtered.length, 2);
      expect(filtered[0].id, '1');
      expect(filtered[1].id, '3');
    });

    test('filters out unsupported types', () {
      const assets = [
        ImmichAsset(id: '1', type: 'VIDEO', originalPath: '/video.mp4'),
        ImmichAsset(id: '2', type: 'OTHER', originalPath: '/file.xyz'),
      ];
      final filtered = repository.filterByMediaType(assets);
      expect(filtered.length, 1);
    });
  });

  group('processAssets', () {
    test('maps assets to AerialMedia', () {
      when(mockApi.getAssetUri('1', true))
          .thenReturn('http://localhost/api/assets/1/video/playback');
      const assets = [
        ImmichAsset(
          id: '1',
          type: 'VIDEO',
          originalPath: '/video.mp4',
          albumName: 'Vacation',
        ),
      ];
      final media = repository.processAssets(assets);
      expect(media.length, 1);
      expect(media[0].url, 'http://localhost/api/assets/1/video/playback');
      expect(media[0].type, AerialMediaType.video);
      expect(media[0].source, AerialMediaSource.immich);
    });

    test('skips unsupported file types', () {
      const assets = [
        ImmichAsset(id: '1', type: 'OTHER', originalPath: '/file.xyz'),
      ];
      final media = repository.processAssets(assets);
      expect(media.isEmpty, isTrue);
    });

    test('skips videos when not included', () {
      const prefs = ImmichMediaPrefs(
        mediaType: ProviderMediaType.photos,
      );
      final repo = ImmichRepository(prefs: prefs, api: mockApi);
      const assets = [
        ImmichAsset(id: '1', type: 'VIDEO', originalPath: '/video.mp4'),
      ];
      final media = repo.processAssets(assets);
      expect(media.isEmpty, isTrue);
    });

    test('skips images when not included', () {
      const prefs = ImmichMediaPrefs(
        mediaType: ProviderMediaType.videos,
      );
      final repo = ImmichRepository(prefs: prefs, api: mockApi);
      const assets = [
        ImmichAsset(id: '1', type: 'IMAGE', originalPath: '/image.jpg'),
      ];
      final media = repo.processAssets(assets);
      expect(media.isEmpty, isTrue);
    });

    test('builds description from EXIF location', () {
      when(mockApi.getAssetUri('1', false))
          .thenReturn('http://localhost/api/assets/1/thumbnail?size=preview');
      const prefs = ImmichMediaPrefs(
        mediaType: ProviderMediaType.videosPhotos,
      );
      final repo = ImmichRepository(prefs: prefs, api: mockApi);
      const assets = [
        ImmichAsset(
          id: '1',
          type: 'IMAGE',
          originalPath: '/image.jpg',
          exifInfo: ExifInfo(city: 'SF', state: 'CA', country: 'US'),
        ),
      ];
      final media = repo.processAssets(assets);
      expect(media[0].metadata.shortDescription, 'SF, CA, US');
    });

    test('falls back to description when no EXIF location', () {
      when(mockApi.getAssetUri('1', false))
          .thenReturn('http://localhost/api/assets/1/thumbnail?size=preview');
      const prefs = ImmichMediaPrefs(
        mediaType: ProviderMediaType.videosPhotos,
      );
      final repo = ImmichRepository(prefs: prefs, api: mockApi);
      const assets = [
        ImmichAsset(
          id: '1',
          type: 'IMAGE',
          originalPath: '/image.jpg',
          description: 'Fallback description',
        ),
      ];
      final media = repo.processAssets(assets);
      expect(media[0].metadata.shortDescription, 'Fallback description');
    });
  });

  group('fetchAllAssets', () {
    test('fetches and deduplicates assets', () async {
      when(mockApi.getAlbums()).thenAnswer((_) async => []);
      when(mockApi.getAlbums(shared: true)).thenAnswer((_) async => []);

      final result = await repository.fetchAllAssets();
      expect(result, isEmpty);
    });
  });

  group('fetchAlbums', () {
    test('deduplicates albums', () async {
      final album1 = const ImmichAlbum(id: '1', name: 'Album 1');
      final album2 = const ImmichAlbum(id: '1', name: 'Album 1 Duplicate');
      final album3 = const ImmichAlbum(id: '2', name: 'Album 2');

      when(mockApi.getAlbums()).thenAnswer((_) async => [album1, album2]);
      when(mockApi.getAlbums(shared: true)).thenAnswer((_) async => [album3]);

      final albums = await repository.fetchAlbums();
      expect(albums.length, 2);
    });
  });

  group('getSelectedAlbumFromAPI', () {
    test('returns empty album when no IDs selected', () async {
      const prefs = ImmichMediaPrefs(
        selectedAlbumIds: {},
        authType: ImmichAuthType.apiKey,
      );
      final repo = ImmichRepository(prefs: prefs, api: mockApi);

      final album = await repo.getSelectedAlbumFromAPI();
      expect(album.id, 'combined');
      expect(album.description, 'No albums selected');
    });
  });
}
