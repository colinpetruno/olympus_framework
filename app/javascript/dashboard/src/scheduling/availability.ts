export class Availability {
  destroyed: number = 0;
  startMinute: number;
  endMinute: number;
  showAm: boolean;
  showPm: boolean;
  topPosition: number;

  amHeight: number = 480;
  pmHeight: number = 288; 

  $element: JQuery<HTMLElement>;

  constructor(
    $element: JQuery<HTMLElement>, 
    showAm:boolean = false, 
    showPm:boolean = false
  ) {
    this.$element = $element;
    this.startMinute = $element.data("start-minute");
    this.endMinute = $element.data("end-minute");
    this.topPosition = parseInt($element.css("top"));
    this.showAm = showAm;
  }

  delete() {
    this.destroyed = 1;
  }

  overlaps(height:number, topOfDiv: number) {
    if (this.destroyed == 1) {
      // it can't overlap if it was deleted
      return false;
    }
    // this function will check to see if these numbers will overlap or not
    // with this existinv availablity

    let amPadding;
    if (this.showAm) {
      // because am is enabled, we don't need to add any more pixels to 
      // calc the time
      amPadding = 0;
    } else {
      // since am is hidden, we need to add padding to calculate the time
      amPadding = 384;
    }

    // every 4 pixels is 5 minutes. This takes the full top of the div and
    // divides by 4 to get number of 5 minute increments it is, then multiplied
    // by 5 to get the time of the day
    let startTime = (topOfDiv + amPadding) / 4 * 5;
    let endTime = startTime + (height / 4 * 5);

    // endTime < this.startMinute
    // (EndA <= StartB or StartA >= EndB)

    // new one
    let overLaps = !(this.endMinute <= startTime || this.startMinute >= endTime)

    return overLaps;
  }

  height() {
    return (this.duration() / 5) * 4;
  }

  dayNumber() {
    return this.$element.data("day-number");
  }

  updateHeight(height: number) {
    let duration = height / 4 * 5;
    this.endMinute = this.startMinute + duration;

    this.updateDisplay();
  }

  id() {
    return this.$element.data("meettrics-id");
  }

  asJson() {
    return {
      availabilityable_type: "MeetingTemplate",
      availabilityable_id: this.$element.data("meeting-template-id"),
      day: this.dayNumber(),
      start_time: this.startMinute,
      end_time: this.endMinute,
      id: this.id() || null,
      _destroy: this.destroyed
    }
  }

  updateTop(position: number) {
    let originalDuration = this.duration();
    this.topPosition = position;

    if (this.showAm) {
      // divide by 4 pixels per 5 minutes, then * 5 minutes 
      this.startMinute = position / 4 * 5;
    } else {
      this.startMinute = (position + 384) / 4 * 5;
    }
    this.endMinute = this.startMinute + originalDuration;

    this.updateDisplay();
  }

  duration() {
    return this.endMinute - this.startMinute;
  }

  updateDisplay () {
    let message;

    // update duration
    let hours = Math.floor(this.duration() / 60);
    let minutes:any = this.duration() % 60;
    let hoursLabel;
    let minutesLabel;

    if(minutes == 1) {
      minutesLabel = this.$element.data("minutes-label-singular");
    } else {
      minutesLabel = this.$element.data("minutes-label-plural");
    }

    if (hours == 1) {
      hoursLabel = this.$element.data("hours-label-singular");
    } else {
      hoursLabel = this.$element.data("hours-label-plural");
    }

    if(this.duration() >= 60) {
      minutes = minutes < 10 ? '0' + minutes : minutes;
      message = hours + hoursLabel 

      if (minutes != 0) {
        message =  message + " " + minutes + minutesLabel;
      }
    } else {
      message = minutes + minutesLabel;
    }

    this.$element.find(".duration").text(message);

    let timeMessage = "";
    let clockFormat = this.$element.data("clock-format");

    let startHours = Math.floor(this.startMinute / 60);
    let startMinutes:any = this.startMinute % 60;
    let startMinutesString = startMinutes < 10 ? '0' + startMinutes : startMinutes;
    let endHours = Math.floor(this.endMinute / 60);
    let endMinutes:any = this.endMinute % 60;
    let endMinutesString = endMinutes < 10 ? '0' + endMinutes : endMinutes;
    let startMeridien;
    let endMeridien;

    if (clockFormat == "12hours") {
      if (startHours >= 12) {
        startMeridien = "pm"

        if (startHours > 12) {
          startHours = startHours - 12;
        }
      } else {
        startMeridien = "am"
      }

      if (endHours >= 12) {
        endMeridien = "pm"

        if (endHours > 12) {
          endHours = endHours - 12;
        }
      } else {
        endMeridien = "am"
      }

      timeMessage = startHours + ":" + startMinutesString + startMeridien;
      timeMessage = timeMessage + " - ";
      timeMessage = timeMessage + endHours + ":" + endMinutesString + endMeridien;

    } else {
      timeMessage = startHours + ":" + startMinutesString + " - ";
      timeMessage = timeMessage + endHours + ":" + endMinutesString;
    }

    this.$element.find(".time-range").html(timeMessage);
  }

  top() {
    let adjustedPosition;

    // 4 pixels is 5 minutes, this divdes by 5 and multiples by 4 to change
    // from start minute to the pixel representation
    let startingPosition = (this.startMinute / 5) * 4

    // if am is shown we don't need to do anything since the top is correct
    // however if it's hidden we need to remove the hidden portion of the
    // top
    if (this.showAm) {
      adjustedPosition = startingPosition;
    } else {
      adjustedPosition = startingPosition - 384;
    }

    return adjustedPosition;
  }

  toggleShowAm(show: boolean) {
    if(show) {
      this.topPosition = this.topPosition + 384;
      this.showAm = true;
    } else {
      this.topPosition = this.topPosition - 384;
      this.showAm = false;
    }
  }
}
