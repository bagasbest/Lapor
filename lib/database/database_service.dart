import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lapor/auth/login_screen.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class DatabaseService {
  static Future<XFile?> getImageGallery() async {
    var image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (image != null) {
      return image;
    } else {
      return null;
    }
  }

  static uploadImageReport(XFile imageFile) async {
    String filename = basename(imageFile.path);

    FirebaseStorage storage = FirebaseStorage.instance;
    final Reference reference = storage.ref().child('product/$filename');
    await reference.putFile(File(imageFile.path));

    String downloadUrl = await reference.getDownloadURL();
    if (downloadUrl != null) {
      return downloadUrl;
    } else {
      return null;
    }
  }

  static void uploadReport(String title, String pengaduan, String address,
      latitude, longitude, String image, String name, String userId) {
    try {
      var timeInMillis = DateTime.now().millisecondsSinceEpoch;
      FirebaseFirestore.instance
          .collection('report')
          .doc(timeInMillis.toString())
          .set({
        'uid': timeInMillis.toString(),
        'title': title,
        'pengaduan': pengaduan,
        'address': address,
        'latitude': latitude,
        'longitude': longitude,
        'image': image,
        'status': 'Belum Ditanggapi',
        'name': name,
        'userId': userId,
      });
      toast('Berhasil menambahkan laporan baru');
    } catch (error) {
      toast(
          'Gagal menambahkan laporan baru, silahkan cek koneksi anda dan coba lagi nanti');
    }
  }

  static updateReport(String uid) {
    try {
      FirebaseFirestore.instance.collection('report').doc(uid).update({
        'status': 'Diproses',
      });
      toast('Berhasil menerima laporan, status laporan menjadi Diproses');
    } catch (error) {
      toast('Gagal menerima laporan, silahkan periksa koneksi internet anda');
    }
  }

  static finishReport(String uid) {
    try {
      FirebaseFirestore.instance.collection('report').doc(uid).update({
        'status': 'Selesai',
      });
      toast('Berhasil menyelesaikan laporan, status laporan menjadi Selesai');
    } catch (error) {
      toast(
          'Gagal menyelesaikan laporan, silahkan periksa koneksi internet anda');
    }
  }

  static updateProfile(String name, String phone, String uid) {
    try {
      FirebaseFirestore.instance.collection('users').doc(uid).update({
        'name': name,
        'phone': phone,
      });
      toast('Berhasil mengupdate data pengguna');
    } catch (error) {
      toast('Gagal mengupdate data pengguna');
    }
  }
}
