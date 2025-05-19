import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
    connect() {
        this.handleScroll = this.handleScroll.bind(this);
        window.addEventListener("scroll", this.handleScroll);
        window.addEventListener("resize", this.handleScroll);
        this.nav = document.getElementById("main-nav");
        this.handleScroll(); // trigger on load
    }

    disconnect() {
        window.removeEventListener("scroll", this.handleScroll);
        window.removeEventListener("resize", this.handleScroll);
    }

    handleScroll() {
        const isSmallScreen = window.innerWidth < 640;
        const navBottom = this.nav?.getBoundingClientRect().bottom ?? 0;
        const button = this.element;

        if (!isSmallScreen && navBottom < 0) {
            button.style.display = "flex";
        } else {
            button.style.display = "none";
        }
    }

    scrollToTop(event) {
        event.preventDefault();
        window.scrollTo({ top: 0, behavior: "smooth" });
    }
}
