import 'package:aerial_views/aerial_views.dart';

/// Example usage of the aerial_views library
Future<void> main() async {
  // 1. Apple Videos
  final appleProvider = AppleProvider(
    quality: VideoQuality.video4kSdr,
    timeOfDayFilter: {TimeOfDay.day, TimeOfDay.sunset},
    sceneFilter: {SceneType.beach, SceneType.city},
  );
  final appleVideos = await appleProvider.fetch();
  print('Apple videos: ${appleVideos.length}');
  for (final video in appleVideos.take(3)) {
    print('  ${video.metadata.shortDescription}: ${video.uri}');
  }

  // 2. Community Videos
  final comm1Provider = Comm1Provider(
    quality: VideoQuality.video1080H264,
  );
  final comm1Videos = await comm1Provider.fetch();
  print('\nCommunity 1 videos: ${comm1Videos.length}');

  // 3. Amazon Videos
  final amazonProvider = AmazonProvider(
    quality: VideoQuality.video4kSdr,
  );
  final amazonVideos = await amazonProvider.fetch();
  print('Amazon videos: ${amazonVideos.length}');

  // 4. Custom Feeds (RTSP, HLS, CSV, JSON)
  final customProvider = CustomFeedProvider(
    quality: VideoQuality.video1080Sdr,
    urls: {
      'https://example.com/manifest.json',
      'rtsp://camera.local/stream',
      'https://example.com/videos.csv',
    },
  );
  final customVideos = await customProvider.fetch();
  print('Custom feed videos: ${customVideos.length}');

  // 5. Immich (self-hosted photo server)
  final immichProvider = ImmichProvider(
    prefs: ImmichMediaPrefs(
      url: 'http://192.168.1.100:2283',
      apiKey: 'your-api-key',
      authType: ImmichAuthType.apiKey,
      selectedAlbumIds: ['album-id-1'],
      includeVideos: true,
      includePhotos: false,
    ),
  );
  final immichVideos = await immichProvider.fetch();
  print('Immich videos: ${immichVideos.length}');

  // Quality selection example
  final video = appleVideos.first;
  final h264Url = video.uri; // Already at selected quality
  print('\nPlaying: ${video.metadata.shortDescription}');
  print('URL: $h264Url');
  print('Source: ${video.source}');
  print('Type: ${video.type}');
}
