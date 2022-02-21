import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lapor/auth/register_screen.dart';
import 'package:lapor/homepage/homepage_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _showPassword = false;
  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 100,
              decoration: const BoxDecoration(
                color: Color(0xfffbbb5b),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            const Icon(
              Icons.mark_email_read,
              size: 100,
              color: Color(0xfffbbb5b),
            ),
            const Text(
              'LOGIN',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const Text(
              'Masukkan Nomor Handphone & Kata Sandi',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  /// KOLOM NOMOR HANDPHONE
                  Container(
                    margin: const EdgeInsets.only(top: 10, left: 16, right: 16),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 30, vertical: 1),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TextFormField(
                      controller: _phoneController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        hintText: 'No.Handphone',
                        border: InputBorder.none,
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'No.Handphone tidak boleh kosong';
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),

                  /// KOLOM PASSWORD
                  Container(
                    margin: const EdgeInsets.only(top: 10, left: 16, right: 16),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 30, vertical: 1),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TextFormField(
                      controller: _passwordController,
                      obscureText: !_showPassword,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        hintText: 'Kata Sandi',
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              _showPassword = !_showPassword;
                            });
                          },
                          child: Icon(_showPassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined),
                        ),
                        border: InputBorder.none,
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Kata Sandi tidak boleh kosong';
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),

                  /// LOADING INDIKATOR
                  Visibility(
                    visible: _visible,
                    child: const SpinKitRipple(
                      color: Color(0xfffbbb5b),
                    ),
                  ),

                  const SizedBox(
                    height: 16,
                  ),

                  /// TOMBOL LOGIN
                  SizedBox(
                    width: 200,
                    height: 50,
                    child: RaisedButton(
                        color: const Color(0xfffbbb5b),
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(29)),
                        onPressed: () async {
                          /// CEK APAKAH NO.HANDPHONE DAN PASSWORD SUDAH TERISI DENGAN FORMAT YANG BENAR
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              _visible = true;
                            });

                            /// Cek apakah ada no hp yang diinputkan pengguna ketika klik login
                            var collection = FirebaseFirestore.instance.collection('users');
                            var docSnapshot = await collection.where("phone", isEqualTo: _phoneController.text).limit(1).get();
                            if (docSnapshot.size > 0) {
                              Map<String, dynamic>? data = docSnapshot.docs.first.data();
                              var email = data['email'];


                              /// CEK APAKAH NO.HANDPHONE DAN PASSWORD SUDAH TERDAFTAR / BELUM
                              bool shouldNavigate = await _signInHandler(
                                email,
                                _passwordController.text,
                              );

                              if (shouldNavigate) {
                                setState(() {
                                  _visible = false;
                                });

                                _formKey.currentState!.reset();

                                /// MASUK KE HOMEPAGE JIKA SUKSES LOGIN
                                Route route = MaterialPageRoute(
                                    builder: (context) =>
                                    const HomepageScreen());
                                Navigator.pushReplacement(context, route);
                              } else {
                                setState(() {
                                  _visible = false;
                                });
                              }
                            } else {
                              toast('Maaf, Nomor Handphone atau Kata sandi anda tidak terdaftar');
                              setState(() {
                                _visible = false;
                              });
                            }
                          }
                        }),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  FlatButton(
                    onPressed: () {
                      Route route = MaterialPageRoute(
                          builder: (context) => const RegisterScreen());
                      Navigator.push(context, route);
                    },
                    splashColor: Colors.grey[200],
                    child: const Text(
                      'Saya Ingin Mendaftar',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xfffbbb5b),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _signInHandler(String email, String password) async {
    try {
      (await FirebaseAuth.instance
              .signInWithEmailAndPassword(email: email, password: password))
          .user;

      return true;
    } catch (error) {
      toast(
          'Terdapat kendala ketika ingin login. Silahkan periksa kembali email & password, serta koneksi internet anda');
      return false;
    }
  }
}

void toast(String message) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: const Color(0xfffbbb5b),
      textColor: Colors.white,
      fontSize: 16.0);
}
