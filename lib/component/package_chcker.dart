import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';

class PlayStoreVersionChecker {
  /// Gets the current version of an app from Google Play Store
  /// 
  /// [packageName] - The package name of the app (e.g., 'com.whatsapp')
  /// 
  /// Returns the version string if found, null if not found or error occurs
  static Future<String?> getPlayStoreVersion() async {
    try {
      final url = 'https://play.google.com/store/apps/details?id=ir.cyren.winksy&gl=US';

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
        },
      );

      if (response.statusCode == 200) {
        final document = html_parser.parse(response.body);

        // Look for version information in the page
        final scripts = document.querySelectorAll('script');

        for (final script in scripts) {
          final scriptContent = script.text;
          if (scriptContent.contains('Current Version')) {
            // Extract version using regex
            final versionRegex = RegExp(r'Current Version.*?(\d+(?:\.\d+)+)');
            final match = versionRegex.firstMatch(scriptContent);
            if (match != null) {
              return match.group(1);
            }
          }

          // Alternative approach - look for version in app data
          if (scriptContent.contains('ir.cyren.winksy')) {
            final versionRegex = RegExp(r'"(\d+(?:\.\d+)+)"');
            final matches = versionRegex.allMatches(scriptContent);
            for (final match in matches) {
              final version = match.group(1);
              if (version != null && _isValidVersion(version)) {
                return version;
              }
            }
          }
        }

        // Fallback: look in meta tags or other elements
        final elements = document.querySelectorAll('[data-g-label="Version"]');
        for (final element in elements) {
          final text = element.text.trim();
          final versionRegex = RegExp(r'(\d+(?:\.\d+)+)');
          final match = versionRegex.firstMatch(text);
          if (match != null) {
            return match.group(1);
          }
        }
      }
    } catch (e) {
      print('Error fetching Play Store version: $e');
    }

    return null;
  }

  /// Validates if a string looks like a valid version number
  static bool _isValidVersion(String version) {
    final parts = version.split('.');
    if (parts.length < 2) return false;

    for (final part in parts) {
      if (int.tryParse(part) == null) return false;
    }

    return true;
  }

  /// Alternative method using a third-party API service
  /// Note: This requires an API key from a service like AppMonsta or similar
  static Future<String?> getVersionFromAPI(String packageName, String apiKey) async {
    try {
      final url = 'https://api.appmonsta.com/v1/stores/android/details/$packageName.json';

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $apiKey',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['version'];
      }
    } catch (e) {
      print('Error fetching version from API: $e');
    }

    return null;
  }


  /// Gets the current app version using native platform channels
  /// No external dependencies required - uses Flutter's built-in platform channels
 static Future<Map<String, String?>> getCurrentAppVersion() async {
    try {
      if (Platform.isAndroid) {
        return await getAndroidVersion();
      } else if (Platform.isIOS) {
        return await getIOSVersion();
      } else {
        throw UnsupportedError('Platform not supported');
      }
    } catch (e) {
      throw Exception('Failed to get app version: $e');
    }
  }

  /// Gets version info for Android using method channels
  static Future<Map<String, String?>> getAndroidVersion() async {
    const platform = MethodChannel('app_version_channel');

    try {
      final Map<dynamic, dynamic> result = await platform.invokeMethod('getVersionInfo');
      return {
        'version': result['versionName']?.toString(),
        'buildNumber': result['versionCode']?.toString(),
        'packageName': result['packageName']?.toString(),
        'appName': result['appName']?.toString(),
      };
    } catch (e) {
      // Fallback: try to get basic info
      return {
        'version': 'Unknown',
        'buildNumber': 'Unknown',
        'packageName': 'Unknown',
        'appName': 'Unknown',
      };
    }
  }

  /// Gets version info for iOS using method channels
  static Future<Map<String, String?>> getIOSVersion() async {
    const platform = MethodChannel('app_version_channel');

    try {
      final Map<dynamic, dynamic> result = await platform.invokeMethod('getVersionInfo');
      return {
        'version': result['version']?.toString(),
        'buildNumber': result['buildNumber']?.toString(),
        'packageName': result['bundleId']?.toString(),
        'appName': result['appName']?.toString(),
      };
    } catch (e) {
      return {
        'version': 'Unknown',
        'buildNumber': 'Unknown',
        'packageName': 'Unknown',
        'appName': 'Unknown',
      };
    }
  }

  /// Simple function to get just the version string
  Future<String> getCurrentVersionString() async {
    final versionInfo = await getCurrentAppVersion();
    return versionInfo['version'] ?? 'Unknown';
  }

  /// Gets full version with build number
  Future<String> getFullVersionString() async {
    final versionInfo = await getCurrentAppVersion();
    final version = versionInfo['version'] ?? 'Unknown';
    final buildNumber = versionInfo['buildNumber'] ?? 'Unknown';
    return '$version ($buildNumber)';
  }
}


class Version {
  final int major;
  final int minor;
  final int patch;

  Version(this.major, this.minor, this.patch);

  factory Version.parse(String version) {
    final parts = version.split('.');
    if (parts.length != 3) {
      throw FormatException('Invalid version format. Use major.minor.patch');
    }

    return Version(
      int.parse(parts[0]),
      int.parse(parts[1]),
      int.parse(parts[2]),
    );
  }

  @override
  String toString() => '$major.$minor.$patch';

  bool operator >(Version other) {
    if (major != other.major) return major > other.major;
    if (minor != other.minor) return minor > other.minor;
    return patch > other.patch;
  }

  bool operator <(Version other) => other > this;

  bool operator ==(Object other) =>
      other is Version &&
          major == other.major &&
          minor == other.minor &&
          patch == other.patch;

  @override
  int get hashCode => Object.hash(major, minor, patch);
}
