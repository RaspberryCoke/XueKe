package com.hebut.tomato_clock;

import static android.content.Context.ACTIVITY_SERVICE;
import static com.hebut.tomato_clock.MainActivity.appList;
import static com.hebut.tomato_clock.WindowChangeDetectingService.shouldSupervise;

import android.app.ActivityManager;
import android.content.BroadcastReceiver;
import android.content.ComponentName;
import android.content.Intent;

import java.util.List;

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

    }
    private final String WHETHER_SUPERVISE = "com.hebut.broadcast.WhetherSupervise";
}
