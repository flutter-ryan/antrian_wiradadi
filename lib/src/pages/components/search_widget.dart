import 'package:antrian_wiradadi/src/confg/style.dart';
import 'package:flutter/material.dart';

class SearchWidget extends StatelessWidget {
  const SearchWidget({
    super.key,
    required this.filter,
    this.hint,
    this.onTap,
  });

  final TextEditingController filter;
  final String? hint;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: Colors.white,
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TextField(
                controller: filter,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 10.0,
                  ),
                  border: InputBorder.none,
                  hintText: '$hint',
                  hintStyle: TextStyle(color: Colors.grey[400]!),
                ),
                readOnly: true,
                onTap: onTap,
              ),
            ),
          ),
          Container(
            height: 42,
            width: 42,
            decoration: BoxDecoration(
              color: kPrimaryDarkColor,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: const Icon(
              Icons.search_rounded,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
