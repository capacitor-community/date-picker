package com.getcapacitor.community.datepicker;

import android.annotation.SuppressLint;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.TimeZone;

public class Parse {

    public static Date dateFromString(String date, String format, String timezone) throws ParseException {
        SimpleDateFormat dateFormat = new SimpleDateFormat(format);
        if (timezone != null) {
            TimeZone tz = TimeZone.getTimeZone(timezone);
            dateFormat.setTimeZone(tz);
        }
        return dateFormat.parse(date);
    }

    public static String dateToString(Date date, String format) {
        SimpleDateFormat dateFormat = new SimpleDateFormat(format);
        return dateFormat.format(date);
    }
}
