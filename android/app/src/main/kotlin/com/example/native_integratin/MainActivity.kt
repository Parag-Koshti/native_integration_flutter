package com.example.native_integratin

import android.os.Bundle
import android.widget.Toast
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val channelName = "Hello"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        val channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)
        channel.setMethodCallHandler { call, result ->
            when (call.method) {
                "proccessData" -> {
                    val name = call.argument<String>("name")
                    val phone = call.argument<String>("phone")
                    val processedData = processData(name, phone)
                    result.success(processedData)
                }
                "showToast" -> {
                    val message = call.argument<String>("message")
                    showToast(message)
                    result.success(null)
                }
                "showData"->{
                    val name = call.argument<String>("name")
                    val phone = call.argument<String>("phone")
                    showData(name,phone)
                }

                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun processData(name: String?, phone: String?): String {
        return "Processed Name: $name, Processed Phone: $phone"

    }

    private fun showToast(message: String?) {
        Toast.makeText(applicationContext, message, Toast.LENGTH_SHORT).show()
    }
    private fun showData(name: String?,phone: String?) {
        var message = "name:$name phone:$phone"
        Toast.makeText(applicationContext, message, Toast.LENGTH_LONG).show()
    }

}
