package com.smartchef.smart_chef

import android.content.Intent
import android.os.Bundle
import androidx.core.view.WindowCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        // Tell the window to lay out behind the system bars (edge-to-edge).
        // This must happen before Flutter draws its first frame so that
        // MediaQuery.viewPadding.bottom correctly reflects the nav-bar height.
        WindowCompat.setDecorFitsSystemWindows(window, false)
        super.onCreate(savedInstanceState)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "com.smartchef/keep"
        ).setMethodCallHandler { call, result ->
            if (call.method == "createChecklist") {
                val title = call.argument<String>("title") ?: ""
                val items = call.argument<List<String>>("items") ?: emptyList()

                val checklistText = items.joinToString("\n") { "- [ ] $it" }

                val intent = Intent(Intent.ACTION_SEND).apply {
                    type = "text/plain"
                    setPackage("com.google.android.keep")
                    putExtra(Intent.EXTRA_SUBJECT, title)
                    putExtra(Intent.EXTRA_TEXT, checklistText)
                }

                try {
                    startActivity(intent)
                    result.success(true)
                } catch (e: Exception) {
                    result.success(false) // Keep not installed
                }
            } else {
                result.notImplemented()
            }
        }
    }
}
