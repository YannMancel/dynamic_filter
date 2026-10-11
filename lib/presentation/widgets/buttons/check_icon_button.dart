import 'package:flutter/material.dart';

class CheckIconButton extends StatelessWidget {
  final VoidCallback? _onPressed;

  const CheckIconButton({super.key, this._onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(onPressed: _onPressed, icon: Icon(Icons.check_circle));
  }
}
