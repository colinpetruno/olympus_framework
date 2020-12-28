import { Controller } from "stimulus"
import SlimSelect from 'slim-select'

export default class extends Controller {
  connect() {
    new SlimSelect({
      select: this.element,
    })
  }
}
