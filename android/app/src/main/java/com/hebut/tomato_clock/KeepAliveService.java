package com.hebut.tomato_clock;
import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.Service;
import android.content.Intent;
import android.os.Binder;
import android.os.Build;
import android.os.IBinder;
import android.util.Log;

import androidx.annotation.Nullable;
import androidx.core.app.NotificationCompat;
public class KeepAliveService extends Service {
    private static final int SERVICE_ID = 62562;
    @Override
    public void onCreate() {
        super.onCreate();
        //startForeground();
    }
    private final IBinder iBinder = new KeepAliveService.KeepAliveServiceBinder();
    public class KeepAliveServiceBinder extends Binder {
        KeepAliveService getService() {
            //返回MyBinderService实例，以便客户端可以调用公共方法
            return KeepAliveService.this;
        }
    }
    @Override
    public IBinder onBind(Intent intent) {
        Log.i("KeepAliveService", "执行onBind方法");
        return iBinder;
    }
    @Override
    public boolean onUnbind(Intent intent) {
        Log.i("KeepAliveService", "执行onUnbind方法");
        return super.onUnbind(intent);
    }
    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        return START_STICKY;
    }
    public void startForeground() {
        System.out.println("startForeground");
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            NotificationChannel channel = new NotificationChannel("my_channel", "My Channel", NotificationManager.IMPORTANCE_DEFAULT);
            NotificationManager notificationManager = getSystemService(NotificationManager.class);
            notificationManager.createNotificationChannel(channel);
        }
        NotificationCompat.Builder builder = new NotificationCompat.Builder(this, "my_channel")
//                .setSmallIcon(R.drawable.ic_launcher_foreground)
                .setContentTitle("My Service")
                .setContentText("Service is running in foreground")
                .setPriority(NotificationCompat.PRIORITY_DEFAULT);

        Notification notification = builder.build();
        startForeground(SERVICE_ID, notification);
    }

    public void stopForeground() {
        System.out.println("stopForeground");
        stopForeground(true);
    }
}
