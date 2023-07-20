package wu.pei.cheng.card_book_flutter

import android.R.attr.data
import android.content.Intent
import android.net.Uri
import android.os.ParcelFileDescriptor
import android.provider.DocumentsContract
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.BufferedReader
import java.io.FileOutputStream
import java.io.InputStreamReader
import java.lang.reflect.Method


class MainActivity : FlutterActivity() {
    private val CHANNEL = "package/Main"

    private var pendingResult: MethodChannel.Result? = null

    private var methodCall: MethodCall? = null

    private var dataString: String? = null

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->
            val handlers = mapOf(
                "writeFile" to ::createFile,
            )
            if (call.method in handlers) {
                handlers[call.method]!!.invoke(call, result)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun createFile(call: MethodCall, result: MethodChannel.Result) {
        dataString = call.arguments()
        val pickerInitialUri =
            Uri.parse("")
        val intent = Intent(Intent.ACTION_CREATE_DOCUMENT).apply {
            addCategory(Intent.CATEGORY_OPENABLE)
            type = "application/*"
            putExtra(Intent.EXTRA_TITLE,"FlutterSharedPreferences.xml")

            // Optionally, specify a URI for the directory that should be opened in
            // the system file picker before your app creates the document.
            putExtra(DocumentsContract.EXTRA_INITIAL_URI, pickerInitialUri)
        }
        startActivityForResult(intent, 1)
    }

    private fun readFileContent(uri: Uri): String {

        val inputStream = contentResolver.openInputStream(uri)
        val reader = BufferedReader(
            InputStreamReader(
                inputStream
            )
        )
        val stringBuilder = StringBuilder()


        var currentline = reader.readLine()

        while (currentline != null) {
            stringBuilder.append(currentline + "\n")
            currentline = reader.readLine()
        }
        inputStream?.close()
        return stringBuilder.toString()
    }

    private fun writeFileContent(uri: Uri) {
        var success = false

        try {
            val pfd: ParcelFileDescriptor? = contentResolver.openFileDescriptor(uri, "w")
            if (pfd != null) {
                val fileOutputStream = FileOutputStream(pfd.fileDescriptor)
//                val dataString = readFileContent(Uri.parse("/data/data/wu.pei.cheng.card_book_flutter/shared_prefs/FlutterSharedPreferences.xml"))
                fileOutputStream.write(dataString?.toByteArray())
                fileOutputStream.close()
                success = true
            }
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)

        data?.let {
            var currentUri = it.data
            if (currentUri != null) {
                writeFileContent(currentUri)
            }
        }

    }
}
