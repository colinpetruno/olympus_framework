import * as $ from "jquery";
import Wisp from '../wisp/wisp';
import "../wisp/components/tooltips";
import { Application } from "stimulus"
import { Controller } from "stimulus"
import { definitionsFromContext } from "stimulus/webpack-helpers"

declare global {
  interface Window { 
    Wisp: Wisp;
  }
};

document.addEventListener("turbolinks:load", function() {
  let App = new Wisp();

  window.Wisp = App;
  App.setup();
})


const application = Application.start()
const context = require.context("wisp/controllers", true, /.ts$/)
application.load(definitionsFromContext(context))
