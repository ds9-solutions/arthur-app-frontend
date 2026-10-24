import 'package:arthur/core/tokens/tokens.dart';
import 'package:flutter/material.dart';

class AppLoading extends StatelessWidget {
  final double? size;

  const AppLoading({super.key, this.size});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size ?? 24,
        height: size ?? 24,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          color: context.colors.primary,
        ),
      ),
    );
  }
}
