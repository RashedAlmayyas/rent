class Payment {
  final int id;
  final int contractId;
  final double amount;
  final String paymentDate;

  Payment({
    required this.id,
    required this.contractId,
    required this.amount,
    required this.paymentDate,
  });

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
    id: json['id'],
    contractId: json['contract_id'],
    amount: json['amount'].toDouble(),
    paymentDate: json['payment_date'],
  );
}
