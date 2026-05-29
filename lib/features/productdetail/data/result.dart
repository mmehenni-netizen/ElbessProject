// ✅ Outside DetailsRepo class
class RateResult {
  final double rating;
  final int totalRates;
  final int? userRate;
  final String type;

  RateResult({
    required this.rating,
    required this.totalRates,
    required this.userRate,
    required this.type,
  });

  factory RateResult.fromJson(Map<String, dynamic> json) {
    return RateResult(
      rating:     (json['rating']     as num?)?.toDouble() ?? 0.0,
      totalRates: (json['totalRates'] as num?)?.toInt()    ?? 0,
      userRate:   (json['userRate']   as num?)?.toInt(),
      type:        json['type']?.toString()                ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'rating':     rating,
    'totalRates': totalRates,
    'userRate':   userRate,
    'type':       type,
  };

  RateResult copyWith({
    double? rating,
    int? totalRates,
    int? userRate,
    String? type,
  }) {
    return RateResult(
      rating:     rating     ?? this.rating,
      totalRates: totalRates ?? this.totalRates,
      userRate:   userRate   ?? this.userRate,
      type:       type       ?? this.type,
    );
  }

  @override
  String toString() =>
      'RateResult(type: $type, rating: $rating, totalRates: $totalRates, userRate: $userRate)';
}


