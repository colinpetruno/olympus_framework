import { Controller } from "stimulus"

export default class extends Controller {
  outputTarget: Element;
  outputTargets: Element[];
  hasOutputTarget: boolean;
  toggleUrl: string;
  enabled: boolean;

  static targets = [ "output" ];

  connect() {
    let meetrics_enabled:string = this.element.getAttribute("data-metrics-enabled")

    this.toggleUrl = this.element.getAttribute("data-url");
    this.enabled = (meetrics_enabled == "true") ? true : false;
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
            analytics_enabled: !this.enabled 
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
        this.enabled = json["analytics_enabled"];
        this.setToggleClass();
      }
    );
  }

  setToggleClass() {
    this.element.classList.toggle("enabled", this.enabled)
  }
}
