declare module '@capacitor/core' {
  interface PluginRegistry {
    DatepickPlugin: DatepickProtocol;
  }
}

export interface DatepickOptions {
  format?: string; // default: MM/dd/yyyy hh:mm a
  locale?: string; // default: en_EN
  current?: string; // default: Date()
  mode?: 'time' | 'date' | 'dateAndTime' | 'countDownTimer'; // default: dateAndTime
  theme?: 'light' | 'dark'; // default: light
}
export interface DatepickProtocol {
  present(options: DatepickOptions): Promise<{ value: string }>;
  darkMode(): Promise<void>;
  lightMode(): Promise<void>;
}
