class FlashMessages {
  private displayDuration: number = 5000;
  private $container: JQuery<HTMLElement>;
  private widthSet: boolean = false;
  // private forms: Array<ToggleButton> = [];

  constructor() {
    setTimeout(() => {
      this.hideTopFlash();
    }, this.displayDuration);
  }

  addFlash (message:string, level:string) {
    this.$container = $("<div class='alert'></div>");
    var level = level || "notice";
    this.$container.addClass(level);
    this.$container.text(message);

    $("#flash-container").append(this.$container);

    setTimeout(() => {
      this.hideTopFlash();
    }, this.displayDuration);
  }

  hideTopFlash() {
    let that = this;

    // this ensures that the flashes do not pop when short text is in one and
    // long text in another
    if(!this.widthSet) {
      let width = $("#flash-container").width();
      $("#flash-container").width(width + "px");
      this.widthSet = true;
    }

    if($("#flash-container > .alert").length > 0) {
      $("#flash-container > .alert").first().slideToggle(800, function() {
        $(this).remove();

        setTimeout(() => {
          that.hideTopFlash();
        }, 250);
      });
    }
  }
}

export { FlashMessages };
