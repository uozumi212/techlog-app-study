import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form"]
  
  confirm(event) {
    // data-confirm属性のメッセージを取得
    const message = event.target.dataset.confirm
    
    if (message && !confirm(message)) {
      event.preventDefault()
      return false
    }
  }
}
