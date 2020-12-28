import { Controller } from "stimulus"

export default class extends Controller {
  calendarId: string;
  outputTarget: Element;
  outputTargets: Element[];
  hasOutputTarget: boolean;
  refreshUrl: string;
  enabled: boolean;
  syncInProgress: boolean;
  syncUrl: string;

  static targets = [ "output" ];

  connect() {
    let inProgress = this.element.getAttribute("data-sync-in-progress");

    this.calendarId = this.element.getAttribute("data-calendar-id");
    this.refreshUrl = this.element.getAttribute("data-refresh-url");
    this.syncUrl = this.element.getAttribute("data-start-sync-url");
    this.syncInProgress = (inProgress === "true") ? true : false;

    this.toggleSyncDisplay();
  }

  startSync() {
    this.syncInProgress = true;
    this.toggleSyncDisplay();

    fetch(
      this.syncUrl,
      {
        method: "POST",
        body: JSON.stringify({
          authenticity_token: $("meta[name=csrf-token]").attr("content"),
          sync: {
            type: "calendar_events_sync",
            syncable_id: this.calendarId 
          }
        }), 
        headers: {
          "Content-Type": "application/json"
        }
      }
    ).then(
      response => {
        if (response.ok) {
          return response.text();
        } else {
          throw new Error("Something went wrong");
        } 
      }
    ).then(
      jsonString => {
        let json = JSON.parse(jsonString)
        this.syncInProgress = true;
        this.toggleSyncDisplay();

        this.checkSyncStatus();

        window.Meettrics.updateCalendarData(json);
      }
    ).catch(
      error => {
        this.syncInProgress = false;
        this.toggleSyncDisplay();
      }
    );
  }

  checkSyncStatus() {
    setTimeout(() => this.refreshStatus(), 3000);
  }

  refreshStatus() {
    fetch(
      this.refreshUrl,
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
      response => {
        if (response.ok) {
          return response.text();
        } else {
          throw new Error("Something went wrong");
        } 
      }
    ).then(
      jsonString => {
        let json = JSON.parse(jsonString)
        this.syncInProgress = json["sync_in_progress"];

        if (this.syncInProgress) {
          this.checkSyncStatus();
        } else {
          this.toggleSyncDisplay();
        }
      }
    ).catch(
      error => {
        console.log("hmm got an error");
        console.log(error);
      }
    );
  }

  toggleSyncDisplay() {
    this.element.classList.toggle("syncing", this.syncInProgress)
  }
}
