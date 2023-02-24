import { WebPlugin } from '@capacitor/core';
import { DatePickerPlugin, DatePickerOptions } from './definitions';

export class DatePickerWeb extends WebPlugin implements DatePickerPlugin {
  async present(options: DatePickerOptions): Promise<{ value: string }> {
    console.warn('Not Yet Implemented', options);
    return { value: 'Not Yet Implemented' };
  }

  async darkMode(): Promise<void> {
    console.warn('Not Yet Implemented');
  }

  async lightMode(): Promise<void> {
    console.warn('Not Yet Implemented');
  }
}