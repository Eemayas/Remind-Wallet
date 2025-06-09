import 'package:flutter/material.dart';

class AppColors {
  // Dark Mode Expense Tracker Color Palette

  // Primary colors - Deep blue for trust and stability in financial apps
  static const Color primary =
      Color(0xFF673AB7); // Bright blue for primary actions
  static const Color primaryVariant =
      Color(0xFF0D47A1); // Darker blue for depth

  // Secondary colors - Green for positive financial themes (income, savings)
  static const Color secondary = Color(0xFF00C853); // Success green
  static const Color secondaryVariant =
      Color(0xFF00A545); // Darker green variant

  // Surface and background - Dark theme foundation
  static const Color surface = Color(0xFF1E1E1E); // Card surfaces
  static const Color background = Color(0xFF121212); // Main background

  // Error color - Red for expenses and warnings
  static const Color error = Color(0xFFCF6679); // Soft red for dark mode

  // Text colors on colored backgrounds
  static const Color onPrimary = Color(0xFFFFFFFF); // White text on primary
  static const Color onSecondary = Color(0xFF000000); // Black text on secondary
  static const Color onSurface = Color(0xFFE0E0E0); // Light text on surface
  static const Color onBackground =
      Color(0xFFE0E0E0); // Light text on background
  static const Color onError = Color(0xFF000000); // Black text on error

  // Utility colors
  static const Color shadow = Color(0xFF000000); // Shadow color
  static const Color outline = Color(0xFF404040); // Border/outline color

  // Text colors for different states
  static const Color textColor = Color(0xFFE0E0E0); // Primary text color
  static const Color textColorSecondary =
      Color(0xFFBDBDBD); // Secondary text color
  static const Color textColorTertiary =
      Color(0xFF9E9E9E); // Tertiary text color
  static const Color hintTextColor = Color(0xFF757575); // Hint/placeholder text
  static const Color disabledTextColor =
      Color(0xFF616161); // Disabled text color
  static const Color linkTextColor = Color(0xFF64B5F6); // Link text color
  static const Color errorTextColor = Color(0xFFEF5350); // Error text color

  // Input field colors
  static const Color cursorColor = Color(0xFF1E88E5); // Text cursor color
  static const Color selectionColor = Color(0xFF1976D2); // Text selection color
  static const Color selectionHandleColor =
      Color(0xFF1E88E5); // Selection handle color
  static const Color inputFillColor =
      Color(0xFF2C2C2C); // Input field background
  static const Color inputBorderColor =
      Color.fromARGB(255, 117, 114, 114); // Input field border
  static const Color inputFocusedBorderColor =
      Color(0xFF1E88E5); // Focused input border
  static const Color inputErrorBorderColor =
      Color(0xFFEF5350); // Error input border

  // Button and interactive colors
  static const Color buttonColor =
      Color(0xFF673AB7); // Button color (matches primary, deepPurple.shade500)
  static const Color buttonLoadingColor =
      Color(0xFF512DA8); // deepPurple.shade700
  static const Color buttonFailedColor = Color(0xFFE57373); // red.shade300
  static const Color buttonSuccessColor = Color(0xFF66BB6A); // green.shade400
  static const Color buttonDisabledColor =
      Color(0xFF424242); // Disabled button color
  static const Color buttonTextColor = Color(0xFFFFFFFF); // Button text color
  static const Color buttonDisabledTextColor =
      Color(0xFF9E9E9E); // Disabled button text
  static const Color iconColor = Color(0xFFE0E0E0); // Default icon color
  static const Color iconColorSecondary =
      Color(0xFFBDBDBD); // Secondary icon color
  static const Color iconDisabledColor =
      Color(0xFF616161); // Disabled icon color

  // Navigation and app structure
  static const Color navBarColor = Color(0xFF1F1F1F); // Navigation bar
  static const Color tabBarColor = Color(0xFF2C2C2C); // Tab bar background
  static const Color tabSelectedColor = Color(0xFF1E88E5); // Selected tab color
  static const Color tabUnselectedColor =
      Color(0xFF9E9E9E); // Unselected tab color
  static const Color appBarColor =
      Color.fromARGB(255, 43, 41, 50); // App bar background
  static const Color statusBarColor =
      Color(0xFF000000); // Status bar background

  // Card and surface variations
  static const Color cardColor = Color(0xFF2C2C2C); // Card background
  static const Color cardElevatedColor =
      Color(0xFF353535); // Elevated card background
  static const Color bottomSheetColor =
      Color.fromARGB(255, 29, 28, 28); // Bottom sheet background
  static const Color dialogColor = Color(0xFF2C2C2C); // Dialog background
  static const Color snackBarColor = Color(0xFF323232); // Snackbar background

  // Dividers and borders
  static const Color dividerColor = Color(0xFF404040); // Divider lines
  static const Color borderColor = Color(0xFF404040); // General border color
  static const Color focusedBorderColor =
      Color(0xFF1E88E5); // Focused border color

  // Financial category colors
  static const Color incomeColor = Color(0xFF4CAF50); // Green for income
  static const Color expenseColor =
      Color(0xFFFF5722); // Orange-red for expenses
  static const Color savingsColor = Color(0xFF2196F3); // Blue for savings
  static const Color investmentColor =
      Color(0xFF9C27B0); // Purple for investments
  static const Color transferColor = Color(0xFFFF9800); // Orange for transfers
  static const Color billsColor = Color(0xFFF44336); // Red for bills/debts
  static const Color foodColor = Color(0xFFFF9800); // Orange for food
  static const Color transportColor =
      Color(0xFF607D8B); // Blue-grey for transport
  static const Color entertainmentColor =
      Color(0xFFE91E63); // Pink for entertainment
  static const Color healthColor = Color(0xFF00BCD4); // Cyan for health
  static const Color educationColor = Color(0xFF3F51B5); // Indigo for education
  static const Color shoppingColor = Color(0xFF9C27B0); // Purple for shopping

  // Status and feedback colors
  static const Color successColor = Color(0xFF4CAF50); // Success indicators
  static const Color warningColor = Color(0xFFFF9800); // Warning indicators
  static const Color infoColor = Color(0xFF2196F3); // Info indicators
  static const Color dangerColor = Color(0xFFF44336); // Danger indicators

  // Chart and graph colors
  static const Color chartPrimary = Color(0xFF1E88E5); // Primary chart color
  static const Color chartSecondary =
      Color(0xFF4CAF50); // Secondary chart color
  static const Color chartTertiary = Color(0xFFFF9800); // Tertiary chart color
  static const Color chartQuaternary = Color(0xFF9C27B0); // Fourth chart color
  static const Color chartBackground = Color(0xFF2C2C2C); // Chart background
  static const Color chartGrid = Color(0xFF404040); // Chart grid lines

  // Overlay and modal colors
  static const Color overlayColor =
      Color(0x80000000); // Semi-transparent overlay
  static const Color modalBarrierColor =
      Color(0x80000000); // Modal barrier color
  static const Color tooltipColor = Color(0xFF616161); // Tooltip background
  static const Color tooltipTextColor = Color(0xFFFFFFFF); // Tooltip text color

  // Shimmer and loading colors
  static const Color shimmerBaseColor = Color(0xFF2C2C2C); // Shimmer base color
  static const Color shimmerHighlightColor =
      Color(0xFF404040); // Shimmer highlight
  static const Color loadingColor =
      Color(0xFF1E88E5); // Loading indicator color

  static const Color optionSelectedColor =
      Colors.amber; // Selected option color
}
