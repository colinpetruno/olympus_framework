import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ 
    "selectedMeasuringType", 
    "unlimitedToggle",
    "quantityInput"
  ]
  quantityInputTarget: Element
  quantityInputTargets: Element[]
  hasQuantityInputTarget: boolean

  selectedMeasuringTypeTarget: Element
  selectedMeasuringTypeTargets: Element[]
  hasSelectedMeasuringTypeTarget: boolean

  unlimitedToggleTarget: Element
  unlimitedToggleTargets: Element[]
  hasUnlimitedToggleTarget: boolean

  connect() {
    this.setupForm();
    this.toggleCounter();
  }

  measuringType() {
    return $(this.selectedMeasuringTypeTarget).val();
  }

  setupForm () {
    if (this.measuringType() == "toggleable") {
      $(this.element).find(".measurable").addClass("hidden")
      $(this.element).find(".toggleable").removeClass("hidden")
    } else {
      $(this.element).find(".measurable").removeClass("hidden")
      $(this.element).find(".toggleable").addClass("hidden")
    }
  }

  toggleCounter () {
    if ($(this.unlimitedToggleTarget).prop("checked")) {
      $(this.quantityInputTarget).addClass("disabled").prop("disabled", true);
    } else {
      $(this.quantityInputTarget).removeClass("disabled").prop("disabled", false);
    }
  }
}
