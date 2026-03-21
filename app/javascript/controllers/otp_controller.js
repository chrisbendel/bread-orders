import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input"]

  submit() {
    if (this.inputTarget.value.length === 6) {
      this.element.requestSubmit()
    }
  }
}
