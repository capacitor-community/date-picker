# capacitor-datepick [![npm version](https://badge.fury.io/js/capacitor-datepick.svg)](https://badge.fury.io/js/capacitor-datepick)

Native Datetime Picker Plugin for Capacitor Apps

> work in progress

![Native Datetime Picker Plugin for Capacitor Apps](https://i.imgur.com/sRlCJp0.gif)

## Roadmap

### ios

- [x] present
- [x] config
  - [x] format
  - [x] locale
  - [x] mode
  - [x] theme
  - [x] background

### android

- [ ] present
- [ ] config
  - [ ] format
  - [ ] locale
  - [ ] mode
  - [ ] theme
  - [ ] background

### web

- [ ] present
- [ ] config
  - [ ] format
  - [ ] locale
  - [ ] mode
  - [ ] theme
  - [ ] background

## API

- `present(DatepickOptions): Promise<{ value:string }>`

### Config (`DatepickOptions`)

These options can be used through the `present` method and/or within `capacitor.config.json`

| name       | type     | default              | options                                |
| ---------- | -------- | -------------------- | -------------------------------------- |
| format     | `string` | `MM/dd/yyyy hh:mm a` |                                        |
| locale     | `string` | `en_US`              |                                        |
| date       | `string` | `Date()`             |                                        |
| mode       | `string` | `dateAndTime`        | `time/date/dateAndTime/countDownTimer` |
| background | `string` | `transparent`        |                                        |
| theme      | `string` | `light`              | `light/dark`                           |

> For more information check the [`definitions`](/src/definitions.ts) file

## Usage

```js
import { Datepick } from 'capacitor-datepick';

const datepick = new Datepick();
const selectedTheme = 'light';

datepick
  .present({
    mode: 'date',
    locale: 'pt_BR',
    format: 'dd/MM/yyyy',
    date: '13/07/2019',
    theme: selectedTheme,
    background: selectedTheme === 'dark' ? '#333333' : '#ffffff'
  })
  .then(date => alert(date.value));
```

### Capacitor Config

```json
{
  //...
  "plugins": {
    "DatepickPlugin": {
      "mode": "date",
      "locale": "pt_BR",
      "current": "13/07/2019",
      "format": "dd/MM/yyyy"
    }
  }
}
```

## iOS setup

- `ionic start my-cap-app --capacitor`
- `cd my-cap-app`
- `npm install --save capacitor-datepick`
- `mkdir www && touch www/index.html`
- `sudo gem install cocoapods` (only once)
- `npx cap add ios`
- `npx cap sync ios` (every time you run `npm install`)
- `npx cap open ios`

> Tip: every time you change a native code you may need to clean up the cache (Product > Clean build folder) and then run the app again.

## Android setup

- `ionic start my-cap-app --capacitor`
- `cd my-cap-app`
- `npm install --save capacitor-datepick`
- `mkdir www && touch www/index.html`
- `npx cap add android`
- `npx cap sync android` (every time you run `npm install`)
- `npx cap open android`
- `[extra step]` in android case we need to tell Capacitor to initialise the plugin:

> on your `MainActivity.java` file add `import io.stewan.capacitor.datepick.DatepickPlugin;` and then inside the init callback `add(DatepickPlugin.class);`

Now you should be set to go. Try to run your client using `ionic cap run android --livereload --address=0.0.0.0`.

> Tip: every time you change a native code you may need to clean up the cache (Build > Clean Project | Build > Rebuild Project) and then run the app again.

## Updating

For existing projects you can upgrade all capacitor related packages (including this plugin) with this single command

`npx npm-upgrade '*capacitor*' && npm install`

## Sample app

https://github.com/stewwan/capacitor-datepick-demo

## You may also like

- [capacitor-fcm](https://github.com/stewwan/capacitor-fcm)
- [capacitor-analytics](https://github.com/stewwan/capacitor-analytics)
- [capacitor-media](https://github.com/stewwan/capacitor-media)
- [capacitor-intercom](https://github.com/stewwan/capacitor-intercom)
- [capacitor-twitter](https://github.com/stewwan/capacitor-twitter)

Cheers 🍻

Follow me [@Twitter](https://twitter.com/StewanSilva)

## License

MIT
