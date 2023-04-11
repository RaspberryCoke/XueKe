package com.hebut.tomato_clock;

import android.util.Log;
import android.util.EventLogTags;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.plugin.common.PluginRegistry;
import android.content.Context;
import android.app.AlarmManager;
import android.app.PendingIntent;
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
    private static final String TAG = "MainActivity";
    private static final String channel = "BackToApp";
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        //setContentView(R.layout.activity_main);
        new MethodChannel(getFlutterEngine().getDartExecutor().getBinaryMessenger(),channel).setMethodCallHandler(
                new MethodChannel.MethodCallHandler() {
                    @Override
                    public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
                        if (methodCall.method.equals("take_to_top")) {
                            result.success(take_to_top());
                        } else {
                            result.notImplemented();
                        }
                    }
                }
        );
        GeneratedPluginRegistrant.registerWith(new FlutterEngine(this));
    }

    boolean take_to_top() {
        Log.w(TAG, "---------java  take_to_top----start--------");
        Context context = getApplicationContext();
        if (TgSystem.isRunningForeground(context)) {
            Log.w(TAG, "---------java  this app is already on the top-------");
        } else {
            TgSystem.setTopApp(context);
            if (TgSystem.isRunningForeground(context)){
                Log.w(TAG, "---------java take_to_top succeed-------");
                return true;
            }else{
                Log.w(TAG, "---------java take_to_top fail-------");
                return false;
            }
        }
        return true;
    }
}
