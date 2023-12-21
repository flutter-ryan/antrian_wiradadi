import 'package:flutter/material.dart';

class QuickMenu extends StatelessWidget {
  const QuickMenu({
    super.key,
    this.icon,
    this.title,
    this.onTap,
  });

  final Icon? icon;
  final String? title;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 28,
                  child: icon ?? const SizedBox(),
                ),
                const SizedBox(
                  height: 12.0,
                ),
                Text(
                  '$title',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontSize: 12.0),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
