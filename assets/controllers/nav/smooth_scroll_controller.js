// assets/controllers/smooth_scroll_controller.js
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
    connect() {
        // Find all in-page links and bind a handler
        this.element.querySelectorAll('a[href^="#"]').forEach(link => {
            link.addEventListener("click", this.scrollTo.bind(this));
        });
    }

    scrollTo(event) {
        const href = event.currentTarget.getAttribute("href");
        const targetId = href.slice(1);
        const targetEl = document.getElementById(targetId);

        if (targetEl) {
            event.preventDefault();
            targetEl.scrollIntoView({ behavior: "smooth" });
        }
    }
}
