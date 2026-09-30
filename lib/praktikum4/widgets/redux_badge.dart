import 'package:flutter/material.dart';

class ReduxBadge extends StatelessWidget {
  final String? extraText;

  const ReduxBadge({super.key, this.extraText});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.deepPurple.shade200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Colors.deepPurple,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            extraText != null ? 'Redux • $extraText' : 'Redux State Management',
            style: TextStyle(
              color: Colors.deepPurple.shade900,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
