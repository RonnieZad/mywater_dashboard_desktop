import 'package:file_picker/file_picker.dart';

class Campaign {
  final List<Ad> ad;
  final List<String> clients;
  final int endDate;
  final String name;
  final Reward reward;
  final int startDate;
  final String status;
  final String campaignLogo;

  Campaign({
    required this.ad,
    required this.clients,
    required this.endDate,
    required this.name,
    required this.reward,
    required this.startDate,
    required this.status,
    required this.campaignLogo,
  });

  factory Campaign.fromMap(Map<String, dynamic> map) {
    return Campaign(
      ad: List<Ad>.from((map['ad'] ?? []).map((x) => Ad.fromMap(x))),
      clients: List<String>.from(map['clients'] ?? []),
      endDate: map['endDate'] ?? 0,
      name: map['name'] ?? '',
      reward: Reward.fromMap(map['reward'] ?? {}),
      startDate: map['startDate'] ?? 0,
      status: map['status'] ?? '',
      campaignLogo: map['campaignLogo'] ?? '',
    );
  }
}

class Ad {
  final String adArtworkUrl;
  final String adName;
  final String adPhone;
  final String adWebsite;
  final String companyEmail;
  final String companyLogo;
  final String companyName;
  final String companyPhone;
  final String companyWebsite;
  final String description;

  Ad({
    required this.adArtworkUrl,
    required this.adName,
    required this.adPhone,
    required this.adWebsite,
    required this.companyEmail,
    required this.companyLogo,
    required this.companyName,
    required this.companyPhone,
    required this.companyWebsite,
    required this.description,
  });

  factory Ad.fromMap(Map<String, dynamic> map) {
    return Ad(
      adArtworkUrl: map['adArtworkUrl'] ?? '',
      adName: map['adName'] ?? '',
      adPhone: map['adPhone'] ?? '',
      adWebsite: map['adWebsite'] ?? '',
      companyEmail: map['companyEmail'] ?? '',
      companyLogo: map['companyLogo'] ?? '',
      companyName: map['companyName'] ?? '',
      companyPhone: map['companyPhone'] ?? '',
      companyWebsite: map['companyWebsite'] ?? '',
      description: map['description'] ?? '',
    );
  }
}

class Reward {
  final int amount;
  final String type;

  Reward({
    required this.amount,
    required this.type,
  });

  factory Reward.fromMap(Map<String, dynamic> map) {
    return Reward(
      amount: map['amount'] ?? 0,
      type: map['type'] ?? '',
    );
  }
}

class CampaignFormData {
  final String title;
  final String description;
  final String publicUrl;
  final DateTime startDate;
  final DateTime endDate;
  final FilePickerResult? artworkFile;

  const CampaignFormData({
    required this.title,
    required this.description,
    required this.publicUrl,
    required this.startDate,
    required this.endDate,
    this.artworkFile,
  });
}