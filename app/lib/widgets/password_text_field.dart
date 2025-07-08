import 'package:flutter/material.dart';
import 'custom_text_field.dart';
import '../utils/app_colors.dart';

class PasswordTextField extends StatefulWidget {
  final String label;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final void Function(String)? onChanged;

  const PasswordTextField({
    Key? key,
    required this.label,
    this.controller,
    this.validator,
    this.focusNode,
    this.onChanged,
  }) : super(key: key);

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      label: widget.label,
      controller: widget.controller,
      validator: widget.validator,
      focusNode: widget.focusNode,
      onChanged: widget.onChanged,
      obscureText: _isObscured,
      suffixIcon: IconButton(
        icon: Icon(
          _isObscured ? Icons.visibility_off : Icons.visibility,
          color: AppColors.textSecondary,
        ),
        onPressed: () {
          setState(() {
            _isObscured = !_isObscured;
          });
        },
      ),
    );
  }
}
