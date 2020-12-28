import { Controller } from "stimulus"

export default class extends Controller {
  lastSyncDateTarget: Element;
  lastSyncDateTargets: Element[];
  haslastSyncDateTarget: boolean;
  calendarId: number; 

  toggleUrl: string;
  public enabled: boolean;

  static targets = [ "lastSyncDate" ];

  connect() {
    let sync_enabled:string = this.element.getAttribute("data-sync-enabled")

    this.calendarId = parseInt(this.element.getAttribute("data-calendar-id"));
    this.toggleUrl = this.element.getAttribute("data-url");
    this.enabled = (sync_enabled == "true") ? true : false;
    this.setToggleClass();
  }

  toggle() {
    fetch(
      this.toggleUrl,
      {
        method: "PATCH",
        body: JSON.stringify({
          authenticity_token: $("meta[name=csrf-token]").attr("content"),
          calendar: {
            sync_enabled: !this.enabled 
          }
        }), 
        headers: {
          "Content-Type": "application/json"
        }
      }
    ).then(
      response => response.text()
    ).then(
      jsonString => {
        let json = JSON.parse(jsonString)
        this.enabled = json["sync_enabled"];
        this.setToggleClass();
        this.syncOtherControllers();
        window.Meettrics.updateCalendarData(json);
      }
    );
  }

  setToggleClass() {
    this.element.classList.toggle("enabled", this.enabled)
  }

  syncOtherControllers() {
    this.otherControllers().map(context => {
      let controller = (context.controller as any);

      if(controller.calendarId == this.calendarId) {
        controller.enabled = this.enabled;
        controller.setToggleClass();
      }
    });
  }

  otherControllers() {
    return this.application.router.modules.find(element => {
      return element.identifier == this.identifier
    }).contexts.filter(context => this.context != context);
  }
}
