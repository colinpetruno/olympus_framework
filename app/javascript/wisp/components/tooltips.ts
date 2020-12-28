import * as $ from "jquery";
import 'popper.js'
import { Tooltip } from 'bootstrap';

$(document).on('turbolinks:load', function() {
  ($('[data-toggle="tooltip"]') as any).each(function() {
    // NOTE: It's this line that makes bootstrap append to the jquery object
    // that get's exposed to the window. Why.. who knows. Just having the line
    // makes it work. Commenting it out will cause undefined methods when 
    // trying to call bootstrap from the window
    new Tooltip(this);
  });
});
