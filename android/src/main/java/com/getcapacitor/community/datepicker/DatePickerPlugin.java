package com.getcapacitor.community.datepicker;


import com.getcapacitor.JSObject;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;
import com.getcapacitor.annotation.CapacitorPlugin;

@CapacitorPlugin(name = "DatePicker")
public class DatePickerPlugin extends Plugin {
    public static final String PLUGIN_PREFIX = "plugins.DatePickerPlugin.";

    public DatePickerPlugin() { }

    @PluginMethod
    public void present(final PluginCall call) throws java.text.ParseException {
        DatePickerOptions options = new DatePickerOptions(PLUGIN_PREFIX, getConfig(), call);
        DatePicker datePicker = new DatePicker(options, getContext());

        datePicker.open(new DatePickerResolve() {
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
        });
    }
}
