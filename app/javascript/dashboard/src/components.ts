import { Navigation } from "./components/navigation";
import { FlashMessages } from "./components/flash_messages";

class Components {
  private _componentList: {[index: string]:any} = {};

  constructor() {
  }

  setup() {
    this._componentList["navigation"] = new Navigation();
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
