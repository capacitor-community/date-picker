import { WebPlugin } from '@capacitor/core';

import type { DatePickerOptions, DatePickerPlugin } from './definitions';

export class DatePickerWeb extends WebPlugin implements DatePickerPlugin {
  present(options: DatePickerOptions): Promise<{ value: string }> {
    throw new Error('Method not implemented.');
  }
}
