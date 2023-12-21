import 'package:antrian_wiradadi/src/confg/db_helper_identitas.dart';
import 'package:antrian_wiradadi/src/confg/size_config.dart';
import 'package:antrian_wiradadi/src/confg/style.dart';
import 'package:antrian_wiradadi/src/pages/components/date_form_field.dart';
import 'package:antrian_wiradadi/src/pages/components/input_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FormPasienBaru extends StatefulWidget {
  const FormPasienBaru({super.key});

  @override
  State<FormPasienBaru> createState() => _FormPasienBaruState();
}

class _FormPasienBaruState extends State<FormPasienBaru> {
  final _formKey = GlobalKey<FormState>();
  final _nik = TextEditingController();
  final _nikFocus = FocusNode();
  final _nama = TextEditingController();
  final _tanggal = TextEditingController();
  final _kontak = TextEditingController();
  int _nikLength = 0;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      FocusScope.of(context).requestFocus(_nikFocus);
    });
  }

  bool validateAndSave() {
    var formData = _formKey.currentState;
    if (formData!.validate()) {
      return true;
    }
    return false;
  }

  Future<void> _simpan() async {
    if (validateAndSave()) {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      FocusScope.of(context).unfocus();
      var identitas = IdentitasPasienSql(
        jenisPasien: "2",
        nama: _nama.text,
        nik: _nik.text,
        tanggal: _tanggal.text,
        kontak: _kontak.text,
        status: 1,
      );
      Navigator.pop(context, identitas);
    }
  }

  @override
  void dispose() {
    _nik.dispose();
    _nama.dispose();
    _tanggal.dispose();
    _kontak.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      constraints: BoxConstraints(
        maxHeight: SizeConfig.blockSizeVertical * 90,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 22,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 22.0),
              child: Text(
                'Input Identitas Pasien Baru',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(
              height: 22,
            ),
            const Divider(
              height: 0,
            ),
            Flexible(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                    vertical: 22.0, horizontal: 22.0),
                shrinkWrap: true,
                children: [
                  InputFormField(
                    controller: _nik,
                    focusNode: _nikFocus,
                    label: 'NIK',
                    hint: 'Ketikkan nomor identitas',
                    counterText: '$_nikLength/16',
                    counterStyle: TextStyle(
                        color: _nikLength == 16 ? Colors.green : Colors.red,
                        fontWeight: FontWeight.w600),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    charLengthValidate: true,
                    charLength: 16,
                    onChanged: (val) {
                      _nikLength = val.length;
                      setState(() {});
                    },
                  ),
                  const SizedBox(
                    height: 25.0,
                  ),
                  InputFormField(
                    controller: _nama,
                    label: 'Nama',
                    hint: 'Ketikkan nama sesuai identitas',
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(
                    height: 25.0,
                  ),
                  DateFormField(
                    controller: _tanggal,
                    label: 'Tanggal lahir',
                    hint: 'Ketikkan tanggal lahir sesuai identitas',
                    icon: const Icon(Icons.calendar_month),
                  ),
                  const SizedBox(
                    height: 25.0,
                  ),
                  InputFormField(
                    controller: _kontak,
                    label: 'Nomor kontak',
                    hint: 'Contoh: 081222333445',
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.phone,
                    isPhone: true,
                  ),
                  const SizedBox(
                    height: 32.0,
                  ),
                  ElevatedButton(
                    onPressed: _simpan,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 45),
                      backgroundColor: kPrimaryColor,
                    ),
                    child: const Text('SIMPAN'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
