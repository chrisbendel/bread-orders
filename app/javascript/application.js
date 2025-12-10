// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

// Global "Click Outside" behavior for <details> menus
window.addEventListener("click", (event) => {
    document.querySelectorAll("details[open]").forEach((details) => {
        if (!details.contains(event.target)) {
            details.removeAttribute("open");
        }
    });
});
