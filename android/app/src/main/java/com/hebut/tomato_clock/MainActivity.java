package com.hebut.tomato_clock;

import android.content.ComponentName;
import android.content.ServiceConnection;
import android.os.IBinder;
import android.util.Log;
import android.util.EventLogTags;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.plugin.common.PluginRegistry;
import android.content.Context;
import android.app.AlarmManager;
import android.app.PendingIntent;
import android.content.Intent;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.os.SystemClock;
import android.view.View;
import android.widget.AdapterView;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Timer;
import java.util.TimerTask;
import static android.content.Context.ACTIVITY_SERVICE;

public class MainActivity extends FlutterActivity {

    public static ArrayList<String> appList = new ArrayList<String>();
    public MasterService masterService;
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
    private static final String TAG = "MainActivity";
    private static final String WhetherSuperviseChannel = "WhetherSupervise";
    private static final String PackageChangeChannel = "PackageChange";
    private static final String BackToApp = "BackToApp";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        //注册与主程序的通信渠道
        registerChannel();
        System.out.println("---------java  onCreate------------");
        //启动监听服务
        Intent bindIntent = new Intent(this,WindowChangeDetectingService.class);
        startService(bindIntent);

        //启动主服务
        Intent MasterServicendIIntent = new Intent(this,MasterService.class);
        boolean bindMasterServiceRes= bindService(MasterServicendIIntent,masterServiceConnection, Context.BIND_AUTO_CREATE);
        if(!bindMasterServiceRes) {
            Log.e(TAG, "---------MasterServicend  bindService fail------------");
        }else{
            Log.w(TAG, "---------MasterServicend  bindService succeed------------");
        }

        //注册Flutter插件
        GeneratedPluginRegistrant.registerWith(new FlutterEngine(this));
    }



    public  ArrayList<String> getDBAppList(){
        //获取监听应用列表
        DBAdapter dbAdapter = new DBAdapter(this);
        dbAdapter.open();
        ArrayList<String> appList=dbAdapter.getAllPackage();
        if(!appList.contains("com.hebut.tomato_clock"))
            appList.add("com.hebut.tomato_clock");
        dbAdapter.close();
        return appList;
    }

    public boolean take_to_top() {
        Log.w(TAG, "---------java  take_to_top----start--------");
        Context context = getApplicationContext();
        if (TgSystem.isRunningForeground(context)) {
            Log.w(TAG, "---------java  this app is already on the top-------");
        } else {
            TgSystem.setTopApp(context);
            if (TgSystem.isRunningForeground(context)){
                Log.w(TAG, "---------java take_to_top succeed-------");
                return true;
            }else{
                Log.w(TAG, "---------java take_to_top fail-------");
                return false;
            }
        }
        return true;
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
                        } else {
                            result.notImplemented();//在发行版中可以去掉
                        }
                    }
            );
        new MethodChannel(
            getFlutterEngine().getDartExecutor().getBinaryMessenger(), WhetherSuperviseChannel)
            .setMethodCallHandler(
                    (methodCall, result) ->
                    {
                        if (methodCall.method.equals("stopSupervise")) {
                            masterService.stopSupervise();
                            result.success(true);
                        } else {
                            result.notImplemented();
                        }
                    }
            );
        new MethodChannel(
                getFlutterEngine().getDartExecutor().getBinaryMessenger(), PackageChangeChannel)
                .setMethodCallHandler(
                        (methodCall, result) ->
                        {
                            if (methodCall.method.equals("packageChange")) {
                                appList.clear();
                                masterService.PackageChange();//发送改变信号，在处理函数中进行更新包的操作
                                result.success(true);
                            } else {
                                result.notImplemented();
                            }
                        }
                );
        new MethodChannel(
                getFlutterEngine().getDartExecutor().getBinaryMessenger(), BackToApp)
                .setMethodCallHandler(
                        (methodCall, result) ->
                        {
                            if (methodCall.method.equals("backToApp")) {
                                masterService.BackToApp();
                                result.success(true);
                            } else {
                                result.notImplemented();
                            }
                        }
                );
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        Log.w(TAG, "---------java  onDestroy--------");
        if (masterService != null) {
            unbindService(masterServiceConnection);
        }
    }
}


