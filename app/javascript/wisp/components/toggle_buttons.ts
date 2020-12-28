import { ToggleButton } from "./toggle_button";

class ToggleButtons {
  private buttonSelector = "div.toggle";
  private toggles: Array<ToggleButton> = [];

  constructor() {
    this.setup();
  }

  setup() {
    document.querySelectorAll(this.buttonSelector).forEach(function(containerDiv: HTMLElement) {
      if($(containerDiv).data("wisp-toggle")) {
        // the toggle is already instantiated so skip initialization
      } else {
        let button = new ToggleButton(containerDiv);
        this.toggles.push(button);
      }
    }, this);
  }

  list(): Array<ToggleButton> {
    return this.toggles;
  }

  reset(): void {
    this.toggles = [];

    this.setup();
  }
}

export { ToggleButtons };
