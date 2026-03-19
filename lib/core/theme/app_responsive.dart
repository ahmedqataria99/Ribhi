import 'package:flutter/material.dart';

/// ──────────────────────────────────────────
///  AppSizes — Responsive helpers
///  Base design width: 390px (iPhone 14)
/// ──────────────────────────────────────────
class AppSizes {
  AppSizes._();

  static const double _baseWidth = 390.0;

  /// Screen width
  static double sw(BuildContext ctx) => MediaQuery.sizeOf(ctx).width;

  /// Screen height
  static double sh(BuildContext ctx) => MediaQuery.sizeOf(ctx).height;

  /// Scale a value relative to the base screen width.
  /// e.g. s(ctx, 16) → 16 on 390px, bigger on tablets, smaller on tiny phones.
  static double s(BuildContext ctx, double val) =>
      val * (sw(ctx) / _baseWidth).clamp(0.75, 1.4);

  /// Horizontal screen padding (4.5% of width, clamped)
  static double hPad(BuildContext ctx) => sw(ctx) * 0.045;

  /// Vertical spacing helper
  static double vPad(BuildContext ctx) => sh(ctx) * 0.022;

  /// Font scale — same ratio as s()
  static double fs(BuildContext ctx, double size) => s(ctx, size);
}