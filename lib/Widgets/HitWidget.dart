import 'package:flutter/material.dart';

class HitWidget extends StatelessWidget {
  const HitWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: SizedBox(
        width: 50,
        height: 50,
        child : Image.asset("assets/images/fist.png"),
      ),
      onPressed: () { print("caca"); },
    );
  }
}