import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    Key? key,
    required this.height,
  }) : super(key: key);

  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 60,
            child: LoadingIndicator(
              indicatorType: Indicator.lineScalePulseOutRapid,
              colors: [
                Colors.red.shade300,
                Colors.orange.shade300,
                Colors.yellow.shade300,
                Colors.green.shade300,
                Colors.blue.shade300,
              ],
            ),
          ),
          const SizedBox(
            height: 22.0,
          ),
          const Text(
            'Please wait',
            style: TextStyle(color: Colors.orange),
          ),
        ],
      ),
    );
  }
}
