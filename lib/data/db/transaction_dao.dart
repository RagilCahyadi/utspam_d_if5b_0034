import 'package:sqflite/sqflite.dart' hide Transaction;
import 'db_helper.dart';
import '../models/transaction_model.dart';

class TransactionDao {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  /// Create - Insert new transaction
  Future<int> insertTransaction(Transaction transaction) async {
    final db = await _dbHelper.database;
    return await db.insert(
      'transactions',
      transaction.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Read - Get transaction by ID
  Future<Transaction?> getTransactionById(String transactionId) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'transactions',
      where: 'transactionId = ?',
      whereArgs: [transactionId],
    );

    if (maps.isEmpty) {
      return null;
    }

    return Transaction.fromMap(maps.first);
  }

  /// Read - Get all transactions
  Future<List<Transaction>> getAllTransactions() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'transactions',
      orderBy: 'date DESC',
    );

    return List.generate(maps.length, (i) {
      return Transaction.fromMap(maps[i]);
    });
  }

  /// Read - Get transactions by status
  Future<List<Transaction>> getTransactionsByStatus(
      TransactionStatus status) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'transactions',
      where: 'status = ?',
      whereArgs: [status.name],
      orderBy: 'date DESC',
    );

    return List.generate(maps.length, (i) {
      return Transaction.fromMap(maps[i]);
    });
  }

  /// Read - Get transactions by buyer name
  Future<List<Transaction>> getTransactionsByBuyer(String buyerName) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'transactions',
      where: 'buyerName = ?',
      whereArgs: [buyerName],
      orderBy: 'date DESC',
    );

    return List.generate(maps.length, (i) {
      return Transaction.fromMap(maps[i]);
    });
  }

  /// Read - Get transactions by date range
  Future<List<Transaction>> getTransactionsByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'transactions',
      where: 'date BETWEEN ? AND ?',
      whereArgs: [startDate.toIso8601String(), endDate.toIso8601String()],
      orderBy: 'date DESC',
    );

    return List.generate(maps.length, (i) {
      return Transaction.fromMap(maps[i]);
    });
  }

  /// Update - Update transaction
  Future<int> updateTransaction(Transaction transaction) async {
    final db = await _dbHelper.database;
    return await db.update(
      'transactions',
      transaction.toMap(),
      where: 'transactionId = ?',
      whereArgs: [transaction.transactionId],
    );
  }

  /// Update - Update transaction status
  Future<int> updateTransactionStatus(
    String transactionId,
    TransactionStatus status,
  ) async {
    final db = await _dbHelper.database;
    return await db.update(
      'transactions',
      {'status': status.name},
      where: 'transactionId = ?',
      whereArgs: [transactionId],
    );
  }

  /// Delete - Delete transaction
  Future<int> deleteTransaction(String transactionId) async {
    final db = await _dbHelper.database;
    return await db.delete(
      'transactions',
      where: 'transactionId = ?',
      whereArgs: [transactionId],
    );
  }

  /// Delete - Delete all transactions (for testing)
  Future<int> deleteAllTransactions() async {
    final db = await _dbHelper.database;
    return await db.delete('transactions');
  }


  /// Get total transactions count
  Future<int> getTotalTransactionsCount() async {
    final db = await _dbHelper.database;
    final result =
        await db.rawQuery('SELECT COUNT(*) as count FROM transactions');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  /// Get total revenue
  Future<double> getTotalRevenue() async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery(
      'SELECT SUM(totalPrice) as total FROM transactions WHERE status = ?',
      [TransactionStatus.success.name],
    );
    return (result.first['total'] as num?)?.toDouble() ?? 0.0;
  }

  /// Get transaction count by status
  Future<int> getTransactionCountByStatus(TransactionStatus status) async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM transactions WHERE status = ?',
      [status.name],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }
}
