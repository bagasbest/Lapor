import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lapor/homepage/data_user/data_user.dart';
import 'package:lapor/homepage/pengaduan/pengaduan_screen.dart';
import 'package:lapor/homepage/profile/profile_screen.dart';
import 'package:lapor/homepage/settings/settings_screen.dart';
import 'package:lapor/widgets/loading_widgets.dart';

import 'daftar_pengaduan/list_screen.dart';

class HomepageScreen extends StatefulWidget {
  const HomepageScreen({Key? key}) : super(key: key);

  @override
  _HomepageScreenState createState() => _HomepageScreenState();
}

class _HomepageScreenState extends State<HomepageScreen> {
  String role = "";
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    getUserRole();
  }

  void getUserRole() async {
    setState(() {
      _loading = true;
    });
    String uid = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get()
        .then((value) {
      role = "" + value.get('role');
      setState(() {
        _loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return (_loading)
        ? LoadingWidget()
        : Scaffold(
            appBar: AppBar(
              title: Text(
                'Pengaduan Masyarakat',
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
              children: [
                Flexible(
                  flex: 1,
                  child: Row(
                    children: [
                      Flexible(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 16,
                            left: 16,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              Route route = MaterialPageRoute(
                                  builder: (context) => const ProfileScreen());
                              Navigator.push(context, route);
                            },
                            child: Card(
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/profile.png',
                                      width: 100,
                                      height: 100,
                                    ),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    Text(
                                      'Profil',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 16,
                            left: 16,
                            right: 16,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              if (role == "user") {
                                Route route = MaterialPageRoute(
                                    builder: (context) =>
                                        const PengaduanScreen());
                                Navigator.push(context, route);
                              } else {
                                Route route = MaterialPageRoute(
                                    builder: (context) =>
                                        const DataUserScreen());
                                Navigator.push(context, route);
                              }
                            },
                            child: Card(
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    (role == "user")
                                        ? Image.asset(
                                            'assets/pengaduan.png',
                                            width: 100,
                                            height: 100,
                                          )
                                        : Icon(
                                            Icons.people,
                                            color: Colors.orange,
                                            size: 100,
                                          ),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    (role == "user")
                                        ? Text(
                                            'Buat Pengaduan',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 18),
                                          )
                                        : Text(
                                            'Data Pengguna',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 18),
                                          ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Row(
                    children: [
                      Flexible(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 16,
                            left: 16,
                            bottom: 16,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              Route route = MaterialPageRoute(
                                  builder: (context) =>
                                      const PengaduanListScreen());
                              Navigator.push(context, route);
                            },
                            child: Card(
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/daftar_pengaduan.png',
                                      width: 100,
                                      height: 100,
                                    ),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    Text(
                                      'Daftar Pengaduan',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 17,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 16,
                            left: 16,
                            bottom: 16,
                            right: 16,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              Route route = MaterialPageRoute(
                                  builder: (context) => const SettingsScreen());
                              Navigator.push(context, route);
                            },
                            child: Card(
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/settings.png',
                                      width: 100,
                                      height: 100,
                                    ),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    Text(
                                      'Pengaturan',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
  }
}
