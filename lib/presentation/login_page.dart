import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _globalkey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundColor: const Color.fromRGBO(218, 243, 232, 1.0),
                        radius: 40,
                        child: Image.asset('assets/images/pill.png', height: 40),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Kita Sehat',
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Kami Hadir Sebagai Partner sehatmu',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
                      ),
                      SizedBox(height: 50),
                      Form(
                        key: _globalkey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _usernameController,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Silahkan masukkan username anda";
                                }
                                return null;
                              },
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                labelText: "Username",
                                hintText: "Masukkan username anda",
                                icon: Icon(Icons.person),
                              ),
                            ),
                            TextFormField(
                              controller: _passwordController,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Silahkan masukkan password anda";
                                } else if (value.length < 6) {
                                  return "Password harus berisi setidaknya 6 karakter";
                                }
                                return null;
                              },
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: isObscure,
                              decoration: InputDecoration(
                                labelText: "Password",
                                hintText: "Masukkan password anda",
                                icon: Icon(Icons.lock),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    isObscure ? Icons.visibility_off : Icons.visibility,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      isObscure = !isObscure;
                                    });
                                  },
                                ),
                              ),
                            ),
                            SizedBox(height: 35),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_globalkey.currentState!.validate()) {
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => LoginPage(),
                                      ),
                                      (route) => false,
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color.fromRGBO(16, 185, 129, 1),
                                  foregroundColor: Colors.white,
                                ),
                                child: Text(
                                  'Login',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Belum punya akun? "
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginPage(), 
                        ),
                      );
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero
                    ),
                    child: Text(
                      "Daftar disini",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
