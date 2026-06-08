import 'package:json_annotation/json_annotation.dart';

import 'abstract_video.dart';
import 'enums.dart';

part 'comm_video.g.dart';

@JsonSerializable()
class Comm1Video extends AbstractVideo {
  const Comm1Video({
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

  factory Comm1Video.fromJson(Map<String, dynamic> json) =>
      _$Comm1VideoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$Comm1VideoToJson(this);

}

@JsonSerializable()
class Comm1Videos {
  final List<Comm1Video>? assets;

  const Comm1Videos({this.assets});

  factory Comm1Videos.fromJson(Map<String, dynamic> json) =>
      _$Comm1VideosFromJson(json);

  Map<String, dynamic> toJson() => _$Comm1VideosToJson(this);
}

@JsonSerializable()
class Comm2Video extends AbstractVideo {
  const Comm2Video({
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

  factory Comm2Video.fromJson(Map<String, dynamic> json) =>
      _$Comm2VideoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$Comm2VideoToJson(this);

  @override
  String uriAtQuality(VideoQuality? quality) {
    switch (quality) {
      case VideoQuality.video1080Sdr:
        // Map HDR to SDR as 10-bit colour space alone is not HDR
        return video1080hdr ?? '';
      case VideoQuality.video4kSdr:
        return video4ksdr ?? '';
      default:
        return video1080h264 ?? '';
    }
  }
}

@JsonSerializable()
class Comm2Videos {
  final List<Comm2Video>? assets;

  const Comm2Videos({this.assets});

  factory Comm2Videos.fromJson(Map<String, dynamic> json) =>
      _$Comm2VideosFromJson(json);

  Map<String, dynamic> toJson() => _$Comm2VideosToJson(this);
}
