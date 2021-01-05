import { Controller } from "stimulus"

export default class extends Controller {
  goToSlideTwo (event:any) {
    event.preventDefault();
    $(this.element).find(".slider").removeClass("slide-1").addClass("slide-2");
  }

  goToSlideOne (event:any) {
    event.preventDefault();
    $(this.element).find(".slider").removeClass("slide-2").addClass("slide-1");
  }
}
