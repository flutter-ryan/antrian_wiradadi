import 'package:antrian_wiradadi/src/bloc/token_bloc.dart';
import 'package:antrian_wiradadi/src/common/ui/widget/stream_response.dart';
import 'package:antrian_wiradadi/src/models/token_model.dart';
import 'package:antrian_wiradadi/src/repositories/responseApi/api_response.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class DisplayPage extends StatefulWidget {
  const DisplayPage({Key? key}) : super(key: key);

  @override
  State<DisplayPage> createState() => _DisplayPageState();
}

class _DisplayPageState extends State<DisplayPage> {
  final TokenBloc _tokenBloc = TokenBloc();

  final Future<FirebaseApp> _initFirebase = Firebase.initializeApp();

  @override
  void initState() {
    super.initState();
    _tokenBloc.getToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 8.0,
            ),
            SizedBox(
              height: 52.0,
              child: Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 22.0),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 2.0,
                          offset: Offset(2.0, 2.0),
                        )
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 22.0,
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        padding: EdgeInsets.zero,
                        icon: const Icon(Icons.arrow_back_rounded),
                      ),
                    ),
                  ),
                  const Center(
                    child: Text(
                      'Display Antrian',
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.w600),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder(
                future: _initFirebase,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        StreamResponse(
                          image: 'images/server_error_1.png',
                          message: 'Memuat...',
                        ),
                        SizedBox(
                          height: 180,
                        )
                      ],
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.done) {
                    return StreamBuilder<ApiResponse<TokenResponseModel>>(
                      stream: _tokenBloc.tokenStream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          switch (snapshot.data!.status) {
                            case Status.loading:
                              return const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  StreamResponse(
                                    image: 'images/loading_transparent.gif',
                                    message: 'Memuat...',
                                  ),
                                  SizedBox(
                                    height: 180,
                                  )
                                ],
                              );
                            case Status.error:
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  StreamResponse(
                                    image: 'images/server_error_1.png',
                                    message: snapshot.data!.message,
                                  ),
                                  const SizedBox(
                                    height: 180,
                                  )
                                ],
                              );
                            case Status.completed:
                              if (snapshot.data!.data!.metadata!.code == 500) {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    StreamResponse(
                                      image: 'images/server_error_1.png',
                                      message: snapshot
                                          .data!.data!.metadata!.message,
                                    ),
                                    const SizedBox(
                                      height: 180,
                                    )
                                  ],
                                );
                              }
                              return StreamDisplayAntrian(
                                token: snapshot.data!.data!.response!.token!,
                              );
                          }
                        }
                        return const SizedBox();
                      },
                    );
                  }
                  return const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      StreamResponse(
                        image: 'images/loading_transparent.gif',
                        message: 'Memuat...',
                      ),
                      SizedBox(
                        height: 180,
                      )
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StreamDisplayAntrian extends StatefulWidget {
  const StreamDisplayAntrian({
    Key? key,
    required this.token,
  }) : super(key: key);

  final String token;

  @override
  State<StreamDisplayAntrian> createState() => _StreamDisplayAntrianState();
}

class _StreamDisplayAntrianState extends State<StreamDisplayAntrian> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
