import 'dart:convert';

TransactionsModel transactionsModelFromJson(String str) => TransactionsModel.fromJson(json.decode(str));

String transactionsModelToJson(TransactionsModel data) => json.encode(data.toJson());

class TransactionsModel {
  final List<Transaction>? transaction;

  TransactionsModel({
    this.transaction,
  });

  factory TransactionsModel.fromJson(Map<String, dynamic> json) => TransactionsModel(
    transaction: json["transaction"] == null ? [] : List<Transaction>.from(json["transaction"]!.map((x) => Transaction.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "transaction": transaction == null ? [] : List<dynamic>.from(transaction!.map((x) => x.toJson())),
  };
}

class Transaction {
  final String? name;
  final int? currentBalance;
  final int? updatedBalance;
  final int? receivedAmount;
  final String? dateTime;

  Transaction({
    this.name,
    this.currentBalance,
    this.updatedBalance,
    this.receivedAmount,
    this.dateTime,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
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
