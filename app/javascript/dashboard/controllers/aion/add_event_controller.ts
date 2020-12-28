import { Controller } from "stimulus"
import { createPopper } from '@popperjs/core';

export default class extends Controller {
  connect() {
    console.log("connected to a row");
  }

  addEvent(event:any) {
    console.log("addEvent");
    console.log(event);
    console.log(event.offsetY);
    console.log((event.offsetY - 40) / 80);
    console.log(
      Math.floor(((event.offsetY - 40) / 80) * 2) / 2
    );

    let topMultiplier = Math.floor(((event.offsetY - 40) / 80) * 2) / 2;
    let topPosition = topMultiplier * 80 + 40;

    let $placeholder = $("#empty-event-placeholder").clone();
    $(event.srcElement).append($placeholder);
    $placeholder.show();
    $placeholder.css("top", topPosition + "px");
    $placeholder.css("height", "80px");
  }
}
