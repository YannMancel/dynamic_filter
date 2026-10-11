import 'package:flutter/material.dart';

class DeleteIconButton extends StatelessWidget {
  final VoidCallback? _onPressed;

  const DeleteIconButton({super.key, this._onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(onPressed: _onPressed, icon: Icon(Icons.delete_forever));
  }
}
