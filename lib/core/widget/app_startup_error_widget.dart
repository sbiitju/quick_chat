import 'package:flutter/material.dart';

class AppStartUpErrorWidget extends StatelessWidget {
  final String error;

  const AppStartUpErrorWidget({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Error: $error'),
      ),
    );
  }
}
