package com.hebut.tomato_clock.white_app;

import static android.content.Context.ACTIVITY_SERVICE;
import static com.hebut.tomato_clock.MainActivity.appList;

import android.app.ActivityManager;
import android.content.BroadcastReceiver;
import android.content.ComponentName;
import android.content.Intent;

import java.util.List;
import java.util.Objects;

public class WindowChange extends BroadcastReceiver {
    @Override
    public void onReceive(android.content.Context context, android.content.Intent intent) {
        android.os.Bundle bundle = intent.getExtras();
        if (bundle == null) return;

        String _new = bundle.getString("new");
        System.out.println("WindowChange onReceive");
        System.out.println("new:" + _new);
        if (!WindowChangeDetectingService.shouldSupervise) {
            return;
        }
        //下面的逻辑是：一旦发现当前页面不被允许，马上跳转回本应用。
        if (!appList.contains(_new)) {
            //获取ActivityManager
            ActivityManager activityManager = (ActivityManager) context.getSystemService(ACTIVITY_SERVICE);
            List<ActivityManager.RunningTaskInfo> taskInfoList = activityManager.getRunningTasks(100);
            boolean counldFind = false;//能否找到旧的应用，要排除已经被杀进程的情况
            for (ActivityManager.RunningTaskInfo task : taskInfoList) {
                //找到本应用的 task，并将它切换到前台
                ComponentName componentName = task.baseActivity;
                String packageName = componentName.getPackageName();
                if (packageName.equals("com.hebut.tomato_clock")) {
                    counldFind = true;
                    try {
                        activityManager.moveTaskToFront(task.id, 0);
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                    break;
                }
            }
            //确实已经被杀死进程,停止监控
            if (!counldFind) {
                WindowChangeDetectingService.shouldSupervise = false;
                //连本进程都没有了，这个时候设置好不再监控
                Intent intent2 = new Intent(WHETHER_SUPERVISE);
                intent2.putExtra("status", false);
                context.sendBroadcast(intent2);
                System.out.println("WindowChange onReceive:the process is killed,so stop supervise!");
            }
        }
        //发现该应用是白名单应用
        if(Objects.equals(_new, "com.hebut.tomato_clock") ||Objects.equals(_new, "com.android.systemui") )
            return;


        //其他白名单应用
        //应该发送常驻通知，提醒用户
        //同时有开启一个定时器，每隔一分钟更新时间
        //一旦完成计时，取消这个常驻通知
        //转而发送一个重要通知，提醒已经完成
        //完成之后马上保存好数据
        //注意：一旦跳转回到了本应用，就应该停止发送消息，撤回所有消息。
    }
    private final String WHETHER_SUPERVISE = "com.hebut.broadcast.WhetherSupervise";
}
