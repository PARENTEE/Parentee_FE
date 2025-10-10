import 'package:flutter/material.dart';
import 'package:toasty_box/toast_enums.dart';
import 'package:toasty_box/toast_service.dart';

class PopUpToastService {
  /// Show a success toast
  static void showSuccessToast(BuildContext context, String message) {
    ToastService.showSuccessToast(
      context,
      length: ToastLength.medium,
      expandedHeight: 80,
      message: message,
    );
  }

  /// Show a success toast
  static void showWarningToast(BuildContext context, String message) {
    ToastService.showWarningToast(
      context,
      length: ToastLength.medium,
      expandedHeight: 80,
      message: message,
    );
  }

  /// Show an error toast
  static void showErrorToast(BuildContext context, String message) {
    ToastService.showErrorToast(
      context,
      length: ToastLength.medium,
      expandedHeight: 80,
      message: message,
    );
  }
}
