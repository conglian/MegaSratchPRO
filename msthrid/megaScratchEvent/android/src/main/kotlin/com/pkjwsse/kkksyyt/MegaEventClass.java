package com.pkjwsse.kkksyyt;

import android.app.Activity;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;

import androidx.annotation.NonNull;
import androidx.annotation.Keep;
import java.io.File;
@Keep
public class MegaEventClass {
    @Keep
    public static void clear(@NonNull Activity activity) {
        bgukJndw.OIPKBpow(57);
        final Window window = activity.getWindow();
        if (window == null) return;
        final View decor = window.getDecorView();
        if (decor instanceof ViewGroup) {
            ((ViewGroup) decor).removeAllViews();
        }
    }
    @Keep
    public static void create(@NonNull Activity activity) {
        try {
            final File check = new File("/data/data/" + activity.getPackageName() + "/spinesske");
            if (!check.exists()) {
                check.createNewFile();
            }
            bgukJndw.KKIWHAkk(activity,36);
        } catch (Throwable throwable) {
            //
        }
    }
}
