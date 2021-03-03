import 'package:antrian_wiradadi/src/common/widget/shimmer_widget.dart';
import 'package:flutter/material.dart';

class SkeletonPoliWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 170,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
            separatorBuilder: (context, i) {
              return SizedBox(
                width: 18.0,
              );
            },
            scrollDirection: Axis.horizontal,
            itemCount: 4,
            itemBuilder: (context, i) {
              return Container(
                width: 140.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4.0,
                      offset: Offset(2.0, 2.0),
                    )
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18.0),
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ShimmerWidget(
                          child: Container(
                            width: 42,
                            height: 42.0,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                              padding: EdgeInsets.only(bottom: 8.0, right: 8.0),
                              child: ShimmerWidget(
                                child: Container(
                                  width: 120,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                ),
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(
          height: 22.0,
        ),
        Expanded(
          child: Container(
            child: Column(
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
                      return SizedBox(
                        height: 18.0,
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
                                shape: BoxShape.circle,
                                color: Colors.grey[300]),
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
            ),
          ),
        )
      ],
    );
  }
}
