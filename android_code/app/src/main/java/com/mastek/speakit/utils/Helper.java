package com.mastek.speakit.utils;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.util.Base64;
import android.util.Log;
import android.widget.Toast;

import com.android.volley.AuthFailureError;
import com.android.volley.Request;
import com.android.volley.VolleyError;
import com.android.volley.VolleyLog;
import com.android.volley.toolbox.JsonObjectRequest;
import com.google.zxing.BarcodeFormat;
import com.google.zxing.WriterException;
import com.google.zxing.common.BitMatrix;
import com.google.zxing.qrcode.QRCodeWriter;
import com.mastek.speakit.BuildConfig;
import com.mastek.speakit.application.AppController;
import com.mastek.speakit.interfaces.AuthenticationListener;
import com.mastek.speakit.webservices.APIClient;

import org.json.JSONObject;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by shreyas13732 on 6/6/2017.
 */

public class Helper {

    public static void log(String key, String value){
        if (BuildConfig.DEBUG) {
            Log.d(key,value);
        }
    }

    public static void showToast(Context context, String message){
        Toast.makeText(context, message, Toast.LENGTH_LONG).show();
    }

    public static boolean isValidEmailAddress(String email){
        if (email == null) {
            return false;
        } else {
            return android.util.Patterns.EMAIL_ADDRESS.matcher(email).matches();
        }
    }

    public static Bitmap convertBase64StringToBitmap(String encodedImage){
        try {

            byte[] decodedString = Base64.decode(encodedImage, Base64.DEFAULT);
            Bitmap decodedByte = BitmapFactory.decodeByteArray(decodedString, 0, decodedString.length);
            return decodedByte;
        }catch (Throwable throwable){
            throwable.printStackTrace();
            return null;
        }
    }

    public static Bitmap getQRCode(String barcode_content, int size){
        QRCodeWriter writer = new QRCodeWriter();
        try {
            BitMatrix bitMatrix = writer.encode(barcode_content, BarcodeFormat.QR_CODE, size, size);
            int width = bitMatrix.getWidth();
            int height = bitMatrix.getHeight();
            Bitmap bmp = Bitmap.createBitmap(width, height, Bitmap.Config.RGB_565);
            for (int x = 0; x < width; x++) {
                for (int y = 0; y < height; y++) {
                    bmp.setPixel(x, y, bitMatrix.get(x, y) ? Color.BLACK : Color.WHITE);
                }
            }
            return bmp;
        } catch (WriterException e) {
            e.printStackTrace();
            return null;
        }
    }


    public static void authenticateUser(final Context context, final String username, final String password, final AuthenticationListener listener){
        try {
            JSONObject reqObj = new JSONObject();
            reqObj.put("username", username);
            reqObj.put("password", password);

            JsonObjectRequest jsonObjReq = new JsonObjectRequest(Request.Method.POST,
                    APIClient.BASE_URL+"loginUser/authenticateUser", reqObj,new com.android.volley.Response.Listener<JSONObject>() {

                @Override
                public void onResponse(final JSONObject response) {
                    Log.d("response", response.toString());
                    AppSession.getSession().saveIsLogin(context, true);
                    AppSession.getSession().saveUserName(context, username);
                    AppSession.getSession().savePassword(context, password);
                    AppSession.getSession().saveSessionToken(context, response.optString("authorization"));
                    listener.onAuthenticateSuccess();
                }
            }, new com.android.volley.Response.ErrorListener() {

                @Override
                public void onErrorResponse(VolleyError error) {
                    VolleyLog.d("error", "Error: " + error.getMessage());
                }
            }) {

                /**
                 * Passing some request headers
                 * */
                @Override
                public Map<String, String> getHeaders() throws AuthFailureError {
                    HashMap<String, String> headers = new HashMap<String, String>();
                    headers.put("Content-Type", "application/json");
                    return headers;
                }

            };
            AppController.getInstance().addToRequestQueue(jsonObjReq, "json_request");
        }catch (Exception e){
            e.printStackTrace();
        }

    }
}
