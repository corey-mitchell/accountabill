import 'package:flutter/material.dart';

/// Create a large call to action button for page wide actions
///
/// @param Widget buttonChild
/// @param void Function() onPressed
/// @param Color? backgroundColor
/// @param Color? foregroundColor
/// @returns MainCTA
class MainCTA extends StatelessWidget {
  final Widget child;
  final void Function() onPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const MainCTA({
    required this.child,
    required this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 16),
      child: SizedBox(
        width: double.infinity,
        height: 48,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor:
                backgroundColor ?? Theme.of(context).colorScheme.inversePrimary,
            foregroundColor: foregroundColor ?? Colors.white,
          ),
          child: child,
        ),
      ),
    );
  }
}
