package com.mastek.speakit.models;

import android.os.Parcel;
import android.os.Parcelable;

/**
 * Created by shreyas13732 on 6/6/2017.
 */

public class Place implements Parcelable {

    String name;
    String address;
    String iconUrl;
    String placeId;
    String photoReference;
    float averageRating;

    public float getAverageRating() {
        return averageRating;
    }

    public void setAverageRating(float averageRating) {
        this.averageRating = averageRating;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getIconUrl() {
        return iconUrl;
    }

    public void setIconUrl(String iconUrl) {
        this.iconUrl = iconUrl;
    }

    public String getPlaceId() {
        return placeId;
    }

    public void setPlaceId(String placeId) {
        this.placeId = placeId;
    }

    public String getPhotoReference() {
        return photoReference;
    }

    public void setPhotoReference(String photoReference) {
        this.photoReference = photoReference;
    }

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeString(this.name);
        dest.writeString(this.address);
        dest.writeString(this.iconUrl);
        dest.writeString(this.placeId);
        dest.writeString(this.photoReference);
        dest.writeFloat(this.averageRating);
    }

    public Place() {
    }

    protected Place(Parcel in) {
        this.name = in.readString();
        this.address = in.readString();
        this.iconUrl = in.readString();
        this.placeId = in.readString();
        this.photoReference = in.readString();
        this.averageRating = in.readFloat();
    }

    public static final Parcelable.Creator<Place> CREATOR = new Parcelable.Creator<Place>() {
        @Override
        public Place createFromParcel(Parcel source) {
            return new Place(source);
        }

        @Override
        public Place[] newArray(int size) {
            return new Place[size];
        }
    };
}
