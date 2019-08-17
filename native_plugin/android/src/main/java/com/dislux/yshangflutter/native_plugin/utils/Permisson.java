package com.dislux.yshangflutter.native_plugin.utils;

import android.app.Activity;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.support.v4.app.ActivityCompat;
import android.support.v4.content.ContextCompat;
import android.util.Log;

import com.tbruyelle.rxpermissions2.RxPermissions;

import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

public class Permisson implements PluginRegistry.ActivityResultListener, PluginRegistry.RequestPermissionsResultListener {

    private final Activity activity;
    MethodChannel.Result result;
    private PermissionCallBack callBack;

    public Permisson(Activity activity) {
        this.activity=activity;
    }

    public boolean checkPermission(MethodChannel.Result result, String permissionName){
        this.result=result;
        int code = ContextCompat.checkSelfPermission(activity, permissionName);
        if(code==PackageManager.PERMISSION_GRANTED){
            return true;
        }
        return false;
    }

    public void requestPermission(String permissionName){
        ActivityCompat.requestPermissions(activity,new String[]{permissionName},10);
    }

    public boolean shouldShowRequestPermissionRationale(String permissionName){
      return ActivityCompat.shouldShowRequestPermissionRationale(activity,permissionName);
    }

    public void requestPermissions(String[] permissions){
        ActivityCompat.requestPermissions(activity,permissions,10);
    }

    @Override
    public boolean onActivityResult(int i, int i1, Intent intent) {
        return false;
    }


    @Override
    public boolean onRequestPermissionsResult(int reqCode, String[] permissions, int[] grantResults) {
        boolean result=false;
        if(permissions.length == 1){
            if (grantResults[0] == PackageManager.PERMISSION_GRANTED) {//成功
                result= true;
            }
        }else {
            result=true;
            for(int code:grantResults){
                if(code==  PackageManager.PERMISSION_DENIED){
                    result=false;
                    break;
                }
            }
        }
        if(callBack!=null){
             callBack.onResult(result);
        }
        return result;
    }

    public void setOnPermissionCallBack(PermissionCallBack callBack){
        this.callBack=callBack;
    }

    interface  PermissionCallBack {
        void onResult(boolean result);
    }
}
