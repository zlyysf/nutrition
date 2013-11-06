package com.lingzhimobile.nutritionfoodguide;

import android.app.Activity;
import android.app.Notification;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;



public class BroadcastReceiverAlert extends BroadcastReceiver  {
	
	

	@Override
	public void onReceive(Context context, Intent intent) {
//		intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);  
//		intent.setClass(context, ActivityAlarmTool.class);// ActivityHome.class);  
//		context.startActivity(intent);  
		
		NotificationManager nm=(NotificationManager) context.getSystemService(Activity.NOTIFICATION_SERVICE);  
//		Uri uriData = intent.getData();
//		if (Constants.URIflag_morning.equals(uriData)){
//			Notification notification1=new Notification(R.drawable.ic_launcher, "a1", System.currentTimeMillis());  
//			Intent intent1 = new Intent(context,ActivityHome.class);
//			intent1.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);  
//			intent1.putExtra(Constants.IntentParamKey_IsFromDiagnoseAlert, true);
//			PendingIntent pendingIntent1 = PendingIntent.getActivity(context, 0, intent1, PendingIntent.FLAG_UPDATE_CURRENT);
//			
//	        notification1.setLatestEventInfo(context, "title111111111111", "contentAAAAAAAAAA", pendingIntent1);
//	        nm.notify(Constants.NotificationId_diagnoseAlert_morning, notification1);  
//		}else if (Constants.URIflag_afternoon.equals(uriData)){
//			Notification notification1=new Notification(R.drawable.ic_launcher, "b2", System.currentTimeMillis());  
//			Intent intent1 = new Intent(context,ActivityHome.class);
//			intent1.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);  
//			intent1.putExtra(Constants.IntentParamKey_IsFromDiagnoseAlert, true);
//			PendingIntent pendingIntent1 = PendingIntent.getActivity(context, 0, intent1, PendingIntent.FLAG_UPDATE_CURRENT);
//			
//	        notification1.setLatestEventInfo(context, "title222222222222", "contentBBBBBBBBBBBB", pendingIntent1);
//	        nm.notify(Constants.NotificationId_diagnoseAlert_afternoon, notification1);  
//		}else{
//			Notification notification1=new Notification(R.drawable.ic_launcher, "c3", System.currentTimeMillis());  
//			Intent intent1 = new Intent(context,ActivityHome.class);
//			intent1.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);  
//			intent1.putExtra(Constants.IntentParamKey_IsFromDiagnoseAlert, true);
//			PendingIntent pendingIntent1 = PendingIntent.getActivity(context, 0, intent1, PendingIntent.FLAG_UPDATE_CURRENT);
//			
//	        notification1.setLatestEventInfo(context, "title33333333", "contentCCCCCCCCCCC", pendingIntent1);
//	        nm.notify(Constants.NotificationId_diagnoseAlert_night, notification1);  
//		}
		
		String tickerText = context.getResources().getString(R.string.app_name);
		String notifyTitle = tickerText;
		String notifyContent = context.getResources().getString(R.string.diagnoseTimeIsUp);
		Notification notification1=new Notification(R.drawable.ic_launcher, tickerText, System.currentTimeMillis());  
		Intent intent1 = new Intent(context,ActivityHome.class);
		intent1.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);  
//		intent1.putExtra(Constants.IntentParamKey_IsFromDiagnoseAlert, true);
		intent.putExtra(Constants.IntentParamKey_DestinationActivity, ActivityDiagnose.class.getName());
		PendingIntent pendingIntent1 = PendingIntent.getActivity(context, 0, intent1, PendingIntent.FLAG_UPDATE_CURRENT);
		
        notification1.setLatestEventInfo(context, notifyTitle, notifyContent, pendingIntent1);
        nm.notify(Constants.NotificationId_diagnoseAlert_anyTime, notification1);  
		
//        Notification notification1 = new Notification.Builder(this)
//        .setContentTitle("titleaaaaaaaaa")
//        .setContentText("contentBBBBBBBBBBB")
//        .setSmallIcon(R.drawable.ic_launcher)
//        .build();
	}

}
