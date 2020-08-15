declare module "@capacitor/core" {
  interface PluginRegistry {
    DatePickerPlugin: DatePickerPluginInterface;
  }
}

export type DatePickerMode = 'time' | 'date' | 'dateAndTime' | 'countDownTimer';
export type DatePickerTheme = 'light' | 'dark' | 'legacyLight' | 'legacyDark' | string;

export interface DatePickerOptions {
  /**
   * @type {string}
   * @default "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
   * 
   * @description ISO String format
   */
  format?: string;
  /**
   * @type {string}
   * @default null
   * 
   * @description If null, empty or undefined, use the device locale
   */
  locale?: string;
  /**
   * @type {string}
   * @default null
   * 
   * @description If null, empty or undefined, will be current date
   */
  date?: string;
  /**
   * @type {DatePickerMode}
   * @default "dateAndTime"
   * 
   * @description Datepicker modes
   */
  mode?: DatePickerMode;
  /**
   * @type {DatePickerTheme}
   * @default "light"
   * 
   * @description Datepicker themes
   */
  theme?: DatePickerTheme;
  /**
   * @type: string
   * @default: null
   * 
   * @description If null, empty or undefined, will be the device timezone
   */
  timezone?: string;
  /**
   * @type {string}
   * @default null
   * 
   * @description If null, empty or undefined, will be none. use Date.toISOString()
   */
  min?: string;
  /**
   * @type {string}
   * @default null
   * 
   * @description If null, empty or undefined, will be none. use Date.toISOString()
   */
  max?: string;
  /**
   * @type {string}
   * @default null
   * 
   * @description If null, empty or undefined, will be "OK".
   */
  doneText?: string;
  /**
   * @type {string}
   * @default null
   * 
   * @description If null, empty or undefined, will be "CANCEL".
   */
  cancelText?: string;
  /**
   * @type {string}
   * @default null
   * 
   * @description If null, empty or undefined, will be "false".
   */
  is24h?: boolean;
  /**
   * @type {string}
   * @default null
   * 
   * @description hex string for title font color
   * @note Only IOS
   */
  titleFontColor?: string;
  /**
   * @type {string}
   * @default null
   * 
   * @description hex string for title background color
   * @note Only IOS
   */
  titleBgColor?: string;
  /**
   * @type {string}
   * @default null
   * 
   * @description hex string for picker background color
   * @note Only IOS
   */
  bgColor?: string;
  /**
   * @type {string}
   * @default null
   * 
   * @description hex string for picker font color
   * @note Only IOS
   */
  fontColor?: string;
  /**
   * @type {string}
   * @default null
   * 
   * @description hex string for buttons background color
   * @note Only IOS
   */
  buttonBgColor?: string;
  /**
   * @type {string}
   * @default null
   * 
   * @description hex string for button font color
   * @note Only IOS
   */
  buttonFontColor?: string;
  /**
   * @type {boolean}
   * @default null
   * 
   * @description Format dateAndTime picker for ios
   * @note Only IOS
   */
  mergedDateAndTime?: boolean;
}

export interface DatePickerPluginInterface {
  present(options: DatePickerOptions): Promise<{ value: string }>;
  darkMode(): Promise<void>;
  lightMode(): Promise<void>;
}
