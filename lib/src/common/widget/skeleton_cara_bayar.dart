import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SkeletonCaraBayar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(vertical: 18.0),
      separatorBuilder: (context, int t) {
        return Divider();
      },
      itemCount: 5,
      itemBuilder: (context, int i) {
        return ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 32.0),
          leading: Shimmer.fromColors(
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            period: Duration(milliseconds: 1000),
            baseColor: Colors.grey[200],
            highlightColor: Colors.white38,
          ),
          title: Shimmer.fromColors(
            child: Container(
              width: 80,
              height: 10,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            period: Duration(milliseconds: 1000),
            baseColor: Colors.grey[300],
            highlightColor: Colors.white38,
          ),
        );
      },
    );
  }
}
