import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:m2health/const.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'core/presentation/views/pdf_screen.dart';
import 'package:share_plus/share_plus.dart';

class Utils {
  // start SP utils
  static Future<void> setProfile(profile) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(profile.toJson());
    await prefs.setString(Const.OBJ_PROFILE, jsonString);
    // print('cekProfile stored: $jsonString');
  }

  // static Future<rProfile?> getProfile() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final jsonString = prefs.getString(Const.OBJ_PROFILE);
  //   if (jsonString != null) {
  //     final userMap = jsonDecode(jsonString);
  //     return rProfile.fromJson(userMap);
  //   }
  //   return null;
  // }

  // Save a boolean value with the given key to SharedPreferences.
  static Future<bool> setSpBool(String key, bool value) async {
    try {
      final prefs = await getPreferencesInstance();
      return prefs.setBool(key, value);
    } catch (e) {
      debugPrint("Error saving boolean: $e");
      return false;
    }
  }

  // Save an integer value with the given key to SharedPreferences.
  static Future<bool> setSpInt(String key, int value) async {
    try {
      final prefs = await getPreferencesInstance();
      return prefs.setInt(key, value);
    } catch (e) {
      debugPrint("Error saving integer: $e");
      return false;
    }
  }

  // Save a double value with the given key to SharedPreferences.
  static Future<bool> setSpDouble(String key, double value) async {
    try {
      final prefs = await getPreferencesInstance();
      return prefs.setDouble(key, value);
    } catch (e) {
      debugPrint("Error saving double: $e");
      return false;
    }
  }

  // Save a string value with the given key to SharedPreferences.
  static Future<bool> setSpString(String key, String value) async {
    try {
      final prefs = await getPreferencesInstance();
      return prefs.setString(key, value);
    } catch (e) {
      debugPrint("Error saving string: $e");
      return false;
    }
  }

  // Save a list of strings with the given key to SharedPreferences.
  static Future<bool> setSpStringList(String key, List<String> value) async {
    try {
      final prefs = await getPreferencesInstance();
      return prefs.setStringList(key, value);
    } catch (e) {
      debugPrint("Error saving string list: $e");
      return false;
    }
  }

  // Retrieve a boolean value with the given key from SharedPreferences.
  static Future<bool?> getSpBool(String key) async {
    try {
      final prefs = await getPreferencesInstance();
      return prefs.getBool(key);
    } catch (e) {
      debugPrint("Error retrieving boolean: $e");
      return null;
    }
  }

  // Retrieve an integer value with the given key from SharedPreferences.
  static Future<int?> getSpInt(String key) async {
    try {
      final prefs = await getPreferencesInstance();
      return prefs.getInt(key);
    } catch (e) {
      debugPrint("Error retrieving integer: $e");
      return null;
    }
  }

  // Retrieve a double value with the given key from SharedPreferences.
  static Future<double?> getSpDouble(String key) async {
    try {
      final prefs = await getPreferencesInstance();
      return prefs.getDouble(key);
    } catch (e) {
      debugPrint("Error retrieving double: $e");
      return null;
    }
  }

  // Retrieve a string value with the given key from SharedPreferences.
  static Future<String?> getSpString(String key) async {
    try {
      final prefs = await getPreferencesInstance();
      return prefs.getString(key);
    } catch (e) {
      debugPrint("Error retrieving string: $e");
      return null;
    }
  }

  // Retrieve a list of strings with the given key from SharedPreferences.
  static Future<List<String>?> getSpStringList(String key) async {
    try {
      final prefs = await getPreferencesInstance();
      return prefs.getStringList(key);
    } catch (e) {
      debugPrint("Error retrieving string list: $e");
      return null;
    }
  }

  // get Loged in
  static Future<bool> isUserLoggedIn() async {
    final prefs = await getPreferencesInstance();
    bool isLoggedIn = prefs.getBool(Const.IS_LOGED_IN) ?? false;
    return isLoggedIn;
  }

  // Remove data associated with the given key from SharedPreferences.
  static Future<void> removeSp(String key) async {
    try {
      final prefs = await getPreferencesInstance();
      await prefs.remove(key);
    } catch (e) {
      debugPrint("Error removing data: $e");
    }
  }

  // Clear all data from SharedPreferences.
  static Future<void> clearSp() async {
    try {
      final prefs = await getPreferencesInstance();
      await prefs.clear();
    } catch (e) {
      debugPrint("Error clearing data: $e");
    }
  }

  // Get an instance of SharedPreferences.
  static Future<SharedPreferences> getPreferencesInstance() async {
    return await SharedPreferences.getInstance();
  }
  // end SP Utils

  /// Checks whether the user has accepted the AI assistant data consent.
  static Future<bool> hasAcceptedAiConsent() async {
    final result = await getSpBool(Const.AI_CONSENT_ACCEPTED);
    return result ?? false;
  }

  /// Stores the user's AI assistant data consent acceptance.
  static Future<void> setAiConsentAccepted(bool accepted) async {
    await setSpBool(Const.AI_CONSENT_ACCEPTED, accepted);
  }

  // static void myLog(String message) {
  //   final pattern = RegExp('.{1,800}');
  //   pattern.allMatches(message).forEach((match) => print(match.group(0)));
  // }

  static void shareUrl(String url) {
    Share.share(url, subject: 'SHARE');
  }

  static void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  static Future<void> launchURL(BuildContext context, String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      try {
        await launch(url, forceSafariVC: false, forceWebView: false);
      } catch (e) {
        showSnackBar(context, '$e , Could not launch $url');
      }
    }
  }

  static Future<File> pdfFetch(String url) async {
    final response = await http.get(Uri.parse(url));
    final bytes = response.bodyBytes;
    return pdfStoreFile(url, bytes);
  }

  static Future<File> pdfStoreFile(String url, List<int> bytes) async {
    final filename = basename(url);
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/$filename');
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }

  static void openPDF(BuildContext context, String url) async {
    try {
      final file = await pdfFetch(url);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => PDFScreen(path: file.path),
        ),
      );
    } catch (e) {
      // Handle errors
      print(e.toString());
    }
  }

  static void openPDFFromAssets(BuildContext context, String assetPath) async {
    try {
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/${basename(assetPath)}');
      final ByteData byteData = await rootBundle.load(assetPath);
      final List<int> bytes = byteData.buffer.asUint8List();
      await file.writeAsBytes(bytes, flush: true);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => PDFScreen(path: file.path),
        ),
      );
    } catch (e) {
      // Handle errors
      print(e.toString());
    }
  }

  static String trimString(String? text) {
    int maxChars = 40;
    if (text != null) {
      if (text.length > maxChars) {
        return text.substring(0, maxChars) + ' ...';
      } else {
        return text;
      }
    } else {
      return 'Not Available';
    }
  }

  static String fmtToDMY(String? str) {
    if (str != null) {
      DateTime date = DateTime.parse(str);
      String formattedDate = DateFormat('dd MMM yyyy hh:mm:ss').format(date);
      return formattedDate;
    } else {
      return 'Not Available';
    }
  }
}

abstract class StringValidator {
  ValidationResult validate(String value);
}

RegExp _emailRegExp = RegExp(
  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
);

class ValidationResult {
  ValidationResult({this.isValid = false, this.text});
  final bool isValid;
  final String? text;
}

class EmailValidator implements StringValidator {
  EmailValidator(this.label);
  final String label;

  @override
  ValidationResult validate(String value, {List<String>? targets}) {
    if (value.isEmpty) {
      return ValidationResult(text: 'Please enter $label');
    }

    if (!_emailRegExp.hasMatch(value)) {
      return ValidationResult(text: 'Please enter the correct $label');
    }

    return ValidationResult(isValid: true);
  }
}

// String getImageUrl(String imageUrl) {
//   if (Const.BASE_URL.contains('localhost')) {
//     return imageUrl.replaceFirst(
//         'https://homecare-api.med-map.org', 'http://localhost:3334');
//   }
//   return imageUrl;
// }

// String getImageUrl(String imageUrl) {
//   if (imageUrl.contains('localhost:3334')) {
//     return imageUrl.replaceFirst(
//         'http://localhost:3334', 'https://homecare-api.med-map.org');
//   } else if (imageUrl.contains('localhost:3333')) {
//     return imageUrl.replaceFirst(
//         'http://localhost:3333', 'https://homecare-api.med-map.org');
//   }
//   return imageUrl;
// }
