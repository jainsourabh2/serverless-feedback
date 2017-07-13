package com.mastek.speakit.activities;

import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.widget.FrameLayout;

import com.mastek.speakit.R;
import com.mastek.speakit.fragments.FeedbackFragment;
import com.mastek.speakit.interfaces.BackActionListener;

import butterknife.ButterKnife;
import butterknife.InjectView;

public class FeedbackActivity extends AppCompatActivity {

    @InjectView(R.id.toolbar)
    Toolbar toolbar;
    @InjectView(R.id.container)
    FrameLayout container;
    BackActionListener mListener;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_feedback);
        ButterKnife.inject(this);

        setSupportActionBar(toolbar);
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);

        FeedbackFragment fragment = new FeedbackFragment();
        fragment.setArguments(getIntent().getExtras());
        getSupportFragmentManager().beginTransaction().replace(R.id.container, fragment).commit();
    }

    public void setBackActionListener(BackActionListener listener){
        mListener = listener;
    }

    @Override
    public void onBackPressed() {
        if (mListener != null){
            mListener.onBackPressed();
        }else {
            super.onBackPressed();
        }
    }
}
