import { Controller } from "stimulus";
import { Availability } from "../../src/scheduling/availability";

export default class extends Controller {
  availability: Availability;
  availabilities: Array<Array<Availability>> = [[], [], [], [], [], [], []];
  outputTarget: Element;
  outputTargets: Element[];
  hasOutputTarget: boolean;
  $container: JQuery<HTMLElement>;
  amHeight: number = 384;
  dayHeight: number = 480;
  pmHeight: number = 288;
  // flag to determine if an availability is being dragged at the current time
  manipulating: boolean = false;

  // track if the pre work hours and post work hours
  // are open or closed
  amOpen: boolean = false;
  eveningOpen: boolean = false;

  static targets = [ "output" ];

  connect() {
    this.$container = $(this.element).find(".container");

    this.amOpen = !this.$container.hasClass("hide-am");
    this.eveningOpen = !this.$container.hasClass("hide-evening");

    this.element.querySelectorAll('.container .availability').forEach((element:any) => {
      this.setupAvailabilityDrag(element);
    });

    this.updateHiddenField();
  }

  availabilityJson() {
    return $.map(this.availabilities, function(n){
       return n; // .asJson();
    }).map(function(avail:Availability) {
      return avail.asJson();
    });;
  }

  updateHiddenField() {
    $("#meetingAvailabilitiesInput").val(
      JSON.stringify(this.availabilityJson())
    );
  }

  toggleAm() {
    if (this.$container.hasClass("transitioning")) {
      return;
    }

    if (this.amOpen) {
      this.hideAm();
    } else {
      this.showAm();
    }
  }

  togglePm() {
    if (this.$container.hasClass("transitioning")) {
      return;
    }

    if (this.eveningOpen) {
      this.hideEvening();
    } else {
      this.showEvening();
    }
  }

  hideEvening() {
    this.$container.addClass("hide-evening transitioning");
    this.eveningOpen = false;
    setTimeout(function () {
      this.$container.removeClass("transitioning");
    }.bind(this), 1000);
  }

  showEvening() {
    this.$container.removeClass("hide-evening transitioning");
    this.eveningOpen = true;
    setTimeout(function () {
      this.$container.removeClass("transitioning");
    }.bind(this), 1000);
  }

  hideAm() {
    let that = this;

    this.$container.
      find(".availability").
      css("transition", "top 1s, min-height 1s, max-height 1s");


    that.$container.addClass("hide-am transitioning");
    that.amOpen = false;

    setTimeout(function () {
      this.$container.removeClass("transitioning");
    }.bind(this), 1000);

    that.$container.find(".availability").each(function() {
      let $availability = $(this);
      let currentTop = parseInt($availability.css("top"));

      $availability.data("availability").toggleShowAm(false);
      $availability.css("top", (currentTop - 384) + "px");

      setTimeout(function () {
        that.$container.find(".availability").css("transition", "none");
      }, 1100);
    });
  }

  showAm() {
    let that = this;

    this.$container.
      find(".availability").
      css("transition", "top 1s, min-height 1s, max-height 1s");

    that.$container.removeClass("hide-am transitioning");
    that.$container.addClass("transitioning");
    that.amOpen = true;

    setTimeout(function () {
      this.$container.removeClass("transitioning");
    }.bind(this), 1000);

    that.$container.find(".availability").each(function() {
      let $availability = $(this);
      let currentTop = parseInt($availability.css("top"));

      $availability.data("availability").toggleShowAm(true);
      $availability.css("top", (currentTop + 384) + "px");

      setTimeout(function () {
        that.$container.find(".availability").css("transition", "none");
      }, 1100);
    });
  }

  // triggered by click, event is the click event
  addEvent(event:any) {
    if (this.$container.hasClass("transitioning") || this.manipulating) {
      // don't let them add an event while things are moving all over the place
      // weird things will happen. Also there is a small delay between drag 
      // end and the end of manipulating to prevent accidental creation of
      // events
      return;
    }

    let $dayColumn = $(event.target).closest(".day-column");
    if($dayColumn.hasClass("dragging")) {
      return false;
    }

    let topOfDivPosition = event.offsetY;
    if (event.target.classList.contains("evening")) {
      // since the event target is going to be the invdidual container we need
      // to add the middle height to the bottom div targets 
      topOfDivPosition = topOfDivPosition + this.dayHeight;
    }

    if (this.amOpen && !event.target.classList.contains("am")) {
      // add the am height for events that aren't in the am section but the
      // am section is open
      topOfDivPosition = topOfDivPosition + this.amHeight;
    }

    // this is pinning the click to a 5 minute interval with modulus subtract
    // of the remainder. The div will appear earlier than clicked
    // let adjustedClickHeight = topOfDivPosition - (topOfDivPosition % 4);
    let pinnedTopPosition = topOfDivPosition - (topOfDivPosition % 4);

    // ensure this is after pinning the position to a 5 minute time
    let startMinute = Math.floor(pinnedTopPosition / 4) * 5;

    let dayOfWeek = $dayColumn.data("day-number");
    let $template = $(".availability-template").clone();

    let avail = new Availability($template, this.amOpen);

    $template.removeClass("availability-template");
    $template.data("day-number", dayOfWeek);
    $template.data("start-minute", startMinute);
    $template.data("availability", avail);
    $template.css("top", pinnedTopPosition + "px");


    // set the top of the event div to the correct height
    $template.data("availability").updateTop(pinnedTopPosition);

    // the event should try to be set to two hours long 
    $template.data("availability").updateHeight(96);

    // need to ensure no overlap of events
    let dayAvailabilities = this.availabilities[avail.dayNumber()];

    for(var i = 0; i < dayAvailabilities.length; i++) {
      // we don't need to skip our self because it isn't added to the array yet
      let overlaps = dayAvailabilities[i].overlaps(
        96, // height of 2 hours 
        pinnedTopPosition
      );

      if(overlaps) {
        // assumption that overlap can only happen with following events
        let height = dayAvailabilities[i].top() - pinnedTopPosition;
        $template.css("height", height + "px");
        $template.css("min-height", height + "px");
        $template.css("max-height", height + "px");
        avail.updateHeight(height);
      }
    }

    $(event.target).closest(".day-column").append($template);
    this.setupAvailabilityDrag($template[0]);
    this.updateHiddenField();
  }

  removeEvent(event: any) {
    event.stopPropagation();
    event.preventDefault();
    let $availability = $(event.target).closest(".availability");
    let availability = $availability.data("availability");
    availability.delete();

    $availability.empty().remove();
    this.updateHiddenField();
  }

  setupAvailabilityDrag(element: any) {
    let $element:any = $(element);
    let that = this;

    if (!$element.data("availability")) {
      $element.data("availability", new Availability($element));
    }

    // TODO: I think this is a problem, it may be duplicated between places
    this.availabilities[$element.data("availability").dayNumber()].
      push($element.data("availability"));

    $element.on("click", function (event:any) {
      event.stopPropagation();
    });

    $element.draggable({ 
      axis: "y",
      grid: [ 4, 4 ],
      containment: "parent",
      drag: function(event: any, ui: any) {
        let availability = $(this).data("availability");
        let willOverlap = that.checkOverlap(
          availability,
          availability.height(),
          ui.position.top 
        );

        if (willOverlap === true) {
          ui.position.top = availability.topPosition;
        } else {
          availability.updateTop(ui.position.top);
        }
      },
      start: function(event:any) {
        that.manipulating = true;
        $(this).closest(".day-column").addClass("dragging");
      },
      stop: function(event:any) {
        event.stopPropagation();
        let $dayColumn = $(this).closest(".day-column");
        $dayColumn.find(".availability").css("transition", "none");
        that.updateHiddenField();

        // a small delay is needed here to ensure we don't fire a click
        // event on the drag end
        setTimeout(function () {
          that.manipulating = false;
          $dayColumn.removeClass("dragging");
        }, 200);
      }
    }).resizable({
      grid: 4,
      handles: "n, s",
      start: function () {
        that.manipulating = true;
      },
      stop: function () {
        that.updateHiddenField();

        setTimeout(function () {
          that.manipulating = false;
        }, 200);
      }
    }).on( "resize", function( event:any, ui:any ) {
      // the below commented code will make a full drag
      // let topPosition = parseInt($(this).data("availability").css("top"));
      // let topPosition = $(this).data("availability").top();
      let topPosition = ui.position.top

      let willOverlap = that.checkOverlap(
        $(this).data("availability"),
        ui.size.height,
        topPosition 
      );

      if (willOverlap === true) {
        return false;
      } else {
        $element.css("max-height", (ui.size.height + "px"));
        $element.css("min-height", (ui.size.height + "px"));

        $(this).data("availability").updateTop(topPosition);
        $(this).data("availability").updateHeight(ui.size.height);
      }
    });
  }

  // availability is the one being dragged
  // height is height of dragged div
  // top of div is the new top position
  checkOverlap(availability: Availability, height: number, topOfDiv: number):boolean {
    // this function is used on a resize to check for collisions on resize
    // the availability passed in is the availability being resized and the
    // other two attributes are the new positions of the availability

    // get the day of week to check collisions against
    let dayOfWeek = availability.dayNumber();
    let overlap = false;

    this.availabilities[dayOfWeek].forEach(function (otherAvail:Availability) {
      // don't check if they are the same object
      if(otherAvail === availability) {
        return;
      }

      if(otherAvail.overlaps(height, topOfDiv)) {
        overlap = true;
      } 
    });

    return overlap;
  }
}
