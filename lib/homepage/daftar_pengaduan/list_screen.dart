import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lapor/homepage/daftar_pengaduan/list_data.dart';
import 'package:lapor/widgets/loading_widgets.dart';

class PengaduanListScreen extends StatefulWidget {
  const PengaduanListScreen({Key? key}) : super(key: key);

  @override
  _PengaduanListScreenState createState() => _PengaduanListScreenState();
}

class _PengaduanListScreenState extends State<PengaduanListScreen> {
  List<String> _status = ['Semua', 'Belum Ditanggapi', 'Diproses', 'Selesai'];
  var _selectedStatus;
  String title = "Daftar Pengaduan";
  String role = "";
  bool _isLoading = true;

  _checkRole() {
    var uid = FirebaseAuth.instance.currentUser?.uid;

    FirebaseFirestore.instance.collection('users').doc(uid).get().then((value) {
      role = "" + value.get('role');
      if (role == "admin") {
        setState(() {
          title = "Daftar Pengaduan Diterima";
          _isLoading = false;
        });
      } else{
        setState(() {
          title = "Daftar Pengaduan Anda";
          _isLoading = false;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _checkRole();
  }

  @override
  Widget build(BuildContext context) {
    return (_isLoading)
        ? LoadingWidget()
        : Scaffold(
            appBar: AppBar(
              title: Text(
                title,
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
            body: Stack(
              children: [

                Container(
                  margin: EdgeInsets.only(top: 16, left: 16, right: 16),
                  width: MediaQuery.of(context).size.width,
                  child: DropdownButton(
                    hint: Text(
                      'Pilih Kategori',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // Not necessary for Option 1
                    value: _selectedStatus,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedStatus = newValue.toString();
                      });
                    },
                    items: _status.map((category) {
                      return DropdownMenuItem(
                        child: new Text(
                          category,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        value: category,
                      );
                    }).toList(),
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(left: 16, right: 16, top: 60),
                  child: StreamBuilder(
                    stream: (_selectedStatus == "Semua" || _selectedStatus == null)
                        ? FirebaseFirestore.instance
                            .collection('report')
                            .snapshots()
                        : (_selectedStatus == 'Belum Ditanggapi')
                            ? FirebaseFirestore.instance
                                .collection('report')
                                .where('status', isEqualTo: 'Belum Ditanggapi')
                                .snapshots()
                            : (_selectedStatus == "Diproses")
                                ? FirebaseFirestore.instance
                                    .collection('report')
                                    .where('status', isEqualTo: 'Diproses')
                                    .snapshots()
                                : FirebaseFirestore.instance
                                    .collection('report')
                                    .where('status', isEqualTo: 'Selesai')
                                    .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData) {
                        return (snapshot.data!.size > 0)
                            ? ListData(
                                document: snapshot.data!.docs,
                              )
                            : _emptyData();
                      } else {
                        return _emptyData();
                      }
                    },
                  ),
                ),
              ],
            ),
          );
  }
  Widget _emptyData() {
    return Container(
      child: Center(
        child: Text(
          'Tidak Ada Laporan\nTersedia',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
    );
  }
}
