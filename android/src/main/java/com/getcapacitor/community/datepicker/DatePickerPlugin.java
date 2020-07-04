package com.getcapacitor.community.datepicker;

import com.getcapacitor.CapConfig;
import com.getcapacitor.JSObject;
import com.getcapacitor.NativePlugin;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;

import android.app.DatePickerDialog;
import android.app.Dialog;
import android.app.TimePickerDialog;
import android.graphics.Color;
import android.view.View;
import android.widget.Button;
import android.widget.DatePicker;
import android.widget.TimePicker;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.TimeZone;

@NativePlugin()
public class DatePickerPlugin extends Plugin {
    public static final String CONFIG_KEY_PREFIX = "plugins.DatePickerPlugin.android-";
    public CapConfig config;

    PluginCall call;

    private String defaultTheme = "light";
    private String defaultMode = "dateAndTime";
    private String defaultFormat = "MM/dd/yyyy hh:mm a";
    private String defaultLocale = "en_US";
    private String defaultType = "spinner";
    private String defaultTimezone = "UTC";
    private String defaultCancelText = "Cancel";
    private String defaultDoneText = "Done";
    private Boolean default24h = true;

    private String pickerTheme;
    private String pickerMode;
    private String pickerFormat;
    private String pickerLocale;
    private String pickerType;
    private String pickerDate;
    private String pickerMinDate;
    private String pickerMaxDate;
    private String pickerTimezone;
    private String pickerTitle;

    private Boolean picker24h; // for time
    private String pickerDoneText;
    private String pickerCancelText;

    private String doneButtonColor;
    private String cancelButtonColor;

    public DatePickerPlugin() {
        config = getBridge().getConfig();
    }

    public void load() {
        try {
            loadOptions();
        } catch (ParseException e) {
            e.printStackTrace();
        }
    }

    private void loadOptions() throws ParseException {
        final Calendar calendar = Calendar.getInstance();

        if (call != null) {
            pickerLocale = call.getString("locale", pickerLocale != defaultLocale ? pickerLocale : defaultLocale); // @todo
            pickerFormat = call.getString("format", pickerFormat != defaultFormat ? pickerFormat : defaultFormat);
            pickerTheme = call.getString("theme", pickerTheme != defaultTheme ? pickerTheme : defaultTheme);
            pickerMode = call.getString("mode", pickerMode != defaultMode ? pickerMode : defaultMode);
            pickerType = call.getString("type", pickerType != defaultType ? pickerType : defaultType);
            pickerTimezone = call.getString("timezone", pickerTimezone != defaultTimezone ? pickerTimezone : defaultTimezone);
            pickerDate = call.getString("date");
            pickerMinDate = call.getString("min");
            pickerMaxDate = call.getString("max");
            pickerTitle = call.getString("title");
            pickerCancelText = call.getString("cancelText", pickerCancelText != defaultCancelText ? pickerCancelText : defaultCancelText);
            pickerDoneText = call.getString("doneText", pickerDoneText != defaultDoneText ? pickerDoneText : defaultDoneText);
            picker24h = call.getBoolean("is24h", picker24h != default24h ? picker24h : default24h);
        } else {
            pickerLocale = config.getString(CONFIG_KEY_PREFIX + "locale", defaultLocale); // @todo
            pickerFormat = config.getString(CONFIG_KEY_PREFIX + "format", defaultFormat);
            pickerTheme = config.getString(CONFIG_KEY_PREFIX + "theme", defaultTheme);
            pickerMode = config.getString(CONFIG_KEY_PREFIX + "mode", defaultMode);
            pickerType = config.getString(CONFIG_KEY_PREFIX + "type", defaultType);
            pickerTimezone = config.getString(CONFIG_KEY_PREFIX + "timezone", defaultTimezone);
            pickerDate = config.getString(CONFIG_KEY_PREFIX + "date");
            pickerMinDate = config.getString(CONFIG_KEY_PREFIX + "min");
            pickerMaxDate = config.getString(CONFIG_KEY_PREFIX + "max");
            pickerTitle = config.getString(CONFIG_KEY_PREFIX + "title");
            pickerCancelText = config.getString(CONFIG_KEY_PREFIX + "cancelText", defaultCancelText);
            pickerDoneText = config.getString(CONFIG_KEY_PREFIX + "doneText", defaultDoneText);
            picker24h = config.getBoolean(CONFIG_KEY_PREFIX + "is24h", default24h);
        }
        doneButtonColor = pickerTheme == "dark" ? "#ffffff" : "#333333";
        cancelButtonColor = pickerTheme == "dark" ? "#ffffff" : "#333333";
    }

    private String parseDateFromObject(Date date) {
        SimpleDateFormat dateFormat = new SimpleDateFormat(pickerFormat);
        TimeZone tz = TimeZone.getTimeZone(pickerTimezone);
        dateFormat.setTimeZone(tz);
        return dateFormat.format(date);
    }


    private Date parseDateFromString(String date) throws ParseException {
        SimpleDateFormat dateFormat = new SimpleDateFormat(pickerFormat);
        TimeZone tz = TimeZone.getTimeZone(pickerTimezone);
        dateFormat.setTimeZone(tz);

        return dateFormat.parse(date);
    }


    private int getType(String typeString) {
        // 0 - default from os
        // 1 - spinner unstyled
        // 2 - spinner dark
        // 3 - spinner light
        // 4 - calendar dark
        // 5 - calendar light

        int themeType = 0;

        switch (typeString) {
            case "spinner":
                themeType = pickerTheme.equals(defaultTheme) ? 3 : 2;
                break;

            case "calendar":
                themeType = pickerTheme.equals(defaultTheme) ? 5 : 4;
                break;

            case "unstyled":
                themeType = 1;
                break;

        }

        return themeType;
    }

    private void launchTime() throws ParseException {
        final JSObject response = new JSObject();
        final Calendar calendar = Calendar.getInstance();
        if (pickerDate != null) {
            calendar.setTime(parseDateFromString(pickerDate));
        }

        final TimePickerDialog timePicker = new TimePickerDialog(getContext(), getType(pickerType), new TimePickerDialog.OnTimeSetListener() {
            @Override
            public void onTimeSet(TimePicker view, int hourOfDay, int minute) {
                calendar.setTime(new Date());
                calendar.set(calendar.get(Calendar.YEAR), calendar.get(Calendar.MONTH), calendar.get(Calendar.DAY_OF_MONTH), hourOfDay, minute);
                response.put("value", parseDateFromObject(calendar.getTime()));
                call.resolve(response);
            }
        }, calendar.get(Calendar.HOUR), calendar.get(Calendar.MINUTE), picker24h);


        timePicker.create();

        Button doneButton = timePicker.getButton(Dialog.BUTTON_POSITIVE);
        Button cancelButton = timePicker.getButton(Dialog.BUTTON_NEGATIVE);


        if (pickerDate != null) {
            calendar.setTime(parseDateFromString(pickerDate));
        }

        if (pickerTitle != null) {
            timePicker.setTitle(pickerTitle);
        }

        if (pickerDoneText != null) {
            doneButton.setText(pickerDoneText);
        }

        if (pickerCancelText != null) {
            cancelButton.setText(pickerCancelText);
        }

        if (cancelButtonColor != null) {
            cancelButton.setTextColor(Color.parseColor(cancelButtonColor));
        }

        cancelButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                response.put("value", null);
                call.resolve(response);
                timePicker.dismiss();
            }
        });

        timePicker.show();
    }

    private void launchDate() throws ParseException {
        final Calendar calendar = Calendar.getInstance();
        final JSObject response = new JSObject();

        if (pickerDate != null) {
            calendar.setTime(parseDateFromString(pickerDate));
        }

        final DatePickerDialog datePicker = new
                DatePickerDialog(getContext(), getType(pickerType), new DatePickerDialog.OnDateSetListener() {
            @Override
            public void onDateSet(DatePicker view, int year, int month, int dayOfMonth) {
                calendar.setTime(new Date());
                calendar.set(year, month, dayOfMonth);
                response.put("value", parseDateFromObject(calendar.getTime()));
                call.resolve(response);
            }
        }, calendar.get(Calendar.YEAR), calendar.get(Calendar.MONTH), calendar.get(Calendar.DAY_OF_MONTH));


        datePicker.create();
        DatePicker picker = datePicker.getDatePicker();
        Button doneButton = datePicker.getButton(Dialog.BUTTON_POSITIVE);
        Button cancelButton = datePicker.getButton(Dialog.BUTTON_NEGATIVE);

        if (pickerTitle != null) {
            datePicker.setTitle(pickerTitle);
        }

        if (pickerMaxDate != null) {
            Date maxDate = parseDateFromString(pickerMaxDate);
            picker.setMaxDate(maxDate.getTime());
        }

        if (pickerMinDate != null) {
            Date minDate = parseDateFromString(pickerMinDate);
            picker.setMinDate(minDate.getTime());
        }

        if (pickerDoneText != null) {
            doneButton.setText(pickerDoneText);
        }

        if (doneButtonColor != null) {
            doneButton.setTextColor(Color.parseColor(doneButtonColor));
        }

        if (pickerCancelText != null) {
            cancelButton.setText(pickerCancelText);
        }

        if (cancelButtonColor != null) {
            cancelButton.setTextColor(Color.parseColor(cancelButtonColor));
        }

        cancelButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                response.put("value", null);
                call.resolve(response);
                datePicker.cancel();
            }
        });

        datePicker.show();
    }


    @PluginMethod()
    public void present(final PluginCall call_) throws ParseException {
        call = call_;
        loadOptions();
        if (pickerMode.equals("time")) {
            launchTime();
        } else {
            launchDate();
        }
    }
}
