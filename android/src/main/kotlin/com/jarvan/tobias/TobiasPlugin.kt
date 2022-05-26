package com.jarvan.tobias

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry

class TobiasPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {

    private val delegate = TobaisPluginDelegate()

    override fun onMethodCall(call: MethodCall, result: Result) =
        delegate.handleMethodCall(call, result)

    companion object {
        /**
         * Plugin registration.
         */
        @SuppressWarnings("deprecation")
        public fun registerWith(registrar: PluginRegistry.Registrar) {
            val instance = TobiasPlugin()
            instance.onAttachedToEngine(registrar.messenger())
        }
    }

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        onAttachedToEngine(binding.binaryMessenger);
    }


    private fun onAttachedToEngine(messenger: BinaryMessenger) {
        val channel = MethodChannel(messenger, "com.jarvanmo/tobias")
        channel.setMethodCallHandler(this)
    }


    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        delegate.cancel()
    }

    override fun onDetachedFromActivity() {
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        delegate.activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
    }

}
