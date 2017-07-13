package com.mastek.speakit.models;

/**
 * Created by shreyas13732 on 6/7/2017.
 */

public class Question {

    String question;
    int rating;
    String comment;
    String file;

    public Question() {
        rating = 3;
    }

    public String getQuestion() {
        return question;
    }

    public void setQuestion(String question) {
        this.question = question;
    }

    public int getRating() {
        return rating;
    }

    public void setRating(int rating) {
        this.rating = rating;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public String getFile() {
        return file;
    }

    public void setFile(String file) {
        this.file = file;
    }
}
