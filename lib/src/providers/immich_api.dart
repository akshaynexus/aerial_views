import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/immich_models.dart';
import 'utils.dart';

class ImmichApi {
  final String serverUrl;
  final String? apiKey;
  String? _resolvedSharedKey;
  ImmichMediaPrefs? _prefs;

  ImmichApi({required this.serverUrl, this.apiKey});

  void setPrefs(ImmichMediaPrefs prefs) => _prefs = prefs;

  void setResolvedSharedKey(String? key) => _resolvedSharedKey = key;

  String getAssetUri(String id, bool isVideo) {
    if (_prefs == null) throw StateError('Prefs not set');
    final prefs = _prefs!;
    final key = _resolvedSharedKey ?? cleanSharedLinkKey(prefs.pathName);
    final path = _buildAssetPath(id, isVideo);
    if (prefs.authType == null) {
      throw StateError('Invalid authentication type');
    }
    if (prefs.authType == ImmichAuthType.sharedLink) {
      return _appendAuth(path, key, prefs.password);
    }
    return path;
  }

  String _buildAssetPath(String id, bool isVideo) {
    final prefs = _prefs!;
    if (isVideo) {
      return prefs.videoType == ImmichVideoType.transcoded
          ? '$serverUrl/api/assets/$id/video/playback'
          : '$serverUrl/api/assets/$id/original';
    }
    if (prefs.imageType == ImmichImageType.original) {
      return '$serverUrl/api/assets/$id/original';
    }
    final size = prefs.imageType == ImmichImageType.fullsize ? 'fullsize' : 'preview';
    return '$serverUrl/api/assets/$id/thumbnail?size=$size';
  }

  static String _appendAuth(String path, String key, String password) {
    final separator = path.contains('?') ? '&' : '?';
    path = '$path${separator}key=$key';
    if (password.isNotEmpty) {
      path = '$path&password=$password';
    }
    return path;
  }

  static ImmichAsset parseAsset(dynamic e) =>
      ImmichAsset.fromJson(e as Map<String, dynamic>);

  static ImmichAlbum parseAlbum(dynamic json) =>
      ImmichAlbum.fromJson(json as Map<String, dynamic>);

  Map<String, String> get _headers => {
        if (apiKey != null) 'x-api-key': apiKey!,
        'Content-Type': 'application/json',
      };

  Future<T> _get<T>(
    String path,
    Map<String, String>? queryParams,
    T Function(dynamic) parser,
  ) async {
    final uri = Uri.parse('$serverUrl$path').replace(
      queryParameters:
          queryParams != null && queryParams.isNotEmpty ? queryParams : null,
    );
    return _handleResponse(await http.get(uri, headers: _headers), parser);
  }

  Future<T> _post<T>(
    String path,
    Map<String, dynamic> body,
    T Function(dynamic) parser,
  ) async {
    final uri = Uri.parse('$serverUrl$path');
    return _handleResponse(
      await http.post(uri, headers: _headers, body: jsonEncode(body)),
      parser,
    );
  }

  T _handleResponse<T>(http.Response response, T Function(dynamic) parser) {
    if (response.statusCode == 200) {
      return parser(jsonDecode(response.body));
    }
    String message;
    try {
      final errorJson = jsonDecode(response.body) as Map<String, dynamic>;
      message = ErrorResponse.fromJson(errorJson).message;
    } catch (_) {
      message = response.reasonPhrase ?? 'Unknown error';
    }
    throw Exception('API error: ${response.statusCode} - $message');
  }

  Future<SharedLinkResponse> getSharedAlbum({
    String? key,
    String? slug,
    String? password,
  }) async {
    final queryParams = <String, String>{};
    if (key != null) queryParams['key'] = key;
    if (slug != null) queryParams['slug'] = slug;
    if (password != null && password.isNotEmpty) {
      queryParams['password'] = password;
    }
    return _get(
      '/api/shared-links/me',
      queryParams.isNotEmpty ? queryParams : null,
      (json) => SharedLinkResponse.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<List<ImmichAlbum>> getAlbums({bool? shared}) async {
    final queryParams = <String, String>{};
    if (shared != null) queryParams['shared'] = shared.toString();
    return _get('/api/albums', queryParams, (json) {
      return (json as List<dynamic>).map(parseAlbum).toList();
    });
  }

  Future<ImmichAlbum> getAlbum(String albumId) async {
    return _get('/api/albums/$albumId', null, parseAlbum);
  }

  Future<ImmichAlbum> getSharedAlbumById(
    String albumId, {
    required String key,
    String? password,
  }) async {
    final queryParams = <String, String>{'key': key};
    if (password != null && password.isNotEmpty) {
      queryParams['password'] = password;
    }
    return _get('/api/albums/$albumId', queryParams, parseAlbum);
  }

  Future<SearchAssetsResponse> searchAssets(SearchMetadataRequest request) {
    return _post('/api/search/metadata', request.toJson(),
        (json) => SearchAssetsResponse.fromJson(json as Map<String, dynamic>));
  }

  Future<List<ImmichAsset>> getRandomAssets(SearchMetadataRequest request) {
    return _post('/api/search/random', request.toJson(), (json) {
      return (json as List<dynamic>).map(parseAsset).toList();
    });
  }
}
