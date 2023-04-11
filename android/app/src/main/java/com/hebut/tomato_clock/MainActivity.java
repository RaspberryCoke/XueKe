package com.hebut.tomato_clock;

import android.os.Bundle;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.plugin.common.PluginRegistry;

import android.content.Context;
import androidx.appcompat.app.AppCompatActivity;

import android.app.AlarmManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.os.SystemClock;
import android.view.View;
import android.widget.AdapterView;

import java.util.ArrayList;
import java.util.List;
import java.util.Timer;
import java.util.TimerTask;
import static android.content.Context.ACTIVITY_SERVICE;

public class MainActivity extends FlutterActivity {
    private static final String channel = "the_listener";
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        new MethodChannel(getFlutterEngine().getDartExecutor().getBinaryMessenger(),channel).setMethodCallHandler(
                new MethodChannel.MethodCallHandler() {
                    @Override
                    public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
                        if (methodCall.method.equals("check_and_take_to_top")) {
                            result.success(check_and_take_to_top());
                        } else {
                            result.notImplemented();
                        }
                    }
                }
        );

        GeneratedPluginRegistrant.registerWith(new FlutterEngine(this));
    }

    boolean check_and_take_to_top(){
        Context context = getApplicationContext();
        TimerTask timerTask = new TimerTask() {
            @Override
            public void run() {
                if(!TgSystem.appIsExist())return;
                if (TgSystem.isRunningForeground(context)) {
                    System.out.println("this app is on the top.");
                }else {
                    TgSystem.setTopApp(context);
                    System.out.println("try to move to the top");
                }
            }
        };
        Timer timer=new Timer("Timer");
        timer.schedule(timerTask
                ,1000//延迟1秒执行
                ,1000);//周期时间

    }
    //数字自增方法
}
