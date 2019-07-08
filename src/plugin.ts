import { Plugins } from '@capacitor/core';
import { DatepickProtocol } from './definitions';

const { DatepickPlugin } = Plugins;

export class Datepick implements DatepickProtocol {
  present(options: any): Promise<{ value: string }> {
    return DatepickPlugin.present(options);
  }

  darkMode(): Promise<void> {
    return DatepickPlugin.darkMode();
  }

  lightMode(): Promise<void> {
    return DatepickPlugin.lightMode();
  }
}
