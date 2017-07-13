package com.mastek.speakit.fragments;


import android.app.Dialog;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ListView;

import com.android.volley.AuthFailureError;
import com.android.volley.Request;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.VolleyLog;
import com.android.volley.toolbox.JsonObjectRequest;
import com.mastek.speakit.R;
import com.mastek.speakit.activities.FeedbackActivity;
import com.mastek.speakit.activities.TabBaseActivity;
import com.mastek.speakit.adapters.PlacesAdapter;
import com.mastek.speakit.application.AppController;
import com.mastek.speakit.interfaces.AuthenticationListener;
import com.mastek.speakit.models.Place;
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
public class PlaceListingFragment extends Fragment {


    @InjectView(R.id.lvPlaces)
    ListView lvPlaces;
    String mType;
    PlacesAdapter adapter;
    ArrayList<Place> placeList;
    Dialog mDialog;

    public PlaceListingFragment() {
        // Required empty public constructor
    }


    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        // Inflate the layout for this fragment
        View view = View.inflate(getContext(), R.layout.fragment_place_listing, null);
        ButterKnife.inject(this, view);
        mType = getArguments().getString("type");
        initialise();
        if (placeList.isEmpty()){
            getPlaceList(getActivity(), mType);
        }
        return view;
    }

    private void initialise() {
        if (placeList == null) {
            placeList = new ArrayList<>();
        }
        adapter = new PlacesAdapter(getActivity(), R.layout.list_item_place, placeList);
        lvPlaces.setAdapter(adapter);
        lvPlaces.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                Intent intent = new Intent(getActivity(), FeedbackActivity.class);
                intent.putExtra("place", placeList.get(position));
                startActivity(intent);
            }
        });

    }

    @Override
    public void onDestroyView() {
        super.onDestroyView();
        ButterKnife.reset(this);
    }

    private void getPlaceList(final Context context, String type) {
        try {
            mDialog = DialogManager.showProgressDialog(context);
            JsonObjectRequest jsonObjReq = new JsonObjectRequest(Request.Method.GET,
                    APIClient.BASE_URL + "places/locationlisting?lat="+ TabBaseActivity.getCurrentLocation().getLatitude()+"" +
                            "&lng="+TabBaseActivity.getCurrentLocation().getLongitude()+"&type=" + type, null, new Response.Listener<JSONObject>() {

                @Override
                public void onResponse(JSONObject response) {
                    mDialog.dismiss();
                    Log.d("response", response.toString());
                    JSONArray resultArray = response.optJSONArray("results");
                    if (resultArray != null){
                        for (int i = 0; i < resultArray.length(); i++) {
                            JSONObject placeObj = resultArray.optJSONObject(i);
                            Place place = new Place();
                            place.setName(placeObj.optString("name"));
                            place.setAddress(placeObj.optString("vicinity"));
                            place.setIconUrl(placeObj.optString("icon"));
                            place.setPlaceId(placeObj.optString("place_id"));
                            /*place.setPhotoReference(placeObj.optString("reference"));*/
                            place.setAverageRating((float) placeObj.optDouble("rating"));

                            JSONArray photoArray = placeObj.optJSONArray("photos");
                            if (photoArray != null){
                                JSONObject photoObj = photoArray.optJSONObject(0);
                                place.setPhotoReference(photoObj.optString("photo_reference"));
                            }
                            placeList.add(place);
                        }
                    }
                    adapter.notifyDataSetChanged();
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
                                        if (placeList.isEmpty()){
                                            getPlaceList(getActivity(), mType);
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
}
