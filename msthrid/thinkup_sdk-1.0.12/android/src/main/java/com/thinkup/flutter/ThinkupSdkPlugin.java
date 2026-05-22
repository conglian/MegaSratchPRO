package com.thinkup.flutter;

import androidx.annotation.NonNull;

import com.thinkup.flutter.utils.FlutterPluginUtil;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;

/**
 * ThinkupSdkPlugin
 */
public class ThinkupSdkPlugin implements FlutterPlugin, ActivityAware {

    private FlutterPlugin.FlutterPluginBinding pluginBinding;

    /**
     * <p>Channel recovery when Activity re-attaches or configuration changes.</p>
     * <p>Re-initialize with {@link TUFlutterEventManager#init} using saved {@link FlutterPlugin.FlutterPluginBinding}.</p>
     * <p>Use {@link TUFlutterEventManager#releaseForMessenger} in {@link #onDetachedFromEngine} so multiple engines do not clear the wrong channel.</p>
     */
    @Override
    public void onAttachedToEngine(@NonNull FlutterPlugin.FlutterPluginBinding flutterPluginBinding) {
        this.pluginBinding = flutterPluginBinding;
        TUFlutterEventManager.getInstance().init(flutterPluginBinding.getBinaryMessenger());
        TUPlatformViewManager.getInstance().init(flutterPluginBinding);
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPlugin.FlutterPluginBinding binding) {
        TUFlutterEventManager.getInstance().releaseForMessenger(binding.getBinaryMessenger());
        this.pluginBinding = null;
    }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding activityPluginBinding) {
        FlutterPluginUtil.setActivity(activityPluginBinding.getActivity());
        ensureMethodChannelIfNeeded();
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {

    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding activityPluginBinding) {
        FlutterPluginUtil.setActivity(activityPluginBinding.getActivity());
        ensureMethodChannelIfNeeded();
    }

    @Override
    public void onDetachedFromActivity() {

    }

    private void ensureMethodChannelIfNeeded() {
        if (TUFlutterEventManager.getInstance().isChannelAvailable()) {
            return;
        }
        if (pluginBinding != null) {
            TUFlutterEventManager.getInstance().init(pluginBinding.getBinaryMessenger());
        }
    }
}
