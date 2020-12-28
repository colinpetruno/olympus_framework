import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "source" ]
  sourceTarget: HTMLInputElement;
  sourceTargets: HTMLInputElement[];
  hasSourceTarget: boolean;

  connect() {
    if (document.queryCommandSupported("copy")) {
      $(this.element).find("button.copy").removeClass("hidden");;
    }
  }

  copy () {
    this.sourceTarget.select();

    document.execCommand("copy");

    window.Meettrics.
      components("flashmessages").
      addFlash("Copied to clipboard", "success");
  }
}

