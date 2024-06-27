import { browser, by, element } from 'protractor';

export class AppPage {
  // eslint-disable-next-line
  navigateTo() {
    return browser.get('/');
  }

  // eslint-disable-next-line
  getParagraphText() {
    return element(by.deepCss('app-root ion-content')).getText();
  }
}
