import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var _name = TextEditingController();
  var _email = TextEditingController();
  var _phone = TextEditingController();

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
        ],
      ),
    );
  }
}
