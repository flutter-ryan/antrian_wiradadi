import 'dart:io';

import 'package:antrian_wiradadi/src/blocs/tempat_tidur_bloc.dart';
import 'package:antrian_wiradadi/src/blocs/token_bloc.dart';
import 'package:antrian_wiradadi/src/confg/size_config.dart';
import 'package:antrian_wiradadi/src/confg/style.dart';
import 'package:antrian_wiradadi/src/models/tempat_tidur_model.dart';
import 'package:antrian_wiradadi/src/models/token_model.dart';
import 'package:antrian_wiradadi/src/pages/components/error_resp_widget.dart';
import 'package:antrian_wiradadi/src/pages/components/loading_widget.dart';
import 'package:antrian_wiradadi/src/repositories/responseApi/api_response.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class TempatTidurPage extends StatefulWidget {
  const TempatTidurPage({super.key});

  @override
  State<TempatTidurPage> createState() => _TempatTidurPageState();
}

class _TempatTidurPageState extends State<TempatTidurPage> {
  final _tokenBloc = TokenBloc();

  @override
  void initState() {
    super.initState();
    _tokenBloc.getToken();
  }

  @override
  void dispose() {
    _tokenBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: SizeConfig.blockSizeVertical * 30,
            color: kPrimaryColor,
          ),
          Column(
            children: [
              SizedBox(height: MediaQuery.of(context).padding.top + 8),
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    color: kTextGreetingsColor,
                    icon: Platform.isAndroid
                        ? const Icon(Icons.arrow_back)
                        : const Icon(Icons.arrow_back_ios),
                  ),
                  const SizedBox(
                    width: 22.0,
                  ),
                  const Expanded(
                    child: Text(
                      'Informasi Tempat Tidur',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600,
                        color: kTextGreetingsColor,
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: _buildStreamTempatTidur(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStreamTempatTidur(BuildContext context) {
    return StreamBuilder<ApiResponse<TokenResponseModel>>(
      stream: _tokenBloc.tokenStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return Center(
                child: LoadingWidget(height: SizeConfig.blockSizeVertical * 35),
              );
            case Status.error:
              return Center(
                child: ErrorRespWidget(
                  message: snapshot.data!.message,
                  reload: () {
                    _tokenBloc.getToken();
                    setState(() {});
                  },
                ),
              );
            case Status.completed:
              if (snapshot.data!.data!.metadata!.code != 200) {
                return Center(
                  child: ErrorRespWidget(
                    message: snapshot.data!.data!.metadata!.message,
                    reload: () {
                      _tokenBloc.getToken();
                      setState(() {});
                    },
                  ),
                );
              }
              return ListTempatTidur(
                token: snapshot.data!.data!.response!.token!,
              );
          }
        }
        return const SizedBox();
      },
    );
  }
}

class ListTempatTidur extends StatefulWidget {
  const ListTempatTidur({
    super.key,
    required this.token,
  });

  final String token;

  @override
  State<ListTempatTidur> createState() => _ListTempatTidurState();
}

class _ListTempatTidurState extends State<ListTempatTidur> {
  final _tempatTidurBloc = TempatTidurBloc();

  @override
  void initState() {
    super.initState();
    _tempatTidurBloc.tokenSink.add(widget.token);
    _tempatTidurBloc.getTempatTidur();
  }

  @override
  void dispose() {
    _tempatTidurBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ApiResponse<TempatTidurModel>>(
      stream: _tempatTidurBloc.tempatTidurStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return Center(
                child: LoadingWidget(height: SizeConfig.blockSizeVertical * 35),
              );
            case Status.error:
              return Center(
                child: ErrorRespWidget(
                  message: snapshot.data!.message,
                  reload: () {
                    _tempatTidurBloc.getTempatTidur();
                    setState(() {});
                  },
                ),
              );
            case Status.completed:
              if (snapshot.data!.data!.metadata!.code != 200) {
                return Center(
                  child: ErrorRespWidget(
                    message: snapshot.data!.data!.metadata!.message,
                    reload: () {
                      _tempatTidurBloc.getTempatTidur();
                      setState(() {});
                    },
                  ),
                );
              }
              var data = snapshot.data!.data!.tempatTidur;
              return _listTempatTidur(context, data);
          }
        }
        return const SizedBox();
      },
    );
  }

  Widget _listTempatTidur(BuildContext context, List<TempatTidur>? data) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(22.0, 32, 22.0, 32.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 17,
        childAspectRatio: 3 / 4,
      ),
      itemCount: data!.length,
      itemBuilder: (context, i) {
        var tempat = data[i];
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4.0,
                offset: Offset(2.0, 2.0),
              )
            ],
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(
                    Icons.hotel,
                    size: 22.0,
                  ),
                  Flexible(
                    child: Text(
                      '${tempat.kamar}',
                      style: const TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.end,
                    ),
                  )
                ],
              ),
              Expanded(
                child: Center(
                  child: CircularPercentIndicator(
                    radius: 55.0,
                    animation: true,
                    animationDuration: 1200,
                    lineWidth: 12.0,
                    percent: (double.parse(tempat.terisi!) /
                        double.parse(tempat.total!)),
                    center: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Kosong'),
                        Text(
                          "${tempat.kosong}",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                              color: Colors.green),
                        ),
                      ],
                    ),
                    circularStrokeCap: CircularStrokeCap.butt,
                    backgroundColor: Colors.green,
                    progressColor: Colors.red,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      const Text(
                        'Terisi',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      Text(
                        '${tempat.terisi}',
                        style: const TextStyle(
                            color: Colors.red, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const Text(
                        'Total',
                        style: TextStyle(color: Colors.grey, fontSize: 12.0),
                      ),
                      Text(
                        '${tempat.total}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
