import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../data/models/transaction_model.dart';
import '../data/db/transaction_dao.dart';

class EditTransactionPage extends StatefulWidget {
  final Transaction transaction;

  const EditTransactionPage({super.key, required this.transaction});

  @override
  State<EditTransactionPage> createState() => _EditTransactionPageState();
}

class _EditTransactionPageState extends State<EditTransactionPage> {
  final _formKey = GlobalKey<FormState>();
  final TransactionDao _transactionDao = TransactionDao();
  final ImagePicker _picker = ImagePicker();

  late TextEditingController _quantityController;
  late TextEditingController _notesController;
  late TextEditingController _recipeNumberController;
  late PurchaseMethod _purchaseMethod;
  
  File? _recipeImage;
  String? _existingRecipeImagePath;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _quantityController = TextEditingController(text: widget.transaction.quantity.toString());
    _notesController = TextEditingController(text: widget.transaction.notes ?? '');
    _recipeNumberController = TextEditingController(text: widget.transaction.recipeNumber ?? '');
    _purchaseMethod = widget.transaction.purchaseMethod;
    _existingRecipeImagePath = widget.transaction.recipeImagePath;
    if (_existingRecipeImagePath != null) {
      _recipeImage = File(_existingRecipeImagePath!);
    }
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _notesController.dispose();
    _recipeNumberController.dispose();
    super.dispose();
  }

  double _calculateTotal() {
    final quantity = int.tryParse(_quantityController.text) ?? 0;
    return widget.transaction.medicineData.price * quantity;
  }

  Future<void> _showImageSourceDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pilih Sumber Foto'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt, color: Colors.green),
                title: Text('Kamera'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.photo_library, color: Colors.blue),
                title: Text('Galeri'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 1920,
        maxHeight: 1080,
      );
      if (image != null) {
        setState(() {
          _recipeImage = File(image.path);
          _existingRecipeImagePath = null;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengambil foto: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<String?> _saveRecipeImage() async {
    if (_recipeImage == null) return null;
    if (_existingRecipeImagePath != null && _recipeImage!.path == _existingRecipeImagePath) {
      return _existingRecipeImagePath;
    }
    try {
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final savedPath = '${directory.path}/recipe_$timestamp.jpg';
      await _recipeImage!.copy(savedPath);
      return savedPath;
    } catch (e) {
      return null;
    }
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;
    if (_purchaseMethod == PurchaseMethod.recipe && _recipeImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Silakan ambil foto resep terlebih dahulu'), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final quantity = int.parse(_quantityController.text);
      final totalPrice = _calculateTotal();
      String? recipeImagePath;
      if (_purchaseMethod == PurchaseMethod.recipe && _recipeImage != null) {
        recipeImagePath = await _saveRecipeImage();
      }

      final updatedTransaction = widget.transaction.copyWith(
        quantity: quantity,
        totalPrice: totalPrice,
        notes: _notesController.text.isEmpty ? null : _notesController.text,
        purchaseMethod: _purchaseMethod,
        recipeNumber: _purchaseMethod == PurchaseMethod.recipe ? _recipeNumberController.text : null,
        recipeImagePath: _purchaseMethod == PurchaseMethod.recipe ? recipeImagePath : null,
      );

      await _transactionDao.updateTransaction(updatedTransaction);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Transaksi berhasil diperbarui!'), backgroundColor: Colors.green),
        );
        Navigator.pop(context, updatedTransaction);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memperbarui transaksi: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Transaksi'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            _buildMedicineInfo(),
            SizedBox(height: 24),
            _buildBuyerInfo(),
            SizedBox(height: 24),
            _buildQuantityField(),
            SizedBox(height: 16),
            _buildPurchaseMethodRadios(),
            if (_purchaseMethod == PurchaseMethod.recipe) ...[
              SizedBox(height: 16),
              _buildRecipeNumberField(),
              SizedBox(height: 16),
              _buildRecipeImagePicker(),
            ],
            SizedBox(height: 16),
            _buildNotesField(),
            SizedBox(height: 24),
            _buildTotalPrice(),
            SizedBox(height: 24),
            _buildActionButtons(),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildMedicineInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Informasi Obat', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                    widget.transaction.medicineData.imageAsset,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 80,
                      height: 80,
                      color: Colors.grey[300],
                      child: Icon(Icons.medication),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.transaction.medicineData.name,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text(widget.transaction.medicineData.category,
                          style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                      SizedBox(height: 4),
                      Text('IDR ${_formatPrice(widget.transaction.medicineData.price)}',
                          style: TextStyle(fontSize: 14, color: Colors.green, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBuyerInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Nama Pembeli', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 12),
        TextFormField(
          initialValue: widget.transaction.buyerName,
          decoration: InputDecoration(
            labelText: 'Nama Pembeli',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.person),
            filled: true,
            fillColor: Colors.grey[100],
          ),
          readOnly: true,
        ),
      ],
    );
  }

  Widget _buildQuantityField() {
    return TextFormField(
      controller: _quantityController,
      decoration: InputDecoration(
        labelText: 'Jumlah',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.shopping_cart),
        suffix: Text('unit'),
      ),
      keyboardType: TextInputType.number,
      onChanged: (_) => setState(() {}),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Jumlah harus diisi';
        final quantity = int.tryParse(value);
        if (quantity == null || quantity < 1) return 'Jumlah harus berupa angka positif';
        return null;
      },
    );
  }

  Widget _buildPurchaseMethodRadios() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Metode Pembelian', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        RadioListTile<PurchaseMethod>(
          title: Text('Pembelian Langsung'),
          value: PurchaseMethod.direct,
          groupValue: _purchaseMethod,
          onChanged: (value) {
            setState(() {
              _purchaseMethod = value!;
              if (_purchaseMethod == PurchaseMethod.direct) {
                _recipeNumberController.clear();
                _recipeImage = null;
                _existingRecipeImagePath = null;
              }
            });
          },
          activeColor: Colors.green,
        ),
        RadioListTile<PurchaseMethod>(
          title: Text('Pembelian dengan Resep Dokter'),
          value: PurchaseMethod.recipe,
          groupValue: _purchaseMethod,
          onChanged: (value) => setState(() => _purchaseMethod = value!),
          activeColor: Colors.green,
        ),
      ],
    );
  }

  Widget _buildRecipeNumberField() {
    return TextFormField(
      controller: _recipeNumberController,
      decoration: InputDecoration(
        labelText: 'Nomor Resep Dokter',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.receipt),
        helperText: 'Minimal 6 karakter, kombinasi huruf & angka',
      ),
      validator: (value) {
        if (_purchaseMethod == PurchaseMethod.recipe) {
          if (value == null || value.isEmpty) return 'Nomor resep harus diisi';
          if (value.length < 6) return 'Nomor resep minimal 6 karakter';
          final hasLetter = RegExp(r'[a-zA-Z]').hasMatch(value);
          final hasNumber = RegExp(r'[0-9]').hasMatch(value);
          if (!hasLetter || !hasNumber) return 'Nomor resep harus kombinasi huruf & angka';
        }
        return null;
      },
    );
  }

  Widget _buildRecipeImagePicker() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Foto Resep Dokter *', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            SizedBox(height: 12),
            if (_recipeImage == null) ...[
              OutlinedButton.icon(
                onPressed: _showImageSourceDialog,
                icon: Icon(Icons.camera_alt),
                label: Text('Ambil Foto Resep'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.green,
                  side: BorderSide(color: Colors.green),
                  minimumSize: Size(double.infinity, 48),
                ),
              ),
              SizedBox(height: 8),
              Text('Foto resep wajib diupload untuk pembelian dengan resep',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600], fontStyle: FontStyle.italic)),
            ] else ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(_recipeImage!, height: 200, width: double.infinity, fit: BoxFit.cover),
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _showImageSourceDialog,
                      icon: Icon(Icons.refresh),
                      label: Text('Ganti Foto'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.orange,
                        side: BorderSide(color: Colors.orange),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => setState(() {
                            _recipeImage = null;
                            _existingRecipeImagePath = null;
                          }),
                      icon: Icon(Icons.delete),
                      label: Text('Hapus'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: BorderSide(color: Colors.red),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildNotesField() {
    return TextFormField(
      controller: _notesController,
      decoration: InputDecoration(
        labelText: 'Catatan Tambahan (Opsional)',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.note),
      ),
      maxLines: 3,
    );
  }

  Widget _buildTotalPrice() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Total Pembayaran', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Text('IDR ${_formatPrice(_calculateTotal())}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green)),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: _isLoading ? null : () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.grey[700],
              side: BorderSide(color: Colors.grey),
              padding: EdgeInsets.symmetric(vertical: 16),
            ),
            child: Text('Batal'),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: _isLoading ? null : _saveChanges,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: _isLoading
                ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                  )
                : Text('Simpan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }

  String _formatPrice(double price) {
    return price.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  }
}
