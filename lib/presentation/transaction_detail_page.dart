import 'dart:io';
import 'package:flutter/material.dart';
import '../data/models/transaction_model.dart';
import '../data/db/transaction_dao.dart';

class TransactionDetailPage extends StatefulWidget {
  final Transaction transaction;

  const TransactionDetailPage({
    super.key,
    required this.transaction,
  });

  @override
  State<TransactionDetailPage> createState() => _TransactionDetailPageState();
}

class _TransactionDetailPageState extends State<TransactionDetailPage> {
  final TransactionDao _transactionDao = TransactionDao();
  late Transaction _transaction;

  @override
  void initState() {
    super.initState();
    _transaction = widget.transaction;
  }

  Future<void> _showDeleteConfirmation() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Batalkan Transaksi'),
        content: Text(
          'Apakah Anda yakin ingin membatalkan transaksi ini? '
          'Transaksi akan dihapus dari riwayat pembelian.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _deleteTransaction();
    }
  }

  Future<void> _deleteTransaction() async {
    try {
      await _transactionDao.deleteTransaction(_transaction.transactionId);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Transaksi berhasil dihapus'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true); // Return true to indicate deletion
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menghapus transaksi: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _editTransaction() {
    // TODO: Navigate to edit page (waiting for specifications)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Fitur edit akan segera tersedia'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _transaction.status == TransactionStatus.success
        ? Colors.green
        : Colors.red;
    final isCancelled = _transaction.status == TransactionStatus.cancelled;

    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Pemesanan'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Status Header
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [statusColor, statusColor.withOpacity(0.7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    _transaction.status == TransactionStatus.success
                        ? Icons.check_circle_outline
                        : Icons.cancel_outlined,
                    color: Colors.white,
                    size: 60,
                  ),
                  SizedBox(height: 12),
                  Text(
                    _transaction.status.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'ID: ${_transaction.transactionId}',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Medicine Information
                  _buildSectionTitle('Data Obat'),
                  SizedBox(height: 12),
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              _transaction.medicineData.imageAsset,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 80,
                                  height: 80,
                                  color: Colors.grey[300],
                                  child: Icon(Icons.medication),
                                );
                              },
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _transaction.medicineData.name,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  _transaction.medicineData.category,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'ID: ${_transaction.medicineData.id}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 24),

                  // Transaction Details
                  _buildSectionTitle('Detail Pembelian'),
                  SizedBox(height: 12),
                  _buildDetailCard([
                    _buildDetailRow('Nama Pembeli', _transaction.buyerName),
                    _buildDetailRow('Jumlah Pembelian', '${_transaction.quantity} unit'),
                    _buildDetailRow(
                      'Harga Satuan',
                      'IDR ${_formatPrice(_transaction.medicineData.price)}',
                    ),
                    _buildDetailRow(
                      'Total Harga',
                      'IDR ${_formatPrice(_transaction.totalPrice)}',
                      isHighlight: true,
                    ),
                    _buildDetailRow(
                      'Tanggal Pembelian',
                      _formatDate(_transaction.date),
                    ),
                    _buildDetailRow('ID Transaksi', _transaction.transactionId),
                    _buildDetailRow(
                      'Metode Pembelian',
                      _transaction.purchaseMethod.toString(),
                    ),
                    if (_transaction.purchaseMethod == PurchaseMethod.recipe)
                      _buildDetailRow(
                        'Nomor Resep',
                        _transaction.recipeNumber ?? '-',
                      ),
                    _buildDetailRow(
                      'Status Transaksi',
                      _transaction.status.toString(),
                      valueColor: statusColor,
                    ),
                  ]),
                  SizedBox(height: 16),

                  // Recipe Image
                  if (_transaction.purchaseMethod == PurchaseMethod.recipe &&
                      _transaction.recipeImagePath != null) ...[
                    _buildSectionTitle('Foto Resep'),
                    SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        File(_transaction.recipeImagePath!),
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: double.infinity,
                            height: 200,
                            color: Colors.grey[300],
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.image_not_supported, size: 40),
                                SizedBox(height: 8),
                                Text('Foto tidak tersedia'),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 16),
                  ],

                  // Notes
                  if (_transaction.notes != null &&
                      _transaction.notes!.isNotEmpty) ...[
                    _buildSectionTitle('Catatan'),
                    SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Text(
                        _transaction.notes!,
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    SizedBox(height: 16),
                  ],

                  SizedBox(height: 24),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _showDeleteConfirmation,
                          icon: Icon(Icons.delete),
                          label: Text('Batalkan'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            side: BorderSide(color: Colors.red),
                            padding: EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: isCancelled ? null : _editTransaction,
                          icon: Icon(Icons.edit),
                          label: Text('Edit'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            disabledBackgroundColor: Colors.grey[300],
                            disabledForegroundColor: Colors.grey[600],
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  if (isCancelled) ...[
                    SizedBox(height: 8),
                    Text(
                      '* Tombol Edit tidak tersedia untuk transaksi yang dibatalkan',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],

                  SizedBox(height: 16),

                  // Back Button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.arrow_back),
                      label: Text('Kembali ke Riwayat'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.green,
                        side: BorderSide(color: Colors.green),
                        padding: EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildDetailCard(List<Widget> children) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: children,
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    String label,
    String value, {
    bool isHighlight = false,
    Color? valueColor,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
          ),
          Text(': ', style: TextStyle(fontSize: 14)),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isHighlight ? FontWeight.bold : FontWeight.w600,
                color: valueColor ?? (isHighlight ? Colors.green : Colors.black87),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  String _formatPrice(double price) {
    return price.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  }
}
