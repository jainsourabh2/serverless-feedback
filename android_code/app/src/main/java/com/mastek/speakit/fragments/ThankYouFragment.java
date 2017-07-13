package com.mastek.speakit.fragments;


import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;

import com.mastek.speakit.R;
import com.mastek.speakit.activities.FeedbackActivity;
import com.mastek.speakit.interfaces.BackActionListener;

import butterknife.ButterKnife;
import butterknife.InjectView;
import butterknife.OnClick;

/**
 * A simple {@link Fragment} subclass.
 */
public class ThankYouFragment extends Fragment {


    @InjectView(R.id.btExit)
    Button btExit;

    public ThankYouFragment() {
        // Required empty public constructor
    }


    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        // Inflate the layout for this fragment
        View view = View.inflate(getActivity(), R.layout.fragment_thank_you, null);
        setHasOptionsMenu(true);
        ButterKnife.inject(this, view);

        ((FeedbackActivity)getActivity()).setBackActionListener(new BackActionListener() {
            @Override
            public void onBackPressed() {
                getActivity().finish();
            }
        });
        return view;
    }

    @Override
    public void onDestroyView() {
        super.onDestroyView();
        ButterKnife.reset(this);
    }

    @OnClick(R.id.btExit)
    public void onViewClicked() {
        getActivity().finish();
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        switch (item.getItemId()){
            case android.R.id.home:
                getActivity().finish();
                break;
        }

        return true;
    }

}
