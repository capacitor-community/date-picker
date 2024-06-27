import type { OnInit } from '@angular/core';
import { Component } from '@angular/core';
import { Device } from '@capacitor/device';
import { DatePicker } from '@capacitor-community/date-picker/src';
import type {
  DatePickerOptions,
  DatePickerTheme,
  DatePickerMode,
} from '@capacitor-community/date-picker/src';

@Component({
  selector: 'app-home',
  templateUrl: 'home.page.html',
  styleUrls: ['home.page.scss'],
})
export class HomePage implements OnInit {
  max: Date;
  min: Date;
  theme: DatePickerTheme;
  mode: DatePickerMode;
  locale: string;
  doneText: string;
  cancelText: string;
  timeMode = false;
  mergedDateAndTime = false;
  wheels = true;
  isIos = false;

  themeList: { value: DatePickerTheme; label: string }[] = [
    {
      value: '',
      label: 'Default Theme',
    },
    {
      value: 'dark',
      label: 'Material Dark Theme',
    },
    {
      value: 'light',
      label: 'Material Light Theme',
    },
    {
      value: 'legacyDark',
      label: 'Legacy Dark Theme',
    },
    {
      value: 'legacyLight',
      label: 'Legacy Light Theme',
    },
    {
      value: 'MyCustomLightDatePicker',
      label: 'My Custom Theme',
    },
  ];

  modesList: { value: DatePickerMode; label: string }[] = [
    {
      value: 'date',
      label: 'Date',
    },
    {
      value: 'time',
      label: 'Time',
    },
    {
      value: 'dateAndTime',
      label: 'Date and Time',
    },
  ];

  async ngOnInit(): Promise<void> {
    const info = await Device.getInfo();

    this.isIos = info.operatingSystem === 'ios';
  }

  async maxFocus(): Promise<void> {
    document.body.focus();
    this.max = null;
    const pickerResult = await this.openPicker();
    if (pickerResult?.value) {
      this.max = new Date(pickerResult.value);
    }
  }

  async minFocus(): Promise<void> {
    document.body.focus();
    this.min = null;
    const pickerResult = await this.openPicker();
    if (pickerResult?.value) {
      this.min = new Date(pickerResult.value);
    }
  }

  async openPicker(): Promise<{ value: string }> {
    const options: DatePickerOptions = { ios: {} };
    if (this.max) {
      if (this.mode === 'date') {
        this.max.setHours(23, 59, 59, 999);
      }
      options.max = this.max.toISOString();
    }
    if (this.timeMode) {
      options.is24h = true;
    }
    if (this.min) {
      if (this.mode === 'date') {
        this.min.setHours(0, 0, 0, 0);
      }
      options.min = this.min.toISOString();
    }
    if (this.theme) {
      options.theme = this.theme;
    }
    if (this.mode) {
      options.mode = this.mode;
    }
    if (this.locale) {
      options.locale = this.locale;
    }
    if (this.doneText) {
      options.doneText = this.doneText;
    }
    if (this.cancelText) {
      options.cancelText = this.cancelText;
    }
    if (this.mergedDateAndTime) {
      options.ios.mergedDateAndTime = this.mergedDateAndTime;
    }
    if (this.wheels) {
      options.ios.style = this.wheels ? 'wheels' : null;
    }
    console.log(options);
    return DatePicker.present(options);
  }

  async platformIs(
    platform: 'ios' | 'android' | 'electron' | 'web',
  ): Promise<boolean> {
    return (await Device.getInfo()).platform === platform;
  }
}
