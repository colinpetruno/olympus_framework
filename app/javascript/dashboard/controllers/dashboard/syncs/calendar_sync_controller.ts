import { Controller } from "stimulus"

export default class extends Controller {
  syncUrl: string;
  statusUrl: string;
  outputTarget: Element;
  outputTargets: Element[];
  hasOutputTarget: boolean;
  syncInProgress: boolean = false;

  static targets = [ "output" ]

  connect() {
    let startSync = this.element.getAttribute("data-start-sync");
    this.syncUrl = this.element.getAttribute("data-url");

    if (startSync === "true") {
      this.startSync();
    }
  }

  startSync() {
    this.displaySyncStart();

    fetch(
      this.syncUrl,
      {
        method: "POST",
        body: JSON.stringify({
          authenticity_token: $("meta[name=csrf-token]").attr("content"),
          sync: {
            type: "member_calendar_sync"
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
        this.statusUrl = json["status_path"];

        this.pollForStatus();
      }
    ).catch(
      error => {
        this.displaySyncFailure();
      }
    );
  }

  private displaySyncFailure() {
    this.syncInProgress = false;
    $(this.element).find(".in-progress").addClass("hidden"); 
    $(this.element).find(".buttons").addClass("hidden");
    $(this.element).find(".sync-error").removeClass("hidden");
  }

  private displaySyncStart(){
    this.syncInProgress = true;
    $(this.element).find(".in-progress").removeClass("hidden"); 
    $(this.element).find(".buttons").addClass("hidden");
    $(this.element).find(".sync-error").addClass("hidden");
  }

  private displaySyncEnd() {
    this.syncInProgress = false;

    $(this.element).find(".in-progress").addClass("hidden"); 
    $(this.element).find(".buttons").removeClass("hidden");
    $(this.element).find(".sync-error").addClass("hidden");

    // TODO: could either use ajax or sockets to refresh the content on 
    // the page. 
    window.location.reload(true); 
  }

  pollForStatus() {
    setTimeout(() => this.getSyncStatus(), 3000);
  }

  getSyncStatus() {
    fetch(this.statusUrl)
      .then((response) => {
        return response.json();
      })
      .then((data) => {
        let completedStatuses = ["failed", "succeeded", "stuck", "partial_success"]
        let sync_status = data["status"];

        if (completedStatuses.includes(sync_status)) {
          this.displaySyncEnd();
        } else {
          this.pollForStatus();
        }
      }).catch(
      error => {
        this.displaySyncFailure();
      }
    );;
  }

  disconnect() {
     // for when the element goes away
  }
}
