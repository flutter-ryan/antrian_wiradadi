import 'package:antrian_wiradadi/src/common/widget/shimmer_widget.dart';
import 'package:flutter/material.dart';

class SkeletonJadwalWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(18.0),
          child: ShimmerWidget(
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                width: 180,
                height: 10,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.symmetric(vertical: 0.0),
            separatorBuilder: (context, i) {
              return Divider(
                height: 0.0,
              );
            },
            itemCount: 5,
            itemBuilder: (context, i) {
              return ListTile(
                leading: ShimmerWidget(
                  child: Container(
                    width: 52.0,
                    height: 52.0,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.grey[300]),
                  ),
                ),
                isThreeLine: true,
                title: ShimmerWidget(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: 180,
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),
                ),
                subtitle: ShimmerWidget(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: 140,
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        )
      ],
    );
  }
}
