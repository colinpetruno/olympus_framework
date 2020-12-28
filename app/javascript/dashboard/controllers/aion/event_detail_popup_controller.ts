import { Controller } from "stimulus"
import { createPopper } from '@popperjs/core';

export default class extends Controller {
  popperInstance: any;

  connect() {
  }

  togglePopup(event:any) {
    event.stopPropagation();
    const eventContainer = document.querySelector("#event-399") as HTMLElement;
    const tooltip = document.querySelector('#weekly_event_detail') as HTMLElement;

    const popper = createPopper(eventContainer, tooltip, { placement: 'right-start' });

    $(document).off('click touchend').on('click touchend', function(e) {
      popper.destroy();
      $(document).off('click touchend');
    });
  }

  disconnect() {

  }
}
