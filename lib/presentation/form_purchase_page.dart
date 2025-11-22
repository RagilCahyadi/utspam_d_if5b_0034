import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../data/models/medicine_model.dart';
import '../data/models/transaction_model.dart';
import '../data/db/transaction_dao.dart';
import '../data/db/user_dao.dart';
import 'history_purchase_page.dart';

class FormPurchasePage extends StatefulWidget {
  final Medicine? selectedMedicine;
  final String username;

  const FormPurchasePage({
    super.key,
    this.selectedMedicine,
    required this.username,
  });

  @override
  State<FormPurchasePage> createState() => _FormPurchasePageState();
}

class _FormPurchasePageState extends State<FormPurchasePage> {
  final _formKey = GlobalKey<FormState>();
  final TransactionDao _transactionDao = TransactionDao();
  final UserDao _userDao = UserDao();
  final ImagePicker _picker = ImagePicker();

  final TextEditingController _buyerNameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController(text: '1');
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _recipeNumberController = TextEditingController();

  Medicine? _selectedMedicine;
  PurchaseMethod _purchaseMethod = PurchaseMethod.direct;
  File? _recipeImage;
  bool _isLoading = false;
  bool _isLoadingUser = true;

  // Daftar obat yang tersedia
  final List<Medicine> _availableMedicines = [
    Medicine(
      id: 'MED001',
      name: 'Paracetamol 500mg',
      category: 'Pereda Nyeri',
      imageAsset: 'assets/images/paracetamol500g.webp',
      price: 15000,
    ),
    Medicine(
      id: 'MED002',
      name: 'Amoxicillin 250mg',
      category: 'Antibiotik',
      imageAsset: 'assets/images/amoxicillin250g.webp',
      price: 5800,
    ),
    Medicine(
      id: 'MED003',
      name: 'Tablet Tambah Darah',
      category: 'Salut Selaput',
      imageAsset: 'assets/images/tab_tambahdarah.webp',
      price: 4400,
    ),
    Medicine(
      id: 'MED004',
      name: 'Vitamin C 250mg',
      category: 'Vitamin',
      imageAsset: 'assets/images/vitaminc250mg.webp',
      price: 15028,
    ),
    Medicine(
      id: 'MED005',
      name: 'Dettol Antiseptik 45 ML',
      category: 'Antiseptik',
      imageAsset: 'assets/images/dettol45ml.webp',
      price: 11400,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _selectedMedicine = widget.selectedMedicine;
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final user = await _userDao.getUserByUsername(widget.username);
      if (user != null) {
        setState(() {
          _buyerNameController.text = user.fullName;
          _isLoadingUser = false;
        });
      } else {
        setState(() {
          _isLoadingUser = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoadingUser = false;
      });
    }
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
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal mengambil foto: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<String?> _saveRecipeImage() async {
    if (_recipeImage == null) return null;

    try {
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'recipe_$timestamp.jpg';
      final savedPath = '${directory.path}/$fileName';

      await _recipeImage!.copy(savedPath);
      return savedPath;
    } catch (e) {
      return null;
    }
  }

  @override
  void dispose() {
    _buyerNameController.dispose();
    _quantityController.dispose();
    _notesController.dispose();
    _recipeNumberController.dispose();
    super.dispose();
  }

  double _calculateTotal() {
    if (_selectedMedicine == null) return 0;
    final quantity = int.tryParse(_quantityController.text) ?? 0;
    return _selectedMedicine!.price * quantity;
  }

  Future<void> _handlePurchase() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedMedicine == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Silakan pilih obat terlebih dahulu'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Validasi foto resep jika metode pembelian adalah resep
    if (_purchaseMethod == PurchaseMethod.recipe && _recipeImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Silakan ambil foto resep terlebih dahulu'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final quantity = int.parse(_quantityController.text);
      final totalPrice = _calculateTotal();

      // Save recipe image if exists
      String? recipeImagePath;
      if (_purchaseMethod == PurchaseMethod.recipe && _recipeImage != null) {
        recipeImagePath = await _saveRecipeImage();
      }

      // Generate transaction ID
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final transactionId = 'TRX$timestamp';

      final transaction = Transaction(
        transactionId: transactionId,
        medicineData: _selectedMedicine!,
        buyerName: _buyerNameController.text,
        username: widget.username,
        quantity: quantity,
        totalPrice: totalPrice,
        date: DateTime.now(),
        notes: _notesController.text.isEmpty ? null : _notesController.text,
        purchaseMethod: _purchaseMethod,
        recipeNumber: _purchaseMethod == PurchaseMethod.recipe
            ? _recipeNumberController.text
            : null,
        recipeImagePath: recipeImagePath,
        status: TransactionStatus.success,
      );

      await _transactionDao.insertTransaction(transaction);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Pembelian berhasil! ID: $transactionId'),
            backgroundColor: Colors.green,
          ),
        );

        // Navigasi ke halaman histori dengan pushReplacement
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HistoryPurchasePage(username: widget.username)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal melakukan pembelian: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Form Pembelian Obat'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            // Pilihan Obat atau Tampilan Data Obat
            if (_selectedMedicine == null) ...[
              Text(
                'Pilih Obat',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<Medicine>(
                decoration: InputDecoration(
                  labelText: 'Obat',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.medication),
                ),
                value: _selectedMedicine,
                items: _availableMedicines.map((medicine) {
                  return DropdownMenuItem(
                    value: medicine,
                    child: Text(medicine.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedMedicine = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Silakan pilih obat';
                  }
                  return null;
                },
              ),
            ] else ...[
              Card(
                elevation: 2,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Obat yang Dipilih',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Divider(height: 24),
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              _selectedMedicine!.imageAsset,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 80,
                                  height: 80,
                                  color: Colors.grey[300],
                                  child: Icon(Icons.image_not_supported),
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
                                  _selectedMedicine!.name,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  _selectedMedicine!.category,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'IDR ${_formatPrice(_selectedMedicine!.price)}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
            SizedBox(height: 24),

            // Nama Pembeli
            Text(
              'Informasi Pembeli',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _buyerNameController,
              decoration: InputDecoration(
                labelText: 'Nama Pembeli',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
                filled: true,
                fillColor: Colors.grey[100],
                suffixIcon: _isLoadingUser
                    ? Padding(
                        padding: EdgeInsets.all(12),
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    : null,
              ),
              readOnly: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Nama pembeli harus diisi';
                }
                return null;
              },
            ),
            SizedBox(height: 24),

            // Detail Pembelian
            Text(
              'Detail Pembelian',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _quantityController,
              decoration: InputDecoration(
                labelText: 'Jumlah',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.shopping_cart),
                suffix: Text('unit'),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {});
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Jumlah harus diisi';
                }
                final quantity = int.tryParse(value);
                if (quantity == null || quantity < 1) {
                  return 'Jumlah harus berupa angka positif';
                }
                return null;
              },
            ),
            SizedBox(height: 16),

            // Metode Pembelian
            Text(
              'Metode Pembelian',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8),
            RadioListTile<PurchaseMethod>(
              title: Text('Pembelian Langsung'),
              value: PurchaseMethod.direct,
              groupValue: _purchaseMethod,
              onChanged: (value) {
                setState(() {
                  _purchaseMethod = value!;
                });
              },
              activeColor: Colors.green,
            ),
            RadioListTile<PurchaseMethod>(
              title: Text('Pembelian dengan Resep Dokter'),
              value: PurchaseMethod.recipe,
              groupValue: _purchaseMethod,
              onChanged: (value) {
                setState(() {
                  _purchaseMethod = value!;
                });
              },
              activeColor: Colors.green,
            ),

            // Nomor Resep dan Foto Resep (conditional)
            if (_purchaseMethod == PurchaseMethod.recipe) ...[
              SizedBox(height: 16),
              TextFormField(
                controller: _recipeNumberController,
                decoration: InputDecoration(
                  labelText: 'Nomor Resep Dokter',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.receipt),
                  helperText: 'Minimal 6 karakter, kombinasi huruf & angka',
                ),
                validator: (value) {
                  if (_purchaseMethod == PurchaseMethod.recipe) {
                    if (value == null || value.isEmpty) {
                      return 'Nomor resep harus diisi';
                    }
                    if (value.length < 6) {
                      return 'Nomor resep minimal 6 karakter';
                    }
                    // Cek kombinasi huruf dan angka
                    final hasLetter = RegExp(r'[a-zA-Z]').hasMatch(value);
                    final hasNumber = RegExp(r'[0-9]').hasMatch(value);
                    if (!hasLetter || !hasNumber) {
                      return 'Nomor resep harus kombinasi huruf & angka';
                    }
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              // Upload Foto Resep
              Card(
                elevation: 2,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Foto Resep Dokter *',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
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
                        Text(
                          'Foto resep wajib diupload untuk pembelian dengan resep',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ] else ...[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            _recipeImage!,
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
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
                                onPressed: () {
                                  setState(() {
                                    _recipeImage = null;
                                  });
                                },
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
              ),
            ],

            SizedBox(height: 16),
            TextFormField(
              controller: _notesController,
              decoration: InputDecoration(
                labelText: 'Catatan (Opsional)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.note),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 24),

            // Total Harga
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Pembayaran',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'IDR ${_formatPrice(_calculateTotal())}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),

            // Tombol Submit
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handlePurchase,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text(
                        'Beli Sekarang',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatPrice(double price) {
    return price.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  }
}