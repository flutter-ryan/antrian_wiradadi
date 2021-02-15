import 'package:antrian_wiradadi/src/common/source/color_style.dart';
import 'package:antrian_wiradadi/src/common/source/size_config.dart';
import 'package:antrian_wiradadi/src/common/widget/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart' as dp;
import 'package:intl/intl.dart';

class DaftarPasienPage extends StatefulWidget {
  final String label;
  final String hari;

  const DaftarPasienPage({
    Key key,
    this.hari,
    this.label,
  }) : super(key: key);

  @override
  _DaftarPasienPageState createState() => _DaftarPasienPageState();
}

class _DaftarPasienPageState extends State<DaftarPasienPage> {
  String _daySelected;
  DateTime _selectedDate;
  DateTime _firstDate;
  DateTime _lastDate;

  final FocusNode _focusNomorRm = FocusNode();
  final FocusNode _focusNama = FocusNode();
  final FocusNode _focusTanggalLahir = FocusNode();
  final FocusNode _focusNomorPonsel = FocusNode();

  Color selectedDateStyleColor;
  Color selectedSingleDateDecorationColor;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now().subtract(Duration(days: 1));
    _firstDate = DateTime.now().subtract(Duration(days: 2));
    _lastDate = DateTime.now().add(Duration(days: 12));
    _daySelected = widget.hari;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // defaults for styles
    selectedDateStyleColor = Theme.of(context).accentTextTheme.bodyText1.color;
    selectedSingleDateDecorationColor = Theme.of(context).accentColor;
  }

  void _onSelectedDateChanged(DateTime newDate) {
    setState(() {
      _selectedDate = newDate;
    });
  }

  bool _isSelectableCustom(DateTime day) {
    DateFormat _format = DateFormat('EEEE', 'id');
    String selectedDay = _format.format(day);
    if ((day.isAfter(DateTime.now().subtract(Duration(days: 1)))) &&
        (selectedDay == _daySelected)) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    dp.DatePickerStyles styles = dp.DatePickerRangeStyles(
      displayedPeriodTitle: TextStyle(fontWeight: FontWeight.bold),
      currentDateStyle: TextStyle(color: Colors.black),
      selectedDateStyle: Theme.of(context)
          .accentTextTheme
          .bodyText1
          .copyWith(color: selectedDateStyleColor),
      selectedSingleDateDecoration: BoxDecoration(
          color: selectedSingleDateDecorationColor, shape: BoxShape.circle),
    );
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        elevation: 0.0,
        backgroundColor: kPrimaryColor,
        brightness: Brightness.light,
        centerTitle: true,
        title: Text(
          '${widget.label}',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.only(top: 18.0),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        children: [
          Container(
            width: SizeConfig.screenWidth,
            height: SizeConfig.blockSizeVertical * 30,
            padding: EdgeInsets.only(top: 4.0),
            child: dp.DayPicker.single(
              selectedDate: _selectedDate,
              onChanged: _onSelectedDateChanged,
              firstDate: _firstDate,
              lastDate: _lastDate,
              datePickerStyles: styles,
              selectableDayPredicate: _isSelectableCustom,
              datePickerLayoutSettings: dp.DatePickerLayoutSettings(
                scrollPhysics: ClampingScrollPhysics(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 18.0),
            child: Text(
              '*) Pilih tanggal sesuai jadwal dokter yang telah dipilih',
              style: TextStyle(color: Colors.grey, fontSize: 11.0),
            ),
          ),
          SizedBox(
            height: 18.0,
          ),
          Container(
            height: SizeConfig.blockSizeVertical * 55,
            padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 18.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(22.0),
                topRight: Radius.circular(22.0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[300],
                  blurRadius: 8.0,
                  offset: Offset(1.0, -2.0),
                ),
              ],
            ),
            child: Column(
              children: [
                TextFieldWidget(
                  focus: _focusNomorRm,
                  hint: 'Nomor RM',
                  icon: Icon(Icons.contacts),
                  inputAction: TextInputAction.next,
                ),
                TextFieldWidget(
                  focus: _focusNama,
                  hint: 'Nama pasien',
                  icon: Icon(Icons.assignment_ind),
                  inputAction: TextInputAction.next,
                ),
                TextFieldWidget(
                  focus: _focusTanggalLahir,
                  hint: 'Tanggal lahir',
                  icon: Icon(Icons.calendar_today),
                  inputAction: TextInputAction.next,
                ),
                TextFieldWidget(
                  focus: _focusNomorPonsel,
                  hint: 'Nomor ponsel',
                  icon: Icon(Icons.mobile_friendly),
                  inputAction: TextInputAction.done,
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
            ),
          ),
        ],
      ),
    );
  }
}
