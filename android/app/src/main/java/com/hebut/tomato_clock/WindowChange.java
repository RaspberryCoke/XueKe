package com.hebut.tomato_clock;

import android.content.BroadcastReceiver;

public class WindowChange extends BroadcastReceiver {
    @Override
    public void onReceive(android.content.Context context, android.content.Intent intent) {
        android.os.Bundle bundle = intent.getExtras();
        if (bundle != null)
        {
            System.out.println("WindowChange onReceive");
            System.out.println("new: "+bundle.getString("new"));
            System.out.println("old: "+bundle.getString("old"));

        }
    }
}
