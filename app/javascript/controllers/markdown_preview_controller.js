import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = [
    "input",
    "output",
    "previewWrapper",
    "layout",
    "modePlain",
    "modeMarkdown",
    "help",
  ];

  static values = { url: String };

  connect() {
    this.toggleMode();
  }

  async toggleMode() {
    if (this.modeMarkdownTarget.checked) {
      this.previewWrapperTarget.classList.remove("hidden");
      this.layoutTarget.classList.add("md:grid-cols-2");
      this.helpTarget.textContent =
        "Markdownを選ぶと # 見出し や - 箇条書き が使えます。";
      await this.render();
    } else {
      this.previewWrapperTarget.classList.add("hidden");
      this.layoutTarget.classList.remove("md:grid-cols-2");
      this.helpTarget.textContent = "通常入力ではそのまま表示されます。";
    }
  }

  async render() {
    if (!this.modeMarkdownTarget.checked) return;

    const text = this.inputTarget.value?.trim();

    if (!text) {
      this.outputTarget.innerHTML =
        '<p class="text-gray-400">ここにプレビューが表示されます</p>';
      return;
    }

    const csrfToken = document.querySelector(
      'meta[name="csrf-token"]',
    )?.content;

    try {
      const response = await fetch(this.urlValue, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": csrfToken,
          Accept: "text/html",
        },
        body: JSON.stringify({ content: this.inputTarget.value }),
      });

      if (!response.ok) {
        this.outputTarget.innerHTML =
          '<p class="text-red-500">プレビューの取得に失敗しました</p>';
        return;
      }

      this.outputTarget.innerHTML = await response.text();
    } catch {
      this.outputTarget.innerHTML =
        '<p class="text-red-500">プレビューの通信に失敗しました</p>';
    }
  }
}
