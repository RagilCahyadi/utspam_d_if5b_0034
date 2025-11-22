import 'package:flutter/material.dart';
import 'package:utspam_d_if5b_0034/presentation/login_page.dart';
import 'package:utspam_d_if5b_0034/presentation/form_purchase_page.dart';
import 'package:utspam_d_if5b_0034/presentation/history_purchase_page.dart';
import 'package:utspam_d_if5b_0034/presentation/profile_page.dart';
import '../data/models/medicine_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.nama, required this.username});
  final String nama;
  final String username;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Data obat dalam list menggunakan Medicine model
  final List<Medicine> medicines = [
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello, ${widget.nama}',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  'Apa yang bisa kami bantu hari ini?',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
                ),
                SizedBox(height: 20),

                // Menu Grid
                Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildMenuCard(
                            icon: Icons.medication,
                            iconColor: Colors.green,
                            title: 'Beli Obat',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FormPurchasePage(
                                    username: widget.username,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: _buildMenuCard(
                            icon: Icons.history,
                            iconColor: Colors.blue,
                            title: 'Histori Pemesanan',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HistoryPurchasePage(),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: _buildMenuCard(
                            icon: Icons.person,
                            iconColor: Colors.orange,
                            title: 'Profil',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProfilePage(
                                    username: widget.username,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: _buildMenuCard(
                            icon: Icons.logout,
                            iconColor: Colors.red,
                            title: 'Logout',
                            onTap: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Konfirmasi Logout'),
                                  content: Text('Apakah Anda yakin ingin keluar?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, false),
                                      child: Text('Cancel'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () => Navigator.pop(context, true),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                        foregroundColor: Colors.white,
                                      ),
                                      child: Text('Logout'),
                                    ),
                                  ],
                                ),
                              );
                              
                              if (confirm == true && context.mounted) {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(builder: (context) => LoginPage()),
                                  (route) => false,
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                SizedBox(height: 20),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Obat Tersedia',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 15),

                ...medicines.map(
                  (medicine) => Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: _buildMedicineCard(
                      medicine: medicine,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Method untuk membuat menu card
  Widget _buildMenuCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Card(
        color: Colors.white,
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Icon(icon, size: 50, color: iconColor),
              SizedBox(height: 15),
              Text(
                title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Method untuk membuat medicine card yang lebih menarik
  Widget _buildMedicineCard({
    required Medicine medicine,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Container untuk gambar dengan gradient overlay
          Stack(
            children: [
              Container(
                height: 180,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.grey[100]!, Colors.white],
                  ),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  child: Image.asset(
                    medicine.imageAsset,
                    width: double.infinity,
                    height: 180,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.medication,
                              size: 60,
                              color: Colors.grey[400],
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Gambar tidak tersedia',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),

              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_circle, size: 14, color: Colors.white),
                      SizedBox(width: 4),
                      Text(
                        'Tersedia',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          Container(
            height: 3,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.cyan.withOpacity(0.3),
                  Colors.green.withOpacity(0.3),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.medical_services,
                        size: 18,
                        color: Colors.green[700],
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        medicine.name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),

                Container(
                  padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.cyan[100]!, Colors.cyan[50]!],
                    ),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.cyan[200]!, width: 1),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.category, size: 14, color: Colors.cyan[900]),
                      SizedBox(width: 6),
                      Text(
                        medicine.category,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.cyan[900],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),

                Divider(color: Colors.grey[300], thickness: 1),
                SizedBox(height: 12),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Harga',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'IDR ${_formatPrice(medicine.price)}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[700],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.green[600]!, Colors.green[400]!],
                        ),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.withOpacity(0.4),
                            spreadRadius: 1,
                            blurRadius: 8,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FormPurchasePage(
                                selectedMedicine: medicine,
                                username: widget.username,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          foregroundColor: Colors.white,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 28,
                            vertical: 14,
                          ),
                          elevation: 0,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.shopping_cart, size: 18),
                            SizedBox(width: 8),
                            Text(
                              'Beli',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
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
