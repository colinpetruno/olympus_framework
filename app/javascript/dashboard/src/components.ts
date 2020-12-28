import { DisabledButtons } from "./components/disabled_buttons";
import { Navigation } from "./components/navigation";
import { Autosave } from "./components/auto_save";
import { FlashMessages } from "./components/flash_messages";

class Components {
  private _componentList: {[index: string]:any} = {};

  constructor() {
  }

  setup() {
    this._componentList["disabledbuttons"] = new DisabledButtons();
    this._componentList["navigation"] = new Navigation();
    this._componentList["autosave"] = new Autosave();
    this._componentList["flashmessages"] = new FlashMessages();
  }


  getComponent(componentName: string) {
    return this._componentList[componentName.toLowerCase()];
  }

  navigation() {
    return this._componentList["navigation"];
  }
}

export { Components };
