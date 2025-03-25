import 'package:flutter/material.dart';

class EatWidget extends StatelessWidget {
  const EatWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: SizedBox(
        width: 50,
        height: 50,
        child : Image.asset("assets/images/eat.png"),
      ),
      onPressed: () { print("Modifier"); },
    );
  }
}