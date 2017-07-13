package com.mastek.speakit.activities;

import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.widget.ProgressBar;

import com.mastek.speakit.R;
import com.mastek.speakit.interfaces.AuthenticationListener;
import com.mastek.speakit.utils.AppSession;
import com.mastek.speakit.utils.Helper;

import butterknife.ButterKnife;
import butterknife.InjectView;

public class SplashActivity extends AppCompatActivity {

    @InjectView(R.id.progressBar)
    ProgressBar progressBar;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_splash);
        ButterKnife.inject(this);
        navigateToNextScreen();
    }

    private void navigateToNextScreen() {
        if (AppSession.getSession().isLogin(SplashActivity.this)) {
            progressBar.setVisibility(View.VISIBLE);
            Helper.authenticateUser(SplashActivity.this,
                    AppSession.getSession().getUserName(SplashActivity.this),
                    AppSession.getSession().getPassword(SplashActivity.this), new AuthenticationListener() {
                        @Override
                        public void onAuthenticateSuccess() {
                            progressBar.setVisibility(View.GONE);
                            Intent intent = null;
                            intent = new Intent(SplashActivity.this, TabBaseActivity.class);
                            startActivity(intent);
                            finish();
                        }
                    });
        } else {
            Handler handler = new Handler();
            handler.postDelayed(new Runnable() {
                @Override
                public void run() {
                    Intent intent = null;
                    intent = new Intent(SplashActivity.this, LoginActivity.class);
                    startActivity(intent);
                    finish();
                }
            }, 3000);
        }
    }
}
