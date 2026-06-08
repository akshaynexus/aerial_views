import 'package:json_annotation/json_annotation.dart';

import 'abstract_video.dart';
import 'enums.dart';

part 'apple_video.g.dart';

@JsonSerializable()
class AppleVideo extends AbstractVideo {
  const AppleVideo({
    super.video1080h264,
    super.video1080sdr,
    super.video1080hdr,
    super.video4ksdr,
    super.video4khdr,
    super.description,
    super.pointsOfInterest,
    super.timeOfDay,
    super.scene,
  });

  factory AppleVideo.fromJson(Map<String, dynamic> json) =>
      _$AppleVideoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$AppleVideoToJson(this);

  @override
  String uriAtQuality(VideoQuality? quality) {
    String? url;
    switch (quality) {
      case VideoQuality.video1080Sdr:
        url = video1080sdr;
      case VideoQuality.video1080Hdr:
        url = video1080hdr;
      case VideoQuality.video4kSdr:
        url = video4ksdr;
      case VideoQuality.video4kHdr:
        url = video4khdr;
      default:
        url = video1080h264;
    }
    // Apple uses an invalid certificate, rewrite to http
    return (url ?? '').replaceAll('https://', 'http://');
  }


}

@JsonSerializable()
class AppleVideos {
  final List<AppleVideo>? assets;

  const AppleVideos({this.assets});

  factory AppleVideos.fromJson(Map<String, dynamic> json) =>
      _$AppleVideosFromJson(json);

  Map<String, dynamic> toJson() => _$AppleVideosToJson(this);
}
