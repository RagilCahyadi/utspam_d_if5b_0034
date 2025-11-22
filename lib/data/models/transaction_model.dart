import 'medicine_model.dart';

enum PurchaseMethod {
  direct,
  recipe;

  @override
  String toString() {
    switch (this) {
      case PurchaseMethod.direct:
        return 'Langsung';
      case PurchaseMethod.recipe:
        return 'Resep';
    }
  }

  static PurchaseMethod fromString(String value) {
    switch (value.toLowerCase()) {
      case 'langsung':
      case 'direct':
        return PurchaseMethod.direct;
      case 'resep':
      case 'recipe':
        return PurchaseMethod.recipe;
      default:
        return PurchaseMethod.direct;
    }
  }
}

enum TransactionStatus {
  success,
  cancelled;

  @override
  String toString() {
    switch (this) {
      case TransactionStatus.success:
        return 'Sukses';
      case TransactionStatus.cancelled:
        return 'Dibatalkan';
    }
  }

  static TransactionStatus fromString(String value) {
    switch (value.toLowerCase()) {
      case 'sukses':
      case 'success':
        return TransactionStatus.success;
      case 'dibatalkan':
      case 'cancelled':
        return TransactionStatus.cancelled;
      default:
        return TransactionStatus.success;
    }
  }
}

class Transaction {
  final String transactionId;
  final Medicine medicineData;
  final String buyerName;
  final int quantity;
  final double totalPrice;
  final DateTime date;
  final String? notes;
  final PurchaseMethod purchaseMethod;
  final String? recipeNumber;
  final TransactionStatus status;

  Transaction({
    required this.transactionId,
    required this.medicineData,
    required this.buyerName,
    required this.quantity,
    required this.totalPrice,
    required this.date,
    this.notes,
    required this.purchaseMethod,
    this.recipeNumber,
    required this.status,
  });

  // Convert Transaction object to Map for database
  Map<String, dynamic> toMap() {
    return {
      'transactionId': transactionId,
      'medicineId': medicineData.id,
      'medicineName': medicineData.name,
      'medicineCategory': medicineData.category,
      'medicinePrice': medicineData.price,
      'medicineImage': medicineData.imageAsset,
      'buyerName': buyerName,
      'quantity': quantity,
      'totalPrice': totalPrice,
      'date': date.toIso8601String(),
      'notes': notes,
      'purchaseMethod': purchaseMethod.name,
      'recipeNumber': recipeNumber,
      'status': status.name,
    };
  }

  // Convert Map from database to Transaction object
  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      transactionId: map['transactionId'] as String,
      medicineData: Medicine(
        id: map['medicineId'] as String,
        name: map['medicineName'] as String,
        category: map['medicineCategory'] as String,
        imageAsset: map['medicineImage'] as String,
        price: (map['medicinePrice'] as num).toDouble(),
      ),
      buyerName: map['buyerName'] as String,
      quantity: map['quantity'] as int,
      totalPrice: (map['totalPrice'] as num).toDouble(),
      date: DateTime.parse(map['date'] as String),
      notes: map['notes'] as String?,
      purchaseMethod: PurchaseMethod.fromString(map['purchaseMethod'] as String),
      recipeNumber: map['recipeNumber'] as String?,
      status: TransactionStatus.fromString(map['status'] as String),
    );
  }

  // Create a copy of Transaction with modified fields
  Transaction copyWith({
    String? transactionId,
    Medicine? medicineData,
    String? buyerName,
    int? quantity,
    double? totalPrice,
    DateTime? date,
    String? notes,
    PurchaseMethod? purchaseMethod,
    String? recipeNumber,
    TransactionStatus? status,
  }) {
    return Transaction(
      transactionId: transactionId ?? this.transactionId,
      medicineData: medicineData ?? this.medicineData,
      buyerName: buyerName ?? this.buyerName,
      quantity: quantity ?? this.quantity,
      totalPrice: totalPrice ?? this.totalPrice,
      date: date ?? this.date,
      notes: notes ?? this.notes,
      purchaseMethod: purchaseMethod ?? this.purchaseMethod,
      recipeNumber: recipeNumber ?? this.recipeNumber,
      status: status ?? this.status,
    );
  }

  @override
  String toString() {
    return 'Transaction(id: $transactionId, medicine: ${medicineData.name}, buyer: $buyerName, total: $totalPrice, status: $status)';
  }
}
