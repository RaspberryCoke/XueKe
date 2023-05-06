package com.hebut.tomato_clock;
import static com.hebut.tomato_clock.MainActivity.appList;

import android.content.BroadcastReceiver;
import android.os.Bundle;

import java.util.Arrays;

public class PackageChange extends BroadcastReceiver {
    @Override
    public void onReceive(android.content.Context context, android.content.Intent intent) {
        System.out.println("PackageChange onReceive");
        Bundle bundle = intent.getExtras();
        if(bundle==null)return;
        appList.clear();
        appList.addAll(Arrays.asList(bundle.getStringArray("package")));
    }
}
