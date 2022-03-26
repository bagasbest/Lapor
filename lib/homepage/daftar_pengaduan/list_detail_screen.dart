import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lapor/auth/login_screen.dart';
import 'package:lapor/database/database_service.dart';
import 'package:lapor/homepage/daftar_pengaduan/maps_pengaduan.dart';
import 'package:lapor/widgets/loading_widgets.dart';

class PengaduanDetail extends StatefulWidget {
  final String uid;
  final String title;
  final String pengaduan;
  final String address;
  final latitude;
  final longitude;
  final String image;
  final String status;

  PengaduanDetail(
      {required this.uid,
      required this.title,
      required this.pengaduan,
      required this.address,
      this.latitude,
      this.longitude,
      required this.image,
      required this.status});

  @override
  _PengaduanDetailState createState() => _PengaduanDetailState();
}

class _PengaduanDetailState extends State<PengaduanDetail> {
  var _title = TextEditingController();
  var _address = TextEditingController();
  var _pengaduan = TextEditingController();
  var _latitude;
  var _longitude;

  final _formKey = GlobalKey<FormState>();
  bool isImageAdd = false;
  bool _visible = false;
  String role = "";
  String accButton = "";
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkRole();
    _title.text = widget.title;
    _pengaduan.text = widget.pengaduan;
    _address.text = widget.address;
    if (widget.status == 'Belum Ditanggapi') {
      accButton = 'Terima Laporan';
    } else if (widget.status == 'Diproses') {
      accButton = 'Selesai';
    }
  }

  _checkRole() {
    var uid = FirebaseAuth.instance.currentUser?.uid;

    FirebaseFirestore.instance.collection('users').doc(uid).get().then((value) {
      setState(() {
        role = "" + value.get('role');
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return (_isLoading)
        ? LoadingWidget()
        : Scaffold(
            appBar: AppBar(
              title: Text(
                'Detail Pengaduan',
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
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      'Status: ${widget.status}',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),

                    /// KOLOM JUDUL
                    Container(
                      margin:
                          const EdgeInsets.only(top: 10, left: 16, right: 16),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 1),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: TextFormField(
                        controller: _title,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: const InputDecoration(
                          hintText: 'Judul',
                          border: InputBorder.none,
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Judul tidak boleh kosong';
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),

                    /// KOLOM PENGADUAN
                    Container(
                      margin:
                          const EdgeInsets.only(top: 16, left: 16, right: 16),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 1),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: TextFormField(
                        controller: _pengaduan,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: const InputDecoration(
                          hintText: 'Pengaduan',
                          border: InputBorder.none,
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Deskripsi pengaduan tidak boleh kosong';
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),

                    /// KOLOM ALAMAT LENGKAP
                    Container(
                      margin:
                          const EdgeInsets.only(top: 16, left: 16, right: 16),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 1),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: TextFormField(
                        controller: _address,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: const InputDecoration(
                          hintText: 'Alamat Lengkap',
                          border: InputBorder.none,
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Alamat lengkap tidak boleh kosong';
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),

                    /// foto dan lokasi
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            height: 100,
                            margin: EdgeInsets.only(
                              top: 16,
                              left: 16,
                            ),
                            width: 120,
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.network(
                                widget.image,
                                fit: BoxFit.cover,
                                width: 100,
                                height: 100,
                              ),
                            )),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 16,
                            right: 16,
                          ),
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  Route route = MaterialPageRoute(
                                      builder: (context) => MapsPengaduan(
                                            latitude: widget.latitude,
                                            longitude: widget.longitude,
                                          ));
                                  Navigator.push(context, route);
                                },
                                child: Image.asset(
                                  "assets/location.png",
                                  width: 100,
                                  height: 70,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Titik Lokasi Pelapor',
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    /// LOADING INDIKATOR
                    Visibility(
                      visible: _visible,
                      child: const SpinKitRipple(
                        color: Color(0xfffbbb5b),
                      ),
                    ),

                    const SizedBox(
                      height: 50,
                    ),

                    (role == 'admin')
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              (widget.status == 'Belum Ditanggapi')
                                  ? Padding(
                                      padding: const EdgeInsets.only(
                                        left: 16,
                                        top: 16,
                                        bottom: 30,
                                      ),
                                      child: SizedBox(
                                        width: 150,
                                        height: 50,
                                        child: RaisedButton(
                                            color: const Color(0xfffbbb5b),
                                            child: const Text(
                                              'Tolak Laporan',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(29)),
                                            onPressed: () {
                                              _declineReport();
                                            }),
                                      ),
                                    )
                                  : Container(),
                              (widget.status != 'Selesai')
                                  ? Padding(
                                      padding: const EdgeInsets.only(
                                        left: 16,
                                        top: 16,
                                        right: 16,
                                        bottom: 30,
                                      ),
                                      child: SizedBox(
                                        width: 150,
                                        height: 50,
                                        child: RaisedButton(
                                          color: const Color(0xfffbbb5b),
                                          child: Text(
                                            accButton,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(29)),
                                          onPressed: () {
                                            if (widget.status ==
                                                'Belum Ditanggapi') {
                                              _accReport();
                                            } else if (widget.status ==
                                                'Diproses') {
                                              _finishReport();
                                            }
                                          },
                                        ),
                                      ),
                                    )
                                  : Container(),
                            ],
                          )
                        : Container(),
                  ],
                ),
              ),
            ),
          );
  }

  _declineReport() {
    // set up the buttons
    Widget noButton = TextButton(
      child: Text("TIDAK"),
      onPressed: () => Navigator.of(context).pop(),
    );
    Widget yesButton = TextButton(
      child: Text("YA"),
      onPressed: () async {
        await FirebaseFirestore.instance
            .collection('report')
            .doc(widget.uid)
            .delete()
            .then((value) {
          toast('Berhasil menolak laporan ini, laporan segera dihapus!');
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        });
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Konfirfmasi Menolak Laporan"),
      content: Text("Apakah anda yakin ingin menolak laporan ini ?"),
      actions: [
        noButton,
        yesButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  _accReport() {
    // set up the buttons
    Widget noButton = TextButton(
      child: Text("TIDAK"),
      onPressed: () => Navigator.of(context).pop(),
    );
    Widget yesButton = TextButton(
      child: Text("YA"),
      onPressed: () async {
        await DatabaseService.updateReport(widget.uid);
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Konfirfmasi Menerima Laporan"),
      content: Text("Apakah anda yakin ingin menerima laporan ini ?"),
      actions: [
        noButton,
        yesButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  _finishReport() {
    // set up the buttons
    Widget noButton = TextButton(
      child: Text("TIDAK"),
      onPressed: () => Navigator.of(context).pop(),
    );
    Widget yesButton = TextButton(
      child: Text("YA"),
      onPressed: () async {
        await DatabaseService.finishReport(widget.uid);
        Navigator.of(context).pop();
        Navigator.of(context).pop();

      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Konfirfmasi Menyelesaikan Laporan"),
      content: Text("Apakah anda yakin ingin menyelesaikan laporan ini ?"),
      actions: [
        noButton,
        yesButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
