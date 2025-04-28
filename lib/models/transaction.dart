class Transaction {
  String id;
  String description;
  double amount;
  DateTime date;
  bool isIncome;
  
  Transaction({
    required this.id,
    required this.description,
    required this.amount,
    required this.date,
    required this.isIncome,
  });
}
