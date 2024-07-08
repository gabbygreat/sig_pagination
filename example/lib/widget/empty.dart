
import 'package:flutter/material.dart';

class EmptyScreen extends StatelessWidget {
  final String? text;
  const EmptyScreen({
    super.key,
    this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text ?? "Nothing to see here",
      ),
    );
  }
}
