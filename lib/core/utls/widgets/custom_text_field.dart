import 'package:flutter/material.dart';

/// A highly customizable, reusable text input field widget.
///
/// It supports standard text input, multi-line text, and password fields
/// with built-in visibility toggling. It automatically adapts to the
/// current application theme (Light/Dark).
class CustomTextFormField extends StatefulWidget {
  /// Constructs a [CustomTextFormField].
  ///
  /// [hintText] and [controller] are required.
  const CustomTextFormField({
    super.key,
    required this.hintText,
    this.textInputType,
    this.isPassword = false,
    required this.controller,
    this.validator,
    this.onChange,
    this.maxLines = 1,
    this.prefixIcon,
    this.suffixIcon,
    this.readOnly = false,
    this.onSubmit,
  });

  /// The text displayed in the field when it is empty.
  final String hintText;

  /// Whether the text field is read-only.
  ///
  /// If `true`, the text cannot be modified and the text color appears faded.
  final bool readOnly;

  /// An optional icon to display at the beginning of the text field.
  final IconData? prefixIcon;

  /// An optional widget to display at the end of the text field.
  ///
  /// Note: If [isPassword] is `true`, this will be overridden by the built-in
  /// password visibility toggle button.
  final Widget? suffixIcon;

  /// The type of keyboard to display (e.g., email, number, text).
  final TextInputType? textInputType;

  /// Whether this field is used for passwords.
  ///
  /// If `true`, it automatically obscures the text and adds a visibility toggle icon.
  final bool isPassword;

  /// Controls the text being edited.
  final TextEditingController? controller;

  /// The maximum number of lines for the input. Defaults to 1.
  ///
  /// Keep it at 1 for standard inputs, or increase it for multiline text areas.
  final int maxLines;

  /// An optional function that validates the input.
  ///
  /// Returns an error string to display if the input is invalid, or `null` otherwise.
  final String? Function(String?)? validator;

  /// Called whenever the text changes.
  final ValueChanged<String>? onChange;

  /// Called when the user indicates they are done editing the text in the field
  /// (e.g., pressing "Done" or "Enter" on the keyboard).
  final ValueChanged<String>? onSubmit;

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  /// Tracks the visibility state of the text when [isPassword] is true.
  bool isShow = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Unused variable, but kept safe if needed for future logic
    // final isDark = theme.brightness == Brightness.dark;

    return TextFormField(
      readOnly: widget.readOnly,
      maxLines: widget.maxLines,
      onChanged: widget.onChange,
      onFieldSubmitted: widget.onSubmit,
      // Automatically validates when the user interacts with the field
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: widget.controller,
      validator: widget.validator,
      obscureText: widget.isPassword ? isShow : false,
      keyboardType: widget.textInputType,
      style: TextStyle(
        color: widget.readOnly
            ? Colors.grey.shade500
            : theme.textTheme.bodyLarge?.color,
      ),
      decoration: InputDecoration(
        prefixIcon: (widget.prefixIcon != null)
            ? Icon(
          widget.prefixIcon,
          color: Theme.of(context).colorScheme.secondary,
        )
            : null,
        suffixIcon: widget.isPassword
            ? IconButton(
          icon: Icon(
            isShow ? Icons.visibility : Icons.visibility_off,
            color: theme.iconTheme.color,
          ),
          onPressed: () {
            setState(() {
              isShow = !isShow;
            });
          },
        )
            : widget.suffixIcon,
        hintText: widget.hintText,
        hintStyle: TextStyle(color: theme.hintColor),
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}