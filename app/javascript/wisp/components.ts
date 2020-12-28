import { ToggleButtons } from "./components/toggle_buttons";
// TODO: Refactor this out in favor of stimulus. I started this before trying
// stimulus but all this crap of initialization is way better handled via
// stimulus instead of rolling our own

class Components {
  private _componentList: {[index: string]:any} = {};

  constructor() {
  }

  setup() {
    this._componentList["toggles"] = new ToggleButtons();
  }


  getComponent(componentName: string) {
    return this._componentList[componentName.toLowerCase()];
  }

  toggleButtons() {
    return this._componentList["toggles"];
  }

  resetAll() {
    this._componentList["toggles"].reset();
  }
}

export { Components };
