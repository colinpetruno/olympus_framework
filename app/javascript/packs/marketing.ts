require("jquery")
require("bootstrap")
require("ichnaea")

import { Application } from "stimulus"
import { Controller } from "stimulus"
import { definitionsFromContext } from "stimulus/webpack-helpers"
const application = Application.start()
const context = require.context("../marketing/controllers", true, /.ts$/)
application.load(definitionsFromContext(context))
