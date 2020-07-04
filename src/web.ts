import { WebPlugin } from '@capacitor/core';
import { DatePickerPluginInterface, DatePickerOptions } from './definitions';

export class DatePickerPluginWeb extends WebPlugin implements DatePickerPluginInterface {
  constructor() {
    super({
      name: 'DatePickerPlugin',
      platforms: ['web']
    });
  }

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

const DatePickerPlugin = new DatePickerPluginWeb();

export { DatePickerPlugin };

import { registerWebPlugin } from '@capacitor/core';
registerWebPlugin(DatePickerPlugin);
