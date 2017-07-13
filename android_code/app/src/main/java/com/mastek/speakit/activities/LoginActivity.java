package com.mastek.speakit.activities;

import android.app.Dialog;
import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.app.AppCompatDelegate;
import android.text.TextUtils;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;

import com.android.volley.AuthFailureError;
import com.android.volley.Request;
import com.android.volley.VolleyError;
import com.android.volley.VolleyLog;
import com.android.volley.toolbox.JsonObjectRequest;
import com.mastek.speakit.R;
import com.mastek.speakit.application.AppController;
import com.mastek.speakit.utils.AppSession;
import com.mastek.speakit.utils.DialogManager;
import com.mastek.speakit.webservices.APIClient;

import org.json.JSONObject;

import java.util.HashMap;
import java.util.Map;

import butterknife.ButterKnife;
import butterknife.InjectView;
import butterknife.OnClick;

public class LoginActivity extends AppCompatActivity {

    @InjectView(R.id.etEmail)
    EditText etEmail;
    @InjectView(R.id.etPassword)
    EditText etPassword;
    @InjectView(R.id.tvForgotPassword)
    TextView tvForgotPassword;
    @InjectView(R.id.btSignIn)
    Button btSignIn;
    @InjectView(R.id.tvSignUp)
    TextView tvSignUp;
    @InjectView(R.id.etCode)
    EditText etCode;
    Dialog mDialog;

    static {
        AppCompatDelegate.setCompatVectorFromResourcesEnabled(true);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_login);
        ButterKnife.inject(this);
        etCode.setEnabled(false);
        /*if (getIntent().getExtras() != null){
            String username = getIntent().getExtras().getString("username");
            String password = getIntent().getExtras().getString("password");
            authenticateUser(username,password);
        }*/
    }

    @OnClick({R.id.tvForgotPassword, R.id.btSignIn, R.id.tvSignUp})
    public void onViewClicked(View view) {
        switch (view.getId()) {
            case R.id.tvForgotPassword:
                navigateToForgotPassword();
                break;
            case R.id.btSignIn:
                if (isValid()) {
                    authenticateUser((etCode.getText().toString()+etEmail.getText().toString()), etPassword.getText().toString());
                }
                //navigateToTabActivity();
                break;
            case R.id.tvSignUp:
                navigateToSignUp();
                break;
        }
    }

    private void navigateToSignUp() {
        Intent intent = new Intent(LoginActivity.this, SignUpActivity.class);
        startActivity(intent);
    }

    private void navigateToForgotPassword() {
        Intent intent = new Intent(LoginActivity.this, ForgotPasswordActivity.class);
        startActivity(intent);
    }

    private void navigateToTabActivity() {
        Intent intent = new Intent(LoginActivity.this, TabBaseActivity.class);
        startActivity(intent);
        finish();
    }

    private boolean isValid() {
        if (TextUtils.isEmpty(etEmail.getText().toString().trim())) {
            etEmail.setError(getString(R.string.please_enter_mobile_number));
            return false;
        }
        if (etEmail.getText().toString().length()!= 10){
            etEmail.setError(getString(R.string.please_enter_valid_mobile_number));
            return false;
        }

        if (TextUtils.isEmpty(etPassword.getText().toString().trim())) {
            etPassword.setError(getString(R.string.please_enter_password));
            return false;
        }

        if (etPassword.getText().toString().length()<8){
            etPassword.setError(getString(R.string.password_length_too_short));
            return false;
        }
        return true;
    }


    private void authenticateUser(final String username, final String password){
        try {
            mDialog = DialogManager.showProgressDialog(LoginActivity.this);
            JSONObject reqObj = new JSONObject();
            reqObj.put("username", username);
            reqObj.put("password", password);

            JsonObjectRequest jsonObjReq = new JsonObjectRequest(Request.Method.POST,
                    APIClient.BASE_URL+"loginUser/authenticateUser", reqObj,new com.android.volley.Response.Listener<JSONObject>() {

                @Override
                public void onResponse(final JSONObject response) {
                    mDialog.dismiss();
                    Log.d("response", response.toString());
                    if (response.has("message")){
                        DialogManager.showOkDialog(LoginActivity.this, getString(R.string.invalid_credentials));
                    }else {
                        AppSession.getSession().saveIsLogin(LoginActivity.this, true);
                        AppSession.getSession().saveUserName(LoginActivity.this, username);
                        AppSession.getSession().savePassword(LoginActivity.this, password);
                        AppSession.getSession().saveSessionToken(LoginActivity.this, response.optString("authorization"));
                        navigateToTabActivity();
                    }
                }
            }, new com.android.volley.Response.ErrorListener() {

                @Override
                public void onErrorResponse(VolleyError error) {
                    mDialog.dismiss();
                    VolleyLog.d("error", "Error: " + error.getMessage());
                    if (error.toString().equals(getString(R.string.volley_server_error))){
                        DialogManager.showOkDialog(LoginActivity.this, getString(R.string.invalid_credentials));
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
        }catch (Exception e){
            e.printStackTrace();
        }

    }
}
