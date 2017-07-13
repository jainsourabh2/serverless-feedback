package com.mastek.speakit.fragments;


import android.Manifest;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.graphics.Bitmap;
import android.net.Uri;
import android.os.Bundle;
import android.os.Environment;
import android.support.annotation.NonNull;
import android.support.v4.app.ActivityCompat;
import android.support.v4.app.Fragment;
import android.support.v4.content.ContextCompat;
import android.text.format.DateFormat;
import android.view.LayoutInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.bumptech.glide.Glide;
import com.bumptech.glide.load.engine.DiskCacheStrategy;
import com.mastek.speakit.R;
import com.mastek.speakit.activities.FeedbackActivity;
import com.mastek.speakit.interfaces.BackActionListener;
import com.mastek.speakit.models.Coupon;
import com.mastek.speakit.models.Place;
import com.mastek.speakit.utils.Helper;

import java.io.File;
import java.io.FileOutputStream;
import java.util.Date;

import butterknife.ButterKnife;
import butterknife.InjectView;
import butterknife.OnClick;

/**
 * A simple {@link Fragment} subclass.
 */
public class CouponsFragment extends Fragment {

    @InjectView(R.id.ivIcon)
    ImageView ivIcon;
    @InjectView(R.id.tvTitle)
    TextView tvTitle;
    @InjectView(R.id.tvSubtitle)
    TextView tvSubtitle;
    @InjectView(R.id.tvDescription)
    TextView tvDescription;
    @InjectView(R.id.ivQRCode)
    ImageView ivQRCode;
    @InjectView(R.id.tvCouponCode)
    TextView tvCouponCode;
    @InjectView(R.id.tvValidity)
    TextView tvValidity;
    @InjectView(R.id.btSaveCoupon)
    Button btSaveCoupon;
    @InjectView(R.id.llFullScreen)
    LinearLayout llFullScreen;


    Place mPlace;
    Coupon mCoupon;
    private static final int QR_CODE_SIZE = 250;
    private static final int MY_PERMISSIONS_REQUEST_STORAGE = 154;

    public CouponsFragment() {
        // Required empty public constructor
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View view = View.inflate(getActivity(), R.layout.fragment_coupons, null);
        setHasOptionsMenu(true);
        ButterKnife.inject(this, view);
        mPlace = getArguments().getParcelable("place");
        mCoupon = getArguments().getParcelable("coupon");
        putValues(mPlace, mCoupon);

        ((FeedbackActivity)getActivity()).setBackActionListener(new BackActionListener() {
            @Override
            public void onBackPressed() {
                getActivity().finish();
            }
        });
        return view;
    }

    private void putValues(Place place, Coupon coupon) {
        tvTitle.setText(place.getName());
        tvDescription.setText(coupon.getCouponDescription());
        tvSubtitle.setText(place.getAddress());
        tvCouponCode.setText(getString(R.string.coupon_code) + " : " + coupon.getCouponCode());
        tvValidity.setText(getString(R.string.valid_upto) + " " + coupon.getCouponExpiry());
        Glide.with(getContext()).load(place.getIconUrl())
                .thumbnail(0.5f)
                .crossFade()
                .diskCacheStrategy(DiskCacheStrategy.ALL)
                .into(ivIcon);

        Bitmap bitmap = Helper.getQRCode(coupon.getCouponCode(), QR_CODE_SIZE);
        ivQRCode.setImageBitmap(bitmap);
    }

    @Override
    public void onDestroyView() {
        super.onDestroyView();
        ButterKnife.reset(this);
    }

    @OnClick(R.id.btSaveCoupon)
    public void onViewClicked() {
        if (ContextCompat.checkSelfPermission(getActivity(), Manifest.permission.WRITE_EXTERNAL_STORAGE)!= PackageManager.PERMISSION_GRANTED) {
            ActivityCompat.requestPermissions(getActivity(),new String[]{Manifest.permission.WRITE_EXTERNAL_STORAGE},MY_PERMISSIONS_REQUEST_STORAGE);
            return;
        }
        takeScreenshot(llFullScreen);

    }

    private void takeScreenshot(View view) {
        Date now = new Date();
        DateFormat.format("yyyy-MM-dd_hh:mm:ss", now);

        try {
            // image naming and path  to include sd card  appending name you choose for file
            String mPath = Environment.getExternalStorageDirectory().toString() + "/" +getString(R.string.app_name)+"/"+ now + ".jpg";

            // create bitmap screen capture
            /*View v1 = getActivity().getWindow().getDecorView().getRootView();*/
            view.setDrawingCacheEnabled(true);
            Bitmap bitmap = Bitmap.createBitmap(view.getDrawingCache());
            view.setDrawingCacheEnabled(false);
            File imageFile = new File(mPath);
            if (!imageFile.exists()) {
                imageFile.getParentFile().mkdirs();
            }

            FileOutputStream outputStream = new FileOutputStream(imageFile);
            int quality = 100;
            bitmap.compress(Bitmap.CompressFormat.JPEG, quality, outputStream);
            outputStream.flush();
            outputStream.close();
            getActivity().sendBroadcast(new Intent(Intent.ACTION_MEDIA_SCANNER_SCAN_FILE, Uri.parse("file://"+ Environment.getExternalStorageDirectory())));

            Helper.showToast(getActivity(), getString(R.string.coupons_saved_successfully));
            getActivity().finish();
        } catch (Throwable e) {
            // Several error may come out with file handling or OOM
            e.printStackTrace();
        }
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

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        switch (requestCode) {
            case MY_PERMISSIONS_REQUEST_STORAGE:
                if (grantResults.length > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                    takeScreenshot(llFullScreen);
                }
                break;
        }
    }
}
