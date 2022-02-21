import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
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
              'REGISTRASI LAPOR!!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 16,
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [

                  Text('Data Pribadi', textAlign: TextAlign.start, style: TextStyle(fontWeight: FontWeight.w500),),
                  const SizedBox(
                    height: 16,
                  ),
                  /// NOMOR HANDPHONE
                  Container(
                    margin: const EdgeInsets.only(top: 10, left: 16, right: 16),
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 1),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: const InputDecoration(
                        hintText: 'Nomor Handphone',
                        border: InputBorder.none,
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Nomor Handphone tidak boleh kosong';
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),

                  /// KOLOM NAMA
                  Container(
                    margin: const EdgeInsets.only(top: 10, left: 16, right: 16),
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 1),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TextFormField(
                      controller: _nameController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: const InputDecoration(
                        hintText: 'Nama Lengkap',
                        border: InputBorder.none,
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Nama Lengkap tidak boleh kosong';
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text('Email & Kata sandi',textAlign: TextAlign.start, style: TextStyle(fontWeight: FontWeight.w500),),
                  const SizedBox(
                    height: 16,
                  ),
                  /// KOLOM EMAIL
                  Container(
                    margin: const EdgeInsets.only(top: 10, left: 16, right: 16),
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 1),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TextFormField(
                      controller: _emailController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: const InputDecoration(
                        hintText: 'Email',
                        border: InputBorder.none,
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Email tidak boleh kosong';
                        } else if (!value.contains('@') ||
                            !value.contains('.')) {
                          return 'Format Email tidak sesuai';
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),

                  /// KOLOM PASSWORD
                  Container(
                    margin: const EdgeInsets.only(top: 10, left: 16, right: 16),
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 1),
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

                  /// TOMBOL REGISTRASI
                  SizedBox(
                    width: 250,
                    height: 50,
                    child: RaisedButton(
                        color: const Color(0xfffbbb5b),
                        child: const Text(
                          'Registrasi',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(29)),
                        onPressed: () async {
                          /// CEK APAKAH EMAIL DAN PASSWORD SUDAH TERISI DENGAN FORMAT YANG BENAR
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              _visible = true;
                            });

                            bool shouldNavigate = await _registerHandler();

                            if (shouldNavigate) {
                              await _registeringUserToDatabase();

                              setState(() {
                                _visible = false;
                              });

                              _formKey.currentState!.reset();
                              _showSuccessRegistration();
                            } else {
                              setState(() {
                                _visible = false;
                              });
                              _showFailureRegistration();
                            }
                          }
                        }),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  FlatButton(
                    onPressed: () {
                      Route route =
                      MaterialPageRoute(builder: (context) => const LoginScreen());
                      Navigator.pushReplacement(context, route);
                    },
                    splashColor: Colors.grey[200],
                    child: const Text(
                      'Ke Halaman Login',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
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

  _registerHandler() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text);
      return true;
    } catch (error) {
      toast(
          'Gagal melakukan pendaftaran, silahkan periksa kembali data diri anda dan koneksi internet anda');
      return false;
    }
  }

  _registeringUserToDatabase() async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        "uid": uid,
        "name": _nameController.text,
        "email": _emailController.text,
        "phone": _phoneController.text,
        "role": 'user',
      });
    } catch (error) {
      toast("Gagal melakukan pendaftaran, silahkan cek koneksi internet anda");
    }
  }

  _showSuccessRegistration() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            side: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.all(
              Radius.circular(16),
            ),
          ),
          backgroundColor: Color(0xfffbbb5b),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Center(
                child: Text(
                  'Sukses Mendaftar',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Container(
                margin: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.1,
                  right: MediaQuery.of(context).size.width * 0.1,
                ),
                child: const Divider(
                  color: Colors.white,
                  height: 3,
                  thickness: 3,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              const Text(
                'Anda berhasil terdaftar pada Sistem LAPOR!!\n\nSilahkan Login dengan akun anda',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  width: 250,
                  height: 50,
                  child: const Center(
                    child: Text(
                      "Tutup",
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 18,
                        letterSpacing: 1,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xfffbbb5b),
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
            ],
          ),
          elevation: 10,
        );
      },
    );
  }

  _showFailureRegistration() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Gagal Registrasi"),
          content: const Text(
            'Anda gagal terdaftar dalam Sistem LAPOR!!, silahkan periksa data yang anda inputkan dan periksa koneksi internet, coba lagi kemudian',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.clear,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}