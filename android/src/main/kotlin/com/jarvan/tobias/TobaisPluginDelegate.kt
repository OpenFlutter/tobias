package com.jarvan.tobias

import android.app.Activity
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import com.alipay.sdk.app.AlipayApi
import com.alipay.sdk.app.AuthTask
import com.alipay.sdk.app.EnvUtils
import com.alipay.sdk.app.PayTask
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel.Result
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import kotlin.coroutines.CoroutineContext

/***
 * Created by mo on 2020/3/14
 * 冷风如刀，以大地为砧板，视众生为鱼肉。
 * 万里飞雪，将穹苍作烘炉，熔万物为白银。
 **/
class TobaisPluginDelegate : CoroutineScope {
    var activity: Activity? = null
    fun handleMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "registerApp" -> registerApp(call,result)
            "version" -> version(result)
            "pay" -> pay(call, result)
            "auth" -> auth(call, result)
            "isAliPayInstalled" -> isAliPayInstalled(result)
            "isAliPayHKInstalled" -> isAliPayHKInstalled(result)
            else -> result.notImplemented()
        }
    }

    fun cancel() {
        job.cancel()
    }

    private fun pay(call: MethodCall, result: Result) {
        launch {
            if (call.argument<Int>("payEnv") == 1) {
                EnvUtils.setEnv(EnvUtils.EnvEnum.SANDBOX)
            } else {
                EnvUtils.setEnv(EnvUtils.EnvEnum.ONLINE)
            }
            val payResult = doPayTask(
                call.argument("order") ?: "",
                call.argument<Boolean?>("showPayLoading") ?: true
            )
            withContext(Dispatchers.Main) {
                result.success(payResult)
            }
        }
    }

    private suspend fun doPayTask(orderInfo: String, showPayLoading: Boolean): Map<String, String> =
        withContext(Dispatchers.IO) {
            val alipay = PayTask(activity)
            alipay.payV2(orderInfo, showPayLoading) ?: mapOf<String, String>()
        }


    private fun auth(call: MethodCall, result: Result) {
        launch {
            val authResult = doAuthTask(call.arguments as String)
            withContext(Dispatchers.Main) {
                result.success(authResult.plus("platform" to "android"))
            }
        }
    }

    private suspend fun doAuthTask(authInfo: String): Map<String, String> =
        withContext(Dispatchers.IO) {
            val alipay = AuthTask(activity)
            alipay.authV2(authInfo, true) ?: mapOf<String, String>()
        }

    private fun registerApp(call: MethodCall, result: Result) {
        activity?.let {
            val appId: String? = call.argument("appId")
            AlipayApi.registerApp(it,appId)
        }
        result.success(null)
    }

    private fun version(result: Result) {
        launch {
            val version = doGetVersionTask()
            withContext(Dispatchers.Main) {
                result.success(version)
            }
        }
    }

    private fun isAliPayHKInstalled(result: Result) {
        result.success(checkIfInstalledByUri("alipayhk://"))
    }

    private fun isAliPayInstalled(result: Result) {
        result.success(checkIfInstalledByUri("alipays://"))
    }

    private fun checkIfInstalledByUri(uri: String): Boolean {
        val manager = activity?.packageManager
        return if (manager != null) {
            val action = Intent(Intent.ACTION_VIEW)
            action.data = Uri.parse(uri)
            val list = manager.queryIntentActivities(action, PackageManager.GET_RESOLVED_FILTER)
            list.isNotEmpty()
        } else {
            false
        }
    }

    private suspend fun doGetVersionTask(): String = withContext(Dispatchers.IO) {
        val alipay = PayTask(activity)
        alipay.version ?: ""
    }

    val job = Job()

    override val coroutineContext: CoroutineContext = Dispatchers.Main + job
}