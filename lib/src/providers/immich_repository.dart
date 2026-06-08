import 'dart:async';

import '../models/aerial_media.dart';
import '../models/immich_models.dart';
import 'immich_api.dart';
import 'utils.dart';

class ImmichRepository {
  final ImmichMediaPrefs prefs;
  final ImmichApi api;

  ImmichRepository({required this.prefs, required this.api});

  String? _getTypeFilter() => prefs.mediaType.apiTypeFilter;

  List<AerialMedia> processAssets(List<ImmichAsset> assets) {
    final media = <AerialMedia>[];
    for (final asset in assets) {
      final filename = asset.originalPath;
      final isVideo = isSupportedVideoType(filename);
      final isImage = isSupportedImageType(filename);
      if (!isVideo && !isImage) continue;
      if (isVideo && !prefs.includeVideos) continue;
      if (isImage && !prefs.includePhotos) continue;

      media.add(AerialMedia(
        url: api.getAssetUri(asset.id, isVideo),
        type: isVideo ? AerialMediaType.video : AerialMediaType.image,
        source: AerialMediaSource.immich,
        metadata: AerialMediaMetadata(
          shortDescription: _buildDescription(asset),
        ),
      ));
    }
    return media;
  }

  List<ImmichAsset> filterByMediaType(List<ImmichAsset> assets) {
    return assets.where((asset) {
      final filename = asset.originalPath;
      if (isSupportedVideoType(filename)) return prefs.includeVideos;
      if (isSupportedImageType(filename)) return prefs.includePhotos;
      return false;
    }).toList();
  }

  static String _buildDescription(ImmichAsset asset) {
    final parts = <String>[];
    final exif = asset.exifInfo;
    final city = exif?.city;
    final state = exif?.state;
    final country = exif?.country;
    if (city != null) parts.add(city);
    if (state != null) parts.add(state);
    if (country != null) parts.add(country);
    if (parts.isNotEmpty) return parts.join(', ');
    return asset.description ?? '';
  }

  Future<List<AerialMedia>> fetchAllAssets() async {
    final primaryAlbum = prefs.authType == ImmichAuthType.sharedLink
        ? await getSharedAlbumFromAPI()
        : await getSelectedAlbumFromAPI();

    final filteredPrimary = filterByMediaType(primaryAlbum.assets);
    final allAssets = <ImmichAsset>[...filteredPrimary];

    final favoriteAssets = await _fetchOptionalAssets(() => _fetchFavorites());
    final ratedAssets = await _fetchOptionalAssets(() => _fetchRated());
    final randomAssets = await _fetchOptionalAssets(() => _fetchRandom());
    final recentAssets = await _fetchOptionalAssets(() => _fetchRecent());

    allAssets.addAll(filterByMediaType(favoriteAssets));
    allAssets.addAll(filterByMediaType(ratedAssets));
    allAssets.addAll(filterByMediaType(randomAssets));
    allAssets.addAll(filterByMediaType(recentAssets));

    final seenIds = <String>{};
    final unique = <ImmichAsset>[];
    for (final asset in allAssets) {
      if (seenIds.add(asset.id)) unique.add(asset);
    }

    return processAssets(unique);
  }

  Future<ImmichAlbum> getSharedAlbumFromAPI() async {
    final path = prefs.pathName;
    final cleaned = cleanSharedLinkKey(path);
    final useSlug = _isSlugFormat(path);

    final shared = await api.getSharedAlbum(
      key: useSlug ? null : cleaned,
      slug: useSlug ? cleaned : null,
      password: prefs.password,
    );

    api.setResolvedSharedKey(shared.key);

    switch (shared.type) {
      case 'INDIVIDUAL':
        return _sharedFallbackAlbum(
          shared,
          assetCount: shared.assets.length,
          assets: shared.assets,
        );
      case 'ALBUM':
        if (shared.album == null || shared.album!.id.isEmpty) {
          return _sharedFallbackAlbum(
            shared,
            description: 'Album information not available',
          );
        }
        try {
          final album = await api.getSharedAlbumById(
            shared.album!.id,
            key: shared.key,
            password: prefs.password,
          );
          return album.copyWith(assets: _enrichAlbumAssets(album));
        } catch (_) {
          return _sharedFallbackAlbum(shared, description: 'Error loading album');
        }
      default:
        final album = shared.album ??
            _sharedFallbackAlbum(
              shared,
              assetCount: shared.assets.length,
              assets: shared.assets,
            );
        if (album.name.isNotEmpty) {
          return album.copyWith(assets: _enrichAlbumAssets(album));
        }
        return album;
    }
  }

  Future<ImmichAlbum> getSelectedAlbumFromAPI() async {
    final selectedAlbumIds = prefs.selectedAlbumIds;
    if (selectedAlbumIds.isEmpty) {
      return const ImmichAlbum(id: 'combined', description: 'No albums selected');
    }

    final allAssets = <ImmichAsset>[];
    final names = <String>[];

    final results = await Future.wait(
      selectedAlbumIds.map((id) => api.getAlbum(id)),
      eagerError: false,
    );

    for (final album in results) {
      names.add(album.name);
      allAssets.addAll(_enrichAlbumAssets(album));
    }

    if (allAssets.isEmpty) {
      throw Exception('No assets found in any of the selected albums');
    }

    final unique = _deduplicateAssets(allAssets, names.length == 1);

    return ImmichAlbum(
      id: 'combined',
      name: names.join(', '),
      description: 'Combined album from ${names.length} selected albums',
      assetCount: unique.length,
      assets: unique,
    );
  }

  List<ImmichAsset> _enrichAlbumAssets(ImmichAlbum album) {
    return album.assets.map((a) => a.copyWith(albumName: album.name)).toList();
  }

  Future<List<ImmichAsset>> _fetchFavorites() async {
    const request = SearchMetadataRequest(isFavorite: true, withExif: true);
    final response = await api.searchAssets(request);
    return response.assets.items;
  }

  Future<List<ImmichAsset>> _fetchRated() async {
    final assets = <ImmichAsset>[];
    for (final rating in prefs.includeRatings) {
      final request = SearchMetadataRequest(
        rating: int.tryParse(rating),
        withExif: true,
        type: _getTypeFilter(),
      );
      final response = await api.searchAssets(request);
      assets.addAll(response.assets.items);
    }
    return assets;
  }

  Future<List<ImmichAsset>> _fetchRandom() async {
    final count = int.tryParse(prefs.includeRandom);
    if (count == null) return [];
    return api.getRandomAssets(
      SearchMetadataRequest(size: count, withExif: true, type: _getTypeFilter()),
    );
  }

  Future<List<ImmichAsset>> _fetchRecent() async {
    final count = int.tryParse(prefs.includeRecent);
    if (count == null) return [];
    final request = SearchMetadataRequest(
      size: count,
      order: 'desc',
      withExif: true,
      type: _getTypeFilter(),
    );
    final response = await api.searchAssets(request);
    return response.assets.items;
  }

  Future<List<ImmichAsset>> _fetchOptionalAssets(
    Future<List<ImmichAsset>> Function() fetcher,
  ) async {
    try {
      if (prefs.authType != ImmichAuthType.apiKey) return [];
      return await fetcher();
    } catch (_) {
      return [];
    }
  }

  ImmichAlbum _sharedFallbackAlbum(
    SharedLinkResponse shared, {
    String? description,
    int assetCount = 0,
    List<ImmichAsset> assets = const [],
  }) {
    return ImmichAlbum(
      id: 'shared-${shared.id}',
      name: shared.description ?? 'Shared Link',
      description: description ?? shared.description ?? '',
      assetCount: assetCount,
      assets: assets,
    );
  }

  List<ImmichAsset> _deduplicateAssets(List<ImmichAsset> all, bool isSingle) {
    final seenIds = <String>{};
    final unique = <ImmichAsset>[];
    for (final asset in all) {
      if (seenIds.add(asset.id)) {
        unique.add(asset.copyWith(albumName: isSingle ? asset.albumName : null));
      }
    }
    return unique;
  }

  List<ImmichAlbum> _deduplicateAlbums(List<ImmichAlbum> albums) {
    final seenIds = <String>{};
    final unique = <ImmichAlbum>[];
    for (final album in albums) {
      if (seenIds.add(album.id)) unique.add(album);
    }
    return unique;
  }

  Future<List<ImmichAlbum>> fetchAlbums() async {
    final results = await Future.wait(
      [api.getAlbums(), api.getAlbums(shared: true)],
      eagerError: false,
    );
    return _deduplicateAlbums(results[0] + results[1]);
  }

  static bool _isSlugFormat(String input) {
    final trimmed = input.trim().replaceFirst(RegExp(r'^/+'), '');
    return trimmed.startsWith('s/');
  }
}

extension ProviderMediaTypeExtension on ProviderMediaType {
  String? get apiTypeFilter => switch (this) {
        ProviderMediaType.videos => 'VIDEO',
        ProviderMediaType.photos => 'IMAGE',
        ProviderMediaType.videosPhotos => null,
      };
}
