import 'package:antrian_wiradadi/src/common/source/color_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart' as dp;
import 'package:intl/intl.dart';

class DialogDatePicker extends StatefulWidget {
  final String weekday;

  const DialogDatePicker({
    Key key,
    this.weekday,
  }) : super(key: key);

  @override
  _DialogDatePickerState createState() => _DialogDatePickerState();
}

class _DialogDatePickerState extends State<DialogDatePicker> {
  DateTime _selectedDate;
  DateTime _firstDate;
  DateTime _lastDate;
  DateFormat _format;
  bool _errorPick = false;

  Color selectedDateStyleColor;
  Color selectedSingleDateDecorationColor;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _firstDate = DateTime.now().subtract(Duration(days: 1));
    _lastDate = DateTime.now().add(Duration(days: 12));
    _format = DateFormat('yyyy-MM-dd');
  }

  void _onSelectedDateChanged(DateTime newDate) {
    setState(() {
      _errorPick = false;
      _selectedDate = newDate;
    });
  }

  bool _dateActiveDesire(DateTime day, String weekday) {
    DateFormat _format = DateFormat('yyyy-MM-dd', 'id');
    String selectedDay = _format.format(day);
    String now = _format.format(DateTime.now());
    if ((day.weekday == int.parse(weekday) + 1 &&
            day.isAfter(DateTime.now())) ||
        selectedDay == now) {
      return true;
    }
    return false;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    selectedDateStyleColor = Theme.of(context).accentTextTheme.bodyText1.color;
    selectedSingleDateDecorationColor = Theme.of(context).accentColor;
  }

  @override
  Widget build(BuildContext context) {
    dp.DatePickerStyles styles = dp.DatePickerRangeStyles(
      dayHeaderStyle: dp.DayHeaderStyle(
          textStyle: TextStyle(fontSize: 32.0, fontWeight: FontWeight.w600)),
      currentDateStyle: TextStyle(
          color: Colors.blue, fontWeight: FontWeight.w700, fontSize: 18.0),
      defaultDateTextStyle: TextStyle(
          color: Colors.blueGrey, fontWeight: FontWeight.w700, fontSize: 18.0),
      selectedDateStyle: Theme.of(context).accentTextTheme.bodyText1.copyWith(
          color: Colors.white, fontWeight: FontWeight.w700, fontSize: 18.0),
      selectedSingleDateDecoration: BoxDecoration(
        color: Colors.blueGrey,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(15.0),
      ),
    );
    return Dialog(
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 18.0),
      child: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(
                top: Consts.avatarRadius + Consts.padding,
                bottom: 18.0,
                left: 18.0,
                right: 18.0,
              ),
              margin: EdgeInsets.only(top: Consts.avatarRadius),
              decoration: new BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(22.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10.0,
                    offset: const Offset(0.0, 10.0),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Pilih tanggal antrian',
                    style:
                        TextStyle(fontWeight: FontWeight.w600, fontSize: 18.0),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      'Pilih tanggal sesuai jadwal dokter yang Anda pilih',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15.0),
                    ),
                  ),
                  SizedBox(
                    height: 22.0,
                  ),
                  _errorPick
                      ? Container(
                          margin: EdgeInsets.only(
                            bottom: 10.0,
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 18.0, vertical: 12.0),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Center(
                            child: Text(
                              'Tanggal yang dipilih tidak sesuai dengan jadwal',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        )
                      : SizedBox(),
                  Container(
                    width: double.infinity,
                    child: Center(
                      child: dp.DayPicker.single(
                        selectedDate: _selectedDate,
                        onChanged: _onSelectedDateChanged,
                        firstDate: _firstDate,
                        lastDate: _lastDate,
                        selectableDayPredicate: (DateTime day) =>
                            _dateActiveDesire(day, widget.weekday),
                        datePickerStyles: styles,
                        datePickerLayoutSettings: dp.DatePickerLayoutSettings(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 0.0,
                            vertical: 0.0,
                          ),
                          scrollPhysics: NeverScrollableScrollPhysics(),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 22.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                            textStyle: TextStyle(
                          color: Colors.blueGrey,
                        )),
                        child: Text('Tutup'),
                      ),
                      TextButton(
                        onPressed: () {
                          if ((_selectedDate.weekday ==
                              int.parse(widget.weekday) + 1)) {
                            Navigator.pop(
                              context,
                              _format.format(_selectedDate),
                            );
                          } else {
                            setState(() {
                              _errorPick = true;
                            });
                            Future.delayed(Duration(milliseconds: 3000), () {
                              setState(() {
                                _errorPick = false;
                              });
                            });
                          }
                        },
                        style: TextButton.styleFrom(
                            textStyle: TextStyle(
                          color: Colors.blueGrey,
                        )),
                        child: Text('Pilih'),
                      )
                    ],
                  )
                ],
              ),
            ),
            Positioned(
              top: Consts.avatarRadius + Consts.padding - 18,
              right: 1.0,
              child: Container(
                child: IconButton(
                  icon: Icon(Icons.close, color: Colors.grey[500]),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
            Positioned(
              left: Consts.padding,
              right: Consts.padding,
              child: CircleAvatar(
                backgroundColor: kSecondaryColor,
                radius: Consts.avatarRadius,
                child: Icon(
                  Icons.calendar_today,
                  size: 42.0,
                  color: kPrimaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Consts {
  Consts._();

  static const double padding = 16.0;
  static const double avatarRadius = 42.0;
}
