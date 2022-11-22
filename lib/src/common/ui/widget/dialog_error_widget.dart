import 'package:antrian_wiradadi/src/common/source/size_config.dart';
import 'package:flutter/material.dart';

class DialogErrorWidget extends StatelessWidget {
  const DialogErrorWidget({
    Key? key,
    required this.imageSrc,
    required this.message,
    this.buttonRetry,
  }) : super(key: key);

  final String imageSrc;
  final String message;
  final Widget? buttonRetry;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: SizeConfig.blockSizeVertical * 15,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(imageSrc),
              ),
            ),
          ),
          const SizedBox(
            height: 18.0,
          ),
          Text(
            message,
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 18.0,
          ),
          buttonRetry == null ? Container() : buttonRetry!,
        ],
      ),
    );
  }
}
