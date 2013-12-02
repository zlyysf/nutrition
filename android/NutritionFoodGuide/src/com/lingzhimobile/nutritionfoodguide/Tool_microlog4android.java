package com.lingzhimobile.nutritionfoodguide;

import android.content.Context;

import com.google.code.microlog4android.*;
import com.google.code.microlog4android.config.*;

/*
 * 在assert/microlog.properties 中设置的 microlog.appender.FileAppender.File=mylog.txt 不起作用，实际是 SD卡根目录microlog.txt的文件
 * http://www.cnblogs.com/fbsk/archive/2012/03/08/2385195.html
 */

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
