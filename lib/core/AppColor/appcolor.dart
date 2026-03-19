import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ── Backgrounds ──────────────────────────────────
  /// الخلفية الرئيسية للشاشات
  static const Color background    = Color(0xFFF1F1F1);
  /// خلفية الـ bottom nav
  static const Color navCardBg     = Color(0xFFE8E8E8);
  /// خلفية بطاقة المصاريف الشهرية
  static const Color pinkLight     = Color(0xFFFFCDD2);

  // ── Text ─────────────────────────────────────────
  /// اللون الأساسي للنصوص
  static const Color textPrimary   = Color(0xFF101010);
  /// النصوص الثانوية / الأيقونات غير النشطة
  static const Color textSecondary = Color(0xFF7E7E7E);

  // ── Brand / Interactive ───────────────────────────
  /// اللون البرتقالي — nav نشط، زر Add/Edit، Ribhi header
  static const Color orange        = Color(0xFFF54500);

  // ── Semantic ──────────────────────────────────────
  /// أخضر — ربح صافي، FAB، أعمدة الربح
  static const Color green         = Color(0xFF16A34A);
  /// أحمر — مصاريف، حذف، خطأ
  static const Color red           = Color(0xFFE53935);
  /// أزرق — قيمة المخزون
  static const Color blue          = Color(0xFF1707C8);
  /// أصفر — بضاعة ناقصة، فئة Salaries
  static const Color yellow        = Color(0xFFFFC107);

  // ── Category Colors ───────────────────────────────
  /// فئة Rent
  static const Color categoryRent        = Color(0xFFF54500);  // orange
  /// فئة Utilities
  static const Color categoryUtilities   = Color(0xFF7B8600);
  /// فئة Supplies
  static const Color categorySupplies    = Color(0xFF6435E5);
  /// فئة Salaries
  static const Color categorySalaries    = Color(0xFFFFC107);  // yellow
  /// فئة Maintenance
  static const Color categoryMaintenance = Color(0xFF1707C8);  // blue
  /// فئة Other
  static const Color categoryOther       = Color(0xFFE53935);  // red

  // ── UI Elements ───────────────────────────────────
  /// حدود وخلفيات البطاقات الفاتحة
  static const Color cardBorder    = Color(0xFFD6D4D4);
}