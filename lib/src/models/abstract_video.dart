import 'package:json_annotation/json_annotation.dart';

import 'enums.dart';

part 'abstract_video.g.dart';

@JsonSerializable()
class AbstractVideo {
  @JsonKey(name: 'url-1080-H264')
  final String? video1080h264;

  @JsonKey(name: 'url-1080-SDR')
  final String? video1080sdr;

  @JsonKey(name: 'url-1080-HDR')
  final String? video1080hdr;

  @JsonKey(name: 'url-4K-SDR')
  final String? video4ksdr;

  @JsonKey(name: 'url-4K-HDR')
  final String? video4khdr;

  @JsonKey(name: 'accessibilityLabel')
  final String description;

  @JsonKey(name: 'pointsOfInterest')
  final Map<String, String> pointsOfInterest;

  final String timeOfDay;
  final String scene;

  const AbstractVideo({
    this.video1080h264,
    this.video1080sdr,
    this.video1080hdr,
    this.video4ksdr,
    this.video4khdr,
    this.description = '',
    this.pointsOfInterest = const {},
    this.timeOfDay = '',
    this.scene = '',
  });

  factory AbstractVideo.fromJson(Map<String, dynamic> json) =>
      _$AbstractVideoFromJson(json);

  Map<String, dynamic> toJson() => _$AbstractVideoToJson(this);

  String uriAtQuality(VideoQuality? quality) {
    switch (quality) {
      case VideoQuality.video1080Sdr:
        return video1080sdr ?? '';
      case VideoQuality.video1080Hdr:
        return video1080hdr ?? '';
      case VideoQuality.video4kSdr:
        return video4ksdr ?? '';
      case VideoQuality.video4kHdr:
        return video4khdr ?? '';
      default:
        return video1080h264 ?? '';
    }
  }

  List<String> allUrls() {
    return [
      if (video1080h264 != null) video1080h264!,
      if (video1080sdr != null) video1080sdr!,
      if (video1080hdr != null) video1080hdr!,
      if (video4ksdr != null) video4ksdr!,
      if (video4khdr != null) video4khdr!,
    ];
  }
}
