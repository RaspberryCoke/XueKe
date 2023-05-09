package com.hebut.tomato_clock;

import android.app.ActivityManager;
import android.content.ComponentName;
import android.content.ServiceConnection;
import android.os.IBinder;
import android.util.Log;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;

import com.hebut.tomato_clock.flutter_app_keep_alive.KeepAliveService;
import com.hebut.tomato_clock.white_app.MasterService;
import com.hebut.tomato_clock.white_app.WindowChangeDetectingService;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

public class MainActivity extends FlutterActivity {

//    public DBAdapter dbAdapter;
    public static ArrayList<String> appList = new ArrayList<String>();
    public static Map<String,String> filterSet=new HashMap<>();
    public static ConcurrentHashMap<String,List<String>> packageToFilter=new ConcurrentHashMap<>();

    public MasterService masterService;
    public KeepAliveService keepAliveService;
    public ServiceConnection masterServiceConnection=new ServiceConnection(){
        @Override
        public void onServiceConnected(ComponentName name, IBinder service) {
            Log.w(TAG, "---------MasterServicend  onServiceConnected------------");
            MasterService.MasterServiceBinder binder = (MasterService.MasterServiceBinder) service;
            masterService = binder.getService();
        }

        @Override
        public void onServiceDisconnected(ComponentName name) {
            Log.w(TAG, "---------MasterServicend  DisConnected------------");
            masterService=null;
        }
    };

    public ServiceConnection keepAliveServiceConnection=new ServiceConnection(){
        @Override
        public void onServiceConnected(ComponentName name, IBinder service) {
            Log.w(TAG, "---------KeepAliveService  onServiceConnected------------");
            KeepAliveService.KeepAliveServiceBinder binder = (KeepAliveService.KeepAliveServiceBinder) service;
            keepAliveService = binder.getService();
        }
        @Override
        public void onServiceDisconnected(ComponentName name) {
            Log.w(TAG, "---------KeepAliveService  DisConnected------------");
            keepAliveService=null;
        }
    };
    private Context context;
    public int taskID;
    public ActivityManager activityManager;
    public ActivityManager init_activityManager()
    {
        return (ActivityManager) context.getSystemService(ACTIVITY_SERVICE);
    }
    public void setTopApp() {
        if (isRunningForeground()) {
            return;
        }
        activityManager.moveTaskToFront(taskID, 0);
    }
    public  boolean isRunningForeground() {
//        activityManager = init_activityManager();
        List<ActivityManager.RunningAppProcessInfo> appProcessInfoList = activityManager.getRunningAppProcesses();

        for (ActivityManager.RunningAppProcessInfo appProcessInfo : appProcessInfoList) {
            if (appProcessInfo.importance == ActivityManager.RunningAppProcessInfo.IMPORTANCE_FOREGROUND
                    && appProcessInfo.processName.equals(context.getApplicationInfo().processName)) {
                return true;
            }
        }
        return false;
    }
    @Override
    protected void onStart() {
        System.out.println("---------java  onStart------------");
        super.onStart();
        context=this;
        System.out.println("---------context init,context is:"+context.toString());
        activityManager=init_activityManager();
        System.out.println("---------activityManager init,activityManager is:"+activityManager.toString());
        List<ActivityManager.RunningTaskInfo> taskInfoList = activityManager.getRunningTasks(100);
        System.out.println("---------taskInfoList init,taskInfoList is:"+taskInfoList.toString());
        boolean search=false;
        for (ActivityManager.RunningTaskInfo taskInfo : taskInfoList) {
            if (taskInfo.topActivity.getPackageName().equals(context.getPackageName())) {
                taskID=taskInfo.id;
                search=true;
                break;
            }
        }
        if(!search)
        {
            System.out.println("---------taskID init fail------------");
        }else{
            System.out.println("---------taskID init succeed:"+taskID+"-----");
        }
    }
    private static final String TAG = "MainActivity";
    private static final String WhetherSuperviseChannel = "WhetherSupervise";
    private static final String PackageChangeChannel = "PackageChange";
    private static final String ForegroundChangeChannel = "ForegroundChange";

    private static final String NotificationChangeChannel="NotificationChange";
    private static final String GetPermissionChannel="GetPermission";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        //注册与主程序的通信渠道
        registerChannel();
        System.out.println("---------java  onCreate------------");
        //启动监听服务
        Intent bindIntent = new Intent(this, WindowChangeDetectingService.class);
        startService(bindIntent);

        //启动主服务
        Intent MasterServicendIIntent = new Intent(this,MasterService.class);
        boolean bindMasterServiceRes= bindService(MasterServicendIIntent,masterServiceConnection, Context.BIND_AUTO_CREATE);
        if(!bindMasterServiceRes) {
            Log.e(TAG, "---------MasterServicend  bindService fail------------");
        }else{
            Log.w(TAG, "---------MasterServicend  bindService succeed------------");
        }

        //启动后台监测服务
        Intent ForegroundIIntent = new Intent(this,KeepAliveService.class);
        boolean ForegroundServiceRes= bindService(ForegroundIIntent,keepAliveServiceConnection, Context.BIND_AUTO_CREATE);
        if(!ForegroundServiceRes) {
            Log.e(TAG, "---------ForegroundService  bindService fail------------");
        }else{
            Log.w(TAG, "---------ForegroundService  bindService succeed------------");
        }
        //jumpNotificationAccessSetting(this);
        //注册Flutter插件
        GeneratedPluginRegistrant.registerWith(new FlutterEngine(this));
    }



    public void registerChannel() {
        new MethodChannel(
                getFlutterEngine().getDartExecutor().getBinaryMessenger(), WhetherSuperviseChannel)
                .setMethodCallHandler(
                    (methodCall, result) ->
                    {
                        if (methodCall.method.equals("startSupervise")) {
                            masterService.startSupervise();
                            result.success(true);
                        }else if (methodCall.method.equals("stopSupervise")) {
                            masterService.stopSupervise();
                            result.success(true);
                            } else {
                                result.notImplemented();
                            }
                    }
            );

        new MethodChannel(getFlutterEngine().getDartExecutor().getBinaryMessenger(), PackageChangeChannel).setMethodCallHandler(
            (methodCall, result) -> {
            if (methodCall.method.equals("packageChange")) {
               appList.clear();
               appList=methodCall.arguments();
               result.success(true);
            } else {result.notImplemented();}});
        new MethodChannel(getFlutterEngine().getDartExecutor().getBinaryMessenger(), ForegroundChangeChannel).setMethodCallHandler(
            (methodCall, result) -> {
               if (methodCall.method.equals("setToForeground")) {
               keepAliveService.startForeground();
               result.success(true);
               } else if (methodCall.method.equals("setToBackground"))
               {
                   keepAliveService.stopForeground();
                   result.success(true);
               }
               else{
                   result.notImplemented();
               }});
        new MethodChannel(getFlutterEngine().getDartExecutor().getBinaryMessenger(), NotificationChangeChannel).setMethodCallHandler(
                (methodCall, result) -> {
                    if (methodCall.method.equals("notificationChange")) {
                        filterSet.clear();
                        filterSet=methodCall.arguments();
                        packageToFilter.clear();
                        for(Map.Entry<String, String> item: filterSet.entrySet())
                        {
                            List<String> _list= Arrays.asList(item.getValue().split(","));
                            packageToFilter.put(item.getKey(),_list);
                        }
                        Log.i(TAG, "---------java  notificationChange------------");
                        Log.i(TAG,"---------------遍历所有拦截包：--------------------");
                        for(Map.Entry<String, List<String>> entry: MainActivity.packageToFilter.entrySet()) {
                            Log.i(TAG, "debug :  包名：" + entry.getKey());
                            List<String> filterList = entry.getValue();
                            if (filterList.contains("")) {
                                Log.i(TAG, "debug :  其中的关键字包含空字符串，全部阻塞");
                            }
                            for (String filter : filterList) {
                                Log.i(TAG, "debug :  其中的关键字：" + filter);
                            }

                        }

                        result.success(true);
                    } else {result.notImplemented();}});

        new MethodChannel(getFlutterEngine().getDartExecutor().getBinaryMessenger(), GetPermissionChannel).setMethodCallHandler(
                (methodCall, result) -> {
                    if (methodCall.method.equals("notification")) {
                        jumpNotificationAccessSetting(this);
                        result.success(true);
                    } else {result.notImplemented();}});
    }
    @Override
    protected void onDestroy() {
        super.onDestroy();
        Log.w(TAG, "---------java  onDestroy--------");
        if (masterService != null) {
            unbindService(masterServiceConnection);
        }
        if(keepAliveService != null) {
            unbindService(keepAliveServiceConnection);
        }
    }

    private void jumpNotificationAccessSetting(Context context) {
        try {
            Intent intent = new Intent("android.settings.ACTION_NOTIFICATION_LISTENER_SETTINGS");
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            context.startActivity(intent);
        } catch(Exception e) {
            e.printStackTrace();
        }
    }

}


