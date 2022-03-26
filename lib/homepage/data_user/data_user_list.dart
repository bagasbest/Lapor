import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lapor/homepage/daftar_pengaduan/list_detail_screen.dart';
import 'package:lapor/homepage/data_user/data_user_detail.dart';

class DataUserList extends StatelessWidget {
  final List<DocumentSnapshot> document;

  DataUserList({required this.document});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: document.length,
      itemBuilder: (BuildContext context, int i) {
        String uid = document[i]['uid'].toString();
        String name = document[i]['name'].toString();
        String email = document[i]['email'].toString();
        String password = document[i]['name'].toString();
        String phone = document[i]['phone'].toString();

        return GestureDetector(
          onTap: () {
            Route route = MaterialPageRoute(
              builder: (context) => DataUserDetail(
                uid: uid,
                name: name,
                email: email,
                password: password,
                phone: phone,
              ),
            );
            Navigator.push(context, route);
          },
          child: Container(
            height: 120,
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
                  'Email: $email',
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
                  'Nomor Hp: $phone',
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
