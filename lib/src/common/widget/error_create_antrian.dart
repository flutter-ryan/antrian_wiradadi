import 'package:flutter/material.dart';

class ErrorCreateAntrian extends StatefulWidget {
  final ScrollController scrollController;
  final Function daftar;
  final Function resizeSheet;
  final Widget button;
  final BuildContext context;
  final String message;

  const ErrorCreateAntrian({
    Key key,
    this.scrollController,
    this.daftar,
    this.resizeSheet,
    this.button,
    this.context,
    this.message,
  }) : super(key: key);

  @override
  _ErrorCreateAntrianState createState() => _ErrorCreateAntrianState();
}

class _ErrorCreateAntrianState extends State<ErrorCreateAntrian> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.resizeSheet();
      // DraggableScrollableActuator.reset(widget.context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: ClampingScrollPhysics(),
      controller: widget.scrollController,
      padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 8.0),
      children: [
        Center(
          child: Container(
            width: 40,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[400], width: 2),
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
        ),
        SizedBox(
          height: 18.0,
        ),
        Container(
          height: 170,
          margin: EdgeInsets.only(top: 25, bottom: 18.0),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/server_error.png'),
            ),
          ),
        ),
        Text(
          '${widget.message}',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.grey,
            fontStyle: FontStyle.italic,
            fontSize: 16.0,
          ),
        ),
        SizedBox(
          height: 18.0,
        ),
        widget.button
      ],
    );
  }
}
