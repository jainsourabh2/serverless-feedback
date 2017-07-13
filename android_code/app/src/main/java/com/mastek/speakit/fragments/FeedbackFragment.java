package com.mastek.speakit.fragments;


import android.app.Dialog;
import android.content.Context;
import android.graphics.Bitmap;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.view.ViewPager;
import android.text.TextUtils;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.RatingBar;
import android.widget.TextView;

import com.android.volley.AuthFailureError;
import com.android.volley.Request;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.VolleyLog;
import com.android.volley.toolbox.JsonObjectRequest;
import com.bumptech.glide.Glide;
import com.bumptech.glide.load.engine.DiskCacheStrategy;
import com.mastek.speakit.R;
import com.mastek.speakit.activities.FeedbackActivity;
import com.mastek.speakit.adapters.QuestionAdapter;
import com.mastek.speakit.application.AppController;
import com.mastek.speakit.interfaces.AuthenticationListener;
import com.mastek.speakit.interfaces.BackActionListener;
import com.mastek.speakit.interfaces.QuestionActionListener;
import com.mastek.speakit.models.Coupon;
import com.mastek.speakit.models.Place;
import com.mastek.speakit.models.Question;
import com.mastek.speakit.utils.AppSession;
import com.mastek.speakit.utils.DialogManager;
import com.mastek.speakit.utils.Helper;
import com.mastek.speakit.webservices.APIClient;

import org.json.JSONArray;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import butterknife.ButterKnife;
import butterknife.InjectView;

/**
 * A simple {@link Fragment} subclass.
 */
public class FeedbackFragment extends Fragment {


    @InjectView(R.id.tvTitle)
    TextView tvTitle;
    @InjectView(R.id.ivIcon)
    ImageView ivIcon;
    @InjectView(R.id.tvAddress)
    TextView tvAddress;
    @InjectView(R.id.rbAverage)
    RatingBar rbAverage;
    @InjectView(R.id.vpFeedback)
    ViewPager vpFeedback;
    @InjectView(R.id.ivBackground)
    ImageView ivBackground;

    Place mPlace;
    ArrayList<Question> mList;
    JSONArray mQuestionArray;
    QuestionAdapter adapter;
    Dialog mDialog;

    public FeedbackFragment() {
        // Required empty public constructor
    }


    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        // Inflate the layout for this fragment
        View view = View.inflate(getActivity(), R.layout.fragment_feedback, null);
        setHasOptionsMenu(true);
        ButterKnife.inject(this, view);
        mPlace = getArguments().getParcelable("place");
        putValues(mPlace);
        initialise();
        if (mList.isEmpty()) {
            fetchQuestions(getActivity(), mPlace.getPlaceId());
        }

        ((FeedbackActivity)getActivity()).setBackActionListener(new BackActionListener() {
            @Override
            public void onBackPressed() {
                getActivity().finish();
            }
        });
        return view;
    }

    private void initialise() {
        if (mList == null) {
            mList = new ArrayList<>();
        }
        /*Question question = new Question();
        question.setQuestion("Give your review");
        mList.add(question);
*/
        adapter = new QuestionAdapter(getActivity(), mList, new QuestionActionListener() {
            @Override
            public void onNext(int position, int rating) {
                mList.get(position).setRating(rating);
                if (position < mList.size() - 1) {
                    vpFeedback.setCurrentItem(vpFeedback.getCurrentItem() + 1);
                } else {
                    postFeedback(getActivity(), buildPostFeedbackRequest(mPlace.getPlaceId(), mQuestionArray));
                }
            }
        });
        vpFeedback.setAdapter(adapter);
    }

    private void putValues(Place place) {
        tvTitle.setText(place.getName());
        tvAddress.setText(place.getAddress());
        rbAverage.setRating(place.getAverageRating());
        Glide.with(getContext()).load(place.getIconUrl())
                .thumbnail(0.5f)
                .crossFade()
                .diskCacheStrategy(DiskCacheStrategy.ALL)
                .into(ivIcon);
    }

    private JSONObject buildPostFeedbackRequest(String placeId, JSONArray questionArray) {
        try {
            JSONObject jsonObject = new JSONObject();
            jsonObject.put("placeid", placeId);
            jsonObject.put("userid", AppSession.getSession().getUserName(getActivity()));
            jsonObject.put("questions", questionArray);
            JSONArray jsonArray = new JSONArray();
            for (int i = 0; i < mList.size(); i++) {
                jsonArray.put(mList.get(i).getRating());
            }
            jsonObject.put("feedback", jsonArray);
            return jsonObject;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    private void fetchQuestions(final Context context, String placeId) {
        try {
            mDialog = DialogManager.showProgressDialog(context);
            JsonObjectRequest jsonObjReq = new JsonObjectRequest(Request.Method.GET,
                    APIClient.BASE_URL + "questions/fetchquestions?placeid=" + placeId, null, new Response.Listener<JSONObject>() {

                @Override
                public void onResponse(JSONObject response) {
                    Log.d("response", response.toString());
                    JSONArray jsonArray = response.optJSONArray("results");
                    if (jsonArray != null) {
                        mQuestionArray = jsonArray;
                        for (int i = 0; i < jsonArray.length(); i++) {
                            Question question = new Question();
                            question.setQuestion(jsonArray.optString(i));
                            mList.add(question);
                        }
                        adapter.notifyDataSetChanged();
                    }
                    fetchPlaceDetails(getActivity(), mPlace.getPhotoReference());
                }
            }, new Response.ErrorListener() {

                @Override
                public void onErrorResponse(VolleyError error) {
                    mDialog.dismiss();
                    VolleyLog.d("error", "Error: " + error.getMessage());
                    if (error.toString().equals(getString(R.string.auth_error_message))){
                        Helper.authenticateUser(getActivity(),
                                AppSession.getSession().getUserName(getActivity()),
                                AppSession.getSession().getPassword(getActivity()), new AuthenticationListener() {
                                    @Override
                                    public void onAuthenticateSuccess() {
                                        if (mList.isEmpty()) {
                                            fetchQuestions(getActivity(), mPlace.getPlaceId());
                                        }
                                    }
                                });
                    }
                }
            }) {
                @Override
                public Map<String, String> getHeaders() throws AuthFailureError {
                    HashMap<String, String> headers = new HashMap<String, String>();
                    headers.put("Content-Type", "application/json");
                    headers.put("authorization", AppSession.getSession().getSessionToken(context));
                    return headers;
                }

            };
            AppController.getInstance().addToRequestQueue(jsonObjReq, "json_request");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void fetchPlaceDetails(final Context context, String photoRef) {
        try {
            JsonObjectRequest jsonObjReq = new JsonObjectRequest(Request.Method.GET,
                    APIClient.BASE_URL + "places/placeDetails?photoReference=" + photoRef, null, new Response.Listener<JSONObject>() {

                @Override
                public void onResponse(JSONObject response) {
                    mDialog.dismiss();
                    Log.d("response", response.toString());
                    String encodedString = response.optString("out");
                    Bitmap bitmap = Helper.convertBase64StringToBitmap(encodedString);
                    ivBackground.setImageBitmap(bitmap);

                }
            }, new Response.ErrorListener() {

                @Override
                public void onErrorResponse(VolleyError error) {
                    mDialog.dismiss();
                    VolleyLog.d("error", "Error: " + error.getMessage());
                }
            }) {
                @Override
                public Map<String, String> getHeaders() throws AuthFailureError {
                    HashMap<String, String> headers = new HashMap<String, String>();
                    headers.put("Content-Type", "application/json");
                    headers.put("authorization", AppSession.getSession().getSessionToken(context));
                    return headers;
                }

            };
            AppController.getInstance().addToRequestQueue(jsonObjReq, "json_request");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    private void postFeedback(final Context context, JSONObject reqObj) {
        try {
            mDialog = DialogManager.showProgressDialog(context);
            JsonObjectRequest jsonObjReq = new JsonObjectRequest(Request.Method.POST,
                    APIClient.BASE_URL + "feedback/postfeedback", reqObj, new Response.Listener<JSONObject>() {

                @Override
                public void onResponse(JSONObject response) {
                    mDialog.dismiss();
                    Log.d("response", response.toString());
                    Coupon coupon = new Coupon();
                    JSONObject bodyObj = response.optJSONObject("body");
                    coupon.setCouponName(bodyObj.optString("couponName"));
                    coupon.setCouponCode(bodyObj.optString("couponCode"));
                    coupon.setCouponDescription(bodyObj.optString("couponDesc"));
                    coupon.setCouponExpiry(bodyObj.optString("couponExpiry"));

                    if (TextUtils.isEmpty(coupon.getCouponCode())) {
                        getFragmentManager().beginTransaction().replace(R.id.container, new ThankYouFragment()).addToBackStack("").commit();
                    } else {
                        CouponsFragment fragment = new CouponsFragment();
                        Bundle bundle = new Bundle();
                        bundle.putParcelable("coupon", coupon);
                        bundle.putParcelable("place", mPlace);
                        fragment.setArguments(bundle);
                        getFragmentManager().beginTransaction().replace(R.id.container, fragment).addToBackStack("").commit();
                    }
                }
            }, new Response.ErrorListener() {

                @Override
                public void onErrorResponse(VolleyError error) {
                    mDialog.dismiss();
                    VolleyLog.d("error", "Error: " + error.getMessage());
                    if (error.toString().equals(getString(R.string.auth_error_message))){
                        Helper.authenticateUser(getActivity(),
                                AppSession.getSession().getUserName(getActivity()),
                                AppSession.getSession().getPassword(getActivity()), new AuthenticationListener() {
                                    @Override
                                    public void onAuthenticateSuccess() {
                                        postFeedback(getActivity(), buildPostFeedbackRequest(mPlace.getPlaceId(), mQuestionArray));
                                    }
                                });
                    }
                }
            }) {

                @Override
                public Map<String, String> getHeaders() throws AuthFailureError {
                    HashMap<String, String> headers = new HashMap<String, String>();
                    headers.put("Content-Type", "application/json");
                    headers.put("authorization", AppSession.getSession().getSessionToken(context));
                    return headers;
                }

            };
            AppController.getInstance().addToRequestQueue(jsonObjReq, "json_request");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void onDestroyView() {
        super.onDestroyView();
        ButterKnife.reset(this);
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
