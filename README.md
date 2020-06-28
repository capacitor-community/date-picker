<p align="center"><br><img src="https://user-images.githubusercontent.com/236501/85893648-1c92e880-b7a8-11ea-926d-95355b8175c7.png" width="128" height="128" /></p>
<h3 align="center">Capacitor Date Picker</h3>
<p align="center"><strong><code>@capacitor-community/date-picker</code></strong></p>
<p align="center">
  Capacitor community plugin for native Date Picker
</p>

<p align="center">
  <img src="https://img.shields.io/maintenance/yes/2020?style=flat-square" />
  <a href="https://www.npmjs.com/package/@capacitor-community/date-picker"><img src="https://img.shields.io/npm/l/@capacitor-community/date-picker?style=flat-square" /></a>
<br>
  <a href="https://www.npmjs.com/package/@capacitor-community/date-picker"><img src="https://img.shields.io/npm/dw/@capacitor-community/date-picker?style=flat-square" /></a>
  <a href="https://www.npmjs.com/package/@capacitor-community/date-picker"><img src="https://img.shields.io/npm/v/@capacitor-community/date-picker?style=flat-square" /></a>
  <!-- ALL-CONTRIBUTORS-BADGE:START - Do not remove or modify this section -->
<a href="#contributors"><img src="https://img.shields.io/badge/all%20contributors-1-orange?style=flat-square" /></a>
<!-- ALL-CONTRIBUTORS-BADGE:END -->
</p>

## Maintainers

| Maintainer   | GitHub                                | Social                                          |
| ------------ | ------------------------------------- | ----------------------------------------------- |
| Stewan Silva | [stewwan](https://github.com/stewwan) | [@StewanSilva](https://twitter.com/StewanSilva) |

## Notice 🚀

We're starting fresh under an official org. If you were using the previous npm package `capacitor-datepick`, please update your package.json to `@capacitor-community/date-picker`. Check out [changelog](/CHANGELOG.md) for more info.

## Installation

Using npm:

```bash
npm install @capacitor-community/date-picker
```

Using yarn:

```bash
yarn add @capacitor-community/date-picker
```

Sync native files:

```bash
npx cap sync
```

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
  - [ ] min
  - [ ] max
  - [ ] doneText
  - [ ] cancelText
  - [ ] timezone
  - [ ] title

### android

- [x] present
- [x] config
  - [x] format
  - [ ] locale
  - [x] mode
  - [x] theme
  - [x] background
  - [x] min
  - [x] max
  - [x] doneText
  - [x] cancelText
  - [x] timezone
  - [x] title

### web

- [ ] present
- [ ] config
  - [ ] format
  - [ ] locale
  - [ ] mode
  - [ ] theme
  - [ ] background
  - [ ] min
  - [ ] max
  - [ ] doneText
  - [ ] cancelText
  - [ ] timezone
  - [ ] title

## API

- `present(DatepickOptions): Promise<{ value:string }>`

### Config for iOS (`DatepickOptions`)

These options can be used through the `present` method and/or within `capacitor.config.json`

| name       | type     | default              | options                                |
| ---------- | -------- | -------------------- | -------------------------------------- |
| format     | `string` | `MM/dd/yyyy hh:mm a` |                                        |
| locale     | `string` | `en_US`              |                                        |
| date       | `string` | **_`current date`_** | **_`any date in string format`_**      |
| mode       | `string` | `dateAndTime`        | `time/date/dateAndTime/countDownTimer` |
| background | `string` | **_`transparent`_**  | **_`any #hexadecimal value`_**         |
| theme      | `string` | `light`              | `light/dark`                           |

### Config for Android (`DatepickOptions`)

These options can be used through the `present` method and/or within `capacitor.config.json`

| name       | type      | default              | options                           |
| ---------- | --------- | -------------------- | --------------------------------- |
| format     | `string`  | `MM/dd/yyyy hh:mm a` |                                   |
| date       | `string`  | **_`current date`_** | **_`any date in string format`_** |
| min        | `string`  | `none`               | **_`any date in string format`_** |
| max        | `string`  | `none`               | **_`any date in string format`_** |
| mode       | `string`  | `date`               | `date/time`                       |
| type       | `string`  | `spinner`            | `spinner/calendar`                |
| theme      | `string`  | `light`              | `light/dark`                      |
| timezone   | `string`  | `UTC`                |                                   |
| doneText   | `string`  | `Done`               |                                   |
| cancelText | `string`  | `Cancel`             |                                   |
| title      | `string`  | `none`               |                                   |
| is24h      | `boolean` | `true`               | **_`for time mode`_**             |

> For more information check the [`definitions`](/src/definitions.ts) file

## Usage

```js
import { DatePicker } from "@capacitor-community/date-picker";

const datepick = new DatePicker();
const selectedTheme = "light";

datepick
  .present({
    mode: "date",
    locale: "pt_BR",
    format: "dd/MM/yyyy",
    date: "13/07/2019",
    theme: selectedTheme,
    background: selectedTheme === "dark" ? "#333333" : "#ffffff",
  })
  .then((date) => alert(date.value));
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
- `npm install --save @capacitor-community/date-picker`
- `mkdir www && touch www/index.html`
- `sudo gem install cocoapods` (only once)
- `npx cap add ios`
- `npx cap sync ios` (every time you run `npm install`)
- `npx cap open ios`

> Tip: every time you change a native code you may need to clean up the cache (Product > Clean build folder) and then run the app again.

## Android setup

- `ionic start my-cap-app --capacitor`
- `cd my-cap-app`
- `npm install --save @capacitor-community/date-picker`
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

## License

MIT

## Contributors ✨

Thanks goes to these wonderful people ([emoji key](https://allcontributors.org/docs/en/emoji-key)):

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->
<table>
  <tr>
    <td align="center"><a href="https://twitter.com/StewanSilva"><img src="https://avatars1.githubusercontent.com/u/719763?v=4" width="75px;" alt=""/><br /><sub><b>Stew</b></sub></a><br /><a href="https://github.com/capacitor-community/date-picker/commits?author=stewwan" title="Code">💻</a> <a href="https://github.com/capacitor-community/date-picker/commits?author=stewwan" title="Documentation">📖</a></td>
  </tr>
</table>

<!-- markdownlint-enable -->
<!-- prettier-ignore-end -->

<!-- ALL-CONTRIBUTORS-LIST:END -->

This project follows the [all-contributors](https://github.com/all-contributors/all-contributors) specification. Contributions of any kind welcome!
