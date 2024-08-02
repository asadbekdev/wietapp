class Tier {
  final String tierName;
  final int minPoint;
  final int maxPoint;
  final int seqNo;
  final String fontColor;
  final String bgColor;

  Tier({
    required this.tierName,
    required this.minPoint,
    required this.maxPoint,
    required this.seqNo,
    required this.fontColor,
    required this.bgColor,
  });

  factory Tier.fromJson(Map<String, dynamic> json) {
    return Tier(
      tierName: json['tierName'],
      minPoint: json['minPoint'],
      maxPoint: json['maxPoint'],
      seqNo: json['seqNo'],
      fontColor: json['fontColor'],
      bgColor: json['bgColor'],
    );
  }
}