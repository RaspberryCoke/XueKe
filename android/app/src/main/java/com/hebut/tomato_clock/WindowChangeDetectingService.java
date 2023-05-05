package com.hebut.tomato_clock;

import android.accessibilityservice.AccessibilityService;
import android.content.Intent;
import android.content.IntentFilter;
import android.util.Log;
import android.view.accessibility.AccessibilityEvent;

import java.util.HashSet;
import java.util.Set;

public class WindowChangeDetectingService extends AccessibilityService {
    public static Set<String> PACKAGES = new HashSet<>();
    private String lastAppName = "";
    public static boolean shouldSupervise = true;
    private final String WINDOW_CHANGE = "com.hebut.broadcast.WindowChange";
    private final String WHETHER_SUPERVISE = "com.hebut.broadcast.WhetherSupervise";
    private final String PACKAGE_CHANGE = "com.hebut.broadcast.PackageChange";
    private final String REQUEST_ALIVE_STATUS = "com.hebut.broadcast.RequestAliveStatus";
    private final Intent intentWindowChange = new Intent(WINDOW_CHANGE);
    private final RequestAliveStatus _RequestAliveStatus = new RequestAliveStatus();
    private final PackageChange _packageChange = new PackageChange();
    private final WhetherSupervise _whetherSupervise = new WhetherSupervise();

    @Override
    public void onAccessibilityEvent(AccessibilityEvent event) {
        if (shouldSupervise &&
                event.getEventType() == AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED) {
            String _name = event.getPackageName().toString();
            String _class = event.getClassName().toString();
            Log.i("onAccessibilityEvent", "active");
            Log.i("onAccessibilityEvent", "name: " + _name);
            Log.i("onAccessibilityEvent", "class: " + _class);
            intentWindowChange.putExtra("new", _name);
            intentWindowChange.putExtra("old", lastAppName);
            sendBroadcast(intentWindowChange);
            lastAppName = _name;
        }
    }

    @Override
    public void onCreate() {
        super.onCreate();
        registerReceiver(_RequestAliveStatus, new IntentFilter(REQUEST_ALIVE_STATUS));
        registerReceiver(_packageChange, new IntentFilter(PACKAGE_CHANGE));
        registerReceiver(_whetherSupervise, new IntentFilter(WHETHER_SUPERVISE));
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        unregisterReceiver(_RequestAliveStatus);
        unregisterReceiver(_packageChange);
        unregisterReceiver(_whetherSupervise);
    }

    @Override
    protected void onServiceConnected() {
        super.onServiceConnected();
    }

    @Override
    public void onInterrupt() {
    }
}