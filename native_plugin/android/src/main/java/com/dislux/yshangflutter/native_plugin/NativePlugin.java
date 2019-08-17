package com.dislux.yshangflutter.native_plugin;

import android.app.Activity;
import android.app.Application;

import com.dislux.yshangflutter.native_plugin.utils.DownLoadUtils;
import com.dislux.yshangflutter.native_plugin.utils.Permisson;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * NativePlugin
 */
public class NativePlugin implements MethodCallHandler {
    static Permisson permisson;
    private static Application application;
    static MethodChannel channel;
    static Registrar registrar;

    /**
     * Plugin registration.
     */
    public static void registerWith(Registrar registrar) {
        NativePlugin.registrar=registrar;
        channel = new MethodChannel(registrar.messenger(), "com.dislux.yshangflutter.native_plugin");
        Activity activity = registrar.activity();
        channel.setMethodCallHandler(new NativePlugin());
        application = activity.getApplication();
        permisson = new Permisson(activity);
        registrar.addActivityResultListener(permisson);
        registrar.addRequestPermissionsResultListener(permisson);
    }

    @Override
    public void onMethodCall(MethodCall call, Result result) {
        switch (call.method) {
            case "downloadApk":
                DownLoadUtils.downLoadApk(registrar.activity(), call.arguments.toString(),permisson,result);
                break;
            default:
                result.notImplemented();
        }
    }

    public static void showToast(String msg){
        channel.invokeMethod("showToast",msg);
    }

}
