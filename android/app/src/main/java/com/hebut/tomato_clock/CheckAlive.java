package com.hebut.tomato_clock;
import android.content.BroadcastReceiver;

public class CheckAlive extends BroadcastReceiver {
    @Override
    public void onReceive(android.content.Context context, android.content.Intent intent) {
        android.os.Bundle bundle = intent.getExtras();
        if (bundle != null &&
                bundle.containsKey("response")&&
                bundle.get("response").equals(true))
        {
            System.out.println("Alive onReceive");
            intent.putExtra("response", true);
        }
    }
}
