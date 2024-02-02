class CampaignModel {
  final String promotionText;
  final String promotionDescription;
  final String pictureUrl;
  final String? advertId;
  final String? creationDate;
  final String? expiryDate;
  final String? status;
  final String? advertiserId;
  final int? scanCount;

  CampaignModel({
    required this.promotionText,
    required this.promotionDescription,
    required this.pictureUrl,
    this.advertId,
    this.creationDate,
    this.expiryDate,
    this.scanCount,
    this.status,
    this.advertiserId,
  });

  factory CampaignModel.fromJson(Map<String, dynamic> json) {
    return CampaignModel(
      advertId: json['advert_id'],
      promotionText: json['promotion_text'],
      promotionDescription: json['promotion_description'],
      pictureUrl: json['picture_url'],
      creationDate: json['creation_date'],
      expiryDate: json['expiry_date'] ?? '',
      scanCount: json['scan_count'] ?? 0,
      status: 'Active',
      advertiserId: json['advertiser_id'],
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'advert_id': advertId,
      'promotion_text': promotionText,
      'promotion_description': promotionDescription,
      'picture_url': pictureUrl,
      'creation_date': creationDate,
      'expiry_date': expiryDate,
      'scan_count': scanCount,
      'status': status,
      'advertiser_id': advertiserId,
    };

    //remove null values
    return map..removeWhere((key, value) => value == null);
  }
}
