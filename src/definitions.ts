declare module "@capacitor/core" {
  interface PluginRegistry {
    DatePickerPlugin: DatePickerPluginInterface;
  }
}

export type DatePickerMode = 'time' | 'date' | 'dateAndTime' | 'countDownTimer';
export type DatePickerTheme = 'light' | 'dark';
export type DatePickerType = 'spinner' | 'calendar';

export interface DatePickerOptions {
  format?: string; // default: MM/dd/yyyy hh:mm a
  locale?: string; // default: en_EN (only ios)
  date?: string; // default: Date()
  mode?: DatePickerMode; // default: dateAndTime
  theme?: DatePickerTheme; // default: light
  background?: string; // default: transparent (only ios)
  type?: DatePickerType; // default: spinner (only android)
  timezone?: string; // default: UTC (only android)
  title?: string;
  min?: string;
  max?: string;
  doneText?: string;
  cancelText?: string;
  is24h?: boolean; // only android
}

export interface DatePickerPluginInterface {
  present(options: DatePickerOptions): Promise<{ value: string }>;
  darkMode(): Promise<void>;
  lightMode(): Promise<void>;
}
