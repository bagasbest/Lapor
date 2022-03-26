import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lapor/auth/login_screen.dart';

class DataUserChangePassword extends StatefulWidget {
  final String email;
  final String password;

  DataUserChangePassword({required this.email, required this.password});
  @override
  State<DataUserChangePassword> createState() => _DataUserChangePasswordState();
}

class _DataUserChangePasswordState extends State<DataUserChangePassword> {
  var _password = TextEditingController();
  var _confPassword = TextEditingController();
  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Perbarui Password Pengguna Ini',
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
      body: SingleChildScrollView(
        child: Column(
          children: [
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
                enabled: true,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: const InputDecoration(
                  hintText: 'Kata Sandi',
                  border: InputBorder.none,
                ),
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
                keyboardType: TextInputType.text,
                enabled: true,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: const InputDecoration(
                  hintText: 'Konfirmasi Kata Sandi',
                  border: InputBorder.none,
                ),
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

            SizedBox(
              height: 16,
            ),

            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: RaisedButton(
                onPressed: () async {
                  setState(() {
                    _visible = true;
                  });

                  if (_password.text == _confPassword.text) {
                    String uid = FirebaseAuth.instance.currentUser!.uid;

                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(uid)
                        .get()
                        .then((value) async {
                      String admEmail = "" + value.get('email');
                      String admPassword = "" + value.get('password');

                      await FirebaseAuth.instance.signOut();
                      await FirebaseAuth.instance.signInWithEmailAndPassword(
                        email: widget.email,
                        password: widget.password,
                      );

                      reauthenticatePassword(admEmail, admPassword);
                    });
                  } else {
                    toast('Kata sandi tidak sama');
                  }

                  setState(() {
                    _visible = false;
                  });
                },
                child: Text(
                  'Perbarui Kata Sandi',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: Color(0xfffbbb5b),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> reauthenticatePassword(
      String admEmail, String admPassword) async {
    final user = await FirebaseAuth.instance.currentUser;
    final cred = EmailAuthProvider.credential(
        email: widget.email, password: widget.password);

    await user!.reauthenticateWithCredential(cred).then((value) {
      user.updatePassword(_confPassword.text).then((_) {
        //Success, do something

        FirebaseFirestore.instance
            .collection("users")
            .doc(user.uid)
            .update({'password': 'sas'}).then((_) {
          FirebaseAuth.instance.signOut();
          FirebaseAuth.instance.signInWithEmailAndPassword(
            email: admEmail,
            password: admPassword,
          );

          toast('Berhasil memperbarui kata sandi');
        });
      }).catchError((error) {
        //Error, show something
        toast('Catch: Gagal memperbarui kata sandi!');
      });
    }).catchError((err) {
      toast('Error: Gagal memperbarui kata sandi!');
    });
  }
}
