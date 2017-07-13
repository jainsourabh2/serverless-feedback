package com.mastek.speakit.models;

/**
 * Created by shreyas13732 on 6/9/2017.
 */

public class User {

    String emailAddress;
    String password;
    String mobileNumber;

    public String getEmailAddress() {
        return emailAddress;
    }

    public void setEmailAddress(String emailAddress) {
        this.emailAddress = emailAddress;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getMobileNumber() {
        return mobileNumber;
    }

    public void setMobileNumber(String mobileNumber) {
        this.mobileNumber = mobileNumber;
    }

    @Override
    public String toString() {
        return emailAddress;
    }
}
