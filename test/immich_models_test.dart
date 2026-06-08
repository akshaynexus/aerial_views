import 'package:flutter_test/flutter_test.dart';
import 'package:aerial_views/aerial_views.dart';

void main() {
  group('ImmichMediaPrefs', () {
    test('constructs with defaults', () {
      const prefs = ImmichMediaPrefs();
      expect(prefs.enabled, false);
      expect(prefs.url, '');
      expect(prefs.apiKey, '');
      expect(prefs.authType, ImmichAuthType.sharedLink);
      expect(prefs.mediaType, ProviderMediaType.videosPhotos);
    });

    test('includeVideos for videos type', () {
      const prefs = ImmichMediaPrefs(mediaType: ProviderMediaType.videos);
      expect(prefs.includeVideos, isTrue);
      expect(prefs.includePhotos, isFalse);
    });

    test('includePhotos for photos type', () {
      const prefs = ImmichMediaPrefs(mediaType: ProviderMediaType.photos);
      expect(prefs.includeVideos, isFalse);
      expect(prefs.includePhotos, isTrue);
    });

    test('includeVideos and includePhotos for videosPhotos type', () {
      const prefs = ImmichMediaPrefs(mediaType: ProviderMediaType.videosPhotos);
      expect(prefs.includeVideos, isTrue);
      expect(prefs.includePhotos, isTrue);
    });
  });

  group('ExifInfo', () {
    test('constructs with values', () {
      const exif = ExifInfo(
        description: 'Test',
        country: 'US',
        state: 'CA',
        city: 'SF',
      );
      expect(exif.description, 'Test');
      expect(exif.country, 'US');
    });

    test('fromJson parses correctly', () {
      final json = {
        'description': 'Test',
        'country': 'US',
        'state': 'CA',
        'city': 'SF',
      };
      final exif = ExifInfo.fromJson(json);
      expect(exif.description, 'Test');
      expect(exif.city, 'SF');
    });

    test('fromJson handles nulls', () {
      final json = <String, dynamic>{};
      final exif = ExifInfo.fromJson(json);
      expect(exif.description, isNull);
      expect(exif.country, isNull);
    });
  });

  group('ImmichAsset', () {
    test('constructs with defaults', () {
      const asset = ImmichAsset();
      expect(asset.id, '');
      expect(asset.type, '');
      expect(asset.originalPath, '');
    });

    test('constructs with values', () {
      const asset = ImmichAsset(
        id: '123',
        type: 'VIDEO',
        originalPath: '/path/to/video.mp4',
        localDateTime: '2024-01-01T12:00:00',
        description: 'Test',
        albumName: 'Vacation',
      );
      expect(asset.id, '123');
      expect(asset.albumName, 'Vacation');
    });

    test('copyWith preserves unmodified fields', () {
      const original = ImmichAsset(
        id: '123',
        type: 'VIDEO',
        originalPath: '/path/to/video.mp4',
      );
      final copied = original.copyWith(albumName: 'Test Album');
      expect(copied.id, '123');
      expect(copied.albumName, 'Test Album');
    });

    test('fromJson parses correctly', () {
      final json = {
        'id': '123',
        'type': 'VIDEO',
        'originalPath': '/path/to/video.mp4',
        'localDateTime': '2024-01-01T12:00:00',
        'description': 'Test',
        'albumName': 'Vacation',
        'exifInfo': {
          'city': 'SF',
          'country': 'US',
        },
      };
      final asset = ImmichAsset.fromJson(json);
      expect(asset.id, '123');
      expect(asset.exifInfo!.city, 'SF');
    });

    test('fromJson handles missing exifInfo', () {
      final json = {
        'id': '123',
        'type': 'VIDEO',
        'originalPath': '/path/to/video.mp4',
      };
      final asset = ImmichAsset.fromJson(json);
      expect(asset.exifInfo, isNull);
    });
  });

  group('ImmichAlbum', () {
    test('constructs with defaults', () {
      const album = ImmichAlbum();
      expect(album.id, '');
      expect(album.assets, isEmpty);
    });

    test('copyWith preserves unmodified fields', () {
      const original = ImmichAlbum(
        id: '123',
        name: 'Test',
        description: 'Desc',
      );
      final copied = original.copyWith(
        assets: [const ImmichAsset(id: 'a1')],
      );
      expect(copied.id, '123');
      expect(copied.name, 'Test');
      expect(copied.assets.length, 1);
    });

    test('fromJson parses correctly', () {
      final json = {
        'id': '123',
        'albumName': 'Vacation',
        'description': 'My vacation',
        'shared': 'ALBUM',
        'assetCount': 5,
        'assets': [
          {'id': 'a1', 'type': 'VIDEO', 'originalPath': '/video.mp4'},
        ],
      };
      final album = ImmichAlbum.fromJson(json);
      expect(album.id, '123');
      expect(album.name, 'Vacation');
      expect(album.type, 'ALBUM');
      expect(album.assets.length, 1);
    });

    test('fromJson handles null assets', () {
      final json = {
        'id': '123',
        'albumName': 'Test',
      };
      final album = ImmichAlbum.fromJson(json);
      expect(album.assets, isEmpty);
    });
  });

  group('SharedLinkResponse', () {
    test('fromJson parses correctly', () {
      final json = {
        'id': 'link1',
        'description': 'Shared',
        'key': 'abc123',
        'type': 'ALBUM',
        'userId': 'user1',
        'createdAt': '2024-01-01',
        'allowUpload': false,
        'allowDownload': false,
        'showMetadata': false,
        'assets': [
          {'id': 'a1', 'type': 'VIDEO', 'originalPath': '/v.mp4'},
        ],
        'album': {
          'id': 'album1',
          'albumName': 'Test',
        },
      };
      final response = SharedLinkResponse.fromJson(json);
      expect(response.id, 'link1');
      expect(response.key, 'abc123');
      expect(response.assets.length, 1);
      expect(response.album!.id, 'album1');
      expect(response.allowUpload, false);
    });

    test('fromJson handles defaults', () {
      final json = <String, dynamic>{
        'id': 'link1',
      };
      final response = SharedLinkResponse.fromJson(json);
      expect(response.allowUpload, true);
      expect(response.allowDownload, true);
      expect(response.showMetadata, true);
      expect(response.assets, isEmpty);
      expect(response.album, isNull);
    });
  });

  group('SearchMetadataRequest', () {
    test('toJson includes non-null fields', () {
      const request = SearchMetadataRequest(
        isFavorite: true,
        rating: 5,
        size: 100,
        withExif: true,
        type: 'VIDEO',
      );
      final json = request.toJson();
      expect(json['isFavorite'], true);
      expect(json['rating'], 5);
      expect(json['size'], 100);
      expect(json['withExif'], true);
      expect(json['type'], 'VIDEO');
    });

    test('toJson omits null fields', () {
      const request = SearchMetadataRequest();
      final json = request.toJson();
      expect(json.containsKey('isFavorite'), isFalse);
      expect(json.containsKey('rating'), isFalse);
    });
  });

  group('AssetsResult', () {
    test('fromJson parses items', () {
      final json = {
        'items': [
          {'id': 'a1', 'type': 'VIDEO', 'originalPath': '/v.mp4'},
        ],
      };
      final result = AssetsResult.fromJson(json);
      expect(result.items.length, 1);
    });

    test('fromJson handles null items', () {
      final json = <String, dynamic>{};
      final result = AssetsResult.fromJson(json);
      expect(result.items, isEmpty);
    });
  });

  group('SearchAssetsResponse', () {
    test('fromJson parses correctly', () {
      final json = {
        'assets': {
          'items': [
            {'id': 'a1', 'type': 'VIDEO', 'originalPath': '/v.mp4'},
          ],
        },
      };
      final response = SearchAssetsResponse.fromJson(json);
      expect(response.assets.items.length, 1);
    });
  });

  group('ErrorResponse', () {
    test('fromJson parses correctly', () {
      final json = {
        'message': 'Not found',
        'error': 'Not Found',
        'statusCode': 404,
        'correlationId': 'abc',
      };
      final error = ErrorResponse.fromJson(json);
      expect(error.message, 'Not found');
      expect(error.statusCode, 404);
    });

    test('fromJson handles defaults', () {
      final json = <String, dynamic>{};
      final error = ErrorResponse.fromJson(json);
      expect(error.message, '');
      expect(error.statusCode, 0);
    });
  });

  group('ProviderMediaTypeExtension', () {
    test('videos returns VIDEO', () {
      expect(ProviderMediaType.videos.apiTypeFilter, 'VIDEO');
    });

    test('photos returns IMAGE', () {
      expect(ProviderMediaType.photos.apiTypeFilter, 'IMAGE');
    });

    test('videosPhotos returns null', () {
      expect(ProviderMediaType.videosPhotos.apiTypeFilter, isNull);
    });
  });
}
