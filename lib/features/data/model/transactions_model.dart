class TransactionsModel {
  final String? name;
  final double? currentBalance;
  final double? updatedBalance;
  final double? receivedAmount;
  final String? dateTime;

  TransactionsModel({
    this.name,
    this.currentBalance,
    this.updatedBalance,
    this.receivedAmount,
    this.dateTime,
  });

  factory TransactionsModel.fromJson(Map<String, dynamic> json) => TransactionsModel(
    name: json["name"],
    currentBalance: json["currentBalance"],
    updatedBalance: json["updatedBalance"],
    receivedAmount: json["receivedAmount"],
    dateTime: json["DateTime"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "currentBalance": currentBalance,
    "updatedBalance": updatedBalance,
    "receivedAmount": receivedAmount,
    "DateTime": dateTime,
  };
}
