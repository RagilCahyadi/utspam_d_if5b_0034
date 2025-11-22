import 'package:flutter/material.dart';
import 'package:utspam_d_if5b_0034/presentation/login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.nama});
  final String nama;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Data obat dalam list
  final List<Map<String, dynamic>> medicines = [
    {
      'name': 'Paracetamol 500mg',
      'category': 'Pereda Nyeri',
      'price': 'IDR 15,000',
      'image': 'assets/images/paracetamol500g.webp',
    },
    {
      'name': 'Amoxicillin 250mg',
      'category': 'Antibiotik',
      'price': 'IDR 5,800',
      'image': 'assets/images/amoxicillin250g.webp',
    },
    {
      'name': 'Tablet Tambah Darah',
      'category': 'Salut Selaput',
      'price': 'IDR 4,400',
      'image': 'assets/images/tab_tambahdarah.webp',
    },
    {
      'name': 'Vitamin C 250mg',
      'category': 'Vitamin',
      'price': 'IDR 15,028',
      'image': 'assets/images/vitaminc250mg.webp',
    },
    {
      'name': 'Dettol Antiseptik 45 ML',
      'category': 'Antiseptik',
      'price': 'IDR 11,400',
      'image': 'assets/images/dettol45ml.webp',
    },
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
                              // Navigator ke halaman beli obat
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
                              // Navigator ke halaman histori
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
                              // Navigator ke halaman profil
                            },
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: _buildMenuCard(
                            icon: Icons.logout,
                            iconColor: Colors.red,
                            title: 'Logout',
                            onTap: () {
                              Navigator.pushReplacement(
                                context, 
                                MaterialPageRoute(builder: (context) => LoginPage())
                                );
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
                      name: medicine['name'],
                      category: medicine['category'],
                      price: medicine['price'],
                      image: medicine['image'],
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
    required String name,
    required String category,
    required String price,
    required String image,
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
                    image,
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
                        name,
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
                        category,
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
                          price,
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
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => FormulirPembelianPage(
                          //       namaObat: name,
                          //       hargaObat: price,
                          //       kategoriObat: category,
                          //       gambarObat: image,
                          //     ),
                          //   ),
                          // );
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
}
