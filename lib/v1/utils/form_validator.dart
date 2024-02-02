// //  ZOFI CASH MOBILE APP
// //
// //  Created by Ronald Zad Muhanguzi .
// //  2022, Zofi Cash App. All rights reserved.

// import 'package:flutter/material.dart';


// class FieldValidator {
//   ///#### Field Validator
//   ///This [FieldValidator] class helps in text validation of the textfields across the application.
//   FieldValidator._();

//   ///#### Validate and Save method
//   ///This [validateAndSave] method takes `varFormKey` and checks whether all
//   ///form field constraints have been satisfied and returns a `bool`, that is [true] or [false]
//   static bool validateAndSave(varFormKey) {
//     final FormState? form = varFormKey.currentState;
//     if (form!.validate()) {
//       form.save();
//       return true;
//     }
//     return false;
//   }

//   ///#### Validate Email method
//   ///This [validateEmail] method takes `String` and checks the value contains a valid email incase
//   ///it is submitted by the user
//   ///
//   ///

//   // Validates email address
//   // validateEmail
//   //  @param [String]
//   //  @return [bool]
//   static String? validateEmail(String? value) {
//     Pattern pattern = r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
//         r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
//         r"{0,253}[a-zA-Z0-9])?)*$";
//     RegExp regex = RegExp(pattern.toString());
//     if (!regex.hasMatch(value!.trim()) && value.isNotEmpty) {
//       return 'Enter a valid email';
//     } else {
//       return null;
//     }
//   }

//   ///#### Validate Password method
//   ///This [validatePassword] method takes `String` and checks the if value is longer than 6 characters
//   static String? validatePassword(String? value) {
//     if (value!.length < 6) {
//       return 'Enter at least 6 characters';
//     } else if (value.isEmpty) {
//       return 'Fill in Password please';
//     } else {
//       return null;
//     }
//   }

//   ///#### Validate Tin method
//   ///This [validate Tin] method takes `String` and checks the if value is longer than 10 characters
//   static String? validateTIN(String value) {
//     if (value.length < 10) {
//       return 'Enter a correct TIN';
//     } else if (value.isEmpty) {
//       return 'Fill in please here';
//     } else {
//       return null;
//     }
//   }

//   static String? validateAmount(String? value, min, max) {
//     Pattern pattern = r"^[0-9]";
//     var amount = value!.replaceAll(RegExp(r'[^0-9]'), '');

//     RegExp regex = RegExp(pattern.toString());

//     if (amount.isEmpty) {
//       return 'Fill in a value';
//     } else {
//       if (int.parse(amount) > max) {
//         return 'Value is too much';
//       } else if (int.parse(amount) < min) {
//         return 'Value is less';
//       }
//     }
//     return null;
//   }

//   static String? validatePhone(String? value) {
//     Pattern pattern = r"^[0-9]";

//     RegExp regex = RegExp(pattern.toString());
//     if (!regex.hasMatch(value!)) {
//       return 'Fill phone number';
//     } else if (value.length != 9) {
//       return 'Enter a complete phone number';
//     } else {
//       return null;
//     }
//   }

//   static String? validateNIN(String? value) {
//     if (value != null) {
//       if ((value.startsWith('F', 1) || value.startsWith('M', 1))) {
//         return 'Enter a valid NIN, starting with \'CM......\' or \'CF......\'';
//       } else if (value.length < 14 && value.isNotEmpty) {
//         return 'Enter a complete NIN, it is 14 characters long';
//       } else {
//         return null;
//       }
//     } else {
//       return 'Fill NIN';
//     }
//   }

//   static String? validateTextFieldNames(String value) {
//     final emoji = RegExp(regexToRemoveEmoji);
//     final validCharacters = RegExp(r'^[a-zA-Z0-9`& ]+$');

//     if (value.isEmpty) {
//       return 'This can not be empty';
//     } else {
//       if (!value.trim().contains(validCharacters) || value.trim().contains(emoji)) {
//         return 'Invalid character';
//       } else {
//         return null;
//       }
//     }
//   }

//   static String? validateTextNumberField(String value) {
//     final emoji = RegExp(regexToRemoveEmoji);
//     final validCharacters = RegExp(r'^[a-zA-Z0-9-/]+$');
//     // final allowedCharacters = RegExp(r'^[a-zA-Z-./]*$');

//     if (value.isEmpty) {
//       return 'This can not be empty';
//     } else if (!value.trim().contains(validCharacters) || value.trim().contains(emoji)) {
//       return 'Invalid character';
//     } else {
//       return null;
//     }
//   }

//   static String? validateGeneralField(String? value) {
//     if (value!.isEmpty) {
//       return 'This cannot be empty';
//     } else {
//       return null;
//     }
//   }

//   static String? validateMandatoryField(String? value) {
//     final emoji = RegExp(regexToRemoveEmoji);
//     final validCharacters = RegExp(r'^[a-zA-Z0-9`/, ]+$');

//     if (value!.isEmpty) {
//       return 'This cannot be empty';
//     } else {
//       if (!value.trim().contains(validCharacters) || value.trim().contains(emoji)) {
//         return 'Invalid character';
//       } else {
//         return null;
//       }
//     }
//   }

//   static String? validateFieldMandatory(String? value) {
//     final emoji = RegExp(regexToRemoveEmoji);
//     final validCharacters = RegExp(r'^[a-zA-Z0-9`/, ]+$');

//     if (value!.isEmpty) {
//       return 'This cannot be empty';
//     } else {
//       if (!value.trim().contains(validCharacters) || value.trim().contains(emoji)) {
//         return 'Invalid character';
//       } else {
//         return null;
//       }
//     }
//   }

//   static String? validateField(String? value) {
//     final emoji = RegExp(regexToRemoveEmoji);
//     final validCharacters = RegExp(r'^[a-zA-Z0-9`/., ]+$');

//     if (value!.isEmpty) {
//       return null;
//     } else {
//       if (!value.trim().contains(validCharacters) || value.trim().contains(emoji)) {
//         return 'Invalid character';
//       } else {
//         return null;
//       }
//     }
//   }

//   static String? validateOptionalTextNumberField(String value) {
//     final emoji = RegExp(regexToRemoveEmoji);
//     final validCharacters = RegExp(r'^[a-zA-Z0-9-/,? ]+$');
//     // final allowedCharacters = RegExp(r'^[a-zA-Z-./]*$');

//     if (value.isEmpty) {
//       return null;
//     } else if (!value.trim().contains(validCharacters) || value.trim().contains(emoji)) {
//       return 'Invalid character';
//     } else {
//       return null;
//     }
//   }

//   static String? validateOptionalNumberField(String? value) {
//     final emoji = RegExp(regexToRemoveEmoji);
//     final validCharacters = RegExp(r'^[0-9]+$');

//     if (value!.isEmpty) {
//       return null;
//     } else {
//       if (!value.trim().contains(validCharacters) || value.trim().contains(emoji)) {
//         return 'Invalid character';
//       } else {
//         return null;
//       }
//     }
//   }
// }
