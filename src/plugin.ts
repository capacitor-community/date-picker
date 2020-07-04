import { Plugins } from '@capacitor/core';
import { DatePickerPluginInterface } from './definitions';

const _DatePickerPlugin: DatePickerPluginInterface = Plugins.DatePickerPlugin;

export class DatePicker implements DatePickerPluginInterface {
  present(options: any): Promise<{ value: string }> {
    return _DatePickerPlugin.present(options);
  }

  darkMode(): Promise<void> {
    return _DatePickerPlugin.darkMode();
  }

  lightMode(): Promise<void> {
    return _DatePickerPlugin.lightMode();
  }
}
