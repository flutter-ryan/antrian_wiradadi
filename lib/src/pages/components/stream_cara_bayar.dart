import 'package:antrian_wiradadi/src/blocs/cara_bayar_bloc.dart';
import 'package:antrian_wiradadi/src/blocs/token_bloc.dart';
import 'package:antrian_wiradadi/src/confg/size_config.dart';
import 'package:antrian_wiradadi/src/confg/style.dart';
import 'package:antrian_wiradadi/src/models/cara_bayar_model.dart';
import 'package:antrian_wiradadi/src/models/token_model.dart';
import 'package:antrian_wiradadi/src/pages/components/loading_widget.dart';
import 'package:antrian_wiradadi/src/pages/components/response_modal_bottom.dart';
import 'package:antrian_wiradadi/src/pages/components/search_widget.dart';
import 'package:antrian_wiradadi/src/repositories/responseApi/api_response.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class StreamCaraBayar extends StatefulWidget {
  const StreamCaraBayar({
    super.key,
    this.setCaraBayar,
  });

  final Function(CaraBayar data)? setCaraBayar;

  @override
  State<StreamCaraBayar> createState() => _StreamCaraBayarState();
}

class _StreamCaraBayarState extends State<StreamCaraBayar> {
  final _tokenBloc = TokenBloc();
  CaraBayar? _data;

  void _pilihCaraBayar() {
    _tokenBloc.getToken();
    showMaterialModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            constraints: BoxConstraints(
              maxHeight: SizeConfig.blockSizeVertical * 70,
            ),
            child: _streamCaraBayar(context),
          ),
        );
      },
      duration: const Duration(milliseconds: 600),
    ).then((value) {
      if (value != null) {
        var data = value as CaraBayar;
        widget.setCaraBayar!(data);
        setState(() {
          _data = data;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _tokenBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 22.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Cara Bayar',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                InkWell(
                  onTap: _pilihCaraBayar,
                  child: Text(
                    'Pilih cara bayar',
                    style: TextStyle(color: kPrimaryColor.withAlpha(150)),
                  ),
                )
              ],
            ),
          ),
          const Divider(
            height: 12.0,
          ),
          if (_data != null)
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 22.0),
              minVerticalPadding: 20.0,
              minLeadingWidth: 18.0,
              leading: Container(
                width: 52,
                height: 52,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: kPrimaryColor.withAlpha(100),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Image.asset('images/debit_card.png'),
              ),
              title: Text('${_data!.deskripsi}'),
            )
          else
            const Padding(
              padding: EdgeInsets.all(22.0),
              child: Center(
                child: Text(
                  'Anda belum memilih cara bayar',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _streamCaraBayar(BuildContext context) {
    return StreamBuilder<ApiResponse<TokenResponseModel>>(
      stream: _tokenBloc.tokenStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return LoadingWidget(
                height: SizeConfig.blockSizeVertical * 35,
              );
            case Status.error:
              return ResponseModalBottom(
                title: 'Perhatian',
                message: snapshot.data!.message,
              );

            case Status.completed:
              var data = snapshot.data!.data!;
              if (data.metadata!.code != 200) {
                return ResponseModalBottom(
                  title: 'Perhatian',
                  message: snapshot.data!.data!.metadata!.message,
                );
              }
              return ResponseStreamCaraBayar(
                token: data.response!.token!,
                selected: _data?.id,
              );
          }
        }
        return SizedBox(
          height: SizeConfig.blockSizeVertical * 35,
        );
      },
    );
  }
}

class ResponseStreamCaraBayar extends StatefulWidget {
  const ResponseStreamCaraBayar({
    super.key,
    required this.token,
    this.selected,
  });

  final String token;
  final String? selected;

  @override
  State<ResponseStreamCaraBayar> createState() =>
      _ResponseStreamCaraBayarState();
}

class _ResponseStreamCaraBayarState extends State<ResponseStreamCaraBayar> {
  final _caraBayarBloc = CaraBayarBloc();

  @override
  void initState() {
    super.initState();
    _loadCaraBayar();
  }

  void _loadCaraBayar() {
    _caraBayarBloc.tokenSink.add(widget.token);
    _caraBayarBloc.getCaraBayar();
  }

  @override
  void dispose() {
    _caraBayarBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ApiResponse<CaraBayarModel>>(
      stream: _caraBayarBloc.caraBayarStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return LoadingWidget(
                height: SizeConfig.blockSizeVertical * 35,
              );
            case Status.error:
              return ResponseModalBottom(
                title: 'Perhatian',
                message: snapshot.data!.message,
              );
            case Status.completed:
              if (!snapshot.data!.data!.success!) {
                return ResponseModalBottom(
                  title: 'Perhatian',
                  message: snapshot.data!.message,
                );
              }
              var data = snapshot.data!.data!.caraBayar;
              return Container(
                constraints: BoxConstraints(
                  minHeight: SizeConfig.blockSizeVertical * 10,
                  maxHeight: SizeConfig.blockSizeVertical * 80,
                ),
                child: ListCaraBayar(selected: widget.selected, data: data!),
              );
          }
        }
        return SizedBox(
          height: SizeConfig.blockSizeVertical * 35,
        );
      },
    );
  }
}

class ListCaraBayar extends StatefulWidget {
  const ListCaraBayar({
    super.key,
    this.selected,
    required this.data,
  });

  final String? selected;
  final List<CaraBayar> data;

  @override
  State<ListCaraBayar> createState() => _ListCaraBayarState();
}

class _ListCaraBayarState extends State<ListCaraBayar> {
  final _sc = ScrollController();
  final _filter = TextEditingController();
  String? _selectedId;
  List<CaraBayar> _data = [];

  @override
  void initState() {
    super.initState();
    _selectedId = widget.selected;
    _data = widget.data;
    _filter.addListener(_filterListen);
  }

  void _filterListen() {
    if (_filter.text.isEmpty) {
      _data = widget.data;
    } else {
      _data = widget.data
          .where((e) =>
              e.deskripsi!.toLowerCase().contains(_filter.text.toLowerCase()))
          .toList();
    }
    setState(() {});
  }

  void _selected(CaraBayar cara) {
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      _selectedId = cara.id;
    });
    Future.delayed(const Duration(milliseconds: 300), () {
      Navigator.pop(context, cara);
    });
  }

  @override
  void dispose() {
    _filter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 22.0, vertical: 18.0),
          child: Text(
            'Daftar Cara Bayar',
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
          ),
        ),
        const Divider(
          height: 0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: SearchWidget(
            filter: _filter,
            hint: 'Pencarian cara bayar',
          ),
        ),
        if (_data.isEmpty)
          SizedBox(
            width: double.infinity,
            height: SizeConfig.blockSizeVertical * 30,
            child: Column(
              children: [
                Image.asset(
                  'images/sorry.png',
                  height: SizeConfig.blockSizeVertical * 20,
                ),
                const SizedBox(
                  height: 22.0,
                ),
                const Text(
                  "Data tidak tersedia",
                  style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey,
                      fontStyle: FontStyle.italic),
                )
              ],
            ),
          )
        else
          Flexible(
            child: ListView.separated(
              controller: _sc,
              shrinkWrap: true,
              padding: const EdgeInsets.only(bottom: 22.0),
              itemBuilder: (context, i) {
                var cara = _data[i];
                return ListTile(
                  onTap: () => _selected(cara),
                  selected: _selectedId == cara.id ? true : false,
                  selectedColor: Colors.black,
                  selectedTileColor: kPrimaryColor.withAlpha(50),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 22.0,
                    vertical: 12.0,
                  ),
                  minVerticalPadding: 20.0,
                  minLeadingWidth: 18.0,
                  leading: Container(
                    width: 52.0,
                    height: 52.0,
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: kPrimaryColor.withAlpha(100),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Image.asset('images/debit_card.png'),
                  ),
                  title: Text('${cara.deskripsi}'),
                );
              },
              separatorBuilder: (context, i) => const Divider(
                height: 0,
              ),
              itemCount: _data.length,
            ),
          )
      ],
    );
  }
}
