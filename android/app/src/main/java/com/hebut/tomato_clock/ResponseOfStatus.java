package com.hebut.tomato_clock;
import android.content.BroadcastReceiver;

public class ResponseOfStatus extends BroadcastReceiver {
    @Override
    public void onReceive(android.content.Context context, android.content.Intent intent) {
        System.out.println("ResponseOfStatus onReceive");
    }
}
