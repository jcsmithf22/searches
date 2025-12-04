// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails";
import "controllers";

// Show progress bar even for turbo frames

const progressBarDelay = 500;
let progressBarTimeout;

document.addEventListener("turbo:before-fetch-request", (event) => {
  if ("Turbo-Frame" in event.detail.fetchOptions.headers) {
    Turbo.session.adapter.progressBar.setValue(0);
    progressBarTimeout = window.setTimeout(
      () => Turbo.session.adapter.progressBar.show(),
      progressBarDelay,
    );
  }
});

document.addEventListener("turbo:frame-load", (_event) => {
  Turbo.session.adapter.progressBar.setValue(1);
  Turbo.session.adapter.progressBar.hide();
  if (progressBarTimeout != null) {
    window.clearTimeout(progressBarTimeout);
  }
});

document.addEventListener("turbo:frame-missing", (_event) => {
  Turbo.session.adapter.progressBar.setValue(1);
  Turbo.session.adapter.progressBar.hide();
  if (progressBarTimeout != null) {
    window.clearTimeout(progressBarTimeout);
  }
});
