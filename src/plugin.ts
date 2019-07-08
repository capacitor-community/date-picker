import { Plugins } from '@capacitor/core';
import { DatetimeProtocol } from './definitions';

const { DatetimePlugin } = Plugins;

export class Datetime implements DatetimeProtocol {
  present(options: any): Promise<{ value: string }> {
    return DatetimePlugin.present(options);
  }

  darkMode(): Promise<void> {
    return DatetimePlugin.darkMode();
  }

  lightMode(): Promise<void> {
    return DatetimePlugin.lightMode();
  }
}
