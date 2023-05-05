package com.hebut.tomato_clock;

import android.content.BroadcastReceiver;
import android.content.Intent;
import android.os.Bundle;
import android.content.Intent;
import android.content.IntentFilter;

public class RequestAliveStatus extends BroadcastReceiver {
    private final String RESPONSE_OF_STATUS = "com.hebut.broadcast.ResponseOfStatus";
    @Override
    public void onReceive(android.content.Context context, android.content.Intent intent) {
        Bundle bundle = intent.getExtras();
        if (bundle != null &&
                bundle.containsKey("request")&&
                bundle.get("request").equals(true))
        {
            System.out.println("RequestAliveStatus onReceive");
            Intent intent1 = new Intent(RESPONSE_OF_STATUS);
            intent1.putExtra("response", true);
            context.sendBroadcast(intent1);
        }
    }
}
