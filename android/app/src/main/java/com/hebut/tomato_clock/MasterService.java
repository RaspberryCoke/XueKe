package com.hebut.tomato_clock;

import static android.os.SystemClock.sleep;

import static com.hebut.tomato_clock.MainActivity.appList;

import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Binder;
import android.os.Bundle;
import android.os.IBinder;
import android.provider.Settings;
import android.util.Log;

import java.util.ArrayList;
import java.util.Timer;
import java.util.TimerTask;

public class MasterService extends Service {
    //public static boolean shouldSupervise=false;
//    Intent requestAliveStatusIntent;
//    Intent responseOfStatusIntent;
    private final WindowChange windowChange = new WindowChange();
    private final String TAG ="MasterService";

    private Context activityContext;
    public TimerTask timerTask = null;

    @Override
    public void onCreate() {
        super.onCreate();
        Log.i("MasterBinderService", "执行onCreate方法");
//        requestAliveStatusIntent = new Intent(REQUEST_ALIVE_STATUS);
//        responseOfStatusIntent=new Intent(RESPONSE_OF_STATUS);
//        registerReceiver(checkAlive, new IntentFilter(RESPONSE_OF_STATUS));
        registerReceiver(windowChange, new IntentFilter(WINDOW_CHANGE));
        activityContext = getApplicationContext();
    }
//    public boolean checkAlive() {
//        Log.i("MasterService", "执行checkAlive方法");
//        requestAliveStatusIntent.putExtra("request",true);
//        sendBroadcast(requestAliveStatusIntent);
//        sleep(1000);
//
//        //
//        Bundle bundle = responseOfStatusIntent.getExtras();
//        boolean res=    bundle.getBoolean("message");
//        System.out.println("res="+res);
//        //boolean res=responseOfStatusIntent.getExtras("message",false);
//        Log.i("MasterService", "执行checkAlive方法，返回值(从responseOfStatus获取)为"+res);
//        return res;
//    }

    public void startWindowChangeDetectingService() {
        //主程序已经申请打开服务，但是没有成功打开。所以先打开设置，索取权限。
        Intent Settingintent = new Intent(Settings.ACTION_ACCESSIBILITY_SETTINGS);
        Settingintent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        startActivity(Settingintent);
    }

    public void startSupervise() {
        WindowChangeDetectingService.shouldSupervise=true;
//        timerTask = new TimerTask() {
//            @Override
//            public void run() {
//                if (WindowChangeDetectingService.shouldSupervise) {
//                    if (!checkAlive()) {
//                        startWindowChangeDetectingService();
//                    }
//                }else{
//                    cancel();
//                }
//            }
//        };
//        Timer timer = new Timer();
////        timer.schedule(timerTask, 0, 60000);
        Intent intent = new Intent(WHETHER_SUPERVISE);
        intent.putExtra("status",WindowChangeDetectingService.shouldSupervise);
        sendBroadcast(intent);
    }
    public void stopSupervise() {
        WindowChangeDetectingService.shouldSupervise=false;
//        timerTask.cancel();
        Intent intent = new Intent(WHETHER_SUPERVISE);
        intent.putExtra("status",WindowChangeDetectingService.shouldSupervise);
        sendBroadcast(intent);
    }
//    public void PackageChange()
//    {
//        Intent intent = new Intent(PACKAGE_CHANGE);
//        Bundle bundle = new Bundle();

//        ArrayList<String> _packageList= MainActivity.getDBAppList(activityContext);
//        if(!_packageList.contains("com.hebut.tomato_clock"))
//            _packageList.add("com.hebut.tomato_clock");
//        appList.clear();
//        appList.addAll(_packageList);





//        String [] packageList = new String[_packageList.size()];
//        packageList=_packageList.toArray(packageList);
//        bundle.putStringArray("package",packageList);
//        intent.putExtras(bundle);
//        sendBroadcast(intent);
//    }

    private final IBinder iBinder = new MasterServiceBinder();

//    public void BackToApp() {
//        if (TgSystem.isRunningForeground(activityContext)) {
//            Log.w(TAG, "---------app is already on the top-------");
//        } else {
//            TgSystem.setTopApp(activityContext);
//            if (TgSystem.isRunningForeground(activityContext)){
//                Log.w(TAG, "---------take_to_top succeed-------");
//            }else{
//                Log.w(TAG, "---------take_to_top fail-------");
//            }
//        }
//    }

    public class MasterServiceBinder extends Binder {
        MasterService getService() {
            //返回MyBinderService实例，以便客户端可以调用公共方法
            return MasterService.this;
        }
    }
    @Override
    public IBinder onBind(Intent intent) {
        Log.i("MasterBinderService", "执行onBind方法");
        return iBinder;
    }
    @Override
    public boolean onUnbind(Intent intent) {
        Log.i("MasterBinderService", "执行onUnbind方法");
        return super.onUnbind(intent);
    }
    @Override
    public void onDestroy() {
        super.onDestroy();
//        unregisterReceiver(checkAlive);
        unregisterReceiver(windowChange);
    }
    private final String WINDOW_CHANGE = "com.hebut.broadcast.WindowChange";
    private final String WHETHER_SUPERVISE = "com.hebut.broadcast.WhetherSupervise";
    private final String PACKAGE_CHANGE = "com.hebut.broadcast.PackageChange";
//    private final String REQUEST_ALIVE_STATUS = "com.hebut.broadcast.RequestAliveStatus";
//    private final String RESPONSE_OF_STATUS = "com.hebut.broadcast.ResponseOfStatus";

}