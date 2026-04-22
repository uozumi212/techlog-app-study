import "@hotwired/turbo-rails";
import { Application } from "@hotwired/stimulus";
import LikeController from "controllers/like_controller";
import MarkdownPreviewController from "controllers/markdown_preview_controller";

const application = Application.start();
application.debug = false;
window.Stimulus = application;

application.register("like", LikeController);
application.register("markdown-preview", MarkdownPreviewController);
