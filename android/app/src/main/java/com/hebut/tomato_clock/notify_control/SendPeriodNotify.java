//package com.hebut.tomato_clock.notify_control;
//
//import android.app.Notification;
//import android.app.NotificationChannel;
//import android.app.NotificationManager;
//import android.app.PendingIntent;
//import android.app.Service;
//import android.content.Intent;
//import android.os.Binder;
//import android.os.Build;
//import android.os.IBinder;
//
//import androidx.annotation.Nullable;
//import androidx.core.app.NotificationCompat;
//import androidx.core.app.NotificationManagerCompat;
//
//import com.hebut.tomato_clock.MainActivity;
//
//public class SendPeriodNotify  extends Service {
//    private static final String CHANNEL_ID_PERIOD = "TOMATO_CLOCK_PERIOD_NOTIFY_CHANNEL";
//    private static final String CHANNEL_ID_COMMON = "TOMATO_CLOCK_COMMON_NOTIFY_CHANNEL";
//    private static final int NOTIFICATION_ID_FOR_PERIOD = 26417;
//    private static final int NOTIFICATION_ID_FOR_FINAL = 13715;
//    @Override
//    public void onCreate() {
//        super.onCreate();
//        System.out.println("--------------------onCreate------------");
//
//        NotificationChannel period_channel =null;
//        NotificationChannel common_channel =null;
//        NotificationManager manager =null;
//        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
//            period_channel = new NotificationChannel(CHANNEL_ID_PERIOD, "the TOMATO_CLOCK_PERIOD_NOTIFY_CHANNEL", NotificationManager.IMPORTANCE_LOW);
//            common_channel = new NotificationChannel(CHANNEL_ID_COMMON, "the TOMATO_CLOCK_COMMON_NOTIFY_CHANNEL", NotificationManager.IMPORTANCE_HIGH);
//        }
//        manager = getSystemService(NotificationManager.class);
//        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
//            manager.createNotificationChannel(period_channel);
//            manager.createNotificationChannel(common_channel);
//        }
//        // 创建启动应用程序的 Intent
//        Intent appIntent = new Intent(this, MainActivity.class);
//        appIntent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP | Intent.FLAG_ACTIVITY_SINGLE_TOP);
//        PendingIntent pendingIntent = PendingIntent.getActivity(this, 0, appIntent,
//                PendingIntent.FLAG_CANCEL_CURRENT | PendingIntent.FLAG_UPDATE_CURRENT|PendingIntent.FLAG_MUTABLE
//                        |PendingIntent.FLAG_ONE_SHOT);
//        // Create the notification and start the foreground service
//        Notification notification = new NotificationCompat.Builder(this, NOTIFICATION_ID_FOR_PERIOD)
//                .setContentTitle("学刻")
//                .setContentText("学科正在后台运行，点击返回应用")
//                .setContentIntent(pendingIntent) // 添加启动应用程序的 PendingIntent
////                .setSmallIcon(R.drawable.ic_launcher_foreground)
//                .setAutoCancel(true)// 设置点击通知后自动消失
//                .setPriority(NotificationCompat.PRIORITY_LOW)
//                .setOngoing(true)
//                .build();
//
//        NotificationManagerCompat notificationManager = NotificationManagerCompat.from(this);
//        notificationManager.notify(NOTIFICATION_ID, notification);
//        //notificationManager.cancel(NOTIFICATION_ID, Notification.FLAG_NO_CLEAR);
//        //startForeground(NOTIFICATION_ID, notification);
//    }
//
//    @Override
//    public int onStartCommand(Intent intent, int flags, int startId) {
//        // Perform your service work here
//        return super.onStartCommand(intent, flags, startId);
//    }
//
//    private final IBinder binder = new MyBinder();
//
//    public class MyBinder extends Binder {
//        MyService getService() {
//            return MyService.this;
//        }
//    }
//
//    @Nullable
//    @Override
//    public IBinder onBind(Intent intent) {
//        return binder;
//    }
//
//    @Override
//    public void onDestroy() {
//        super.onDestroy();
//        MainActivity.isBound=false;
//        System.out.println("--------------------onDestory------------");
//        //stopForeground(true);
//    }
//
//}
