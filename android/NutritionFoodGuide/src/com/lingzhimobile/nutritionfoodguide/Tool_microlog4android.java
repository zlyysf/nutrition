package com.lingzhimobile.nutritionfoodguide;

import android.content.Context;

import com.google.code.microlog4android.*;
import com.google.code.microlog4android.config.*;

public class Tool_microlog4android {
	private static Logger logger;
	static public void init(Context ctx){
		if (logger==null){
			logger = LoggerFactory.getLogger();
			PropertyConfigurator.getConfigurator(ctx).configure();
		}
	}
	
	static private Logger getLogger(){
		return logger;
	}
	
	static public void logDebug(String msg){
		if (Constants.KeyIsEnvironmentDebug){
		    if (getLogger()!= null)
		        getLogger().debug(msg);
		}
		
	}

}
