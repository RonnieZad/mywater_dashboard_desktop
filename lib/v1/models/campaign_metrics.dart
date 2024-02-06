class CampaignMetrics {
  final DailyMetrics dailyMetrics;

  const CampaignMetrics({required this.dailyMetrics});

  factory CampaignMetrics.fromJson(Map<String, dynamic> json) {
    return CampaignMetrics(
      dailyMetrics: DailyMetrics.fromJson(json['daily']),
    );
  }
}

class DailyMetrics {
  final int zeroFour;
  final int fourEight;
  final int eightTwelve;
  final int twelveTwentyFour;

  const DailyMetrics(
      {required this.zeroFour,
      required this.fourEight,
      required this.eightTwelve,
      required this.twelveTwentyFour});

  factory DailyMetrics.fromJson(Map<String, dynamic> json) {
    return DailyMetrics(
      zeroFour: json['0-4 hours'],
      fourEight: json['4-8 hours'],
      eightTwelve: json['8-12 hours'],
      twelveTwentyFour: json['12-24 hours'],
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      '0-4 hours': zeroFour,
      '4-8 hours': fourEight,
      '8-12 hours': eightTwelve,
      '12-24 hours': twelveTwentyFour,
    };

    //remove null values
    return map..removeWhere((key, value) => value == null);
  }
}
