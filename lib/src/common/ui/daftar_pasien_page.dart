import 'package:antrian_wiradadi/src/bloc/create_antrian_bloc.dart';
import 'package:antrian_wiradadi/src/common/source/color_style.dart';
import 'package:antrian_wiradadi/src/common/source/size_config.dart';
import 'package:antrian_wiradadi/src/common/widget/pendaftaran_baru_widget.dart';
import 'package:antrian_wiradadi/src/common/widget/pendaftaran_lama_widget.dart';
import 'package:antrian_wiradadi/src/model/jadwal_dokter_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart' as dp;
import 'package:intl/intl.dart';

class DaftarPasienPage extends StatefulWidget {
  final String label;
  final List<Jadwal> jadwal;
  final String idPoli;
  final String idDokter;
  final String namaPoli;
  final String namaDokter;
  final String jenisPendaftaran;

  const DaftarPasienPage({
    Key key,
    this.jadwal,
    this.label,
    this.idDokter,
    this.idPoli,
    this.namaDokter,
    this.namaPoli,
    this.jenisPendaftaran,
  }) : super(key: key);

  @override
  _DaftarPasienPageState createState() => _DaftarPasienPageState();
}

class _DaftarPasienPageState extends State<DaftarPasienPage> {
  CreateAntrianBloc _createAntrianBloc = CreateAntrianBloc();
  DateTime _selectedDate;
  DateTime _firstDate;
  DateTime _lastDate;
  DateFormat _format;

  static const double _min = 0.45;
  static const double _max = 0.86;

  double _initial = _min;
  bool _isExpand = false;
  BuildContext contextSheet;

  Color selectedDateStyleColor;
  Color selectedSingleDateDecorationColor;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now().subtract(Duration(days: 1));
    _firstDate = DateTime.now().subtract(Duration(days: 2));
    _lastDate = DateTime.now().add(Duration(days: 12));
    _format = DateFormat('yyyy-MM-dd');
    _createAntrianBloc.poli.add(widget.idPoli);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    selectedDateStyleColor = Theme.of(context).accentTextTheme.bodyText1.color;
    selectedSingleDateDecorationColor = Theme.of(context).accentColor;
  }

  void _onSelectedDateChanged(DateTime newDate) {
    setState(() {
      _selectedDate = newDate;
    });
    _createAntrianBloc.tanggalKunjungan.add(_format.format(newDate));
  }

  bool _isSelectableCustom(DateTime day) {
    DateFormat _format = DateFormat('EEEE', 'id');
    String selectedDay = _format.format(day);
    for (var _day in widget.jadwal) {
      if ((day.isAfter(DateTime.now().subtract(Duration(days: 1)))) &&
          (selectedDay == _day.deskHari)) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    dp.DatePickerStyles styles = dp.DatePickerRangeStyles(
      displayedPeriodTitle: TextStyle(fontWeight: FontWeight.bold),
      currentDateStyle: TextStyle(
        color: Colors.black,
      ),
      defaultDateTextStyle: TextStyle(
          color: Colors.indigo, fontWeight: FontWeight.w700, fontSize: 20.0),
      selectedDateStyle: Theme.of(context).accentTextTheme.bodyText1.copyWith(
          color: Colors.white, fontWeight: FontWeight.w700, fontSize: 18.0),
      selectedSingleDateDecoration: BoxDecoration(
          color: Colors.indigo,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(15.0)),
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
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 8.0,
              ),
              ListTile(
                isThreeLine: true,
                leading: Container(
                  width: 52.0,
                  height: 52.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: AssetImage('assets/images/avatar_doc.jpg'),
                        fit: BoxFit.cover),
                  ),
                ),
                title: Text('${widget.namaDokter}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${widget.namaPoli}'),
                    SizedBox(
                      height: 8.0,
                    ),
                    Row(
                      children: widget.jadwal
                          .map((jadwal) => Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12.0, vertical: 4.0),
                                child: Text(
                                  '${jadwal.deskHari}',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.w600),
                                ),
                                decoration: BoxDecoration(
                                  color: kSecondaryColor,
                                  borderRadius: BorderRadius.circular(18.0),
                                ),
                              ))
                          .toList(),
                    )
                  ],
                ),
              ),
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
                  '*) Jadwal dokter yang ditampilkan 2 minggu kedepan\nTanggal yang aktif adalah tanggal jadwal dokter yang tersedia',
                  style: TextStyle(color: Colors.grey, fontSize: 12.0),
                ),
              ),
            ],
          ),
          DraggableScrollableActuator(
            child: DraggableScrollableSheet(
                initialChildSize: _initial,
                minChildSize: _min,
                maxChildSize: _max,
                builder: (BuildContext contextSheet, scrollController) {
                  this.contextSheet = contextSheet;
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25.0),
                        topRight: Radius.circular(25.0),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 18.0,
                          offset: Offset(3.0, -1.0),
                        ),
                      ],
                    ),
                    child: widget.jenisPendaftaran == '1'
                        ? PendaftaranLamaWidget(
                            scrollController: scrollController,
                          )
                        : PendaftaranBaruWidget(
                            scrollController: scrollController,
                            idPoli: widget.idPoli,
                            bloc: _createAntrianBloc,
                          ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
