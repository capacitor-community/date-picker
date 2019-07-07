declare module '@capacitor/core' {
  interface PluginRegistry {
    DatetimePlugin: DatetimeProtocol;
  }
}

export interface DatetimeProtocol {
  echo(options: any): Promise<any>;
}
