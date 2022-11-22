import 'package:antrian_wiradadi/src/common/source/size_config.dart';
import 'package:flutter/material.dart';

class StreamResponse extends StatelessWidget {
  const StreamResponse({
    Key? key,
    this.image,
    this.message,
    this.button,
  }) : super(key: key);

  final String? image;
  final String? message;
  final Widget? button;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Padding(
      padding: const EdgeInsets.only(
        top: 32.0,
        left: 22.0,
        right: 22.0,
        bottom: 22.0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 160,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(image!),
              ),
            ),
          ),
          const SizedBox(
            height: 22.0,
          ),
          Text(
            message!,
            style: const TextStyle(fontSize: 15.0, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          button == null
              ? const SizedBox(
                  height: 18.0,
                )
              : const SizedBox(
                  height: 32.0,
                ),
          button == null ? const SizedBox() : button!,
        ],
      ),
    );
  }
}
