import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWidget extends StatelessWidget {
  final Widget child;

  const ShimmerWidget({
    Key key,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      child: child,
      period: Duration(milliseconds: 1000),
      baseColor: Colors.grey[200],
      highlightColor: Colors.white38,
    );
  }
}
