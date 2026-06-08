import 'enums.dart';

export 'enums.dart'
    show ImmichAuthType, ImmichVideoType, ImmichImageType, AerialMediaSource, AerialMediaType;

class ImmichMediaPrefs {
  final bool enabled;
  final String url;
  final bool validateSsl;
  final String apiKey;
  final Set<String> selectedAlbumIds;
  final String includeFavorites;
  final Set<String> includeRatings;
  final String includeRandom;
  final String includeRecent;
  final ProviderMediaType mediaType;
  final String pathName;
  final String password;
  final ImmichAuthType? authType;
  final ImmichImageType? imageType;
  final ImmichVideoType? videoType;

  bool get includeVideos =>
      mediaType == ProviderMediaType.videos ||
      mediaType == ProviderMediaType.videosPhotos;

  bool get includePhotos =>
      mediaType == ProviderMediaType.photos ||
      mediaType == ProviderMediaType.videosPhotos;

  const ImmichMediaPrefs({
    this.enabled = false,
    this.url = '',
    this.validateSsl = true,
    this.apiKey = '',
    this.selectedAlbumIds = const {},
    this.includeFavorites = 'DISABLED',
    this.includeRatings = const {},
    this.includeRandom = 'DISABLED',
    this.includeRecent = 'DISABLED',
    this.mediaType = ProviderMediaType.videosPhotos,
    this.pathName = '',
    this.password = '',
    this.authType = ImmichAuthType.sharedLink,
    this.imageType = ImmichImageType.preview,
    this.videoType = ImmichVideoType.transcoded,
  });
}

enum ProviderMediaType { videos, photos, videosPhotos }

class ExifInfo {
  final String? description;
  final String? country;
  final String? state;
  final String? city;

  const ExifInfo({
    this.description,
    this.country,
    this.state,
    this.city,
  });

  factory ExifInfo.fromJson(Map<String, dynamic> json) {
    return ExifInfo(
      description: json['description'] as String?,
      country: json['country'] as String?,
      state: json['state'] as String?,
      city: json['city'] as String?,
    );
  }
}

class ImmichAsset {
  final String id;
  final String type;
  final String originalPath;
  final String? localDateTime;
  final String? description;
  final ExifInfo? exifInfo;
  final String? albumName;

  const ImmichAsset({
    this.id = '',
    this.type = '',
    this.originalPath = '',
    this.localDateTime,
    this.description,
    this.exifInfo,
    this.albumName,
  });

  ImmichAsset copyWith({
    String? id,
    String? type,
    String? originalPath,
    String? localDateTime,
    String? description,
    ExifInfo? exifInfo,
    String? albumName,
  }) {
    return ImmichAsset(
      id: id ?? this.id,
      type: type ?? this.type,
      originalPath: originalPath ?? this.originalPath,
      localDateTime: localDateTime ?? this.localDateTime,
      description: description ?? this.description,
      exifInfo: exifInfo ?? this.exifInfo,
      albumName: albumName ?? this.albumName,
    );
  }

  factory ImmichAsset.fromJson(Map<String, dynamic> json) {
    return ImmichAsset(
      id: json['id'] as String? ?? '',
      type: json['type'] as String? ?? '',
      originalPath: json['originalPath'] as String? ?? '',
      localDateTime: json['localDateTime'] as String?,
      description: json['description'] as String?,
      exifInfo: json['exifInfo'] != null
          ? ExifInfo.fromJson(json['exifInfo'] as Map<String, dynamic>)
          : null,
      albumName: json['albumName'] as String?,
    );
  }
}

class ImmichAlbum {
  final String id;
  final String name;
  final String description;
  final String type;
  final List<ImmichAsset> assets;
  final int assetCount;

  const ImmichAlbum({
    this.id = '',
    this.name = '',
    this.description = '',
    this.type = '',
    this.assets = const [],
    this.assetCount = 0,
  });

  ImmichAlbum copyWith({
    String? id,
    String? name,
    String? description,
    String? type,
    List<ImmichAsset>? assets,
    int? assetCount,
  }) {
    return ImmichAlbum(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      assets: assets ?? this.assets,
      assetCount: assetCount ?? this.assetCount,
    );
  }

  factory ImmichAlbum.fromJson(Map<String, dynamic> json) {
    return ImmichAlbum(
      id: json['id'] as String? ?? '',
      name: json['albumName'] as String? ?? '',
      description: json['description'] as String? ?? '',
      type: json['shared'] as String? ?? '',
      assets: (json['assets'] as List<dynamic>?)
              ?.map((e) => ImmichAsset.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      assetCount: json['assetCount'] as int? ?? 0,
    );
  }
}

class SharedLinkResponse {
  final String id;
  final String? description;
  final String? password;
  final String? token;
  final String userId;
  final String key;
  final String type;
  final String createdAt;
  final String? expiresAt;
  final List<ImmichAsset> assets;
  final ImmichAlbum? album;
  final bool allowUpload;
  final bool allowDownload;
  final bool showMetadata;
  final String? slug;

  const SharedLinkResponse({
    this.id = '',
    this.description,
    this.password,
    this.token,
    this.userId = '',
    this.key = '',
    this.type = '',
    this.createdAt = '',
    this.expiresAt,
    this.assets = const [],
    this.album,
    this.allowUpload = true,
    this.allowDownload = true,
    this.showMetadata = true,
    this.slug,
  });

  factory SharedLinkResponse.fromJson(Map<String, dynamic> json) {
    return SharedLinkResponse(
      id: json['id'] as String? ?? '',
      description: json['description'] as String?,
      password: json['password'] as String?,
      token: json['token'] as String?,
      userId: json['userId'] as String? ?? '',
      key: json['key'] as String? ?? '',
      type: json['type'] as String? ?? '',
      createdAt: json['createdAt'] as String? ?? '',
      expiresAt: json['expiresAt'] as String?,
      assets: (json['assets'] as List<dynamic>?)
              ?.map((e) => ImmichAsset.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      album: json['album'] != null
          ? ImmichAlbum.fromJson(json['album'] as Map<String, dynamic>)
          : null,
      allowUpload: json['allowUpload'] as bool? ?? true,
      allowDownload: json['allowDownload'] as bool? ?? true,
      showMetadata: json['showMetadata'] as bool? ?? true,
      slug: json['slug'] as String?,
    );
  }
}

class SearchMetadataRequest {
  final bool? isFavorite;
  final int? rating;
  final String? order;
  final int? size;
  final bool? withExif;
  final String? type;

  const SearchMetadataRequest({
    this.isFavorite,
    this.rating,
    this.order,
    this.size,
    this.withExif,
    this.type,
  });

  Map<String, dynamic> toJson() {
    return {
      if (isFavorite != null) 'isFavorite': isFavorite,
      if (rating != null) 'rating': rating,
      if (order != null) 'order': order,
      if (size != null) 'size': size,
      if (withExif != null) 'withExif': withExif,
      if (type != null) 'type': type,
    };
  }
}

class AssetsResult {
  final List<ImmichAsset> items;

  const AssetsResult({this.items = const []});

  factory AssetsResult.fromJson(Map<String, dynamic> json) {
    return AssetsResult(
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => ImmichAsset.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class SearchAssetsResponse {
  final AssetsResult assets;

  const SearchAssetsResponse({required this.assets});

  factory SearchAssetsResponse.fromJson(Map<String, dynamic> json) {
    return SearchAssetsResponse(
      assets: AssetsResult.fromJson(json['assets'] as Map<String, dynamic>),
    );
  }
}

class ErrorResponse {
  final String message;
  final String error;
  final int statusCode;
  final String correlationId;

  const ErrorResponse({
    this.message = '',
    this.error = '',
    this.statusCode = 0,
    this.correlationId = '',
  });

  factory ErrorResponse.fromJson(Map<String, dynamic> json) {
    return ErrorResponse(
      message: json['message'] as String? ?? '',
      error: json['error'] as String? ?? '',
      statusCode: json['statusCode'] as int? ?? 0,
      correlationId: json['correlationId'] as String? ?? '',
    );
  }
}
