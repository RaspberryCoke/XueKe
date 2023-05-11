package com.hebut.tomato_clock;

import android.app.ActivityManager;
import android.app.PendingIntent;
import android.content.ComponentName;
import android.content.ServiceConnection;
import android.os.Build;
import android.os.IBinder;
import android.provider.Settings;
import android.util.Log;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;

//import com.hebut.tomato_clock.flutter_app_keep_alive.KeepAliveService;
import com.hebut.tomato_clock.period_notify.HandleNotification;
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
    //该MainActivity的作用是：
    //启动服务，注册channel，维护部分全局数据

    //全局数据结构。注意：shouldSupervise放在了WindowChangeDetectingService里面。
    public static ArrayList<String> appList = new ArrayList<String>();
    public static Map<String,String> filterSet=new HashMap<>();
    public static ConcurrentHashMap<String,List<String>> packageToFilter=new ConcurrentHashMap<>();
    //全局数据结构

    //服务
    public MasterService masterService;
//    public KeepAliveService keepAliveService;
//    public HandleNotification handleNotification;

    private ServiceConnection HandleNotificationserviceConnection = new ServiceConnection() {
        @Override
        public void onServiceConnected(ComponentName name, IBinder service) {
            System.out.println("HandleNotification   Service onServiceConnected-------------start-----------");
            HandleNotification.HandleNotificationBinder binder = (HandleNotification.HandleNotificationBinder) service;
//            handleNotification = binder.getService();
            //System.out.println("HandleNotification   Service onServiceConnected-------------handleNotification is null?---"+(handleNotification==null));
            System.out.println("HandleNotification   Service onServiceConnected-------------end-----------");
        }
        @Override
        public void onServiceDisconnected(ComponentName name) {
            System.out.println("HandleNotification   Service onServiceDisconnected-------------start-----------");
//            handleNotification = null;
            System.out.println("HandleNotification   Service onServiceDisconnected-------------end-----------");
        }
    };
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
//    public ServiceConnection keepAliveServiceConnection=new ServiceConnection(){
//        @Override
//        public void onServiceConnected(ComponentName name, IBinder service) {
//            Log.w(TAG, "---------KeepAliveService  onServiceConnected------------");
//            KeepAliveService.KeepAliveServiceBinder binder = (KeepAliveService.KeepAliveServiceBinder) service;
//            keepAliveService = binder.getService();
//        }
//        @Override
//        public void onServiceDisconnected(ComponentName name) {
//            Log.w(TAG, "---------KeepAliveService  DisConnected------------");
//            keepAliveService=null;
//        }
//    };
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
        activityManager=init_activityManager();
        List<ActivityManager.RunningTaskInfo> taskInfoList = activityManager.getRunningTasks(100);
        boolean search=false;
        for (ActivityManager.RunningTaskInfo taskInfo : taskInfoList) {
            if (taskInfo.topActivity.getPackageName().equals(context.getPackageName())) {
                taskID=taskInfo.id;
                search=true;
                break;
            }
        }
        if(!search) {
            System.out.println("---------taskID init fail------------");
        }else{
            System.out.println("---------taskID init succeed:"+taskID+"-----");
        }
        System.out.println("---------java  onStart-----end init-------");
    }
    private static final String TAG = "MainActivity";
    private static final String WhetherSuperviseChannel = "WhetherSupervise";
    private static final String PackageChangeChannel = "PackageChange";
    private static final String ForegroundChangeChannel = "ForegroundChange";

    private static final String NotificationChangeChannel="NotificationChange";
    private static final String GetPermissionChannel="GetPermission";
    private static final String CheckPermissionChannel="CheckPermission";
    private static final String PeriodNotifyChannel="PeriodNotify";
    private static final String StopSuperviseAndNotifyChannel="StopSuperviseAndNotify";

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

        //启动发送常驻通知，这个通知会在程序启动之后一直存在，直到程序退出。
        //但是程序不会自动退出，必须要手动杀死程序。这是一个问题。但没必要现在就解决。
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            Intent HandleNotificationServicendIIntent = new Intent(this,HandleNotification.class);
            startForegroundService(HandleNotificationServicendIIntent);
        }

        //注册Flutter插件
        GeneratedPluginRegistrant.registerWith(new FlutterEngine(this));
    }

    public void registerChannel() {
        new MethodChannel(getFlutterEngine().getDartExecutor().getBinaryMessenger(), WhetherSuperviseChannel).setMethodCallHandler(
                    (methodCall, result) -> {
                        if (methodCall.method.equals("startSupervise")) {
                            masterService.startSupervise();
                            result.success(true);
                        }else if (methodCall.method.equals("stopSupervise")) {
                            masterService.stopSupervise();
                            result.success(true);
                        } else {result.notImplemented();}});
        new MethodChannel(getFlutterEngine().getDartExecutor().getBinaryMessenger(), PackageChangeChannel).setMethodCallHandler(
            (methodCall, result) -> {
            if (methodCall.method.equals("packageChange")) {
               appList.clear();
               appList=methodCall.arguments();
               result.success(true);
            } else {result.notImplemented();}});

        new MethodChannel(getFlutterEngine().getDartExecutor().getBinaryMessenger(), NotificationChangeChannel).setMethodCallHandler(
                (methodCall, result) -> {
                    if (methodCall.method.equals("notificationChange")) {
                        filterSet.clear();
                        filterSet=methodCall.arguments();
                        packageToFilter.clear();
                        for(Map.Entry<String, String> item: filterSet.entrySet()) {
                            List<String> _list= Arrays.asList(item.getValue().split(","));
                            packageToFilter.put(item.getKey(),_list);}
                        result.success(true);}
                    else {result.notImplemented();}});
        new MethodChannel(getFlutterEngine().getDartExecutor().getBinaryMessenger(), GetPermissionChannel).setMethodCallHandler(
                (methodCall, result) -> {
                    if (methodCall.method.equals("notification")) {
                        jumpNotificationAccessSetting(this);
                        result.success(true);
                    } else if(methodCall.method.equals("accessibility")) {
                        jumpAccessibilityAccessSetting(this);
                        result.success(true);
                    }else {result.notImplemented();}});
        new MethodChannel(getFlutterEngine().getDartExecutor().getBinaryMessenger(), CheckPermissionChannel).setMethodCallHandler(
                (methodCall, result) -> {
                    if (methodCall.method.equals("notification")) {
                        checkNotificationAccessSetting(this);
                        result.success(true);
                    } else if(methodCall.method.equals("accessibility")) {
                        checkAccessibilityAccessSetting(this);
                        result.success(true);
                    }else {result.notImplemented();}});


        //注意：低版本安卓不支持。
        new MethodChannel(getFlutterEngine().getDartExecutor().getBinaryMessenger(), PeriodNotifyChannel).setMethodCallHandler(
            (methodCall, result) -> {
                if (methodCall.method.equals("periodNotify")) {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                        //handleNotification.updateTime(methodCall.arguments() == null ? 0 : methodCall.arguments());
                    }
                    result.success(true);
                } else if(methodCall.method.equals("stopNotify")) {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                       //handleNotification.sendFinishNotification();
                    }
                    result.success(true);}
                else {result.notImplemented();}});
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        Log.w(TAG, "---------java  onDestroy--------");
        if (masterService != null)
            unbindService(masterServiceConnection);
    }

    private boolean checkNotificationAccessSetting(Context context){
        System.out.println("checkNotificationAccessSetting");
        boolean enable = false;
        String packageName = context.getPackageName();
        String flat = Settings.Secure.getString(context.getContentResolver(),Settings.ACTION_NOTIFICATION_LISTENER_SETTINGS);
        if (flat != null) {
            enable = flat.contains(packageName);
        }
        System.out.println("checkNotificationAccessSetting return: " + enable);
        return enable;
    }
    private boolean checkAccessibilityAccessSetting(Context context){
        System.out.println("checkAccessibilityAccessSetting");
        boolean enable = false;
        String packageName = context.getPackageName();
        String flat = Settings.Secure.getString(context.getContentResolver(),Settings.ACTION_ACCESSIBILITY_SETTINGS);
        if (flat != null) {
            enable = flat.contains(packageName);
        }
        System.out.println("checkAccessibilityAccessSetting return: " + enable);
        return enable;
    }
    private void jumpNotificationAccessSetting(Context context) {
        try {
            Intent intent = new Intent(Settings.ACTION_NOTIFICATION_LISTENER_SETTINGS);
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            context.startActivity(intent);
        } catch(Exception e) {
            e.printStackTrace();
        }
    }
    private void jumpAccessibilityAccessSetting(Context context) {
        try {
            Intent intent = new Intent(Settings.ACTION_ACCESSIBILITY_SETTINGS);
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            context.startActivity(intent);
        } catch(Exception e) {
            e.printStackTrace();
        }
    }

}


