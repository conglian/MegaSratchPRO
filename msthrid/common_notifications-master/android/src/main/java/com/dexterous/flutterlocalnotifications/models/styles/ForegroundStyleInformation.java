package com.dexterous.flutterlocalnotifications.models.styles;

import androidx.annotation.Keep;

@Keep
public class ForegroundStyleInformation extends DefaultStyleInformation {
    public String value;

    public ForegroundStyleInformation(String value) {
        super(false, false);
        this.value = value;
    }
}
