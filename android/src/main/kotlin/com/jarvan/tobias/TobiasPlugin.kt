package com.jarvan.tobias

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import kotlinx.coroutines.experimental.CommonPool
import kotlinx.coroutines.experimental.async
import com.alipay.sdk.app.PayTask
import kotlinx.coroutines.experimental.android.UI
import kotlinx.coroutines.experimental.launch


class TobiasPlugin(private var registrar: Registrar) : MethodCallHandler {
    companion object {
        @JvmStatic
        fun registerWith(registrar: Registrar): Unit {
            val channel = MethodChannel(registrar.messenger(), "com.jarvanmo/tobias")
            channel.setMethodCallHandler(TobiasPlugin(registrar))
        }
    }

    override fun onMethodCall(call: MethodCall, result: Result): Unit {
        when {
            call.method == "version" -> version(call, result)
            call.method == "pay" -> pay(call, result)
            else -> result.notImplemented()
        }

    }

    private fun pay(call: MethodCall, result: Result) {

        launch(UI) {
            val payResult = doPayTask(call.arguments as String)
            result.success( payResult.plus( "platform" to "android"))
        }
    }

    private suspend fun doPayTask(orderInfo: String): Map<String, String> {

        return async(CommonPool) {
            val alipay = PayTask(registrar.activity())
            alipay.payV2(orderInfo, true) ?: mapOf<String, String>()
        }.await()
    }

    private fun version(call: MethodCall, result: Result) {
        launch(UI) {
            val version = doGetVersionTask()
            result.success(mapOf(
                    "platform" to "android",
                    "version" to version
            ))
        }
    }

    private suspend fun doGetVersionTask(): String {

        return async(CommonPool) {
            val alipay = PayTask(registrar.activity())
            alipay.version ?: ""
        }.await()
    }
}
