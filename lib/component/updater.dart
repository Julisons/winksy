// pubspec.yaml dependencies:
// package_info_plus: ^4.2.0
// url_launcher: ^6.2.1
// http: ^1.1.0

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class AppUpdateChecker {
  static const String _playStoreBaseUrl = 'https://play.google.com/store/apps/details?id=';

  // Check for app updates
  static Future<bool> checkForUpdate(String packageName) async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version;

      final playStoreVersion = await _getPlayStoreVersion(packageName);

      if (playStoreVersion != null) {
        return _isVersionGreater(playStoreVersion, currentVersion);
      }

      return false;
    } catch (e) {
      debugPrint('Error checking for updates: $e');
      return false;
    }
  }

  // Get version from Play Store
  static Future<String?> _getPlayStoreVersion(String packageName) async {
    try {
      final url = '$_playStoreBaseUrl$packageName';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // Parse HTML to extract version
        final body = response.body;
        final versionMatch = RegExp(r'Current Version</div><span class="htlgb"><div class="IQ1z0d"><span class="htlgb">([^<]+)</span>')
            .firstMatch(body);

        if (versionMatch != null) {
          return versionMatch.group(1)?.trim();
        }

        // Alternative regex pattern
        final altVersionMatch = RegExp(r'"softwareVersion":"([^"]+)"')
            .firstMatch(body);

        if (altVersionMatch != null) {
          return altVersionMatch.group(1)?.trim();
        }
      }

      return null;
    } catch (e) {
      debugPrint('Error fetching Play Store version: $e');
      return null;
    }
  }

  // Compare version strings
  static bool _isVersionGreater(String newVersion, String currentVersion) {
    List<int> newV = newVersion.split('.').map(int.parse).toList();
    List<int> currentV = currentVersion.split('.').map(int.parse).toList();

    int maxLength = newV.length > currentV.length ? newV.length : currentV.length;

    for (int i = 0; i < maxLength; i++) {
      int newVal = i < newV.length ? newV[i] : 0;
      int currentVal = i < currentV.length ? currentV[i] : 0;

      if (newVal > currentVal) return true;
      if (newVal < currentVal) return false;
    }

    return false;
  }

  // Launch Play Store
  static Future<void> launchPlayStore(String packageName) async {
    final url = '$_playStoreBaseUrl$packageName';
    final uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch Play Store';
    }
  }
}

class UpdateDialog extends StatelessWidget {
  final String packageName;
  final bool forceUpdate;
  final VoidCallback? onUpdateLater;

  const UpdateDialog({
    Key? key,
    required this.packageName,
    this.forceUpdate = false,
    this.onUpdateLater,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => !forceUpdate,
      child: AlertDialog(
        title: const Text('Update Available'),
        content: const Text(
          'A new version of the app is available. Please update to continue using the app with the latest features and improvements.',
        ),
        actions: [
          if (!forceUpdate)
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onUpdateLater?.call();
              },
              child: const Text('Later'),
            ),
          ElevatedButton(
            onPressed: () async {
              try {
                await AppUpdateChecker.launchPlayStore(packageName);
                if (forceUpdate) {
                  // Exit app after launching Play Store for forced updates
                  SystemNavigator.pop();
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error opening Play Store: $e')),
                );
              }
            },
            child: const Text('Update Now'),
          ),
        ],
      ),
    );
  }
}

class AppUpdateManager {
  static Future<void> checkAndShowUpdateDialog(
      BuildContext context,
      String packageName, {
        bool forceUpdate = false,
        VoidCallback? onUpdateLater,
      }) async {
    final hasUpdate = await AppUpdateChecker.checkForUpdate(packageName);

    if (hasUpdate) {
      showDialog(
        context: context,
        barrierDismissible: !forceUpdate,
        builder: (context) => UpdateDialog(
          packageName: packageName,
          forceUpdate: forceUpdate,
          onUpdateLater: onUpdateLater,
        ),
      );
    }
  }
}

// Usage Example in main app
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _checkForUpdates();
  }

  void _checkForUpdates() async {
    // Wait a bit for the app to initialize
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      // Replace with your actual package name
      const packageName = 'com.example.yourapp';

      await AppUpdateManager.checkAndShowUpdateDialog(
        context,
        packageName,
        forceUpdate: true, // Set to false for optional updates
        onUpdateLater: () {
          // Handle when user chooses to update later
          debugPrint('User chose to update later');
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('App Update Demo'),
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('App Update Checker Demo'),
              SizedBox(height: 20),
              Text('Check console for update status'),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            const packageName = 'com.example.yourapp';
            await AppUpdateManager.checkAndShowUpdateDialog(
              context,
              packageName,
              forceUpdate: false,
            );
          },
          child: const Icon(Icons.system_update),
        ),
      ),
    );
  }
}

// Alternative implementation using in_app_update package (more reliable)
// Add to pubspec.yaml: in_app_update: ^4.2.2

/*
import 'package:in_app_update/in_app_update.dart';

class InAppUpdateChecker {
  static Future<void> checkForUpdate() async {
    try {
      final info = await InAppUpdate.checkForUpdate();

      if (info.updateAvailability == UpdateAvailability.updateAvailable) {
        // For immediate updates (force update)
        await InAppUpdate.performImmediateUpdate();

        // OR for flexible updates (optional update)
        // await InAppUpdate.startFlexibleUpdate();
      }
    } catch (e) {
      debugPrint('Error checking for in-app updates: $e');
    }
  }
}
*/