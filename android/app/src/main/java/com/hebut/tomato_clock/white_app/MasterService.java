package com.hebut.tomato_clock.white_app;

import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Binder;
import android.os.IBinder;
import android.provider.Settings;
import android.util.Log;

public class MasterService extends Service {
    private final WindowChange windowChange = new WindowChange();
    private final String TAG ="MasterService";
    private Context activityContext;
    @Override
    public void onCreate() {
        super.onCreate();
        Log.i("MasterBinderService", "执行onCreate方法");
        registerReceiver(windowChange, new IntentFilter(WINDOW_CHANGE));
        activityContext = getApplicationContext();
    }
    public void startWindowChangeDetectingService() {
        //主程序已经申请打开服务，但是没有成功打开。所以先打开设置，索取权限。
        Intent Settingintent = new Intent(Settings.ACTION_ACCESSIBILITY_SETTINGS);
        Settingintent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        startActivity(Settingintent);
    }
    public void startSupervise() {
        WindowChangeDetectingService.shouldSupervise=true;
        Intent intent = new Intent(WHETHER_SUPERVISE);
        intent.putExtra("status",WindowChangeDetectingService.shouldSupervise);
        sendBroadcast(intent);
    }
    public void stopSupervise() {
        WindowChangeDetectingService.shouldSupervise=false;
        Intent intent = new Intent(WHETHER_SUPERVISE);
        intent.putExtra("status",WindowChangeDetectingService.shouldSupervise);
        sendBroadcast(intent);
    }
    private final IBinder iBinder = new MasterServiceBinder();
    public class MasterServiceBinder extends Binder {
        public MasterService getService() {
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
        unregisterReceiver(windowChange);
    }
    private final String WINDOW_CHANGE = "com.hebut.broadcast.WindowChange";
    private final String WHETHER_SUPERVISE = "com.hebut.broadcast.WhetherSupervise";
    private final String PACKAGE_CHANGE = "com.hebut.broadcast.PackageChange";
}