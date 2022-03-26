import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lapor/database/database_service.dart';
import 'package:lapor/homepage/data_user/data_user_change_password.dart';

class DataUserDetail extends StatefulWidget {
  final String uid;
  final String name;
  final String email;
  final String password;
  final String phone;

  DataUserDetail(
      {required this.uid,
      required this.name,
      required this.email,
      required this.password,
      required this.phone});

  @override
  State<DataUserDetail> createState() => _DataUserDetailState();
}

class _DataUserDetailState extends State<DataUserDetail> {
  var _phone = TextEditingController();
  var _name = TextEditingController();
  var _email = TextEditingController();

  bool _visible = false;

  @override
  void initState() {
    super.initState();
    initData();
  }

  void initData() {
    _phone.text = widget.phone;
    _name.text = widget.name;
    _email.text = widget.email;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profil Pengguna',
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
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 16,
            ),
            Text(
              'Data Pribadi',
              textAlign: TextAlign.start,
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
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
                controller: _phone,
                keyboardType: TextInputType.phone,
                enabled: true,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: const InputDecoration(
                  hintText: 'Nomor Handphone',
                  border: InputBorder.none,
                ),
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
                controller: _name,
                enabled: true,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: const InputDecoration(
                  hintText: 'Nama Lengkap',
                  border: InputBorder.none,
                ),
              ),
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
                controller: _email,
                enabled: false,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: const InputDecoration(
                  hintText: 'Email',
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
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  height: 50,
                  child: RaisedButton(
                    onPressed: () {
                      Route route = MaterialPageRoute(
                        builder: (context) => DataUserChangePassword(
                          email: widget.email,
                          password: widget.password,
                        ),
                      );
                      Navigator.push(context, route);
                    },
                    color: Color(0xfffbbb5b),
                    child: Text(
                      'Ubah Password',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  height: 50,
                  child: RaisedButton(
                    onPressed: () async {
                      setState(() {
                        _visible = true;
                      });

                      await DatabaseService.updateProfile(
                        _name.text,
                        _phone.text,
                        widget.uid,
                      );

                      setState(() {
                        _visible = false;
                      });
                    },
                    color: Colors.orange,
                    child: Text(
                      'Update Data',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
