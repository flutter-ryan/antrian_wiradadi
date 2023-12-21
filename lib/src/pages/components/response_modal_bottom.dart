import 'package:antrian_wiradadi/src/confg/size_config.dart';
import 'package:antrian_wiradadi/src/confg/style.dart';
import 'package:flutter/material.dart';

class ResponseModalBottom extends StatelessWidget {
  const ResponseModalBottom({
    Key? key,
    this.image = 'images/sorry.png',
    this.message,
    this.message2,
    this.titleMessage2,
    this.title,
    this.button,
  }) : super(key: key);

  final String image;
  final String? message;
  final String? message2;
  final String? titleMessage2;
  final String? title;
  final Widget? button;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(22.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 18.0,
              ),
              Center(
                child: Image.asset(
                  image,
                  height: SizeConfig.blockSizeVertical * 30,
                ),
              ),
              const SizedBox(
                height: 32.0,
              ),
              Text(
                '$title',
                style: const TextStyle(
                    fontSize: 22.0, fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 12.0,
              ),
              Text(
                '$message',
                style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic),
              ),
              if (message2 != null)
                Text(
                  '$titleMessage2',
                  style: const TextStyle(fontSize: 18.0, color: Colors.black),
                ),
              if (message2 != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Container(
                    padding: const EdgeInsets.all(18.0),
                    decoration: BoxDecoration(
                      color: kPrimaryColor,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      '$message2',
                      style: const TextStyle(
                        fontSize: 15.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              const SizedBox(
                height: 32.0,
              ),
              if (button == null)
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 45),
                    backgroundColor: kPrimaryColor,
                  ),
                  child: const Text('Tutup'),
                )
              else
                button!
            ],
          ),
        ),
        Positioned(
          right: 8,
          top: 8,
          child: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close),
            color: Colors.grey[400],
          ),
        )
      ],
    );
  }
}
