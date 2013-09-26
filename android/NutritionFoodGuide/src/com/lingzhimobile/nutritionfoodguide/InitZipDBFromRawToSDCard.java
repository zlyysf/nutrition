package com.lingzhimobile.nutritionfoodguide;

import java.io.BufferedInputStream;

import java.io.File;

import java.io.FileOutputStream;

import java.io.IOException;

import java.io.InputStream;

import java.io.OutputStream;

import java.util.zip.ZipEntry;

import java.util.zip.ZipInputStream;

import android.app.ProgressDialog;

import android.content.Context;

import android.database.Cursor;

import android.database.SQLException;

import android.database.sqlite.SQLiteDatabase;

import android.database.sqlite.SQLiteOpenHelper;

import android.os.AsyncTask;


public class InitZipDBFromRawToSDCard {
	
    public static final String DATABASE_NAME = "CustomDB.dat";

    private static final int DATABASE_VERSION = 1;

    private DatabaseHelper mDbHelper;

    private SQLiteDatabase mDb;

    private final Context mCtx;

    private static int mDBRawResource = 0; 

    public InitZipDBFromRawToSDCard(Context ctx,int DBRawResource) {

        this.mCtx = ctx;

        mDBRawResource = DBRawResource;

    }

    public InitZipDBFromRawToSDCard(Context ctx) {

        this.mCtx = ctx;

        if (mDBRawResource == 0)

            new Exception("必须指定以zip压缩的数据库Raw文件");

    }

    public static class DatabaseHelper extends SQLiteOpenHelper {

        DatabaseHelper(Context context) {

            super(context, DATABASE_NAME, null, DATABASE_VERSION);

        }

        @Override

        public void onCreate(SQLiteDatabase db) {    

        }

        @Override

        public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {

        }

    }

    

    

    class DBDialogTask extends AsyncTask<String, Integer, Integer> {

        ProgressDialog m_pDialog;

        int StreamLen;

        @Override

        protected Integer doInBackground(String... params) { // 后台进程执行的具体计算在这里实现

            String dbPathString = params[0];

            int len = 1024;//

            int readCount = 0, readSum = 0;

            byte[] buffer = new byte[len];        

            InputStream inputStream;

            OutputStream output;

            try {

                inputStream = mCtx.getResources().openRawResource(mDBRawResource); //这里就是Raw文件引用位置

                output = new FileOutputStream(dbPathString);

                

                ZipInputStream zipInputStream = new ZipInputStream(

                        new BufferedInputStream(inputStream));

                ZipEntry zipEntry = zipInputStream.getNextEntry();

                BufferedInputStream b = new BufferedInputStream(

                        zipInputStream);

                StreamLen = (int) zipEntry.getSize();

                while ((readCount = b.read(buffer)) != -1) {

                //    readCount = b.read(buffer);

                    output.write(buffer,0,readCount);

                    readSum = readSum + readCount;

                    publishProgress(readSum);

                }

                output.flush();

                output.close();

            } catch (IOException e) {

                e.printStackTrace();

            }

            return StreamLen;

        }

        @Override

        // 运行于UI线程。如果在doInBackground(Params...)

        // 中使用了publishProgress(Progress...)，就会触发这个方法。在这里可以对进度条控件根据进度值做出具体的响应。

        protected void onProgressUpdate(Integer... values) {

            super.onProgressUpdate(values);

            if (m_pDialog.getMax() != StreamLen)

                m_pDialog.setMax(StreamLen);

            m_pDialog.setProgress(values[0]);

        }

        @Override

        // 执行预处理，它运行于UI线程，可以为后台任务做一些准备工作，比如绘制一个进度条控件。

        protected void onPreExecute() {

            super.onPreExecute();

            m_pDialog = new ProgressDialog(mCtx);

            m_pDialog.setProgressStyle(ProgressDialog.STYLE_HORIZONTAL);

            m_pDialog.setTitle("提示");

            m_pDialog.setMessage("正在升级数据库,请勿关闭应用程序");

            m_pDialog.show();

        }

        @Override

        // 运行于UI线程，可以对后台任务的结果做出处理，结果就是doInBackground(Params...)的返回值

        protected void onPostExecute(Integer result) {

            super.onPostExecute(result);

            m_pDialog.setProgress(result);

            m_pDialog.cancel();

            if (onDBInstalledListener != null)

                onDBInstalledListener.OnDBInstalled();

        }

    }    

    

    protected OnDBInstalledListener onDBInstalledListener;

    

    public void setOnDBInstalledListener(OnDBInstalledListener onDBInstalledListener) {

        this.onDBInstalledListener = onDBInstalledListener;

    }

    

    public void InstallDatabase() {

        mDbHelper = new DatabaseHelper(mCtx);

        SQLiteDatabase sdbreader = mDbHelper.getReadableDatabase();

        File dbfile = new File(sdbreader.getPath());

        if (dbfile.length()<4096){//依据数据库大小判断,是否需要执行安装.暂时没仔细想别的办法

            DBDialogTask dialogTask = new DBDialogTask();

            dialogTask.execute(sdbreader.getPath());

        }else{

            if (onDBInstalledListener != null)

                onDBInstalledListener.OnDBInstalled(); //这里可以委托一个方法,用以安装完数据库后的初始化工作

        }

    }

    public InitZipDBFromRawToSDCard open() throws SQLException {

        if( mDbHelper == null)

            mDbHelper = new DatabaseHelper(mCtx);

        if (mDb == null)

            mDb = mDbHelper.getWritableDatabase();

        if (!mDb.isOpen())

            mDb = mDbHelper.getWritableDatabase();

        return this;

    }

    public void close() {

        mDbHelper.close();

    }

    

    public Cursor GetSomeData() {

        return mDb.query("table",

                new String[] { "_id", "a1", "a2" }, "a1 = 1",

                null, null, null, "a2");

    }

    

    public interface OnDBInstalledListener{

        void OnDBInstalled();

    }


}
