package com.hebut.tomato_clock.period_notify;


import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.Service;
import android.content.Intent;
import android.os.Binder;
import android.os.Build;
import android.os.IBinder;
import androidx.core.app.NotificationCompat;
import com.hebut.tomato_clock.R;

public class HandleNotification extends Service {
    private final int NOTIFICATION_PERIOD_ID =63751;

    private static final String PERIOD_NOTIFICATION_CHANNEL = "PERIOD_NOTIFICATION_CHANNEL";
    private static final int NOTIFICATION_ID = 1;
    NotificationChannel PERIOD_CHANNEL =null;
    NotificationManager NOTIFICATION_PERIOD_MANAGE =null;

    @Override
    public void onCreate() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            PERIOD_CHANNEL = new NotificationChannel(PERIOD_NOTIFICATION_CHANNEL, "My PERIOD_NOTIFICATION_CHANNEL", NotificationManager.IMPORTANCE_DEFAULT);
            NOTIFICATION_PERIOD_MANAGE = getSystemService(NotificationManager.class);
            NOTIFICATION_PERIOD_MANAGE.createNotificationChannel(PERIOD_CHANNEL);
        }
        super.onCreate();
    }
    @Override
    public void onDestroy() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {stopForeground(true);}
        super.onDestroy();
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        System.out.println("HandleNotification onStartCommand-------------start-----------");
        NotificationCompat.Builder builder = new NotificationCompat.Builder(this, PERIOD_NOTIFICATION_CHANNEL)
                .setContentTitle("学刻").setContentText("正在后台运行")
                .setSmallIcon(R.drawable.tomato);
        Notification notification = builder.build();

        assert NOTIFICATION_PERIOD_MANAGE != null;

        //发送通知的同时，设置为前台服务
        try {
            startForeground(NOTIFICATION_PERIOD_ID, notification);
        }catch (Exception e)
        {
            System.out.println(e);
        }
        return super.onStartCommand(intent, flags, startId);
    }

//    public void startForeground(int time_second) {
//        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) {return;}
//        if(time_second<=0)return;
//        //创建通知
//        NotificationCompat.Builder builder = new NotificationCompat.Builder(this, "TOMATO_CLOCK_PERIOD_NOTIFICATION_CHANNEL")
//                .setContentTitle("学刻").setContentText("剩余时间："+(time_second/60==0?"最后一分钟":(time_second/60+"分钟")))
//                .setPriority(NotificationCompat.PRIORITY_DEFAULT).setSmallIcon(R.drawable.launch_background);
//        Notification notification = builder.build();
//        //发送通知的同时，设置为前台服务
//        startForeground(NOTIFICATION_PERIOD_ID, notification);
//    }

    public void updateTime(int time_second) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) {return;}
        if(time_second<=0)return;
        //创建新的通知
        NotificationCompat.Builder builder = new NotificationCompat.Builder(this, "TOMATO_CLOCK_FINISH_NOTIFICATION_CHANNEL")
                .setContentTitle("学刻").setContentText("剩余时间："+(time_second/60==1?"最后一分钟":(time_second/60+"分钟")))
                .setPriority(NotificationCompat.PRIORITY_DEFAULT).setSmallIcon(R.drawable.launch_background);
        Notification notification = builder.build();
        //更新通知，要保证id一致
        NOTIFICATION_PERIOD_MANAGE.notify(NOTIFICATION_PERIOD_ID, notification);
    }
//    public void sendFinishNotification() {
//        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) {return;}
//        NotificationCompat.Builder builder = new NotificationCompat.Builder(this, "sendFinishNotification")
//                .setContentTitle("学刻").setContentText("计时已结束").setPriority(NotificationCompat.PRIORITY_HIGH).setSmallIcon(R.drawable.launch_background);
//        Notification notification = builder.build();
//        NOTIFICATION_FINISH_MANAGE.notify(NOTIFICATION_FINISH_ID, notification);
//    }
    public void stopForeground() {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) {return;}
        //取消前台服务
        stopForeground(true);
    }



    private final IBinder binder = new HandleNotificationBinder();
    public class HandleNotificationBinder extends Binder {
        public HandleNotification getService()
        {return HandleNotification.this;}
    }
    @Override
    public IBinder onBind(Intent intent) {return binder;}
    @Override
    public boolean onUnbind(Intent intent) {
        return super.onUnbind(intent);
    }

}
