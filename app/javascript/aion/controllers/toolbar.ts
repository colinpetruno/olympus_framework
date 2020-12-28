import { Aion } from "../index";
import { AionCalendar } from "../calendar";

export class AionControllerToolbar {
  private aion: Aion;
  private calendarContainer: HTMLElement;
  private calendar: AionCalendar;
  private calendarId: string;
  private container: HTMLElement;
  private nextButton: HTMLElement;
  private previousButton: HTMLElement;
  private timezoneSelect: HTMLElement;
  private displayDateContainer: HTMLElement;
  private modeToggleContainer: HTMLElement;
  private previewDate: number;

  constructor(controllerContainer: HTMLElement, aion: Aion) {
    this.aion = aion;
    this.container = controllerContainer;
    this.calendarId = this.container.dataset.aionCalendarName;
    this.calendarContainer = document.getElementById(this.calendarId);
    this.calendar = this.aion.lookupCalendar(this.calendarId);
    this.previewDate = parseInt(this.container.dataset.aionPreviewDateUnix);

    // register with the calendar
    this.calendar.registerController(this);


    let controller = this;
    $(this.container).on("click", ".button-offset-time", function(event) {
      let offsetAmount = parseInt(this.dataset.aionTimeOffset);
      let calendar = controller.calendar

      calendar.offsetTargetDate(offsetAmount);
    });
  }

  state() {
    return {
      id: this.container.dataset.aionControllerId,
      preview_date: this.previewDate,
      controller_type: "toolbar"
    }
  }

  updatePreviewTime() {
    // do nothing on this one
  }

  updateTargetDate() {

  }

  refreshContent(html: string) {
    let $content = $(html);

    $(this.container).html($content.html());
  }
  // forward 1 week 
  // back 1 week
  // change timezone?? (not yet)
  // change calendar format
}
