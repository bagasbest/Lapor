import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lapor/auth/login_screen.dart';
import 'package:lapor/database/database_service.dart';
import 'package:lapor/homepage/pengaduan/maps.dart';

class PengaduanScreen extends StatefulWidget {
  const PengaduanScreen({Key? key}) : super(key: key);

  @override
  _PengaduanScreenState createState() => _PengaduanScreenState();
}

class _PengaduanScreenState extends State<PengaduanScreen> {
  var _title = TextEditingController();
  var _address = TextEditingController();
  var _pengaduan = TextEditingController();
  var _latitude;
  var _longitude;
  String name = "";

  final _formKey = GlobalKey<FormState>();
  bool isImageAdd = false;
  XFile? _image;
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    getName();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pengaduan',
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
              /// KOLOM JUDUL
              Container(
                margin: const EdgeInsets.only(top: 10, left: 16, right: 16),
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 1),
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
                margin: const EdgeInsets.only(top: 16, left: 16, right: 16),
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 1),
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
                margin: const EdgeInsets.only(top: 16, left: 16, right: 16),
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 1),
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
                    child: Row(
                      children: [
                        (!isImageAdd)
                            ? GestureDetector(
                                onTap: () async {
                                  _image =
                                      await DatabaseService.getImageGallery();
                                  if (_image == null) {
                                    setState(() {
                                      toast("Gagal ambil foto");
                                    });
                                  } else {
                                    setState(() {
                                      isImageAdd = true;
                                      toast('Berhasil menambah foto');
                                    });
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: DottedBorder(
                                    color: Colors.grey,
                                    strokeWidth: 1,
                                    dashPattern: [6, 6],
                                    child: Container(
                                      child: Center(
                                        child: Text("* Tambah Foto"),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.file(
                                  File(
                                    _image!.path,
                                  ),
                                  fit: BoxFit.cover,
                                  width: 100,
                                  height: 100,
                                ),
                              )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 16,
                      right: 16,
                    ),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Maps()),
                            );

                            setState(() {
                              _latitude = result
                                  .toString()
                                  .substring(0, result.toString().indexOf('|'));
                              _longitude = result.toString().substring(
                                  result.toString().indexOf('|') + 1);
                            });
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
                          'Tentukan titik lokasi anda',
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

              /// TOMBOL LOGIN
              SizedBox(
                width: 200,
                height: 50,
                child: RaisedButton(
                    color: const Color(0xfffbbb5b),
                    child: const Text(
                      'Kirim',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(29)),
                    onPressed: () async {
                      /// CEK APAKAH KOLOM KOLOM SUDAH TERISI SEMUA
                      if (_formKey.currentState!.validate() &&
                          _image != null &&
                          _latitude != null &&
                          _longitude != null) {
                        setState(() {
                          _visible = true;
                        });

                        String? url = (_image != null)
                            ? await DatabaseService.uploadImageReport(_image!)
                            : null;

                        DatabaseService.uploadReport(
                          _title.text,
                          _pengaduan.text,
                          _address.text,
                          _latitude,
                          _longitude,
                          (url != null) ? url : '',
                          name,
                        );

                        setState(() {
                          _visible = false;
                          _title.text = "";
                          _pengaduan.text = "";
                          _address.text = "";
                          _latitude = null;
                          _longitude = null;
                          _image = null;
                          isImageAdd = false;
                          name = "";
                        });

                        setState(() {
                          _visible = false;
                        });
                      } else if (_image == null) {
                        toast(
                            'Mohon tambahkan gambar sebagai bukti laporan anda.');
                      } else if (_latitude == null || _longitude == null) {
                        toast(
                            'Mohon tentukan posisi anda saat ini melalui maps.');
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void getName() {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get()
        .then((value) {name = "" + value.get('name');});
  }
}
