package com.mastek.speakit.adapters;

import android.content.Context;
import android.support.v4.view.PagerAdapter;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;
import android.widget.RatingBar;
import android.widget.TextView;

import com.mastek.speakit.R;
import com.mastek.speakit.interfaces.QuestionActionListener;
import com.mastek.speakit.models.Question;

import java.util.ArrayList;
import java.util.List;

import butterknife.ButterKnife;
import butterknife.InjectView;

/**
 * Created by shreyas13732 on 6/7/2017.
 */

public class QuestionAdapter extends PagerAdapter {

    private Context mContext;
    List<Question> mList;
    QuestionActionListener mListener;
    public QuestionAdapter(Context context, ArrayList<Question> list, QuestionActionListener listener) {
        mContext = context;
        mList = list;
        mListener = listener;
    }

    @Override
    public Object instantiateItem(ViewGroup collection, final int position) {
        View view = View.inflate(mContext, R.layout.pager_item_feedback, null);
        final ViewHolder holder = new ViewHolder(view);
        holder.tvQuestion.setText(mList.get(position).getQuestion());
        holder.tvPageCount.setText((position+1)+"/"+mList.size());
        holder.btNext.setText(position<(mList.size()-1)?mContext.getString(R.string.next):mContext.getString(R.string.finish));
        holder.btNext.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                mListener.onNext(position, ((int) holder.rbFeedback.getRating()));
            }
        });
        collection.addView(view);
        return view;
    }

    @Override
    public void destroyItem(ViewGroup collection, int position, Object view) {
        collection.removeView((View) view);
    }

    @Override
    public int getCount() {
        return mList.size();
    }

    @Override
    public boolean isViewFromObject(View view, Object object) {
        return view == object;
    }

    static class ViewHolder {
        @InjectView(R.id.tvVenue)
        TextView tvVenue;
        @InjectView(R.id.tvSkip)
        TextView tvSkip;
        @InjectView(R.id.tvQuestion)
        TextView tvQuestion;
        @InjectView(R.id.rbFeedback)
        RatingBar rbFeedback;
        @InjectView(R.id.etComment)
        EditText etComment;
        @InjectView(R.id.tvAttachFile)
        TextView tvAttachFile;
        @InjectView(R.id.btNext)
        Button btNext;
        @InjectView(R.id.tvPageCount)
        TextView tvPageCount;

        ViewHolder(View view) {
            ButterKnife.inject(this, view);
        }
    }
}
