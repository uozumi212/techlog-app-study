// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails";
import { Application } from "@hotwired/stimulus";
import LikeController from "controllers/like_controller";

const application = Application.start();
application.debug = false;
window.Stimulus = application;

// Register controllers
application.register("like", LikeController);
