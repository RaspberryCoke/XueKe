package com.hebut.tomato_clock;

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

import java.util.ArrayList;

public class MainActivity extends FlutterActivity {

    public DBAdapter dbAdapter;
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
//    private static final String BackToApp = "BackToApp";

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
        //打开数据库
        dbAdapter = new DBAdapter(this);
        dbAdapter.open();
        System.out.println("---------java  onCreate------------");
        System.out.println("dbAdapter==null?"+dbAdapter==null);

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

        new MethodChannel(
                getFlutterEngine().getDartExecutor().getBinaryMessenger(), PackageChangeChannel)
                .setMethodCallHandler(
                        (methodCall, result) ->
                        {
                            if (methodCall.method.equals("packageChange")) {
                                appList.clear();
                                appList=methodCall.arguments();
                                assert appList != null;
                                System.out.println("appList.size()="+appList.size());
                                for(int i=0;i<appList.size();i++){
                                    System.out.println("appList.get("+i+")="+appList.get(i));
                                }
//                                masterService.PackageChange();//发送改变信号，在处理函数中进行更新包的操作
                                result.success(true);
                            } else {
                                result.notImplemented();
                            }
                        }
                );
//11
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        Log.w(TAG, "---------java  onDestroy--------");
        if (masterService != null) {
            unbindService(masterServiceConnection);
        }
        if(dbAdapter!=null&&dbAdapter.isOpen())
            dbAdapter.close();
    }

//    public static ArrayList<String> getDBAppList(Context context) {
//        //获取监听应用列表
//        DBAdapter dbAdapter = new DBAdapter(context);
//        dbAdapter.open();
//        ArrayList<String> appList=dbAdapter.query();
//        if(!appList.contains("com.hebut.tomato_clock"))
//            appList.add("com.hebut.tomato_clock");
//        dbAdapter.close();
//        return appList;
//    }

//    public boolean take_to_top() {
//        Log.w(TAG, "---------java  take_to_top----start--------");
//        Context context = getApplicationContext();
//        if (TgSystem.isRunningForeground(context)) {
//            Log.w(TAG, "---------java  this app is already on the top-------");
//        } else {
//            TgSystem.setTopApp(context);
//            if (TgSystem.isRunningForeground(context)){
//                Log.w(TAG, "---------java take_to_top succeed-------");
//                return true;
//            }else{
//                Log.w(TAG, "---------java take_to_top fail-------");
//                return false;
//            }
//        }
//        return true;
//    }

}


