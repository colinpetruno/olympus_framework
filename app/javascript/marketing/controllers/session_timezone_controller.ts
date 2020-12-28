import { Controller } from "stimulus"

export default class extends Controller {
  $container: JQuery<Element>;
  remoteUrl: string;

  connect() {
    this.$container = $(this.element);
    this.remoteUrl = this.$container.data("remoteUrl");

    let timezoneSet = localStorage.getItem("meettricsTimezoneSet");
    let timezone = Intl.DateTimeFormat().resolvedOptions().timeZone;

    if (!timezoneSet) {
      $.post(
        this.remoteUrl, 
        { 
          timezone: timezone, 
          authenticity_token: $("meta[name=csrf-token]").attr("content")
        }, 
        function () {
          localStorage.setItem("meettricsTimezoneSet", "true");
        }
      );
    }
  }
}
