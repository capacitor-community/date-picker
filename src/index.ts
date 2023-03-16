import { registerPlugin } from '@capacitor/core';

import type { DatePickerPlugin } from './definitions';

const DatePicker = registerPlugin<DatePickerPlugin>('DatePicker', {
  web: () => import('./web').then(m => new m.DatePickerWeb()),
});

export * from './definitions';
export { DatePicker };
