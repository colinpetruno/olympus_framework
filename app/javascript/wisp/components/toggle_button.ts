class ToggleButton {
  private containerDiv: HTMLElement;
  private checkboxInput: HTMLElement;
  private sliderContainer: HTMLElement;
  private sliderButton: HTMLElement;

  constructor(containerDiv: HTMLElement) {
    this.containerDiv = containerDiv;
    this.checkboxInput = this.containerDiv.querySelector("input[type=checkbox]");
    this.sliderContainer = this.containerDiv.querySelector(".toggle-container");
    this.sliderButton = this.sliderContainer.querySelector("div");

    this.setup();
  }

  setup() {
    $(this.containerDiv).data("wisp-toggle", this);
    // this.checkboxInput = $(this.containerDiv).find("input[type=checkbox]");

    this.containerDiv.addEventListener(
      "click", this.toggle.bind(this)
    );

    // this.reset();
  }

  toggle() {
    $(this.checkboxInput).prop(
      "checked", 
      !$(this.checkboxInput).prop("checked")
    );

    if($(this.checkboxInput).prop("checked")) {
      this.enable();
    } else {
      this.disable();
    }
  }

  enable() {
    this.containerDiv.classList.add("active");
    this.triggerChange();
  }

  disable():void {
    this.containerDiv.classList.remove("active");
    this.triggerChange();
  }

  state(): boolean {
    if($(this.checkboxInput).prop("checked")) {
      return true;
    } else {
      return false;
    }
  }

  // set the state based on the hidden checkbox value
  reset() {
    if($(this.checkboxInput).prop("checked")) {
      this.enable();
    } else {
      this.disable();
    }
  }

  triggerChange(): void {
    // let evt = document.createEvent("HTMLEvents");
    // evt.initEvent("change", false, true);
    // let evt = new Event("change", { "bubbles": true, "cancelable": false, composed: true });
    // this.checkboxInput.dispatchEvent(evt);

    let inputsForm = $(this.checkboxInput).closest("form")[0];

    // I am not happy about this because it should be able to be consolidated
    // into the autosave module. However, while this does work in the browser,
    // the above commented out code does not work in capybara during automated
    // testing.  
    if(inputsForm.classList.contains("autosave")){
      inputsForm.dispatchEvent(new Event("submit", {bubbles: true})); 
    }
  }
}

export { ToggleButton };
