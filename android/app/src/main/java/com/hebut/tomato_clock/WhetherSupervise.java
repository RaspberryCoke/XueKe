package com.hebut.tomato_clock;
import static com.hebut.tomato_clock.WindowChangeDetectingService.shouldSupervise;

import android.content.BroadcastReceiver;
import android.os.Bundle;
public class WhetherSupervise extends BroadcastReceiver {
    @Override
    public void onReceive(android.content.Context context, android.content.Intent intent) {
        Bundle bundle = intent.getExtras();
        if(bundle==null)return;
        boolean res=bundle.getBoolean("status");
        System.out.println("WhetherSupervise onReceive "+res);
        shouldSupervise=res;
    }
}
