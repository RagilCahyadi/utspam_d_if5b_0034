import 'package:flutter/material.dart';
import 'package:utspam_d_if5b_0034/presentation/login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _globalKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool isObscure = true;
  bool confirmIsObscure = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsetsGeometry.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Membuat Akun",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              Text(
                "Bergabung dengan Kita Sehat Sekarang",
                style: TextStyle(fontWeight: FontWeight.w300),
              ),
              SizedBox(height: 20),

              Flexible(
                child: SingleChildScrollView(
                  child: Form(
                    key: _globalKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _nameController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Masukkan nama lengkap anda";
                            } else if(!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                              return "Masukkan dengan huruf";
                            }
                            return null;
                          },
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.badge),
                            labelText: "Nama Lengkap",
                            hintText: "Masukkan nama lengkap",
                          ),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: _emailController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Masukkan alamat email anda';
                            } else if (!value.contains('@')) {
                              return 'Mohon untuk memasukan email yang valid';
                            } else if (!value.contains('gmail.com')) {
                              return 'Email harus berakhiran @gmail.com';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.email),
                            labelText: "Email",
                            hintText: "Masukkan alamat email yang valid",
                          ),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: _phoneController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Masukkan nomer telepon anda';
                            } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                              return 'Masukkan dengan angka';
                            } else if (value.length < 10) {
                              return 'Masukkan nomer minimal: 10 - 13 digit';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.phone),
                            labelText: "Nomer Telepon",
                            hintText: "Masukkan nomer telepon anda",
                          ),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: _addressController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Masukkan alamat anda";
                            } else if (value.length < 5) {
                              return "Alamat harus berisi minimal 5 karakter";
                            }
                            return null;
                          },
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.location_on),
                            labelText: "Alamat",
                            hintText: "Masukkan alamat lengkap",
                          ),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: _usernameController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Masukkan username anda";
                            } else if (value.length < 4) {
                              return "Username harus berisi minimal 4 karakter";
                            }
                            return null;
                          },
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.badge),
                            labelText: "Username",
                            hintText: "Masukkan username",
                          ),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: _passwordController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Mohon masukkan password anda';
                            } else if (value.length < 6) {
                              return 'Password harus berisi minimal 6 karakter';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: isObscure,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            hintText: 'Masukkan password anda',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.lock),
                            suffixIcon: IconButton(
                              icon: Icon(
                                isObscure
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () {
                                setState(() {
                                  isObscure = !isObscure;
                                });
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: _confirmPasswordController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Mohon masukkan ulang password anda';
                            } else if (value != _passwordController.text) {
                              return 'Password tidak sesuai';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: confirmIsObscure,
                          decoration: InputDecoration(
                            labelText: 'Confirm Password',
                            hintText: 'Masukkan confirm password anda',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.lock_person),
                            suffixIcon: IconButton(
                              icon: Icon(
                                confirmIsObscure
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () {
                                setState(() {
                                  confirmIsObscure = !confirmIsObscure;
                                });
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: 30),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_globalKey.currentState!.validate()) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginPage(),
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromRGBO(16, 185, 129, 1),
                              foregroundColor: Colors.white,
                            ),
                            child: Text(
                              'Daftar',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),

                        SizedBox(height: 20),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Apakah sudah punya akun?'),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginPage(),
                                  ),
                                );
                              },
                              child: Text(
                                'Masuk disini!',
                                style: TextStyle(color: Colors.green),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
