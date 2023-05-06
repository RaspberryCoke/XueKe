package com.hebut.tomato_clock;

import android.annotation.SuppressLint;
import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteException;
import android.database.sqlite.SQLiteOpenHelper;
import android.util.Log;

import androidx.annotation.NonNull;

import java.util.ArrayList;

public class DBAdapter {
    private static final String DB_NAME = "packageName.db";
    private static final String DB_TABLE = "packagesName";
    private static final int DB_VERSION = 1;
    private SQLiteDatabase db;
    private final Context context;
    private DBOpenHelper dbOpenHelper;
    private static class DBOpenHelper extends SQLiteOpenHelper {
        public DBOpenHelper(Context context, String name, SQLiteDatabase.CursorFactory factory, int version) {
            super(context, name, factory, version);
        }
        private static final String DB_CREATE = "create table " +
                DB_TABLE + " (name TEXT);";

        public void onCreate(SQLiteDatabase _db) {
            _db.execSQL(DB_CREATE);

        }
        @Override
        public void onUpgrade(SQLiteDatabase _db, int _oldVersion, int _newVersion) {
            _db.execSQL("DROP TABLE IF EXISTS " + DB_TABLE);
            onCreate(_db);
        }
    }
    public DBAdapter(Context _context) {
        context = _context;
    }
    public void open() throws SQLiteException {
        dbOpenHelper = new DBOpenHelper(context, DB_NAME, null, DB_VERSION);
        try {
            db = dbOpenHelper.getWritableDatabase();
            //ContentValues newValues =new ContentValues();
            //newValues.put("name","学刻");
            //db.insert(DB_TABLE,null,newValues);
        }
        catch (SQLiteException ex) {
            db = dbOpenHelper.getReadableDatabase();
        }
    }
    public void close() {
        if (db != null){
            db.close();
            db = null;
        }
    }
    @SuppressLint("Range")
    public ArrayList<String> getAllPackage()
    {
        System.out.println("getAllPackage");
        Cursor cursor = db.query(DB_TABLE, new String[] { "name"}, null, null, null, null, null);
        ArrayList<String> packages=new ArrayList<String>(cursor.getCount());
        int resultCounts = cursor.getCount();
        if (resultCounts == 0 || !cursor.moveToFirst()){
            return packages;
        }

        for (int i = 0 ; i<resultCounts; i++)
        {
            Log.w("getAllPackage",cursor.getString(cursor.getColumnIndex("name")));
            packages.add(cursor.getString(cursor.getColumnIndex("name")));
            cursor.moveToNext();
        }
        return packages;
    }
}

