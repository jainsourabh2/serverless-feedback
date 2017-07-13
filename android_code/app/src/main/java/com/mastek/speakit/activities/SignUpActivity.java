package com.mastek.speakit.activities;

import android.app.Dialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.text.TextUtils;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.CheckBox;
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
import com.mastek.speakit.models.User;
import com.mastek.speakit.utils.DialogManager;
import com.mastek.speakit.utils.Helper;
import com.mastek.speakit.webservices.APIClient;

import org.json.JSONObject;

import java.util.HashMap;
import java.util.Map;

import butterknife.ButterKnife;
import butterknife.InjectView;
import butterknife.OnClick;

public class SignUpActivity extends AppCompatActivity {

    @InjectView(R.id.etEmail)
    EditText etEmail;
    @InjectView(R.id.etPassword)
    EditText etPassword;
    @InjectView(R.id.btSignUp)
    Button btSignUp;
    @InjectView(R.id.tvSignUpIntro)
    TextView tvSignUpIntro;
    @InjectView(R.id.etReEnterPassword)
    EditText etReEnterPassword;
    @InjectView(R.id.cbTermsNCondition)
    CheckBox cbTermsNCondition;
    @InjectView(R.id.btFacebook)
    Button btFacebook;
    @InjectView(R.id.btGooglePlus)
    Button btGooglePlus;
    @InjectView(R.id.etMobNum)
    EditText etMobNum;
    @InjectView(R.id.etCode)
    EditText etCode;
    Dialog mDialog;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_sign_up);
        ButterKnife.inject(this);
        etCode.setEnabled(false);
    }

    @OnClick({R.id.btSignUp, R.id.btFacebook, R.id.btGooglePlus})
    public void onViewClicked(View view) {
        switch (view.getId()) {
            case R.id.btSignUp:
                if (isValid()) {
                    User user = new User();
                    user.setEmailAddress(etEmail.getText().toString());
                    user.setMobileNumber(etCode.getText().toString()+etMobNum.getText().toString());
                    user.setPassword(etPassword.getText().toString());
                    createUser(user);
                    //navigateToVerificationScreen();
                }
                break;
            case R.id.btFacebook:
                break;
            case R.id.btGooglePlus:
                break;
        }
    }

    private boolean isValid() {
        if (TextUtils.isEmpty(etEmail.getText().toString().trim())) {
            etEmail.setError(getString(R.string.please_enter_email_address));
            return false;
        }

        if (!Helper.isValidEmailAddress(etEmail.getText().toString())) {
            etEmail.setError(getString(R.string.please_enter_valid_email_address));
            return false;
        }

        if (TextUtils.isEmpty(etMobNum.getText().toString().trim())) {
            etMobNum.setError(getString(R.string.please_enter_mobile_number));
            return false;
        }

        if (etMobNum.getText().toString().length()!= 10){
            etMobNum.setError(getString(R.string.please_enter_valid_mobile_number));
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

        if (TextUtils.isEmpty(etReEnterPassword.getText().toString().trim())) {
            etReEnterPassword.setError(getString(R.string.please_re_enter_password));
            return false;
        }
        if (!TextUtils.equals(etPassword.getText().toString(), etReEnterPassword.getText().toString())) {
            etPassword.setError(getString(R.string.entered_password_and_confirm_password_is_not_matching));
            return false;
        }

        if (!cbTermsNCondition.isChecked()) {
            Helper.showToast(SignUpActivity.this, getString(R.string.please_accept_terms_and_conditions));
            return false;
        }
        return true;
    }

   /* private void createUser(User user) {
        if (NetworkHelper.isNetworkAvailable(SignUpActivity.this)) {
            JsonObject reqObj = new JsonObject();
            reqObj.addProperty("email", user.getEmailAddress());
            reqObj.addProperty("mobile", user.getMobileNumber());
            reqObj.addProperty("username", user.getMobileNumber());
            reqObj.addProperty("password", user.getPassword());

            NetworkAPI networkAPI = APIClient.getClient().create(NetworkAPI.class);
            Call<SignUpResponse> call = networkAPI.createUser(reqObj);
            call.enqueue(new Callback<SignUpResponse>() {
                @Override
                public void onResponse(Call<SignUpResponse> call, Response<SignUpResponse> response) {
                    Helper.log("response", "response");
                    DialogManager.showOkDialog(SignUpActivity.this, getString(R.string.user_created_successfully), new DialogInterface.OnClickListener() {
                        @Override
                        public void onClick(DialogInterface dialog, int which) {
                            //navigateToVerificationScreen();
                        }
                    });
                }

                @Override
                public void onFailure(Call<SignUpResponse> call, Throwable t) {
                    Helper.log("error", call.toString());
                }
            });
        } else {
            DialogManager.showOkDialog(SignUpActivity.this, getString(R.string.no_internet_connection));
        }
    }*/

    private void navigateToVerificationScreen(String username, String password) {
        Intent intent = new Intent(SignUpActivity.this, VerificationActivity.class);
        intent.putExtra("username", username);
        intent.putExtra("password", password);
        startActivity(intent);
        finish();
    }


    private void createUser(final User user){
        try {
            mDialog = DialogManager.showProgressDialog(SignUpActivity.this);
            JSONObject reqObj = new JSONObject();
            reqObj.put("email", user.getEmailAddress());
            reqObj.put("mobile", user.getMobileNumber());
            reqObj.put("username", user.getMobileNumber());
            reqObj.put("password", user.getPassword());

            JsonObjectRequest jsonObjReq = new JsonObjectRequest(Request.Method.POST,
                    APIClient.BASE_URL+"loginUser/createUser", reqObj,new Response.Listener<JSONObject>() {

                @Override
                public void onResponse(JSONObject response) {
                    mDialog.dismiss();
                    Log.d("response", response.toString());
                    DialogManager.showOkDialog(SignUpActivity.this, response.optString("message"), new DialogInterface.OnClickListener() {
                        @Override
                        public void onClick(DialogInterface dialog, int which) {
                            navigateToVerificationScreen(user.getMobileNumber(), user.getPassword());
                        }
                    });
                }
            }, new Response.ErrorListener() {

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
}
