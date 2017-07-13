package com.mastek.speakit.utils;

import android.content.Context;
import android.content.SharedPreferences;

/**
 * Created by shreyas13732 on 6/12/2017.
 */

public class AppSession {

    private static AppSession session;
    private static final String TAG = AppSession.class.getName();
    private static final String SESSION ="session";
    private static final String USERNAME = "username";
    private static final String PASSWORD = "password";
    private static final String IS_LOGIN = "is_login";

    public static AppSession getSession(){
        if (session == null){
            session = new AppSession();
        }
        return session;
    }

    public void saveSessionToken(Context context, String token){
        SharedPreferences sharedPref = context.getSharedPreferences(TAG,Context.MODE_PRIVATE);
        SharedPreferences.Editor editor = sharedPref.edit();
        editor.putString(SESSION, token);
        editor.commit();
    }

    public String getSessionToken(Context context){
        SharedPreferences sharedPref = context.getSharedPreferences(TAG,Context.MODE_PRIVATE);
        return sharedPref.getString(SESSION, "");
    }

    public void saveUserName(Context context, String username){
        SharedPreferences sharedPref = context.getSharedPreferences(TAG,Context.MODE_PRIVATE);
        SharedPreferences.Editor editor = sharedPref.edit();
        editor.putString(USERNAME, username);
        editor.commit();
    }

    public String getUserName(Context context){
        SharedPreferences sharedPref = context.getSharedPreferences(TAG,Context.MODE_PRIVATE);
        return sharedPref.getString(USERNAME, "");
    }

    public void savePassword(Context context, String password){
        SharedPreferences sharedPref = context.getSharedPreferences(TAG,Context.MODE_PRIVATE);
        SharedPreferences.Editor editor = sharedPref.edit();
        editor.putString(PASSWORD, password);
        editor.commit();
    }

    public String getPassword(Context context){
        SharedPreferences sharedPref = context.getSharedPreferences(TAG,Context.MODE_PRIVATE);
        return sharedPref.getString(PASSWORD, "");
    }

    public void saveIsLogin(Context context, boolean isLogin){
        SharedPreferences sharedPref = context.getSharedPreferences(TAG,Context.MODE_PRIVATE);
        SharedPreferences.Editor editor = sharedPref.edit();
        editor.putBoolean(IS_LOGIN, isLogin);
        editor.commit();
    }

    public boolean isLogin(Context context){
        SharedPreferences sharedPref = context.getSharedPreferences(TAG,Context.MODE_PRIVATE);
        return sharedPref.getBoolean(IS_LOGIN, false);
    }


}
