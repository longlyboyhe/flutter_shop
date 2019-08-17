package com.dislux.yshangflutter.native_plugin.receiver;

import android.app.DownloadManager;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.text.TextUtils;
import android.util.Log;

import com.dislux.yshangflutter.native_plugin.utils.DownLoadUtils;

public class InstallApkReceiver extends BroadcastReceiver {
    @Override
    public void onReceive(Context context, Intent intent) {
        String action = intent.getAction();
        if(TextUtils.equals(action, DownloadManager.ACTION_DOWNLOAD_COMPLETE)){
            DownLoadUtils.installAPk(context);
        }
    }
}
