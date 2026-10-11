import 'package:flutter/material.dart';

class AddIconButton extends StatelessWidget {
  final VoidCallback? _onPressed;

  const AddIconButton({super.key, this._onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(onPressed: _onPressed, icon: Icon(Icons.add_circle));
  }
}
