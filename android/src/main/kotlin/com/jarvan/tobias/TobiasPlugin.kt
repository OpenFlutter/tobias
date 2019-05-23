package com.jarvan.tobias

import com.alipay.sdk.app.AuthTask
import com.alipay.sdk.app.EnvUtils
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import com.alipay.sdk.app.PayTask
import com.alipay.sdk.auth.AlipaySDK
import com.alipay.sdk.auth.AlipaySDK.auth
import kotlinx.coroutines.*


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
            call.method == "version" -> version(result)
            call.method == "pay" -> pay(call, result)
            call.method == "auth" -> auth(call, result)
            call.method == "pay_in_sand_box" -> payInSandBox(call, result)
            else -> result.notImplemented()
        }

    }

    private fun pay(call: MethodCall, result: Result) {
        GlobalScope.launch(Dispatchers.Main, CoroutineStart.DEFAULT) {
            val payResult = doPayTask(call.arguments as String)
            result.success( payResult.plus( "platform" to "android"))
        }
    }

    private fun payInSandBox(call: MethodCall, result: Result) {
        EnvUtils.setEnv(EnvUtils.EnvEnum.SANDBOX)
        GlobalScope.launch(Dispatchers.Main, CoroutineStart.DEFAULT) {
            val payResult = doPayTask(call.arguments as String)
            result.success( payResult.plus( "platform" to "android"))
        }
    }


    private suspend fun doPayTask(orderInfo: String): Map<String, String> {

        return GlobalScope.async(Dispatchers.Default, CoroutineStart.DEFAULT) {
            val alipay = PayTask(registrar.activity())
            alipay.payV2(orderInfo, true) ?: mapOf<String, String>()
        }.await()
    }


    private fun auth(call: MethodCall, result: Result){
        GlobalScope.launch(Dispatchers.Main, CoroutineStart.DEFAULT) {
            val authResult = doAuthTask(call.arguments as String)
            result.success( authResult.plus( "platform" to "android"))
        }
    }

    private suspend fun doAuthTask(authInfo: String): Map<String, String> {

        return GlobalScope.async(Dispatchers.Default, CoroutineStart.DEFAULT) {
            val alipay = AuthTask(registrar.activity())
            alipay.authV2(authInfo,true)?: mapOf<String,String>()
        }.await()
    }


    private fun version( result: Result) {
        GlobalScope.launch(Dispatchers.Main, CoroutineStart.DEFAULT) {
            val version = doGetVersionTask()
            result.success(mapOf(
                    "platform" to "android",
                    "version" to version
            ))
        }
    }

    private suspend fun doGetVersionTask(): String {

        return GlobalScope.async(Dispatchers.Default, CoroutineStart.DEFAULT) {
            val alipay = PayTask(registrar.activity())
            alipay.version ?: ""
        }.await()
    }
}
