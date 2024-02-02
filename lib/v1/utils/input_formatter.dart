//  ZOFI CASH MOBILE APP
//
//  Created by Ronald Zad Muhanguzi .
//  2022, Zofi Cash App. All rights reserved.

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Helper {
  /// #### Get Text Digit method
  /// This is the `getTextDigit` method of type [String?]. It takes a parameter [textToFormat] of
  /// type [String?] and returns the parsed and formatted string.
  /// Here we check whether the [textToFormat] string is empty or equal to null, then we proceed
  /// to check whether the input string contains a decimal point "." and if yes we can then split
  /// the string into two substrings along the decimal point.
  /// We then format the the fist part which is the whole number using the
  ///  `NumberFormat.decimalPattern().format()` from the `package:intl` and this returns a
  /// formatted string with a comma separator "," for digits above 1000. We then concatenate the two
  /// strings together plus a decimal point "." and return the string. if the input [textToFormat]
  /// string does not contain  a string, we simply format the string as seen above and return the
  /// formatted string and otherwise we return zero "0" is the [textToFormat] is null...This is when
  /// a user has not input any digit yet.
  static String? getTextDigit(String? textToFormat, {decimalPlaces = 0}) {
    if (textToFormat != null && textToFormat.isNotEmpty) {
      textToFormat = textToFormat.contains('.')
          ? '${NumberFormat.decimalPattern().format(int.parse(textToFormat.split('.')[0]))}.${textToFormat.split('.')[1]}'
          : textToFormat != ''
              ? NumberFormat.currency(name: '', decimalDigits: decimalPlaces).format(int.parse(textToFormat))
              : '0';
    } else {
      return '0';
    }

    return textToFormat;
  }

  static String getDate(String? textToFormat) {
    return textToFormat == null ? 'NOT GIVEN' : DateFormat('EEE d MMM, yyyy').format(DateTime.parse(textToFormat));
  }

  static getTransactionType(String type) {
    switch (type) {
      case 'mobile_money':
        return 'MOBILE MONEY';

      case 'bank':
        return 'BANK';

      default:
        '';
    }
  }

  static getTransactionStatusColor(String type) {
    switch (type.toLowerCase()) {
      case 'active':
        return Colors.green;

      case 'pending':
        return Colors.orange;

      case 'failed':
        return Colors.red;

      case 'processed_with_errors':
        return Colors.red;

      case 'matured':
        return Colors.cyan;

      case 'processed':
        return Colors.lightBlue;

      default:
        '';
    }
  }

  static getTransactionStatusText(String type) {
    switch (type.toLowerCase()) {
      case 'active':
        return 'ACTIVE';

      case 'pending':
        return 'PENDING';

      case 'failed':
        return 'FAILED';

      case 'processed_with_errors':
        return 'FAILED';

      case 'matured':
        return 'MATURED';

      default:
        'FAILED';
    }
  }

  static getUpdatedBalances(List<dynamic> data, {required String flag}) {
    return List.from(data.where((element) => element['status'] == (flag))).fold(0.0, (num previousValue, entry) => previousValue + entry['amount']);
  }

  static getBalanceLabelText(int index) {
    switch (index) {
      case 0:
        return 'TOTAL BALANCE';

      case 1:
        return 'TOTAL WITHDRAWN';

      default:
        return '';
    }
  }
}
