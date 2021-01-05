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
    let inputsForm = $(this.checkboxInput).closest("form")[0];
  }
}

export { ToggleButton };
