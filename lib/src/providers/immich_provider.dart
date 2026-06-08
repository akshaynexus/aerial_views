import '../models/aerial_media.dart';
import '../models/immich_models.dart';
import 'immich_api.dart';
import 'immich_repository.dart';

class ImmichProvider {
  final ImmichMediaPrefs prefs;

  late final ImmichApi _api;
  late final ImmichRepository _repository;

  ImmichProvider({required this.prefs}) {
    _api = ImmichApi(
      serverUrl: _parseServerUrl(prefs.url),
      apiKey: prefs.apiKey,
    );
    _api.setPrefs(prefs);
    _repository = ImmichRepository(prefs: prefs, api: _api);
  }

  Future<List<AerialMedia>> fetch() async {
    final error = _validateInput();
    if (error != null) throw Exception(error);
    return _repository.fetchAllAssets();
  }

  Future<List<ImmichAlbum>> fetchAlbums() => _repository.fetchAlbums();

  String? _validateInput() {
    if (prefs.url.isEmpty) return 'Hostname and port not specified';
    if (prefs.authType == ImmichAuthType.sharedLink) {
      if (prefs.pathName.isEmpty) return 'Path name is empty';
    } else {
      if (prefs.apiKey.isEmpty) return 'API key is empty';
    }
    return null;
  }

  static String _parseServerUrl(String url) {
    var server = url.trim();
    if (!server.startsWith('http://') && !server.startsWith('https://')) {
      server = 'http://$server';
    }
    return server.replaceAll(RegExp(r'/+$'), '');
  }
}
