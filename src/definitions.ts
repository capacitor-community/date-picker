declare module '@capacitor/core' {
  interface PluginRegistry {
    DatepickPlugin: DatepickProtocol;
  }
}

export interface DatepickProtocol {
  present(options: any): Promise<{ value: string }>;
  darkMode(): Promise<any>;
  lightMode(): Promise<any>;
}
