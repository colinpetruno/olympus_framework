import { Controller } from "stimulus"

export default class extends Controller {
  lastSyncDateTarget: Element;
  lastSyncDateTargets: Element[];
  haslastSyncDateTarget: boolean;
  calendarId: number; 
  transitioning: boolean = false;

  toggleUrl: string;
  public enabled: boolean;

  static targets = [ "lastSyncDate" ];

  connect() {
  }

  selectTime(event:any) {
    let $target = $(event.target);
    $(".availability").removeClass("selected");
    $target.addClass("selected");
    $("#continueButton").attr("disabled", null);
    $("#startTime").val($target.data("unix-time"));
  }

  selectDate(event:any) {
    if( this.transitioning ) {
      return false;
    }

    let $dateTarget = $(event.target).closest(".date")
    let selectedDate = $dateTarget.data("date");
    let that = this;

    this.transitioning = true;

    $(".week-picker .date").removeClass("selected");
    $("#continueButton").attr("disabled", "disabled");

    $dateTarget.addClass("selected");

    // this is important here because animate will dispatch a callback for 
    // each div that gets animated
    $(".availabilities.show > div").animate({
      opacity: 0
    }, 400, "swing", function() {
      setTimeout(function(){ 
        $(".availabilities").removeClass("show");
        $(".availabilities > div").css("opacity", 1);
        $(".availabilities-for-" + selectedDate + " > div").css("opacity", 0);

        $(".availabilities-for-" + selectedDate).addClass("show");

        $(".availabilities-for-" + selectedDate + " > div").
          animate({
            opacity: 1
          }, 400, "swing", function() {
            that.transitioning = false;
          });

        $("#startTime").val(null);
      }, 20);
    });
  }

  disconnect() {
  }
}
