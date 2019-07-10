declare module '@capacitor/core' {
  interface PluginRegistry {
    DatepickPlugin: DatepickProtocol;
  }
}

export type DatepickMode = 'time' | 'date' | 'dateAndTime' | 'countDownTimer';
export type DatepickTheme = 'light' | 'dark';
export type DatepickType = 'spinner' | 'calendar';

export interface DatepickOptions {
  format?: string; // default: MM/dd/yyyy hh:mm a
  locale?: string; // default: en_EN (only ios)
  date?: string; // default: Date()
  mode?: DatepickMode; // default: dateAndTime
  theme?: DatepickTheme; // default: light
  background?: string; // default: transparent (only ios)
  type?: DatepickType; // default: spinner (only android)
  timezone?: string; // default: UTC (only android)
  title?: string;
  min?: string;
  max?: string;
  doneText?: string;
  cancelText?: string;
  is24h?: boolean; // only android
}
export interface DatepickProtocol {
  present(options: DatepickOptions): Promise<{ value: string }>;
}
