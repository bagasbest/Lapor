import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lapor/homepage/profile/profile_change_password_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var _name = TextEditingController();
  var _email = TextEditingController();
  var _phone = TextEditingController();
  String _password = "";

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    var uid = await FirebaseAuth.instance.currentUser!.uid;
    var collection =
        await FirebaseFirestore.instance.collection('users').doc(uid);
    var docSnapshot = await collection.get();

    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();
      _name.text = data!['name'];
      _email.text = data['email'];
      _phone.text = data['phone'];
      _password = data['password'];
    }
    setState(() {});
  }

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
      body: Column(
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
              enabled: false,
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
              enabled: false,
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
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(
              left: 16,
              right: 16,
            ),
            child: ElevatedButton(
              child: Text(
                'Ubah Kata Sandi',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                primary: Color(0xfffbbb5b),
                elevation: 10.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                Route route = MaterialPageRoute(
                  builder: (context) => ProfileChangePasswordScreen(
                      email: _email.text, password: _password),
                );
                Navigator.push(context, route);
              },
            ),
          )
        ],
      ),
    );
  }
}
