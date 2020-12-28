import { Aion } from "../index";
import { AionCalendar } from "../calendar";

export class AionControllerCalendar {
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
    $(this.container).on("click", ".aion-select-container .aion-button", function(event) {
      let offsetAmount = parseInt(this.dataset.aionOffset);
      let calendar = controller.calendar;

      calendar.offsetPreviewDate(offsetAmount);
    });

    $(this.container).on("click", ".aion-date", function(event) {
      let targetDate = this.dataset.aionTargetDate;
      let calendar = controller.calendar

      calendar.setTargetDate(targetDate);
    });

    $(this.container).on("change", ".aion-date-display-container select", function(event) {
      let selectElement = this;
      let selectedOption = selectElement.options[ selectElement.selectedIndex ];
      let previewDate = selectedOption.dataset.aionPreviewDate;
      let calendar = controller.calendar

      calendar.setPreviewDate(previewDate);
    });
  }

  state() {
    return {
      id: this.container.dataset.aionControllerId,
      preview_date: this.previewDate,
      controller_type: "calendar"
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
}
