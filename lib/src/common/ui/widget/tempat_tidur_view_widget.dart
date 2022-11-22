import 'package:antrian_wiradadi/src/bloc/tempat_tidur_bloc.dart';
import 'package:antrian_wiradadi/src/bloc/token_bloc.dart';
import 'package:antrian_wiradadi/src/common/source/size_config.dart';
import 'package:antrian_wiradadi/src/common/source/universal_config.dart';
import 'package:antrian_wiradadi/src/common/ui/widget/stream_response.dart';
import 'package:antrian_wiradadi/src/models/tempat_tidur_model.dart';
import 'package:antrian_wiradadi/src/models/token_model.dart';
import 'package:antrian_wiradadi/src/repositories/responseApi/api_response.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class TempatTidurViewWidget extends StatefulWidget {
  const TempatTidurViewWidget({Key? key}) : super(key: key);

  @override
  _TempatTidurViewWidgetState createState() => _TempatTidurViewWidgetState();
}

class _TempatTidurViewWidgetState extends State<TempatTidurViewWidget> {
  final TokenBloc _tokenBloc = TokenBloc();

  @override
  void initState() {
    super.initState();
    _tokenBloc.getToken();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SizedBox(
      width: SizeConfig.screenWidth,
      child: Column(
        children: [
          SizedBox(
            height: SizeConfig.blockSizeVertical * 12,
          ),
          Expanded(
            child: _buildTokenStream(context),
          )
        ],
      ),
    );
  }

  Widget _buildTokenStream(BuildContext context) {
    return StreamBuilder<ApiResponse<TokenResponseModel>>(
      stream: _tokenBloc.tokenStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return Center(
                child: StreamResponse(
                  image: 'images/loading_transparent.gif',
                  message: snapshot.data!.message,
                ),
              );
            case Status.error:
              return Center(
                child: StreamResponse(
                  image: 'images/server_error_1.png',
                  message: snapshot.data!.message,
                  button: SizedBox(
                    width: 180.0,
                    height: 46.0,
                    child: TextButton(
                      onPressed: () {
                        _tokenBloc.getToken();
                        setState(() {});
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: kPrimaryColor,
                        foregroundColor: kLightTextColor,
                      ),
                      child: const Text('Coba lagi'),
                    ),
                  ),
                ),
              );
            case Status.completed:
              if (snapshot.data!.data!.metadata!.code == 500) {
                return Center(
                  child: StreamResponse(
                    image: 'images/server_error_1.png',
                    message: snapshot.data!.data!.metadata!.message,
                  ),
                );
              }
              return ListTempatTidur(
                token: snapshot.data!.data!.response!.token,
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
    Key? key,
    this.token,
  }) : super(key: key);
  final String? token;
  @override
  _ListTempatTidurState createState() => _ListTempatTidurState();
}

class _ListTempatTidurState extends State<ListTempatTidur> {
  final TempatTidurBloc _tempatTidurBloc = TempatTidurBloc();

  @override
  void initState() {
    super.initState();
    _tempatTidurBloc.tokenSink.add(widget.token!);
    _tempatTidurBloc.getTempatTidur();
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
                child: StreamResponse(
                  image: 'images/loading_transparent.gif',
                  message: snapshot.data!.message,
                ),
              );
            case Status.error:
              return Center(
                child: StreamResponse(
                  image: 'images/server_error_1.png',
                  message: snapshot.data!.message,
                  button: SizedBox(
                    width: 180.0,
                    child: TextButton(
                      onPressed: () {
                        _tempatTidurBloc.getTempatTidur();
                        setState(() {});
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Coba lagi'),
                    ),
                  ),
                ),
              );
            case Status.completed:
              if (!snapshot.data!.data!.success!) {
                return Center(
                  child: StreamResponse(
                    image: 'images/server_error_1.png',
                    message: snapshot.data!.message,
                  ),
                );
              }
              return Column(
                children: [
                  const Text(
                    'Informasi Ketersediaan Tempat Tidur',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20.0,
                      color: kTextColor,
                    ),
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),
                  Expanded(
                    child: GridView.builder(
                      padding:
                          const EdgeInsets.fromLTRB(22.0, 18.0, 22.0, 32.0),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 17,
                        childAspectRatio: 3 / 4,
                      ),
                      itemCount: snapshot.data!.data!.tempatTidur!.length,
                      itemBuilder: (context, i) {
                        var tempat = snapshot.data!.data!.tempatTidur![i];
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 10.0),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      const Text(
                                        'Terisi',
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 12),
                                      ),
                                      Text(
                                        '${tempat.terisi}',
                                        style: const TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      const Text(
                                        'Total',
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 12.0),
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
                    ),
                  ),
                ],
              );
          }
        }
        return const SizedBox();
      },
    );
  }
}
