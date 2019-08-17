package com.dislux.yshangflutter.native_plugin.utils;

import android.app.Activity;
import android.app.DownloadManager;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.Build;
import android.os.Environment;
import android.os.StrictMode;
import android.support.v4.content.FileProvider;
import android.text.TextUtils;
import android.widget.Toast;

import com.dislux.yshangflutter.native_plugin.NativePlugin;

import java.io.File;

import io.flutter.plugin.common.MethodChannel;

public class DownLoadUtils {
    /**
     * 该方法是调用了系统的下载管理器
     */
    public static void downLoadApk(final Activity context, final String url, Permisson permisson, MethodChannel.Result result){
        String permissionName = "android.permission.WRITE_EXTERNAL_STORAGE";
        if(permisson.checkPermission(result, permissionName)){
            checkFile(context, url);
        }else {
            boolean b = permisson.shouldShowRequestPermissionRationale(permissionName);
            if(b){
                permisson.setOnPermissionCallBack(new Permisson.PermissionCallBack() {
                    @Override
                    public void onResult(boolean result) {
                        if(result){
                            checkFile(context, url);
                        }else {
                            NativePlugin.showToast("下载失败，存储权限没有打开");
                        }
                    }
                });
                permisson.requestPermission(permissionName);
            }else {
                NativePlugin.showToast("请在设置里面打开文件存储权限");
            }
        }
    }

    private static void checkFile(Activity context, String url) {
        String path = Environment.getExternalStorageDirectory() + "/Download" + "/yshang.apk";
        File file=new File(path);
        if(file.exists()){
            PackageManager pm = context.getPackageManager();
            PackageInfo info = pm.getPackageArchiveInfo(path, PackageManager.GET_ACTIVITIES);
            if(info!=null && TextUtils.equals(info.packageName,context.getPackageName())){
                if(info.versionCode<=getVersionCode(context)){
                    file.delete();
                    download(context, url);
                } else {
                    installAPk(context);
                }
            }else {
                file.delete();
                download(context, url);
            }
        }else {
            download(context, url);
        }
    }

    private static void download(Context context, String url) {
        //以下两行代码可以让下载的apk文件被直接安装而不用使用Fileprovider,系统7.0或者以上才启动。
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            StrictMode.VmPolicy.Builder localBuilder = new StrictMode.VmPolicy.Builder();
            StrictMode.setVmPolicy(localBuilder.build());
        }

        Uri uri = Uri.parse(url);        //下载连接
        DownloadManager manager = (DownloadManager) context.getSystemService(context.DOWNLOAD_SERVICE);  //得到系统的下载管理
        DownloadManager.Request request = new DownloadManager.Request(uri);  //得到连接请求对象
        request.setAllowedNetworkTypes(DownloadManager.Request.NETWORK_WIFI);   //指定在什么网络下进行下载，这里我指定了WIFI网络
        request.setDestinationInExternalPublicDir("Download","yshang.apk");  //制定下载文件的保存路径，我这里保存到根目录
        request.setVisibleInDownloadsUi(true);  //设置显示下载界面
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.HONEYCOMB) {
            request.allowScanningByMediaScanner();  //表示允许MediaScanner扫描到这个文件，默认不允许。
        }
        request.setTitle("品上商城");      //设置下载中通知栏的提示消息
        request.setDescription("品上商城");//设置设置下载中通知栏提示的介绍
        request.setAllowedNetworkTypes(DownloadManager.Request.NETWORK_MOBILE|DownloadManager.Request.NETWORK_WIFI);
        //7.0以上的系统适配
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            request.setRequiresDeviceIdle(false);
            request.setRequiresCharging(false);
        }
        //制定下载的文件类型为APK
        request.setMimeType("application/vnd.android.package-archive");
        final long downLoadId = manager.enqueue(request);               //启动下载,该方法返回系统为当前下载请求分配的一个唯一的ID

        NativePlugin.showToast("正在下载，状态栏查看下载进度");
    }


    public static int getVersionCode(Context context) {
        try {
            PackageManager packageManager = context.getPackageManager();
            PackageInfo packageInfo = packageManager.getPackageInfo(
                    context.getPackageName(), 0);
            return packageInfo.versionCode;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }


    public static void installAPk(Context context){
        Intent intent = new Intent(Intent.ACTION_VIEW);
        String filePath= Environment.getExternalStorageDirectory() +"/Download"+"/yshang.apk";
        File file = new File(filePath);
        intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        if (Build.VERSION.SDK_INT >= 24) {//大于7.0使用此方法
            Uri apkUri = FileProvider.getUriForFile(context, "com.dislux.yshangflutter.fileprovider", file);///-----ide文件提供者名
            //添加这一句表示对目标应用临时授权该Uri所代表的文件
            intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
            intent.setDataAndType(apkUri, "application/vnd.android.package-archive");
        }else {//小于7.0就简单了
            // 由于没有在Activity环境下启动Activity,设置下面的标签
            intent.setDataAndType(Uri.fromFile(file),"application/vnd.android.package-archive");
        }
        context.startActivity(intent);
    }
}
