import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["button"]

  animate() {
    // ボタンに「pulse」エフェクトを追加
    this.buttonTarget.classList.add("like-pulse")
    
    // 500ms後にエフェクトを削除
    setTimeout(() => {
      this.buttonTarget.classList.remove("like-pulse")
    }, 600)
  }
}
