import 'package:flutter/material.dart';

/// Provides a container which will set the page edge insets and
/// a SafeArea wrapper widget. This is designed to be used on all
/// pages to keep the aligned and consistent without also being
/// redundant.
///
/// Allows for custom insets to be added to a page with the insets param.
///
/// @param Widget child
/// @param EdgeInsets? insets
/// @returns PageContainer
class PageContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets? insets;

  const PageContainer({required this.child, this.insets});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: insets ?? EdgeInsets.all(16),
      child: SafeArea(child: child),
    );
  }
}
