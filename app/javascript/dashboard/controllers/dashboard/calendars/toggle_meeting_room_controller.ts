import { Controller } from "stimulus"

export default class extends Controller {
  outputTarget: Element;
  outputTargets: Element[];
  hasOutputTarget: boolean;
  toggleUrl: string;
  enabled: boolean;

  static targets = [ "output" ];

  connect() {
    let meeting_room:string = this.element.getAttribute("data-meeting-room");

    this.toggleUrl = this.element.getAttribute("data-url");
    this.enabled = (meeting_room == "true") ? true : false;
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
            meeting_room: !this.enabled 
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
        let json = JSON.parse(jsonString);
        this.enabled = json["meeting_room"];
        this.setToggleClass();
      }
    );
  }

  setToggleClass() {
    this.element.classList.toggle("enabled", this.enabled)
  }
}
