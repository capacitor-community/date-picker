package com.getcapacitor.community.datepicker;

import java.util.Date;

public class DatePickerOptions implements Cloneable {
    public String format;
    public String locale;
    public Date date;
    public String mode;
    public String theme;
    public String timezone;
    public Date min;
    public Date max;
    public String doneText;
    public String cancelText;
    public Boolean is24h;
    public String title;

    public DatePickerOptions() {
        date = null;
        min = null;
        max = null;
        title = null;
    }

    public Object clone() throws CloneNotSupportedException
    {
        return super.clone();
    }
}
