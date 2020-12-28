import { AionControllerToolbar } from "./controllers/toolbar";
import { AionControllerCalendar } from "./controllers/calendar";
import { AionCalendar } from "./calendar";

export class Aion {
  private controllerMap: {[key: string]: any} = {};
  private calendarMap: {[key: string]: any} = {};

  constructor() {

  }

  setup() {
    let calendars = document.querySelectorAll(".aion-calendar");
    let calendarControllers = document.querySelectorAll(".aion-controllers-calendar");
    let toolbarControllers = document.querySelectorAll(".aion-controllers-toolbar");

    calendars.forEach(function(calendarDiv: HTMLElement) {
      let calendarId = calendarDiv.dataset.aionCalendarId;
      let calendar = new AionCalendar(calendarDiv, this); 

      this.calendarMap[calendarId] = calendar;
    }.bind(this));

    toolbarControllers.forEach(function(controllerDiv: HTMLElement) {
      let controllerId = controllerDiv.dataset.aionControllerId;
      let aionController = new AionControllerToolbar(controllerDiv, this); 

      this.controllerMap["aion-controller-" + controllerId] = aionController;
    }.bind(this));

    calendarControllers.forEach(function(controllerDiv: HTMLElement) {
      let controllerId = controllerDiv.dataset.aionControllerId;
      let aionController = new AionControllerCalendar(controllerDiv, this); 

      this.controllerMap["aion-controller-" + controllerId] = aionController;
    }.bind(this));

    return self;
  }

  lookupCalendar(calendarId: string) {
    return this.calendarMap[calendarId];
  }

  lookupController(toolbarId: string) {
    let blah = this.controllerMap[toolbarId];

    return blah;
  }
}
