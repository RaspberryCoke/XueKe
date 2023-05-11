//package com.hebut.tomato_clock.flutter_app_keep_alive;
//import android.app.Notification;
//import android.app.NotificationChannel;
//import android.app.NotificationManager;
//import android.app.Service;
//import android.content.Intent;
//import android.os.Binder;
//import android.os.Build;
//import android.os.IBinder;
//
//import androidx.core.app.NotificationCompat;
//public class KeepAliveService extends Service {
//    NotificationChannel channel;
//    NotificationManager notificationManager;
//    private static final int SERVICE_ID = 62562;
//    @Override
//    public void onCreate() {super.onCreate();}
//    private final IBinder iBinder = new KeepAliveService.KeepAliveServiceBinder();
//    public class KeepAliveServiceBinder extends Binder {
//        public KeepAliveService getService() {
//            return KeepAliveService.this;
//        }
//    }
//    @Override
//    public IBinder onBind(Intent intent) {return iBinder;}
//    @Override
//    public boolean onUnbind(Intent intent) {return super.onUnbind(intent);}
//    @Override
//    public int onStartCommand(Intent intent, int flags, int startId) {return START_STICKY;}
//    public void startForeground() {
//        System.out.println("startForeground");
//        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
//            channel = new NotificationChannel("my_channel", "My Channel", NotificationManager.IMPORTANCE_DEFAULT);
//            notificationManager = getSystemService(NotificationManager.class);
//            notificationManager.createNotificationChannel(channel);
//        }
//        NotificationCompat.Builder builder = new NotificationCompat.Builder(this, "my_channel")
////                .setSmallIcon(R.drawable.ic_launcher_foreground)
//                .setContentTitle("学刻")
//                .setContentText("学科正在后台运行")
//                .setPriority(NotificationCompat.PRIORITY_DEFAULT);
//
//        Notification notification = builder.build();
//        startForeground(SERVICE_ID, notification);
//    }
//    public void updateTime(int time_second) {
//        NotificationCompat.Builder builder = new NotificationCompat.Builder(this, "my_channel")
////                .setSmallIcon(R.drawable.ic_launcher_foreground)
//                .setContentTitle("学刻")
//                .setContentText("学科正在后台运行")
//                .setPriority(NotificationCompat.PRIORITY_DEFAULT);
//
//        Notification notification = builder.build();
//        notificationManager.notify(SERVICE_ID, notification);
//    }
//    public void stopForeground() {
//        stopForeground(true);
//    }
//}
