#import <Foundation/Foundation.h>
#import <Capacitor/Capacitor.h>

// Define the plugin using the CAP_PLUGIN Macro, and
// each method the plugin supports using the CAP_PLUGIN_METHOD macro.
CAP_PLUGIN(DatePickerPlugin, "DatePickerPlugin",
           CAP_PLUGIN_METHOD(present, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(darkMode, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(lightMode, CAPPluginReturnPromise);
)
