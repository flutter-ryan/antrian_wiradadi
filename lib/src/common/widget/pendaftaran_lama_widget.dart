import 'package:antrian_wiradadi/src/common/source/color_style.dart';
import 'package:antrian_wiradadi/src/common/source/size_config.dart';
import 'package:antrian_wiradadi/src/common/widget/text_field_widget.dart';
import 'package:flutter/material.dart';

class PendaftaranLamaWidget extends StatefulWidget {
  final ScrollController scrollController;

  const PendaftaranLamaWidget({
    Key key,
    this.scrollController,
  }) : super(key: key);

  @override
  _PendaftaranLamaWidgetState createState() => _PendaftaranLamaWidgetState();
}

class _PendaftaranLamaWidgetState extends State<PendaftaranLamaWidget> {
  final TextEditingController _nomorRmCon = TextEditingController();
  final TextEditingController _tanggalLahirCon = TextEditingController();
  final TextEditingController _nomorPonselCon = TextEditingController();

  final FocusNode _focusNomorRm = FocusNode();
  final FocusNode _focusTanggalLahir = FocusNode();
  final FocusNode _focusNomorPonsel = FocusNode();

  @override
  void dispose() {
    _nomorRmCon?.dispose();
    _tanggalLahirCon?.dispose();
    _nomorPonselCon?.dispose();
    _focusNomorPonsel?.dispose();
    _focusNomorRm?.dispose();
    _focusTanggalLahir?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: ClampingScrollPhysics(),
      controller: widget.scrollController,
      padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 18.0),
      children: [
        TextFieldWidget(
          controller: _nomorRmCon,
          focus: _focusNomorRm,
          hint: 'Nomor RM',
          icon: Icon(Icons.contacts),
          inputAction: TextInputAction.next,
          keyboardType: TextInputType.text,
        ),
        TextFieldWidget(
          controller: _tanggalLahirCon,
          focus: _focusTanggalLahir,
          hint: 'Tanggal lahir',
          isCalendar: true,
          icon: Icon(Icons.calendar_today),
          inputAction: TextInputAction.next,
          keyboardType: TextInputType.text,
        ),
        TextFieldWidget(
          controller: _nomorPonselCon,
          focus: _focusNomorPonsel,
          hint: 'Nomor ponsel',
          icon: Icon(Icons.mobile_friendly),
          inputAction: TextInputAction.done,
          keyboardType: TextInputType.phone,
        ),
        SizedBox(
          height: 32.0,
        ),
        Container(
          width: SizeConfig.blockSizeHorizontal * 60,
          height: 45,
          child: FlatButton(
            onPressed: () {},
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22.0)),
            color: kPrimaryColor,
            child: Text('Daftar'),
          ),
        )
      ],
    );
  }
}
