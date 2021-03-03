import 'package:antrian_wiradadi/src/common/source/size_config.dart';
import 'package:antrian_wiradadi/src/common/widget/jadwal_widget.dart';
import 'package:antrian_wiradadi/src/model/poliklinik_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:search_page/search_page.dart';

class PoliWidget extends StatefulWidget {
  final String token;
  final List<Poliklinik> poli;
  final GlobalKey poliKey;

  const PoliWidget({
    Key key,
    this.poli,
    this.token,
    this.poliKey,
  }) : super(key: key);

  @override
  _PoliWidgetState createState() => _PoliWidgetState();
}

class _PoliWidgetState extends State<PoliWidget>
    with SingleTickerProviderStateMixin {
  TabController _controller;
  int _indexTab = 0;

  TextEditingController _filterCon = TextEditingController();

  static const double _min = 0.43;
  static const double _max = 0.78;
  double _initial = _min;
  String filter;

  @override
  void initState() {
    super.initState();
    _controller = TabController(
        length: widget.poli.length, vsync: this, initialIndex: _indexTab);
    _controller.addListener(_tabListener);
    _filterCon.addListener(() {
      setState(() {
        filter = _filterCon.text;
      });
    });
  }

  void _tabListener() {
    setState(() {
      _indexTab = _controller.index;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: SizeConfig.screenWidth,
          height: 215,
          margin: EdgeInsets.only(
            top: SizeConfig.blockSizeVertical * 27,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 22.0),
                child: TextField(
                  controller: _filterCon,
                  cursorColor: Colors.grey[300],
                  decoration: InputDecoration(
                    hintText: 'Pencarian Poliklinik',
                    hintStyle: TextStyle(color: Colors.grey[300]),
                    suffixIcon: Icon(
                      Icons.search,
                      color: Colors.grey[300],
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(22.0),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 18.0),
                  ),
                ),
              ),
              SizedBox(
                height: 12.0,
              ),
              Expanded(
                child: TabBar(
                  key: widget.poliKey,
                  controller: _controller,
                  isScrollable: widget.poli.length < 4 ? false : true,
                  unselectedLabelColor: Colors.red,
                  indicatorSize: TabBarIndicatorSize.label,
                  labelPadding: EdgeInsets.symmetric(horizontal: 10.0),
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(18.0),
                    color: Colors.redAccent,
                  ),
                  tabs: widget.poli.map((poli) {
                    if (filter == null || filter == "") {
                      return _buildPoliList(context, poli);
                    } else {
                      if (poli.deskripsi
                          .toLowerCase()
                          .contains(filter.toLowerCase())) {
                        return _buildPoliList(context, poli);
                      } else {
                        return Container();
                      }
                    }
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
        DraggableScrollableSheet(
          initialChildSize: _initial,
          maxChildSize: _max,
          minChildSize: _min,
          builder: (context, scrollController) {
            return Container(
              child: TabBarView(
                controller: _controller,
                physics: NeverScrollableScrollPhysics(),
                children: widget.poli
                    .map(
                      (poli) => JadwalWidget(
                        token: widget.token,
                        idPoli: poli.id,
                        controller: scrollController,
                        namaPoli: poli.deskripsi,
                      ),
                    )
                    .toList(),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildPoliList(BuildContext context, Poliklinik poli) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        width: 120,
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
        decoration: BoxDecoration(
          color: _indexTab == widget.poli.indexOf(poli)
              ? Colors.transparent
              : Colors.white,
          borderRadius: BorderRadius.circular(18.0),
          border: Border.all(width: 0.5, color: Colors.redAccent),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(
                    color: Colors.redAccent,
                  )),
              child: Center(
                child: Icon(
                  Icons.paste,
                  color: Colors.red,
                ),
              ),
            ),
            Text(
              '${poli.deskripsi}',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
