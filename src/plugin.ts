import { Plugins } from '@capacitor/core';
import { DatetimeProtocol } from './definitions';

const { DatetimePlugin } = Plugins;

export class Datetime implements DatetimeProtocol {
  echo(options: any): Promise<void> {
    return DatetimePlugin.echo(options);
  }
}
