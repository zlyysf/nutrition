package com.lingzhimobile.nutritionfoodguide;

import java.util.Calendar;

import android.app.AlarmManager;
import android.app.PendingIntent;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;

public class BroadcastReceiverBootComplete extends BroadcastReceiver  {

	@Override
	public void onReceive(Context context, Intent intent) {
		ActivityDiagnoseAlertSetting.setAlarm(context);
	}

}
