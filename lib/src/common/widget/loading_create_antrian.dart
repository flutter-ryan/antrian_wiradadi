import 'package:flutter/material.dart';

class LoadingCreateAntrian extends StatelessWidget {
  final ScrollController scrollController;

  const LoadingCreateAntrian({
    Key key,
    this.scrollController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: ClampingScrollPhysics(),
      controller: this.scrollController,
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
          'Membuat Antrian...\nMohon untuk menunggu sesaat',
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
