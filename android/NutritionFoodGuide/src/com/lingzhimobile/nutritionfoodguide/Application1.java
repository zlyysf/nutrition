package com.lingzhimobile.nutritionfoodguide;

import com.parse.Parse;
import com.parse.ParseACL;
import com.parse.ParseInstallation;
import com.parse.PushService;

import com.parse.ParseUser;


import android.app.Application;
import android.util.Log;

public class Application1 extends Application {

	@Override
	public void onCreate() {
		super.onCreate();
		
		Parse.setLogLevel(Parse.LOG_LEVEL_VERBOSE);

		// Add your initialization code here
		Parse.initialize(this, Constants.ParseApp_ApplicationID, Constants.ParseApp_ClientKey);

		//for push

		PushService.setDefaultPushCallback(this, ActivityHome.class);
		ParseInstallation.getCurrentInstallation().saveInBackground();

//		ParseUser.enableAutomaticUser();//会导致每次通过ide运行app都会创建一个新的Anonymous user
		
		ParseACL defaultACL = new ParseACL();
	    
		// If you would like all objects to be private by default, remove this line.
		defaultACL.setPublicReadAccess(true);
		defaultACL.setPublicWriteAccess(true);
		
		ParseACL.setDefaultACL(defaultACL, true);
		
		
		
		
		
	}

}
