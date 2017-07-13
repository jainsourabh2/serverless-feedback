package com.mastek.speakit.webservices;

import android.content.Context;
import android.net.ConnectivityManager;

/**
 * Created by shreyas13732 on 6/9/2017.
 */

public class NetworkHelper {

    public static boolean isNetworkAvailable(Context context) {
        ConnectivityManager cm = (ConnectivityManager) context.getSystemService(Context.CONNECTIVITY_SERVICE);
        return cm.getActiveNetworkInfo() != null && cm.getActiveNetworkInfo().isConnectedOrConnecting();
    }
}
