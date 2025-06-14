class Contract {
  final int id;
  final int landlordId;
  final int tenantId;
  final String startDate;
  final String endDate;
  final double rentAmount;

  Contract({
    required this.id,
    required this.landlordId,
    required this.tenantId,
    required this.startDate,
    required this.endDate,
    required this.rentAmount,
  });

  factory Contract.fromJson(Map<String, dynamic> json) => Contract(
    id: json['id'],
    landlordId: json['landlord_id'],
    tenantId: json['tenant_id'],
    startDate: json['start_date'],
    endDate: json['end_date'],
    rentAmount: json['rent_amount'].toDouble(),
  );
}
