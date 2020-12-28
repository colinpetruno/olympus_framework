class Autosave {
  private formSelector: string = "form.autosave";
  // private forms: Array<ToggleButton> = [];

  constructor() {
    this.setup();
  }

  setup(): void {
    document.querySelectorAll(this.formSelector).forEach(function(formElement: HTMLElement) {
      let inputs = formElement.querySelectorAll(this.validInputs());

      inputs.forEach(function(inputElement: HTMLElement) {
        inputElement.addEventListener("change", function() {
          let form = $(this).closest("form")[0];
          form.dispatchEvent(new Event("submit", { bubbles: true })); 
        });
      }, this);
    }, this);
  }

  validInputs(): string {
    let valid_inputs = [
      "input[type=text]", 
      // "input[type=checkbox]" // can't consolidate this, see note in 
      // ToggleButton#triggerChange
    ]

    return valid_inputs.join(", ");
  }
}

export { Autosave };
