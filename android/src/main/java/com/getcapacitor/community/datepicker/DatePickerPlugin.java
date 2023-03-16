package com.getcapacitor.community.datepicker;

import com.getcapacitor.JSObject;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;
import com.getcapacitor.annotation.CapacitorPlugin;

import java.text.ParseException;

@CapacitorPlugin(name = "DatePicker")
public class DatePickerPlugin extends Plugin {
    public DatePickerPlugin() {}
    DatePickerOptions options;

    public void load() {
        options = getDatePickerConfig();
    }

    @PluginMethod
    public void present(final PluginCall call) throws java.text.ParseException, CloneNotSupportedException {
        DatePickerOptions options = getDatePickerConfigCall(call);
        DatePicker datePicker = new DatePicker(options, getContext());

        datePicker.open(
            new DatePickerResolve() {
                @Override
                public void resolve(String date) {
                    final JSObject response = new JSObject();
                    response.put("value", date);
                    call.resolve(response);
                }

                @Override
                public void reject(String message) {
                    call.reject(message);
                }
            }
        );
    }

    private DatePickerOptions getDatePickerConfig() {
        DatePickerOptions options = new DatePickerOptions();
        options.theme = getConfig().getString("android.theme", getConfig().getString("theme", "light"));
        options.mode = getConfig().getString("android.mode", getConfig().getString("mode", "dateAndTime"));
        options.format = getConfig().getString("android.format", getConfig().getString("format", "yyyy-MM-dd'T'HH:mm:ss.sss"));
        options.timezone = getConfig().getString("android.timezone", getConfig().getString("timezone", "UTC"));
        options.locale = getConfig().getString("android.locale", getConfig().getString("locale",null));
        options.cancelText = getConfig().getString("android.cancelText", getConfig().getString("cancelText", null));
        options.doneText = getConfig().getString("android.doneText", getConfig().getString("doneText",null));
        options.is24h = getConfig().getBoolean("android.is24h", getConfig().getBoolean("is24h", false));
        return options;
    }

    private DatePickerOptions getDatePickerConfigCall(PluginCall call) throws CloneNotSupportedException, ParseException {

        DatePickerOptions options = (DatePickerOptions)this.options.clone();

        options.theme = call.getString("android.theme", call.getString("theme", this.options.theme));
        options.mode = call.getString("android.mode", call.getString("mode", this.options.mode));
        options.format = call.getString("android.format", call.getString("format", this.options.format));
        options.timezone = call.getString("android.timezone", call.getString("timezone", this.options.timezone));
        options.locale = call.getString("android.locale", call.getString("locale",this.options.locale));
        options.cancelText = call.getString("android.cancelText", call.getString("cancelText", this.options.cancelText));
        options.doneText = call.getString("android.doneText", call.getString("doneText",this.options.doneText));
        options.is24h = call.getBoolean("android.is24h", call.getBoolean("is24h", this.options.is24h));
        options.title = call.getString("android.title", call.getString("title", this.options.title));

        String dateStr = call.getString("date", null);
        String minStr = call.getString("min", null);
        String maxStr = call.getString("max", null);

        if (dateStr != null) options.date = Parse.dateFromString(dateStr, options.format, options.timezone);
        if (minStr != null) options.min = Parse.dateFromString(minStr, options.format, options.timezone);
        if (maxStr != null) options.max = Parse.dateFromString(maxStr, options.format, options.timezone);

        return options;
    }
}