package ir.cyren.winksy

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.content.pm.PackageManager

class MainActivity: FlutterActivity() {
    private val CHANNEL = "app_version_channel"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "getVersionInfo" -> {
                    try {
                        val packageInfo = packageManager.getPackageInfo(packageName, 0)
                        val versionInfo = mapOf(
                            "versionName" to packageInfo.versionName,
                            "versionCode" to packageInfo.versionCode.toString(),
                            "packageName" to packageName,
                            "appName" to applicationInfo.loadLabel(packageManager).toString()
                        )
                        result.success(versionInfo)
                    } catch (e: PackageManager.NameNotFoundException) {
                        result.error("VERSION_ERROR", "Could not get version info", e.localizedMessage)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }
}
