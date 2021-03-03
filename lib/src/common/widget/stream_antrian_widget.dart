import 'package:antrian_wiradadi/src/bloc/create_antrian_bloc.dart';
import 'package:antrian_wiradadi/src/common/widget/error_create_antrian.dart';
import 'package:antrian_wiradadi/src/common/widget/loading_create_antrian.dart';
import 'package:antrian_wiradadi/src/model/create_antrian_model.dart';
import 'package:antrian_wiradadi/src/repository/responseApi/api_response.dart';
import 'package:flutter/material.dart';

class StreamAntrianWidget extends StatefulWidget {
  final ScrollController scrollController;
  final CreateAntrianBloc bloc;
  final String token;
  final Function batal;
  final Function daftar;

  const StreamAntrianWidget({
    Key key,
    this.scrollController,
    @required this.bloc,
    this.token,
    this.batal,
    this.daftar,
  }) : super(key: key);

  @override
  _StreamAntrianWidgetState createState() => _StreamAntrianWidgetState();
}

class _StreamAntrianWidgetState extends State<StreamAntrianWidget> {
  @override
  void initState() {
    super.initState();
    widget.bloc.tokenSink.add(widget.token);
    widget.bloc.createAntrian();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ApiResponse<ResponseCreateAntrianModel>>(
      stream: widget.bloc.createAntrianStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data.status) {
            case Status.LOADING:
              return LoadingCreateAntrian(
                scrollController: widget.scrollController,
              );
            case Status.ERROR:
              return ErrorCreateAntrian(
                scrollController: widget.scrollController,
                daftar: widget.batal,
                message: snapshot.data.message,
                button: Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(top: 18.0),
                        height: 45.0,
                        child: FlatButton(
                          onPressed: widget.batal,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28.0),
                          ),
                          color: Colors.grey[300],
                          textColor: Colors.black,
                          child: Text('BATAL'),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 18.0,
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(top: 18.0),
                        height: 45.0,
                        child: FlatButton(
                          onPressed: widget.daftar,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28.0),
                          ),
                          color: Colors.redAccent,
                          textColor: Colors.white,
                          child: Text('COBA LAGI'),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            case Status.COMPLETED:
              return ListView(
                physics: ClampingScrollPhysics(),
                controller: widget.scrollController,
                padding: EdgeInsets.symmetric(horizontal: 32.0),
                children: [
                  Container(
                    height: 200,
                    margin: EdgeInsets.only(top: 25),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/create_loading.gif'),
                      ),
                    ),
                  ),
                  Text(
                    '${snapshot.data.data.metadata.message}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                      fontSize: 16.0,
                    ),
                  )
                ],
              );
          }
        }
        return Container();
      },
    );
  }
}
