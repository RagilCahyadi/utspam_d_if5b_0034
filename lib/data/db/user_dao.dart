import 'package:sqflite/sqflite.dart';
import 'db_helper.dart';
import '../models/user_model.dart';

class UserDao {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  /// Create - Insert new user
  Future<int> insertUser(User user) async {
    final db = await _dbHelper.database;
    try {
      return await db.insert(
        'users',
        user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.abort,
      );
    } catch (e) {
      throw Exception('Username sudah terdaftar');
    }
  }

  /// Read - Get user by username
  Future<User?> getUserByUsername(String username) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );

    if (maps.isEmpty) {
      return null;
    }

    return User.fromMap(maps.first);
  }

  /// Read - Check if username exists
  Future<bool> isUsernameExists(String username) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
      limit: 1,
    );

    return maps.isNotEmpty;
  }

  /// Read - Validate login
  Future<User?> validateLogin(String username, String password) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );

    if (maps.isEmpty) {
      return null;
    }

    return User.fromMap(maps.first);
  }

  /// Read - Get all users (for admin purposes)
  Future<List<User>> getAllUsers() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('users');

    return List.generate(maps.length, (i) {
      return User.fromMap(maps[i]);
    });
  }

  /// Update - Update user data
  Future<int> updateUser(User user) async {
    final db = await _dbHelper.database;
    return await db.update(
      'users',
      user.toMap(),
      where: 'username = ?',
      whereArgs: [user.username],
    );
  }

  /// Delete - Delete user
  Future<int> deleteUser(String username) async {
    final db = await _dbHelper.database;
    return await db.delete(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );
  }
}
