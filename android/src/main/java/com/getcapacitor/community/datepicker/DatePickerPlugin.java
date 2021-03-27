package com.getcapacitor.community.datepicker;

import com.getcapacitor.CapConfig;
import com.getcapacitor.JSObject;
import com.getcapacitor.NativePlugin;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;
import com.getcapacitor.community.datepicker.datepicker.R;

import android.annotation.SuppressLint;
import android.app.DatePickerDialog;
import android.app.Dialog;
import android.app.TimePickerDialog;
import android.content.res.Configuration;
import android.view.View;
import android.widget.Button;
import android.widget.DatePicker;
import android.widget.TimePicker;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Locale;
import java.util.TimeZone;

@NativePlugin()
public class DatePickerPlugin extends Plugin {
    public static final String CONFIG_KEY_PREFIX = "plugins.DatePickerPlugin.android-";
    public CapConfig config;

    PluginCall call;

    private String pickerTheme;
    private String pickerMode;
    private String pickerFormat;
    private String pickerLocale;
    private String pickerDate;
    private String pickerMinDate;
    private String pickerMaxDate;
    private String pickerTimezone;
    private String pickerTitle;

    private Boolean picker24h; // for time
    private String pickerDoneText;
    private String pickerCancelText;

    private Calendar calendar;

    public DatePickerPlugin() {
    }

    public void load() {
        try {
            loadOptions();
        } catch (ParseException e) {
            e.printStackTrace();
        }
    }

    private void loadOptions() throws ParseException {
        if (config == null) {
            config = getBridge().getConfig();
        }

        //
        // Default values plugin
        pickerTheme = config.getString(CONFIG_KEY_PREFIX + "theme", "light");
        pickerMode = config.getString(CONFIG_KEY_PREFIX + "mode", "dateAndTime");
        pickerFormat = config.getString(CONFIG_KEY_PREFIX + "format", "yyyy-MM-dd'T'HH:mm:ss.sss'Z'");
        pickerTimezone = config.getString(CONFIG_KEY_PREFIX + "timezone", "UTC");
        pickerLocale = config.getString(CONFIG_KEY_PREFIX + "locale",null);
        pickerCancelText = config.getString(CONFIG_KEY_PREFIX + "cancelText", null);
        pickerDoneText = config.getString(CONFIG_KEY_PREFIX + "doneText",null);
        picker24h = config.getBoolean(CONFIG_KEY_PREFIX + "is24h", false);
        pickerDate = null;
        pickerMinDate = null;
        pickerMaxDate = null;
        pickerTitle = null;

        calendar = Calendar.getInstance();
        calendar.setTime(new Date());

        if (call != null) {
            pickerLocale = call.getString("locale", pickerLocale);
            pickerFormat = call.getString("format", pickerFormat);
            pickerTheme = call.getString("theme", pickerTheme);
            pickerMode = call.getString("mode", pickerMode);
            pickerTimezone = call.getString("timezone", pickerTimezone);
            pickerDate = call.getString("date", pickerDate);
            pickerMinDate = call.getString("min", pickerMinDate);
            pickerMaxDate = call.getString("max", pickerMaxDate);
            pickerTitle = call.getString("title", pickerTitle);
            pickerCancelText = call.getString("cancelText", pickerCancelText);
            pickerDoneText = call.getString("doneText", pickerDoneText);
            picker24h = call.getBoolean("is24h", picker24h);

            if (pickerMinDate != null) {
                parseDateFromString(pickerMinDate);
            }

            if (pickerMaxDate != null) {
                parseDateFromString(pickerMaxDate);
            }

            if (pickerDate != null) {
                calendar.setTime(parseDateFromString(pickerDate));
            }
        }

        if (pickerLocale != null) {
            Locale locale = new Locale(pickerLocale);
            Locale.setDefault(locale);
            Configuration config = new Configuration();
            config.locale = locale;
            getContext().getResources().updateConfiguration(config, getContext().getResources().getDisplayMetrics());
        }
    }

    private String parseDateFromObject(Date date) {
        @SuppressLint("SimpleDateFormat") SimpleDateFormat dateFormat = new SimpleDateFormat(pickerFormat);
        return dateFormat.format(date);
    }


    private Date parseDateFromString(String date) throws ParseException {
        @SuppressLint("SimpleDateFormat") SimpleDateFormat dateFormat = new SimpleDateFormat(pickerFormat);
        if (pickerTimezone != null) {
            TimeZone tz = TimeZone.getTimeZone(pickerTimezone);
            dateFormat.setTimeZone(tz);
        }
        return dateFormat.parse(date);
    }


    private int getTheme() {

        Integer result = getContext().getResources().getIdentifier(pickerTheme, "style", getContext().getPackageName());

        if (result != 0) {
            return result;
        }

        switch (pickerTheme) {
            case "dark":
                result = R.style.MateriaDarklTheme;
                break;
            case "light":
                result = R.style.MaterialLightTheme;
                break;
            case "legacyDark":
                result = R.style.SpinnerDarkTheme;
                break;
            case "legacyLight":
                result = R.style.SpinnerLightTheme;
                break;
            default:
                result = R.style.MaterialLightTheme;
                break;
        }

        return result;
    }

    private void launchTime() throws ParseException {
        final JSObject response = new JSObject();

        final TimePickerDialog timePicker = new TimePickerDialog(getContext(), getTheme(), new TimePickerDialog.OnTimeSetListener() {
            @Override
            public void onTimeSet(TimePicker view, int hourOfDay, int minute) {
                calendar.set(calendar.get(Calendar.YEAR), calendar.get(Calendar.MONTH), calendar.get(Calendar.DAY_OF_MONTH), hourOfDay, minute);
                response.put("value", parseDateFromObject(calendar.getTime()));
                call.resolve(response);
            }
        }, calendar.get(Calendar.HOUR), calendar.get(Calendar.MINUTE), picker24h);


        timePicker.create();

        Button doneButton = timePicker.getButton(Dialog.BUTTON_POSITIVE);
        Button cancelButton = timePicker.getButton(Dialog.BUTTON_NEGATIVE);

        if (pickerTitle != null) {
            timePicker.setTitle(pickerTitle);
        }

        if (pickerDoneText != null) {
            doneButton.setText(pickerDoneText);
        }

        if (pickerCancelText != null) {
            cancelButton.setText(pickerCancelText);
        }

        cancelButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                response.put("value", null);
                call.resolve(response);
                timePicker.dismiss();
            }
        });

        timePicker.updateTime(calendar.get(Calendar.HOUR_OF_DAY), calendar.get(Calendar.MINUTE));

        timePicker.show();
    }

    private void launchDate() throws ParseException {
        final JSObject response = new JSObject();

        final DatePickerDialog datePicker = new DatePickerDialog(getContext(), getTheme(), new DatePickerDialog.OnDateSetListener() {
            @Override
            public void onDateSet(DatePicker view, int year, int month, int dayOfMonth) {
                calendar.set(year, month, dayOfMonth);
                if (pickerMode.equals("dateAndTime")) {
                    try {
                        launchTime();
                    } catch (ParseException e) {
                        e.printStackTrace();
                    }
                } else {
                    response.put("value", parseDateFromObject(calendar.getTime()));
                    call.resolve(response);
                }
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

        if (pickerCancelText != null) {
            cancelButton.setText(pickerCancelText);
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

        try {
            loadOptions();
        } catch (Exception e) {
            call.error("Failed to parse options");
            return;
        }

        if (pickerMode.equals("time")) {
            launchTime();
        } else {
            launchDate();
        }
    }
}
