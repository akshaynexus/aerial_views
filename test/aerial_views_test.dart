import 'package:flutter_test/flutter_test.dart';

import 'package:aerial_views/aerial_views.dart';

void main() {
  test('AerialMedia can be constructed', () {
    final media = AerialMedia(
      url: 'https://example.com/video.mp4',
      type: AerialMediaType.video,
      source: AerialMediaSource.apple,
    );
    expect(media.url, 'https://example.com/video.mp4');
  });
}
