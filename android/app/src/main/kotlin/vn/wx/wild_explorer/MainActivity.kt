package vn.wx.wild_explorer
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.IOException
import java.nio.charset.Charset

class MainActivity: FlutterActivity() {
    private val CHANNEL = "pytorch_channel"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "loadModel") {
                try {
                    val modelData = assets.open("MobileNetV2.ptl").readBytes()
                    result.success(modelData)
                } catch (e: IOException) {
                    result.error("MODEL_NOT_FOUND", "MobileNetV2.ptl not found", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }
  
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
    }
}
