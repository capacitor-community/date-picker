package com.getcapacitor.community.datepicker;

import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginConfig;

import java.text.ParseException;
import java.util.Date;

public class DatePickerOptions {
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

    public DatePickerOptions(final String prefix, PluginConfig config, PluginCall call) throws ParseException {
        theme = config.getString(prefix + "theme", "light");
        mode = config.getString(prefix + "mode", "dateAndTime");
        format = config.getString(prefix + "format", "yyyy-MM-dd'T'HH:mm:ss.sss'Z'");
        timezone = config.getString(prefix + "timezone", "UTC");
        locale = config.getString(prefix + "locale",null);
        cancelText = config.getString(prefix + "cancelText", null);
        doneText = config.getString(prefix + "doneText",null);
        is24h = config.getBoolean(prefix + "is24h", false);
        date = null;
        min = null;
        max = null;
        title = null;

        theme = call.getString("theme", theme);
        mode = call.getString("mode", mode);
        format = call.getString("format", format);
        timezone = call.getString("timezone", timezone);
        locale = call.getString("locale",locale);
        cancelText = call.getString("cancelText", cancelText);
        doneText = call.getString("doneText",doneText);
        is24h = call.getBoolean("is24h", is24h);
        title = call.getString("title", title);

        String dateStr = call.getString("date", null);
        String minStr = call.getString("min", null);
        String maxStr = call.getString("max", null);

        if (dateStr != null) date = Parse.dateFromString(dateStr, format, timezone);
        if (minStr != null) min = Parse.dateFromString(minStr, format, timezone);
        if (maxStr != null) max = Parse.dateFromString(maxStr, format, timezone);
    }
}
