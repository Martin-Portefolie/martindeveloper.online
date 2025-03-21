import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
    static targets = ["menu"];

    toggle() {
        this.menuTarget.classList.toggle("hidden");
        this.menuTarget.classList.toggle("menu-slide");


        // Toggle visibility of SVG icons
        document.getElementById("menu-open-icon").classList.toggle("hidden");
        document.getElementById("menu-close-icon").classList.toggle("hidden");
    }

}
