import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lapor/homepage/homepage_screen.dart';

import '../../auth/login_screen.dart';

class ProfileChangePasswordScreen extends StatefulWidget {
  final String email;
  final String password;

  ProfileChangePasswordScreen({
    required this.email,
    required this.password,
  });

  @override
  State<ProfileChangePasswordScreen> createState() =>
      _ProfileChangePasswordScreenState();
}

class _ProfileChangePasswordScreenState
    extends State<ProfileChangePasswordScreen> {
  var _password = TextEditingController();
  var _confPassword = TextEditingController();
  bool _visible = false;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profil',
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        backgroundColor: Color(0xfffbbb5b),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(24),
            bottomRight: Radius.circular(24),
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(
              height: 16,
            ),
            Text(
              'Ubah / Ganti Kata Sandi',
              textAlign: TextAlign.start,
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 16,
            ),

            /// PASSWORD BARU
            Container(
              margin: const EdgeInsets.only(top: 10, left: 16, right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 1),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextFormField(
                controller: _password,
                keyboardType: TextInputType.text,
                obscureText: true,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: const InputDecoration(
                  hintText: 'Kata Sandi',
                  border: InputBorder.none,
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Kata sandi tidak boleh kosong';
                  } else if (value.length < 6) {
                    return 'Kata sandi minimal 6 karakter';
                  } else {
                    return null;
                  }
                },
              ),
            ),

            /// PASSWORD BARU
            Container(
              margin: const EdgeInsets.only(top: 10, left: 16, right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 1),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextFormField(
                controller: _confPassword,
                obscureText: true,
                keyboardType: TextInputType.text,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: const InputDecoration(
                  hintText: 'Konfirmasi Kata Sandi',
                  border: InputBorder.none,
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Kata sandi tidak boleh kosong';
                  } else if (value.length < 6) {
                    return 'Kata sandi minimal 6 karakter';
                  } else {
                    return null;
                  }
                },
              ),
            ),

            SizedBox(
              height: 16,
            ),

            Visibility(
              visible: _visible,
              child: const SpinKitRipple(
                color: Color(0xfffbbb5b),
              ),
            ),

            Container(
              width: MediaQuery.of(context).size.width,
              height: 50,
              margin: EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      _visible = true;
                    });

                    if (_password.text == _confPassword.text) {
                      try {
                        reAuthenticatePassword();
                      } catch (e) {
                        setState(() {
                          _visible = false;
                        });
                        toast('Email atau password salah');
                        print(e.toString());
                      }
                    } else {
                      setState(() {
                        _visible = false;
                      });
                      toast('Kata sandi tidak sama');
                    }
                  }
                },
                child: Text(
                  'Perbarui Kata Sandi',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Color(0xfffbbb5b),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 10.0,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> reAuthenticatePassword() async {
    final user = await FirebaseAuth.instance.currentUser;
    final cred = await EmailAuthProvider.credential(
        email: widget.email, password: widget.password);

    await user!.reauthenticateWithCredential(cred).then((value) {
      user.updatePassword(_confPassword.text).then((_) {
        //Success, do something

        showSuccessChangePassword(user);
      }).catchError((error) {
        setState(() {
          _visible = false;
        });
        //Error, show something
        toast('Catch: Gagal memperbarui kata sandi!');
      });
    }).catchError((err) {
      setState(() {
        _visible = false;
      });
      toast('Error: Gagal memperbarui kata sandi!');
    });
  }

  showSuccessChangePassword(User user) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .update({'password': _confPassword.text}).then((_) {
      _showMyDialog('Sukses Memperbarui Kata Sandi',
          'Kata sandi anda telah diperbarui, jika anda Log-in pastikan anda menggunakan kata sandi yang baru!');
    }).catchError((e) {
      _showMyDialog('Gagal Memperbarui Kata Sandi', e.toString());
    });
  }

  Future<void> _showMyDialog(String title, String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
              child: Text(message, textAlign: TextAlign.start)),
          actions: <Widget>[
            TextButton(
              child: const Text('OKE'),
              onPressed: () {
                setState(() {
                  _visible = false;
                });
                Navigator.of(context).pop();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => const HomepageScreen()),
                    (Route<dynamic> route) => false);
              },
            ),
          ],
        );
      },
    );
  }
}
