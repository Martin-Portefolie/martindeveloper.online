// assets/controllers/background_grid_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static values = {
        icons: Array,    // array of icon paths
        size: Number,    // icon tile size (50)
        rows: Number     // number of rows to render (e.g., 6)
    }

    async connect() {
        console.log("✅ background-grid connected")
        await this.generateBackgroundGrid()
    }

    async generateBackgroundGrid() {
        const icons = this.iconsValue
        const size = this.sizeValue
        const rows = this.rowsValue
        const columnsPattern = [3, 4] // alternating 3/4 columns per row
        const maxCols = 4
        const width = maxCols * size
        const height = rows * size


        let svgContent = ''
        let iconIndex = 0

        for (let row = 0; row < rows; row++) {
            const cols = columnsPattern[row % 2]
            for (let col = 0; col < cols; col++) {
                const x = col * size
                const y = row * size
                const icon = await this.loadSvg(icons[iconIndex % icons.length])
                svgContent += `<g transform="translate(${x}, ${y}) scale(${size / 12.7})">${icon}</g>`
                iconIndex++
            }
        }

        const fullSvg = `
      <svg xmlns="http://www.w3.org/2000/svg" width="${width}" height="${height}" viewBox="0 0 ${width} ${height}">
        ${svgContent}
      </svg>
    `
        const base64 = `data:image/svg+xml;base64,${btoa(fullSvg)}`
        document.body.style.backgroundImage = `url('${base64}')`
        document.body.style.backgroundRepeat = 'repeat'
        document.body.style.backgroundSize = `${width}px ${height}px`
    }

    async loadSvg(url) {
        try {
            const response = await fetch(url)
            const text = await response.text()
            const parser = new DOMParser()
            const doc = parser.parseFromString(text, "image/svg+xml")
            const svg = doc.querySelector("svg")
            // return svg ? svg.innerHTML : ''

            if (!svg) return ''
            const raw = svg.innerHTML

// Force fill on all <path> tags
//             const fixed = raw.replace(/<path\b(?![^>]*fill=)/g, '<path fill="black"') // only if no fill
            const fixed = raw

            return fixed
        } catch (error) {
            console.error(`Failed to load SVG from ${url}`, error)
            return ''
        }
    }
}
