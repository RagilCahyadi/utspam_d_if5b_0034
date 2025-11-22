import 'package:flutter/material.dart';
import '../data/db/user_dao.dart';
import '../data/models/user_model.dart';

class EditProfilePage extends StatefulWidget {
  final User user;

  const EditProfilePage({super.key, required this.user});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final UserDao _userDao = UserDao();

  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _fullNameController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.user.username);
    _emailController = TextEditingController(text: widget.user.email);
    _fullNameController = TextEditingController(text: widget.user.fullName);
    _phoneController = TextEditingController(text: widget.user.phone);
    _addressController = TextEditingController(text: widget.user.address);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _fullNameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final updatedUser = widget.user.copyWith(
        fullName: _fullNameController.text,
        phone: _phoneController.text,
        address: _addressController.text,
      );

      await _userDao.updateUser(updatedUser);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Profil berhasil diperbarui'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pop(context, true); // Return true to indicate success
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memperbarui profil: ${e.toString()}'),
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
        title: Text('Edit Profil'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildDisabledField(
                label: 'Username',
                value: _usernameController.text,
                icon: Icons.person_outline,
              ),
              SizedBox(height: 16),
              _buildDisabledField(
                label: 'Email',
                value: _emailController.text,
                icon: Icons.email_outlined,
              ),
              SizedBox(height: 16),
              _buildEditableField(
                controller: _fullNameController,
                label: 'Nama Lengkap',
                icon: Icons.badge_outlined,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama lengkap tidak boleh kosong';
                  }
                  if (value.length < 3) {
                    return 'Nama lengkap minimal 3 karakter';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              _buildEditableField(
                controller: _phoneController,
                label: 'No. Telepon',
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'No. telepon tidak boleh kosong';
                  }
                  if (value.length < 10) {
                    return 'No. telepon minimal 10 digit';
                  }
                  if (value.length > 13) {
                    return 'No. telepon maksimal 15 digit';
                  }
                  if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                    return 'No. telepon hanya boleh berisi angka';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              _buildEditableField(
                controller: _addressController,
                label: 'Alamat',
                icon: Icons.location_on_outlined,
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Alamat tidak boleh kosong';
                  }
                  if (value.length < 10) {
                    return 'Alamat minimal 10 karakter';
                  }
                  return null;
                },
              ),
              SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: _isLoading ? null : _handleSave,
                icon: _isLoading
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Icon(Icons.save),
                label: Text(
                  _isLoading ? 'Menyimpan...' : 'Simpan Perubahan',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: _isLoading ? null : () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back),
                label: Text(
                  'Batal',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.grey[700],
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  side: BorderSide(color: Colors.grey[400]!),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDisabledField({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: 8),
        TextFormField(
          initialValue: value,
          enabled: false,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.grey),
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEditableField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.green),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.green, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.red),
            ),
          ),
        ),
      ],
    );
  }
}
