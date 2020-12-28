import { Controller } from "stimulus"

interface Properties {
   startTime: string
}

export default class extends Controller {
  static values = {
    startTime: Number
  }
  public timeElapsedTarget!: HTMLInputElement;
  static targets = ["timeElapsed"]
  startTimeValue: number; 

  connect () {
    this.startCounting();
  }

  startCounting () {
    window.setTimeout(function(){
      let currentUnixTime = new Date().getTime();

      this.timeElapsedTarget.innerHTML = this.toHHMMSS(this.timeOffset());

      this.startCounting();
    }.bind(this), 1000);
  }

  timeOffset () {
    // NOTE: js uses milliseconds vs Ruby uses seconds so we need to adjust
    let currentTimeInSeconds = Math.trunc(new Date().getTime() / 1000);

    return currentTimeInSeconds - this.startTimeValue;
  }

  toHHMMSS (seconds: number) {
    let days    = Math.floor(seconds / 86400)
    let hours   = Math.floor(seconds / 3600) % 24
    let minutes = Math.floor(seconds / 60) % 60
    let remaining_seconds = seconds % 60

    return [days, hours, minutes, remaining_seconds]
        .map(v => v < 10 ? "0" + v : v)
        .filter((v,i) => v !== "00" || i > 0)
        .join(":")
  }
}
