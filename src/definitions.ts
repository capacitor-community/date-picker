export type DatePickerMode = 'time' | 'date' | 'dateAndTime' | 'countDownTimer';
export type DatePickerTheme = 'light' | 'dark' | string;
export type DatePickerIosStyle = 'wheels' | 'inline';

export interface DatePickerBaseOptions {
  /**
   * @type {string}
   * @default "yyyy-MM-dd'T'HH:mm:ss.sssZ"
   *
   * @description ISO String format
   * @deprecated please, migrate this to ios and android props because the api is a little bit differen
   * @note For ios read (https://developer.apple.com/documentation/foundation/dateformatter)
   * @note For android read (https://docs.oracle.com/javase/7/docs/api/java/text/SimpleDateFormat.html)
   */
  format?: string;
  /**
   * @type {string}
   * @default null
   *
   * @description If null, empty or undefined, use the device locale
   * @note for ios you can read abouth locale here (https://developer.apple.com/documentation/foundation/locale)
   * @note for android you can read abouth locale here (https://docs.oracle.com/javase/7/docs/api/java/util/Locale.html)
   */
  locale?: string;
  /**
   * @type {DatePickerMode}
   * @default "dateAndTime"
   *
   * @description Datepicker mode
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
}

export interface DatePickerAndroidptions extends DatePickerBaseOptions {
  /**
   * @type {string}
   * @default "yyyy-MM-dd'T'HH:mm:ss.sss"
   *
   * @description ISO String format
   * @note For android read (https://docs.oracle.com/javase/7/docs/api/java/text/SimpleDateFormat.html)
   */
  format?: string;
}

export interface DatePickerIosOptions extends DatePickerBaseOptions {
  /**
   * @type {DatePickerIosStyle}
   * @default "inline"
   * @note works only iOS 14.0 or heiger
   * @description Modal style for ios, for mor information, access: https://developer.apple.com/documentation/uikit/uidatepicker
   */
  style?: DatePickerIosStyle;
  /**
   * @type {string}
   * @default "yyyy-MM-dd'T'HH:mm:ss.sssZ"
   *
   * @description ISO String format
   * @note Read (https://developer.apple.com/documentation/foundation/dateformatter)
   */
  format?: string;
  /**
   * @type {string}
   * @default null
   *
   * @description hex string for title font color
   */
  titleFontColor?: string;
  /**
   * @type {string}
   * @default null
   *
   * @description hex string for title background color
   */
  titleBgColor?: string;
  /**
   * @type {string}
   * @default null
   *
   * @description hex string for picker background color
   */
  bgColor?: string;
  /**
   * @type {string}
   * @default null
   *
   * @description hex string for picker font color
   * @note not work in inline style
   */
  fontColor?: string;
  /**
   * @type {string}
   * @default null
   *
   * @description hex string for buttons background color
   */
  buttonBgColor?: string;
  /**
   * @type {string}
   * @default null
   *
   * @description hex string for button font color
   */
  buttonFontColor?: string;
  /**
   * @type {boolean}
   * @default null
   *
   * @description Format dateAndTime picker for ios
   */
  mergedDateAndTime?: boolean;
}

export interface DatePickerOptions extends DatePickerBaseOptions {
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
   * @description If null, empty or undefined, will be current date
   */
  date?: string;
  /**
   * @type {DatePickerIosOptions}
   * @default null
   *
   * @description Personal configs for ios
   */
  ios?: DatePickerIosOptions;
  /**
   * @type {DatePickerBaseOptions}
   * @default null
   *
   * @description Personal configs for android
   */
  android?: DatePickerBaseOptions;
}

export interface DatePickerPlugin {
  present(options: DatePickerOptions): Promise<{ value: string }>;
}
