import 'package:antrian_wiradadi/src/bloc/cara_bayar_bloc.dart';
import 'package:antrian_wiradadi/src/bloc/token_bloc.dart';
import 'package:antrian_wiradadi/src/common/source/size_config.dart';
import 'package:antrian_wiradadi/src/common/widget/error_cara_bayar_widget.dart';
import 'package:antrian_wiradadi/src/common/widget/skeleton_cara_bayar.dart';
import 'package:antrian_wiradadi/src/model/cara_bayar_model.dart';
import 'package:antrian_wiradadi/src/model/token_model.dart';
import 'package:antrian_wiradadi/src/repository/responseApi/api_response.dart';
import 'package:flutter/material.dart';

class CaraBayarWidget extends StatefulWidget {
  final Function caraBayarSelected;

  const CaraBayarWidget({
    Key key,
    this.caraBayarSelected,
  }) : super(key: key);

  @override
  _CaraBayarWidgetState createState() => _CaraBayarWidgetState();
}

class _CaraBayarWidgetState extends State<CaraBayarWidget> {
  TokenBloc _tokenBloc = TokenBloc();

  @override
  void initState() {
    super.initState();
    _tokenBloc.getToken();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 12.0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 8.0),
          child: Text(
            'Cara Bayar',
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
          ),
        ),
        StreamBuilder<ApiResponse<TokenResponseModel>>(
          stream: _tokenBloc.tokenStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              switch (snapshot.data.status) {
                case Status.LOADING:
                  return SkeletonCaraBayar();
                case Status.ERROR:
                  return ErrorCaraBayarWidget(
                    message: snapshot.data.message,
                  );
                case Status.COMPLETED:
                  return ListCaraBayar(
                    token: snapshot.data.data.response.token,
                    caraBayarSelected: (BuildContext contextSheet, String id,
                            String deskripsi) =>
                        widget.caraBayarSelected(contextSheet, id, deskripsi),
                  );
              }
            }
            return Container();
          },
        ),
      ],
    );
  }
}

class ListCaraBayar extends StatefulWidget {
  final String token;
  final Function caraBayarSelected;

  const ListCaraBayar({
    Key key,
    this.token,
    this.caraBayarSelected,
  }) : super(key: key);

  @override
  _ListCaraBayarState createState() => _ListCaraBayarState();
}

class _ListCaraBayarState extends State<ListCaraBayar> {
  CaraBayarBloc _caraBayarBloc = CaraBayarBloc();

  String selected;

  @override
  void initState() {
    super.initState();
    _caraBayarBloc.tokenSink.add(widget.token);
    _caraBayarBloc.getCaraBayar();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ApiResponse<CaraBayarModel>>(
      stream: _caraBayarBloc.caraBayarStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data.status) {
            case Status.LOADING:
              return SkeletonCaraBayar();
            case Status.ERROR:
              return ErrorCaraBayarWidget(
                message: snapshot.data.message,
              );
            case Status.COMPLETED:
              return ListView.separated(
                shrinkWrap: true,
                separatorBuilder: (context, int i) {
                  return Divider(
                    height: 0.0,
                  );
                },
                itemCount: snapshot.data.data.caraBayar.length,
                itemBuilder: (context, int i) {
                  var cara = snapshot.data.data.caraBayar[i];
                  return ListTile(
                    onTap: () {
                      setState(() {
                        selected = cara.id;
                      });
                      widget.caraBayarSelected(
                          context, cara.id, cara.deskripsi);
                    },
                    contentPadding: EdgeInsets.symmetric(horizontal: 32.0),
                    leading: Icon(Icons.credit_card),
                    title: Text('${cara.deskripsi}'),
                  );
                },
              );
          }
        }
        return Container();
      },
    );
  }
}
