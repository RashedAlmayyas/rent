class Rating {
  final int id;
  final int contractId;
  final int raterId;
  final int rateeId;
  final int ratingValue;
  final String comment;

  Rating({
    required this.id,
    required this.contractId,
    required this.raterId,
    required this.rateeId,
    required this.ratingValue,
    required this.comment,
  });

  factory Rating.fromJson(Map<String, dynamic> json) => Rating(
    id: json['id'],
    contractId: json['contract_id'],
    raterId: json['rater_id'],
    rateeId: json['ratee_id'],
    ratingValue: json['rating_value'],
    comment: json['comment'],
  );
}
