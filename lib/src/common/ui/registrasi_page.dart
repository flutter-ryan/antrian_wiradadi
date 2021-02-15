import 'package:antrian_wiradadi/src/common/source/color_style.dart';
import 'package:antrian_wiradadi/src/common/widget/text_field_widget.dart';
import 'package:flutter/material.dart';

class Registrasipage extends StatefulWidget {
  @override
  _RegistrasipageState createState() => _RegistrasipageState();
}

class _RegistrasipageState extends State<Registrasipage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: AppBar(
        brightness: Brightness.light,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: Text(
          'Registrasi',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Container(
        margin: EdgeInsets.only(top: 15.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(52.0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 18.0,
              offset: Offset(-8.0, -3.0),
              spreadRadius: 4.0,
            )
          ],
        ),
        child: ListView(
          padding:
              EdgeInsets.only(left: 38.0, top: 32.0, right: 22.0, bottom: 22.0),
          children: [
            Text(
              'Registrasi Akun',
              style: TextStyle(fontSize: 19.0, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 4.0,
            ),
            Text(
              'Input sesuai dengan identitas yang Anda miliki',
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(
              height: 12.0,
            ),
            TextFieldWidget(
              hint: 'Input nomor ktp',
              label: 'Nomor KTP',
              icon: Icon(Icons.credit_card),
            ),
            TextFieldWidget(
              hint: 'Input alamat email',
              label: 'Email',
              icon: Icon(Icons.email),
            ),
            TextFieldWidget(
              hint: 'Input nama lengkap',
              label: 'Nama lengkap',
              icon: Icon(Icons.face),
            ),
            TextFieldWidget(
              hint: 'Input tempat lahir',
              label: 'Tempat lahir',
              icon: Icon(Icons.place),
            ),
            TextFieldWidget(
              hint: 'Input tanggal lahir',
              label: 'Tanggal lahir',
              icon: Icon(Icons.calendar_today),
            ),
            TextFieldWidget(
              hint: 'Input jenis kelamin',
              label: 'Jenis kelamin',
              icon: Icon(Icons.wc),
            ),
            TextFieldWidget(
              hint: 'Input password',
              label: 'Password',
              icon: Icon(Icons.lock),
            ),
            TextFieldWidget(
              hint: 'Input ulangi password',
              label: 'Ulangi password',
              icon: Icon(Icons.shuffle),
            ),
            SizedBox(
              height: 20.0,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: 150,
                height: 45.0,
                child: FlatButton(
                  onPressed: () {},
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  color: kSecondaryColor,
                  textColor: Colors.white,
                  child: Text('Registrasi'),
                ),
              ),
            ),
            SizedBox(
              height: 18.0,
            )
          ],
        ),
      ),
    );
  }
}
