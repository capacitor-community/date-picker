package com.getcapacitor.community.datepicker;

import android.app.DatePickerDialog;
import android.app.Dialog;
import android.app.TimePickerDialog;
import android.content.Context;
import android.content.res.Configuration;
import android.widget.Button;
import java.util.Calendar;
import java.util.Locale;

public class DatePicker {

    private Calendar calendar;
    private DatePickerOptions options;
    private Context context;
    private int theme;

    public DatePicker(DatePickerOptions options, Context context) {
        calendar = Calendar.getInstance();
        this.options = options;
        this.context = context;
        theme = DatePickerTheme.get(this.options.theme, context);

        if (this.options.locale != null) {
            Locale locale = new Locale(this.options.locale);
            Locale.setDefault(locale);
            Configuration config = new Configuration();
            config.locale = locale;
            context.getResources().updateConfiguration(config, context.getResources().getDisplayMetrics());
        }
    }

    public void launchTime(DatePickerResolve callback) {
        final TimePickerDialog timePicker = new TimePickerDialog(
            context,
            theme,
            (TimePickerDialog.OnTimeSetListener) (view, hourOfDay, minute) -> {
                calendar.set(
                    calendar.get(Calendar.YEAR),
                    calendar.get(Calendar.MONTH),
                    calendar.get(Calendar.DAY_OF_MONTH),
                    hourOfDay,
                    minute
                );
                callback.resolve(Parse.dateToString(calendar.getTime(), options.format));
            },
            calendar.get(Calendar.HOUR),
            calendar.get(Calendar.MINUTE),
            options.is24h
        );

        timePicker.create();

        Button doneButton = timePicker.getButton(Dialog.BUTTON_POSITIVE);
        Button cancelButton = timePicker.getButton(Dialog.BUTTON_NEGATIVE);

        if (options.date != null) {
            calendar.setTime(options.date);
        }

        if (options.title != null) {
            timePicker.setTitle(options.title);
        }

        if (options.doneText != null) {
            doneButton.setText(options.doneText);
        }

        if (options.cancelText != null) {
            cancelButton.setText(options.cancelText);
        }

        cancelButton.setOnClickListener(
            v -> {
                callback.resolve(null);
                timePicker.dismiss();
            }
        );

        timePicker.updateTime(calendar.get(Calendar.HOUR_OF_DAY), calendar.get(Calendar.MINUTE));

        timePicker.show();
    }

    public void launchDate(DatePickerResolve callback) {
        if (options.date != null) {
            calendar.setTime(options.date);
        }

        final DatePickerDialog datePicker = new DatePickerDialog(
            context,
            theme,
            (view, year, month, dayOfMonth) -> {
                calendar.set(year, month, dayOfMonth);
                if (options.mode.equals("dateAndTime")) {
                    options.date = calendar.getTime();
                    launchTime(callback);
                } else {
                    callback.resolve(Parse.dateToString(calendar.getTime(), options.format));
                }
            },
            calendar.get(Calendar.YEAR),
            calendar.get(Calendar.MONTH),
            calendar.get(Calendar.DAY_OF_MONTH)
        );

        datePicker.create();
        android.widget.DatePicker picker = datePicker.getDatePicker();
        Button doneButton = datePicker.getButton(Dialog.BUTTON_POSITIVE);
        Button cancelButton = datePicker.getButton(Dialog.BUTTON_NEGATIVE);

        if (options.title != null) {
            datePicker.setTitle(options.title);
        }

        if (options.max != null) {
            picker.setMaxDate(options.max.getTime());
        }

        if (options.min != null) {
            picker.setMinDate(options.min.getTime());
        }

        if (options.doneText != null) {
            doneButton.setText(options.doneText);
        }

        if (options.cancelText != null) {
            cancelButton.setText(options.cancelText);
        }

        cancelButton.setOnClickListener(
            v -> {
                callback.resolve(null);
                datePicker.cancel();
            }
        );

        datePicker.show();
    }

    public void open(DatePickerResolve callback) throws java.text.ParseException {
        if (options.mode.equals("time")) {
            launchTime(callback);
        } else {
            launchDate(callback);
        }
    }
}
