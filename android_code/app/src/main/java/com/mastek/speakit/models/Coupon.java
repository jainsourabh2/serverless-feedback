package com.mastek.speakit.models;

import android.os.Parcel;
import android.os.Parcelable;

/**
 * Created by shreyas13732 on 6/16/2017.
 */

public class Coupon implements Parcelable {

    String couponName;
    String couponDescription;
    String couponCode;
    String couponExpiry;

    public String getCouponName() {
        return couponName;
    }

    public void setCouponName(String couponName) {
        this.couponName = couponName;
    }

    public String getCouponDescription() {
        return couponDescription;
    }

    public void setCouponDescription(String couponDescription) {
        this.couponDescription = couponDescription;
    }

    public String getCouponCode() {
        return couponCode;
    }

    public void setCouponCode(String couponCode) {
        this.couponCode = couponCode;
    }

    public String getCouponExpiry() {
        return couponExpiry;
    }

    public void setCouponExpiry(String couponExpiry) {
        this.couponExpiry = couponExpiry;
    }

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeString(this.couponName);
        dest.writeString(this.couponDescription);
        dest.writeString(this.couponCode);
        dest.writeString(this.couponExpiry);
    }

    public Coupon() {
    }

    protected Coupon(Parcel in) {
        this.couponName = in.readString();
        this.couponDescription = in.readString();
        this.couponCode = in.readString();
        this.couponExpiry = in.readString();
    }

    public static final Parcelable.Creator<Coupon> CREATOR = new Parcelable.Creator<Coupon>() {
        @Override
        public Coupon createFromParcel(Parcel source) {
            return new Coupon(source);
        }

        @Override
        public Coupon[] newArray(int size) {
            return new Coupon[size];
        }
    };
}
