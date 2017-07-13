package com.mastek.speakit.activities;

import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.widget.Button;
import android.widget.EditText;

import com.mastek.speakit.R;

import butterknife.ButterKnife;
import butterknife.InjectView;
import butterknife.OnClick;

public class ForgotPasswordActivity extends AppCompatActivity {

    @InjectView(R.id.etEmail)
    EditText etEmail;
    @InjectView(R.id.btSignUp)
    Button btReset;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_forgot_password);
        ButterKnife.inject(this);
    }

    @OnClick(R.id.btSignUp)
    public void onViewClicked() {
    }
}
