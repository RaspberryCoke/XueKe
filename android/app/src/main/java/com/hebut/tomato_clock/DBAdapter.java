package com.hebut.tomato_clock;

import android.annotation.SuppressLint;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteException;
import android.database.sqlite.SQLiteOpenHelper;

import java.util.ArrayList;

public class DBAdapter {
    private static final String DB_NAME = "white_package.db";
    private static final String DB_TABLE = "packages";

    private static final String COLUMN_APP_NAME="AppName";
    private static final String COLUMN_PACKAGE_NAME="PackageName";
    private static final int DB_VERSION = 1;
    private static SQLiteDatabase db;
    private final Context context;
    private DBOpenHelper dbOpenHelper;
    private static class DBOpenHelper extends SQLiteOpenHelper {
        public DBOpenHelper(Context context, String name, SQLiteDatabase.CursorFactory factory, int version) {
            super(context, name, factory, version);
        }
        private static final String DB_CREATE = "create table " +
                DB_TABLE + " ("+COLUMN_APP_NAME+" TEXT," +
                COLUMN_PACKAGE_NAME+" TEXT);";

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
        }
        catch (SQLiteException ex) {
            db = dbOpenHelper.getReadableDatabase();
        }
    }
    public void close() {
        if (db != null&&db.isOpen()){
            db.close();
            db = null;
        }
    }
    @SuppressLint("Range")
    public static ArrayList<String> query()
    {
        System.out.println("---------java  query------------");
        System.out.println("db==null?"+db==null);
        System.out.println("db.isOpen()?"+db.isOpen());
        Cursor cursor = db.query(DB_TABLE, new String[] { "packageName"}, null, null, null, null, null);
        ArrayList<String> packages=new ArrayList<String>(cursor.getCount());
        int resultCounts = cursor.getCount();
        if (resultCounts == 0 || !cursor.moveToFirst()){
            return packages;
        }
        for (int i = 0 ; i<resultCounts; i++)
        {
            packages.add(cursor.getString(cursor.getColumnIndex("packageName")));
            cursor.moveToNext();
        }
        if(!packages.contains("com.hebut.tomato_clock"))
            packages.add("com.hebut.tomato_clock");
        return packages;
    }
    public boolean isOpen()
    {
        return db.isOpen();
    }
}

