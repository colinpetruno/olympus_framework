import { Aion } from "./index";

export class AionCalendar {
  private aion: Aion;
  private targetDate: number;
  private previewDate: number;
  private remotePath: string;
  private calendarId: string;
  private controllers: Array<any> = []
  private displayFormat: string;
  private containerDiv: HTMLElement;

  constructor(calendarContainer: HTMLElement, aion: Aion) {
    this.containerDiv = calendarContainer;
    this.targetDate = parseInt(calendarContainer.dataset.aionTargetUnix);
    this.previewDate = parseInt(calendarContainer.dataset.aionPreviewUnix);
    this.remotePath = calendarContainer.dataset.aionRemotePath;
    this.calendarId = calendarContainer.dataset.aionCalendarId;
    this.displayFormat = calendarContainer.dataset.aionDisplayFormat;
    this.aion = aion;
  }

  offsetPreviewDate(offsetAmount: number) {
    this.previewDate = this.previewDate + offsetAmount;

    this.refresh();
  }

  setPreviewDate(previewDate: number) {
    if(previewDate) { 
      this.previewDate = previewDate;
      this.refresh();
    } 
  }

  offsetTargetDate(offsetAmount: number) {
    this.targetDate = this.targetDate + offsetAmount;

    this.refresh();
  }

  setTargetDate(targetDate: number) {
    if(targetDate) { 
      this.targetDate = targetDate;
      this.refresh();
    } 
  }

  registerController(controller:any) {
    this.controllers.push(controller);
  }

  updateDisplayFormat(format:string) {
    if (this.displayFormat != format) {
      this.displayFormat = format;

      this.refresh();
    }
  }

  refresh() {
    $.ajax({
      url: this.remotePath,
      contentType: "application/json",
      data: {
        aion: {
          calendar_id: this.calendarId,
          target_date: this.targetDate,
          preview_date: this.previewDate,
          controller_type: "calendar",
          controllers: this.controllers.map(controller => controller.state())
        }
      },
      dataType: "script",
      success: function () {}
    })
  }

  updateFromServer(response: any) {
    this.refreshContent(response["content"]["calendar_content"]);

    let controllerIds = Object.keys(response["content"]["controllers_content"])

    controllerIds.map(function(controllerId:string) {
      let controller = this.aion.lookupController(controllerId);
      let content = response["content"]["controllers_content"][controllerId];

      controller.refreshContent(content);
    }.bind(this))
  }

  refreshContent(html: string) {
    let $content = $(html);

    $(this.containerDiv).html($content.html());
  }
}
