package com.mastek.speakit.utils;

import android.app.AlertDialog;
import android.app.Dialog;
import android.content.Context;
import android.content.DialogInterface;

import com.mastek.speakit.R;

/**
 * Created by shreyas13732 on 6/9/2017.
 */

public class DialogManager {

    public static void showOkDialog(Context context, String title, String message){
        AlertDialog.Builder builder = new AlertDialog.Builder(context);
        builder.setTitle(title);
        builder.setMessage(message);
        builder.setPositiveButton(context.getString(R.string.ok), null);
        builder.show();
    }

    public static void showOkDialog(Context context, String message){
        AlertDialog.Builder builder = new AlertDialog.Builder(context);
        builder.setTitle(context.getString(R.string.app_name));
        builder.setMessage(message);
        builder.setPositiveButton(context.getString(R.string.ok), null);
        builder.show();
    }

    public static void showOkDialog(Context context, String message, DialogInterface.OnClickListener listener){
        AlertDialog.Builder builder = new AlertDialog.Builder(context);
        builder.setTitle(context.getString(R.string.app_name));
        builder.setMessage(message);
        builder.setPositiveButton(context.getString(R.string.ok), listener);
        builder.setCancelable(false);
        builder.show();
    }

    public static Dialog showProgressDialog(Context context){
        Dialog dialog = new Dialog(context, R.style.TransparentDialogTheme);
        dialog.setCancelable(false);
        dialog.setContentView(R.layout.dialog_progress);
        dialog.show();
        return dialog;
    }
}
