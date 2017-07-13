package com.mastek.speakit.activities;

import android.app.Dialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.text.Editable;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;

import com.android.volley.AuthFailureError;
import com.android.volley.Request;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.VolleyLog;
import com.android.volley.toolbox.JsonObjectRequest;
import com.mastek.speakit.R;
import com.mastek.speakit.application.AppController;
import com.mastek.speakit.utils.AppSession;
import com.mastek.speakit.utils.DialogManager;
import com.mastek.speakit.utils.Helper;
import com.mastek.speakit.webservices.APIClient;

import org.json.JSONObject;

import java.util.HashMap;
import java.util.Map;

import butterknife.ButterKnife;
import butterknife.InjectView;
import butterknife.OnClick;

public class VerificationActivity extends AppCompatActivity {

    @InjectView(R.id.etFirstNumber)
    EditText etFirstNumber;
    @InjectView(R.id.etSecondNumber)
    EditText etSecondNumber;
    @InjectView(R.id.etThirdNumber)
    EditText etThirdNumber;
    @InjectView(R.id.etFourthNumber)
    EditText etFourthNumber;
    @InjectView(R.id.btSubmit)
    Button btSubmit;
    String username;
    @InjectView(R.id.etFifthNumber)
    EditText etFifthNumber;
    @InjectView(R.id.etSixthNumber)
    EditText etSixthNumber;
    @InjectView(R.id.tvResendOTP)
    TextView tvResendOTP;
    String password;
    Dialog mDialog;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_verification);
        ButterKnife.inject(this);
        username = getIntent().getExtras().getString("username");
        password = getIntent().getExtras().getString("password");
        initialise();
    }

    private void initialise() {
        etFirstNumber.addTextChangedListener(new GenericTextWatcher(etFirstNumber));
        etSecondNumber.addTextChangedListener(new GenericTextWatcher(etSecondNumber));
        etThirdNumber.addTextChangedListener(new GenericTextWatcher(etThirdNumber));
        etFourthNumber.addTextChangedListener(new GenericTextWatcher(etFourthNumber));
        etFifthNumber.addTextChangedListener(new GenericTextWatcher(etFifthNumber));
        etSixthNumber.addTextChangedListener(new GenericTextWatcher(etSixthNumber));
    }

    private String buildOTPCode() {
        StringBuilder builder = new StringBuilder();
        builder.append(etFirstNumber.getText().toString());
        builder.append(etSecondNumber.getText().toString());
        builder.append(etThirdNumber.getText().toString());
        builder.append(etFourthNumber.getText().toString());
        builder.append(etFifthNumber.getText().toString());
        builder.append(etSixthNumber.getText().toString());
        return builder.toString();
    }

    private boolean isValid() {
        if (TextUtils.isEmpty(etFirstNumber.getText().toString()) ||
                TextUtils.isEmpty(etSecondNumber.getText().toString()) ||
                TextUtils.isEmpty(etThirdNumber.getText().toString()) ||
                TextUtils.isEmpty(etFourthNumber.getText().toString()) ||
                TextUtils.isEmpty(etFifthNumber.getText().toString()) ||
                TextUtils.isEmpty(etSixthNumber.getText().toString())) {
            Helper.showToast(VerificationActivity.this, getString(R.string.please_enter_valid_otp));
            return false;
        }
        return true;
    }

    @OnClick({R.id.btSubmit, R.id.tvResendOTP})
    public void onViewClicked(View view) {
        switch (view.getId()) {
            case R.id.btSubmit:
                if (isValid()) {
                    confirmUser(username, buildOTPCode());
                }
                break;

            case R.id.tvResendOTP:
                resendOTP(username);
                break;
        }
    }




    public class GenericTextWatcher implements TextWatcher {
        private View view;

        private GenericTextWatcher(View view) {
            this.view = view;
        }

        @Override
        public void afterTextChanged(Editable editable) {
            // TODO Auto-generated method stub
            String text = editable.toString();
            switch (view.getId()) {
                case R.id.etFirstNumber:
                    if (text.length() == 1)
                        etSecondNumber.requestFocus();
                    break;
                case R.id.etSecondNumber:
                    if (text.length() == 1)
                        etThirdNumber.requestFocus();
                    break;
                case R.id.etThirdNumber:
                    if (text.length() == 1)
                        etFourthNumber.requestFocus();
                    break;
                case R.id.etFourthNumber:
                    if (text.length() == 1)
                        etFifthNumber.requestFocus();
                    break;
                case R.id.etFifthNumber:
                    if (text.length() == 1)
                        etSixthNumber.requestFocus();
                    break;
                case R.id.etSixthNumber:
                    break;
            }
        }

        @Override
        public void beforeTextChanged(CharSequence arg0, int arg1, int arg2, int arg3) {
            // TODO Auto-generated method stub
        }

        @Override
        public void onTextChanged(CharSequence arg0, int arg1, int arg2, int arg3) {
            // TODO Auto-generated method stub
        }
    }

    /*private void confirmUser(String username, String code) {
        if (NetworkHelper.isNetworkAvailable(VerificationActivity.this)) {
            JsonObject reqObj = new JsonObject();
            reqObj.addProperty("username", username);
            reqObj.addProperty("code", code);

            NetworkAPI networkAPI = APIClient.getClient().create(NetworkAPI.class);
            Call<JsonObject> call = networkAPI.confirmUser(reqObj);
            call.enqueue(new Callback<JsonObject>() {
                @Override
                public void onResponse(Call<JsonObject> call, Response<JsonObject> response) {
                    Helper.log("response", "response");
                    finish();
                    *//*DialogManager.showOkDialog(VerificationActivity.this, getString(R.string.user_created_successfully), new DialogInterface.OnClickListener() {
                        @Override
                        public void onClick(DialogInterface dialog, int which) {

                        }
                    });*//*
                }

                @Override
                public void onFailure(Call<JsonObject> call, Throwable t) {
                    Helper.log("error", call.toString());
                }
            });
        } else {
            DialogManager.showOkDialog(VerificationActivity.this, getString(R.string.no_internet_connection));
        }
    }*/

    private void confirmUser(final String username, String code) {
        try {
            mDialog = DialogManager.showProgressDialog(VerificationActivity.this);
            JSONObject reqObj = new JSONObject();
            reqObj.put("username", username);
            reqObj.put("code", code);

            JsonObjectRequest jsonObjReq = new JsonObjectRequest(Request.Method.POST,
                    APIClient.BASE_URL + "loginUser/confirmUser", reqObj, new Response.Listener<JSONObject>() {

                @Override
                public void onResponse(final JSONObject response) {
                    mDialog.dismiss();
                    Log.d("response", response.toString());
                    DialogManager.showOkDialog(VerificationActivity.this, response.optString("message"), new DialogInterface.OnClickListener() {
                        @Override
                        public void onClick(DialogInterface dialog, int which) {
                            authenticateUser(username, password);
                        }
                    });
                }
            }, new Response.ErrorListener() {

                @Override
                public void onErrorResponse(VolleyError error) {
                    mDialog.dismiss();
                    VolleyLog.d("error", "Error: " + error.getMessage());
                    if (error.toString().equals(getString(R.string.volley_server_error))){
                        DialogManager.showOkDialog(VerificationActivity.this, getString(R.string.please_enter_valid_otp));
                    }
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
        } catch (Exception e) {
            e.printStackTrace();
        }

    }

    /*private void navigateToLogin(){
        Intent intent = new Intent(VerificationActivity.this, LoginActivity.class);
        intent.putExtra("username", username);
        intent.putExtra("password", password);
        intent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
        startActivity(intent);
        finish();
    }*/
    private void resendOTP(String username) {
        try {

            JSONObject reqObj = new JSONObject();
            reqObj.put("username", username);

            JsonObjectRequest jsonObjReq = new JsonObjectRequest(Request.Method.POST,
                    APIClient.BASE_URL + "loginUser/resendConfirmation", reqObj, new Response.Listener<JSONObject>() {

                @Override
                public void onResponse(final JSONObject response) {
                    Log.d("response", response.toString());
                }
            }, new Response.ErrorListener() {

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
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void authenticateUser(final String username, String password){
        try {
            mDialog = DialogManager.showProgressDialog(VerificationActivity.this);
            JSONObject reqObj = new JSONObject();
            reqObj.put("username", username);
            reqObj.put("password", password);

            JsonObjectRequest jsonObjReq = new JsonObjectRequest(Request.Method.POST,
                    APIClient.BASE_URL+"loginUser/authenticateUser", reqObj,new com.android.volley.Response.Listener<JSONObject>() {

                @Override
                public void onResponse(final JSONObject response) {
                    mDialog.dismiss();
                    Log.d("response", response.toString());
                    AppSession.getSession().saveIsLogin(VerificationActivity.this, true);
                    AppSession.getSession().saveUserName(VerificationActivity.this, username);
                    AppSession.getSession().saveSessionToken(VerificationActivity.this, response.optString("authorization"));
                    navigateToTabActivity();
                }
            }, new com.android.volley.Response.ErrorListener() {

                @Override
                public void onErrorResponse(VolleyError error) {
                    mDialog.dismiss();
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

    private void navigateToTabActivity() {
        Intent intent = new Intent(VerificationActivity.this, TabBaseActivity.class);
        intent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
        startActivity(intent);
        finish();
    }
}
