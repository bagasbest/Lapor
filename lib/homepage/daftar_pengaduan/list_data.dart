import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lapor/homepage/daftar_pengaduan/list_detail_screen.dart';

class ListData extends StatelessWidget {
  final List<DocumentSnapshot> document;

  ListData({required this.document});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: document.length,
      itemBuilder: (BuildContext context, int i) {
        String uid = document[i]['uid'].toString();
        String title = document[i]['title'].toString();
        String pengaduan = document[i]['pengaduan'].toString();
        String address = document[i]['address'].toString();
        var latitude = document[i]['latitude'];
        var longitude = document[i]['longitude'];
        String image = document[i]['image'].toString();
        String status = document[i]['status'];
        String name = document[i]['name'].toString();

        return GestureDetector(
          onTap: () {
            Route route = MaterialPageRoute(
              builder: (context) => PengaduanDetail(
                uid: uid,
                title: title,
                pengaduan: pengaduan,
                address: address,
                latitude: latitude,
                longitude: longitude,
                image: image,
                status: status,
              ),
            );
            Navigator.push(context, route);
          },
          child: Container(
            height: 150,
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Color(0xfffbbb5b),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nama: $name',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Judul: $title',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  'Pengaduan: $pengaduan',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                  maxLines: 3,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
