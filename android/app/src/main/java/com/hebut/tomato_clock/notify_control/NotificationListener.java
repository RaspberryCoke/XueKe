package com.hebut.tomato_clock.notify_control;

import static com.hebut.tomato_clock.white_app.WindowChangeDetectingService.shouldSupervise;

import android.app.Notification;
import android.os.Build;
import android.os.Bundle;
import android.service.notification.NotificationListenerService;
import android.service.notification.StatusBarNotification;
import android.util.Log;

import androidx.annotation.RequiresApi;

import com.hebut.tomato_clock.MainActivity;
import com.hebut.tomato_clock.white_app.MasterService;

import java.util.List;
import java.util.Map;

@RequiresApi(api = Build.VERSION_CODES.JELLY_BEAN_MR2)
public class NotificationListener extends NotificationListenerService {
    //其他过滤条件，比如包名，标题，内容等等，由其他服务更改
    //当系统收到新的通知后出发回调
    @Override
    public void onNotificationPosted(StatusBarNotification sbn) {
        Log.i("JAVA NotificationListener", "JAVA shouldSupervise:"+shouldSupervise);
        if(!shouldSupervise) {
            super.onNotificationPosted(sbn);
            return;
        }
        Log.i("JAVA NotificationListener", "JAVA onNotificationPosted start");


        //debug
        Log.i("NotificationListener","------------------开始debug--------------------");
        Bundle the_extras = sbn.getNotification().extras;
        if(the_extras==null)
        {
            Log.e("NotificationListener","debug :  异常的通知,debug结束");
        }
        try {
            // 获取通知标题
            String _title = the_extras.getString(Notification.EXTRA_TITLE, "null title");
            // 获取通知内容
            String _content = the_extras.getString(Notification.EXTRA_TEXT, "null content");
            String _sub_text = the_extras.getString(Notification.EXTRA_SUB_TEXT, "null subtext");
            Log.i("NotificationListener", "debug:packageName:" + sbn.getPackageName());
            Log.i("NotificationListener", "debug:title:" + _title);
            Log.i("NotificationListener", "debug:content:" + _content);
            Log.i("NotificationListener", "debug:sub_text:" + _sub_text);
        }catch (Exception e){
            Log.e("NotificationListener","debug :  异常的通知,debug结束");
        }
        //目前需要拦截的包有：
        Log.i("NotificationListener","---------------目前为止，全局需要拦截的包有：--------------------");
        for(Map.Entry<String, List<String>> entry: MainActivity.packageToFilter.entrySet()) {
            Log.i("NotificationListener", "debug :  包名：" + entry.getKey());
            List<String> filterList = entry.getValue();
            if (filterList.contains("")) {
                Log.i("NotificationListener", "debug :  其中的关键字包含空字符串，全部阻塞");
            }
            for (String filter : filterList) {
                Log.i("NotificationListener", "debug :  其中的关键字：" + filter);
            }
        }
        Log.i("NotificationListener","---------------继续代码的执行------------------");
        //debug
        //debug


        String package_name=sbn.getPackageName();
        if(package_name==null){
            Log.e("NotificationListener","debug :  sbn.getPackageName()==null");
            Log.e("NotificationListener","debug :  异常的通知，放行");
            super.onNotificationPosted(sbn);
            return;
        }


        List<String> filterList=MainActivity.packageToFilter.get(package_name);
        if(filterList==null){
            Log.i("NotificationListener","debug :  filterList==null");
            super.onNotificationPosted(sbn);
            return;
        }

        Log.w("NotificationListener","debug :  当前包名为的全局过滤词有："+filterList.size()+"个");


        Log.i("NotificationListener","debug :  发现需要拦截的包名");
        Log.i("NotificationListener","debug :  该包的关键词有："+filterList.size()+"个");


        Log.i("NotificationListener","debug :  遍历关键词");
        for(String filter:filterList){
            Log.i("NotificationListener","debug :  "+filter);
        }


        //全部都要阻塞?
        if(filterList.size()==0|| (filterList.size()==1&&filterList.contains(""))){
            cancelNotification(sbn.getKey());
            super.onNotificationPosted(sbn);
            Log.i("NotificationListener","debug :  没有放行关键字,或者包含空字符串，全部都要阻塞");
            return;
        }else//消息过滤
        {
            boolean _contain=false;
            String title;
            String content;
            String sub_text;
            Bundle extras = sbn.getNotification().extras;


            if(extras==null) {//异常
                super.onNotificationPosted(sbn);
                Log.i("NotificationListener","debug : extras==null,异常的通知，放行");
                return;
            }


            title = extras.getString(Notification.EXTRA_TITLE, "");
            content = extras.getString(Notification.EXTRA_TEXT, "");
            sub_text = extras.getString(Notification.EXTRA_SUB_TEXT, "");
            Log.i("NotificationListener", "title:" + title);
            Log.i("NotificationListener", "content:" + content );
            Log.i("NotificationListener", "subtext:" + sub_text);


            Log.i("NotificationListener", "debug :  开始检查关键字,分别检查三个内容中是否包含关键字。");
            for(String filter:filterList){
                if(title.contains(filter)||content.contains(filter)||sub_text.contains(filter)){
                    Log.w("NotificationListener","title:"+title+",contains filter:"+filter+" is "+title.contains(filter));
                    Log.w("NotificationListener","content:"+content+",contains filter:"+filter+" is "+content.contains(filter));
                    Log.w("NotificationListener","sub_text:"+sub_text+",contains filter:"+filter+" is "+sub_text.contains(filter));
                    _contain=true;
                    break;
                }
            }
            if(_contain) {
                super.onNotificationPosted(sbn);
                Log.i("NotificationListener","debug :  找到关键字，放行");
                return;
            }
        }


        Log.i("NotificationListener","debug :  没有找到关键字，阻塞");
        cancelNotification(sbn.getKey());
        super.onNotificationPosted(sbn);
    }

    //当系统通知被删掉后出发回调
    @Override
    public void onNotificationRemoved(StatusBarNotification sbn) {
        Log.i("NotificationListener", "onNotificationRemoved");
        super.onNotificationRemoved(sbn);
    }
}