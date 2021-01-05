import { Controller } from "stimulus"

// TODO: Find a better way to set this up. Modal isn't on '$' interface since
// that is from bootstrap
declare var $: any 

export default class extends Controller {
  newSessionPath: string;
  awaitingAuth: boolean = false;

  connect () {
    $(window).on('twoFactorAuthEvent', this.authEventOccurred.bind(this))

    this.newSessionPath = $(this.element).data("newSessionPath");

    $(this.element).on("submit", function(e:any) {
      // listen for the modal closure so we can disable the waiting state if
      // the user closes the auth modal
      $(window).on("hidden.bs.modal", function (event:any) {
        this.awaitingAuth = false;

        // unbind event to prevent stackage
        $(window).off("hidden.bs.modal");
      }.bind(this))

      e.preventDefault();

      this.awaitingAuth = true;
      $.get(this.newSessionPath, null, null, "script");
    }.bind(this));
    // we need to take the form this controller is bound to and override the 
    // submit button

    // the submit button should open the modal
    // upon successful auth we should then add the params to the form
    // form should then get submitted
  }

  authEventOccurred(event: any, authDetails: any) {
    // this ensures only the correct form is submitted in the case where
    // there are multiple auth modals on the same page
    if(!this.awaitingAuth) {
      return;
    }

    let $input = $("<input type='hidden' name='two_factor_redemption[id]'/>");
    $input.val(authDetails["id"]);

    $(this.element).append($input);

    $(this.element).trigger("submit.rails");
    $("#twoFactorAuthModal").modal("hide");
  }

  disconnect () {
    $(window).off("twoFactorAuthEvent");
  }
}
