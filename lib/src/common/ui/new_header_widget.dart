import 'package:flutter/material.dart';

class NewHeaderWidget extends StatelessWidget {
  final double height;

  const NewHeaderWidget({
    Key key,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/bg_header.jpeg'),
          fit: BoxFit.fill,
          alignment: Alignment.centerLeft,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 12.0,
            offset: Offset(2.0, 2.0),
          )
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).padding.top,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 18.0, right: 8.0, bottom: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'RSU Wiradadi Husada',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
                ),
                Wrap(
                  children: [
                    ClipOval(
                      child: Material(
                        color: Colors.transparent,
                        child: IconButton(
                          icon: Icon(
                            Icons.hotel,
                            size: 20.0,
                          ),
                          onPressed: () {},
                        ),
                      ),
                    ),
                    ClipOval(
                      child: Material(
                        color: Colors.transparent,
                        child: IconButton(
                          icon: Icon(
                            Icons.receipt,
                            size: 20,
                          ),
                          onPressed: () {},
                        ),
                      ),
                    ),
                    ClipOval(
                      child: Material(
                        color: Colors.transparent,
                        child: IconButton(
                          icon: Icon(
                            Icons.info,
                            size: 20,
                          ),
                          onPressed: () {},
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.0),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Antrian Online',
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      Text(
                        'Layanan antrian prioritas memberikan kemudahan tanpa harus mengantri di loket',
                        style: TextStyle(
                            fontSize: 12.0, fontWeight: FontWeight.w300),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    width: 120,
                    height: 130,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                      image: AssetImage('assets/images/doctor.png'),
                    )),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
