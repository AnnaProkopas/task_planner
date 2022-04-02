import 'package:flutter/cupertino.dart';

class LoadingScreen extends StatelessWidget {
  static const String id = "load";

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Loading ..."),
    );
  }
}
