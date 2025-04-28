class Task {
  String id;
  String title;
  String? description;
  DateTime date;
  double? value;
  bool isIncome; // Se tiver valor, é entrada ou saída
  bool hasValue;

  Task({
    required this.id,
    required this.title,
    this.description,
    required this.date,
    this.value,
    this.isIncome = false,
    this.hasValue = false,
  });
}