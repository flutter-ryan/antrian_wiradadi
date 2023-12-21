import 'package:flutter/material.dart';

class ErrorRespWidget extends StatelessWidget {
  const ErrorRespWidget({
    Key? key,
    this.message,
    this.reload,
    this.height = 200,
    this.buttonText = 'Reload',
  }) : super(key: key);

  final String? message;
  final VoidCallback? reload;
  final double height;
  final String buttonText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'images/sorry.png',
            height: height,
          ),
          const SizedBox(
            height: 22.0,
          ),
          Text(
            '$message',
            style: const TextStyle(
                fontSize: 14.0,
                color: Colors.grey,
                fontStyle: FontStyle.italic),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 22,
          ),
          if (reload != null)
            ElevatedButton(
              onPressed: reload,
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size(150, 38),
                  backgroundColor: Colors.red),
              child: Text(buttonText),
            )
        ],
      ),
    );
  }
}
