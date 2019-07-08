declare module '@capacitor/core' {
  interface PluginRegistry {
    DatetimePlugin: DatetimeProtocol;
  }
}

export interface DatetimeProtocol {
  present(options: any): Promise<{ value: string }>;
  darkMode(): Promise<any>;
  lightMode(): Promise<any>;
}
