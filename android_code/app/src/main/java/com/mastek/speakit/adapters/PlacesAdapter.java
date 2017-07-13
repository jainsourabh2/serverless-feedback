package com.mastek.speakit.adapters;

import android.content.Context;
import android.support.annotation.LayoutRes;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.bumptech.glide.Glide;
import com.bumptech.glide.load.engine.DiskCacheStrategy;
import com.mastek.speakit.R;
import com.mastek.speakit.models.Place;

import java.util.List;

import butterknife.ButterKnife;
import butterknife.InjectView;

/**
 * Created by shreyas13732 on 6/6/2017.
 */

public class PlacesAdapter extends ArrayAdapter<Place> {


    public PlacesAdapter(@NonNull Context context, @LayoutRes int resource, @NonNull List<Place> objects) {
        super(context, resource, objects);
    }

    @NonNull
    @Override
    public View getView(int position, @Nullable View convertView, @NonNull ViewGroup parent) {
        ViewHolder holder = null;
        if (convertView == null) {
            convertView = View.inflate(getContext(), R.layout.list_item_place, null);
            holder = new ViewHolder(convertView);
            convertView.setTag(holder);
        }else {
            holder = (ViewHolder) convertView.getTag();
        }

        holder.tvTitle.setText(getItem(position).getName());
        holder.tvAddress.setText(getItem(position).getAddress());
        Glide.with(getContext()).load(getItem(position).getIconUrl())
                .thumbnail(0.5f)
                .crossFade()
                .diskCacheStrategy(DiskCacheStrategy.ALL)
                .into(holder.ivIcon);
        return convertView;
    }

    static class ViewHolder {
        @InjectView(R.id.ivIcon)
        ImageView ivIcon;
        @InjectView(R.id.tvTitle)
        TextView tvTitle;
        @InjectView(R.id.tvAddress)
        TextView tvAddress;

        ViewHolder(View view) {
            ButterKnife.inject(this, view);
        }
    }
}
