import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
	static targets = ["form", "button", "count"];

	async handleSubmit(event) {
		event.preventDefault();
		console.log("Like button clicked");

		// フォームの action と method を取得
		const form = this.formTarget;
		const url = form.action;
		const formData = new FormData(form);

		try {
			// Fetch で POST リクエストを送信
			const response = await fetch(url, {
				method: "POST",
				body: formData,
				headers: {
					Accept: "application/json",
				},
			});

			console.log("Response status:", response.status);

			if (!response.ok) {
				console.error("Error:", response.statusText);
				return;
			}

			const data = await response.json();
			console.log("Response data:", data);

			if (data.success) {
				// ボタンの状態を更新
				this.updateButton(data.liked);
				// いいね数を更新
				this.updateCount(data.likes_count);
				// アニメーションを実行
				this.animate();
				console.log("Like updated successfully");
			}
		} catch (error) {
			console.error("Error:", error);
		}
	}

	updateButton(isLiked) {
		const button = this.buttonTarget;
		const icon = button.querySelector("span");

		if (isLiked) {
			button.classList.add("liked");
			icon.textContent = "❤️";
			button.title = "いいねを取り消す";
		} else {
			button.classList.remove("liked");
			icon.textContent = "🤍";
			button.title = "いいねする";
		}
	}

	updateCount(count) {
		if (this.hasCountTarget) {
			this.countTarget.textContent = count;
		}
	}

	animate() {
		// ボタンに「pulse」エフェクトを追加
		const button = this.buttonTarget;
		button.classList.add("like-pulse");

		// 600ms後にエフェクトを削除
		setTimeout(() => {
			button.classList.remove("like-pulse");
		}, 600);
	}
}
