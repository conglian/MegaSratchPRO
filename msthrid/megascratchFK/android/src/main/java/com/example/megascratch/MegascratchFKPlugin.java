package com.example.megascratch;

import android.content.Context;

import androidx.annotation.NonNull;

import java.util.Map;

import cn.shuzilm.core.Listener;
import cn.shuzilm.core.Main;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

public class MegascratchFKPlugin implements FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;
  private Context context;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "megascratchFK");
    channel.setMethodCallHandler(this);
    context = flutterPluginBinding.getApplicationContext();
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    final String method = call.method;
    //TODO:修改下面所有的方法名
    switch (method) {
      case "ms_root":
        result.success(BoRiskUtils.isAbnormalEnv() || BoRiskUtils.isXposed());
        break;
      case "ms_vpn":
        result.success(BoRiskUtils.isVpn());
        break;
      case "ms_sim":
        result.success(BoRiskUtils.isSim(context));
        break;
      case "ms_simulator":
        result.success(BoRiskUtils.isEmulator() || BoRiskUtils.isEmulator2());
        break;
      case "ms_store":
        result.success("com.android.vending".contentEquals(BoRiskUtils.getInstaller(context)));
        break;
      case "ms_developer":
        result.success(BoRiskUtils.isDevModel(context) || BoRiskUtils.isDebug(context));
        break;
      case "ms_installer":
        result.success(BoRiskUtils.getInstaller(context));
        break;
      case "ms_initNumberUnit":
        Main.init(context, (String)call.arguments, false);
        result.success(true);
        break;
      case "ms_getNumberUnitID":
        final Map<String, String> arguments = (Map<String, String>)call.arguments;
        Main.getQueryID(context, arguments.get("channel"), arguments.get("message"), false, new Listener() {
          @Override
          public void handler(String s) {
            result.success(s);
          }
        });
        break;
      default:
        result.notImplemented();
        break;
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }
}
