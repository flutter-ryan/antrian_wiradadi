import 'package:antrian_wiradadi/src/blocs/token_bloc.dart';
import 'package:antrian_wiradadi/src/confg/size_config.dart';
import 'package:antrian_wiradadi/src/models/token_model.dart';
import 'package:antrian_wiradadi/src/pages/components/error_resp_widget.dart';
import 'package:antrian_wiradadi/src/pages/components/loading_widget.dart';
import 'package:antrian_wiradadi/src/pages/components/pos_antrian_widget.dart';
import 'package:antrian_wiradadi/src/repositories/responseApi/api_response.dart';
import 'package:flutter/material.dart';

class PanelWidget extends StatefulWidget {
  const PanelWidget({
    super.key,
    this.filter,
  });

  final TextEditingController? filter;

  @override
  State<PanelWidget> createState() => _PanelWidgetState();
}

class _PanelWidgetState extends State<PanelWidget> {
  final _tokenBloc = TokenBloc();

  @override
  void initState() {
    super.initState();
    _tokenBloc.getToken();
  }

  void _reload() {
    _tokenBloc.getToken();
    setState(() {});
  }

  @override
  void dispose() {
    _tokenBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return StreamBuilder<ApiResponse<TokenResponseModel>>(
      stream: _tokenBloc.tokenStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return Align(
                alignment: Alignment.center,
                child: LoadingWidget(
                  height: SizeConfig.blockSizeVertical * 40,
                ),
              );
            case Status.error:
              return Align(
                alignment: Alignment.center,
                child: SingleChildScrollView(
                  child: ErrorRespWidget(
                    message: snapshot.data!.message,
                    reload: _reload,
                  ),
                ),
              );

            case Status.completed:
              if (snapshot.data!.data!.metadata!.code != 200) {
                return Align(
                  alignment: Alignment.center,
                  child: ErrorRespWidget(
                    message: snapshot.data!.data!.metadata!.message,
                    reload: _reload,
                  ),
                );
              }
              return PosAntrianWidget(
                token: snapshot.data!.data!.response!.token!,
                filter: widget.filter,
              );
          }
        }
        return const SizedBox();
      },
    );
  }
}
