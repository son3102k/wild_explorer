package vn.wx.wild_explorer
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.os.Build
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.pytorch.IValue
import org.pytorch.LiteModuleLoader
import org.pytorch.Module
import org.pytorch.torchvision.TensorImageUtils
import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {
    private val PYTORCH_CHANNEL = "pytorch_channel"

    private var modelPath: String? = null
    private var dataLength: Int? = null
    private var imageData: ByteArray? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
                flutterEngine.dartExecutor.binaryMessenger,
                PYTORCH_CHANNEL
        ).setMethodCallHandler { call: MethodCall, result: MethodChannel.Result ->
            when(call.method) {
                "image_classification" -> {
                    var bitmap: Bitmap? = null
                    var module: Module? = null
                    try {
                        modelPath = call.argument<String>("modelPath")
                        imageData = call.argument<ByteArray>("imageData")
                        dataLength = call.argument<Int>("dataLength")

                        bitmap = BitmapFactory.decodeByteArray(imageData, 0, dataLength!!)
                        bitmap = Bitmap.createScaledBitmap(bitmap, 224, 224, true)

                        module = LiteModuleLoader.load(modelPath)
                    } catch (e: Exception) {
                        result.error("An error occurs", "Error at pytorch channel", null)
                    }

                    var inputTensor = TensorImageUtils.bitmapToFloat32Tensor(
                        bitmap,
                        TensorImageUtils.TORCHVISION_NORM_MEAN_RGB,
                        TensorImageUtils.TORCHVISION_NORM_STD_RGB
                    )

                    var output = module?.forward(IValue.from(inputTensor))?.toTensor()
                    var outputFloatArray = output?.dataAsFloatArray
                    result.success(outputFloatArray)
                }
                else -> result.notImplemented()
            }
        }
    }
}
