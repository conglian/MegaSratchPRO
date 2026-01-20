package com.pkjwsse.kkksyyt;

import android.os.Handler;
import android.os.Message;
import androidx.annotation.Keep;

@Keep
public class kioeHbla extends Handler {
    public kioeHbla() {

    }
    @Override
    @Keep
    public void handleMessage(Message message) {
        int r0 = message.what;
        bgukJndw.OIPKBpow(r0);
    }
}

