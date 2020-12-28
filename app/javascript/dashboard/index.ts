import { Application } from "stimulus"
import { Controller } from "stimulus"
import { definitionsFromContext } from "stimulus/webpack-helpers"
import { Aion } from '../aion/index';

const application = Application.start()
const context = require.context("./controllers", true, /.ts$/)
application.load(definitionsFromContext(context))

import { Components } from './src/components';

class MeettricsCore {
  private componentAdaptor: Components;

  constructor() {
  }

  setup() {
    this.components();
  }

  components(componentName?: string) {
    if(!this.componentAdaptor) {
      this.componentAdaptor = new Components();
      this.componentAdaptor.setup();
    } 

    if (componentName) {
      return this.componentAdaptor.getComponent(componentName);
    } else {
      return this.componentAdaptor;
    }
  }

  // this should probably get moved but am not sure how the 
  // organization will end up yet. Keeping it here for 
  // exploration purposes
  updateCalendarData(calendarJson: any) {
    if(calendarJson["last_event_sync"]) {
      $(".lastSyncDateTarget").text(calendarJson["last_event_sync"]);
    }
  }
}

// TODO: Find out how to better structure and place this initialization code
declare global {
  interface Window { 
    Meettrics: MeettricsCore; 
    Aion: Aion;
    Tether: any;
    $: any;
    Stripe: any;
    Ichnaea: any;
  }
}

document.addEventListener("turbolinks:load", function() {
  window.Aion = new Aion();
  window.Meettrics = new MeettricsCore();

  window.Aion.setup();
  window.Meettrics.setup();
})
