// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails";

window.addEventListener("focus", () => {
  const frame = document.querySelector("turbo-frame#my-calendar-events");
  if (frame) {
    frame.reload();
  }
});
