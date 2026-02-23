# Dev notes

## 2026-02-23 — Layout polish (dark mode + branding)

Changes made on branch `layout-fixes-2026-02-23`:

- **Dark-mode typography fix**: Updated `style.css` so hard-coded heading and listing-title link colors apply only in light mode, and dark mode inherits colors from the Quarto `darkly` theme. This prevents low-contrast headings/links in dark mode.
- **Navbar shadow in dark mode**: Increased the shadow alpha for `.navbar` in dark mode to avoid a washed-out/light haze.
- **Branding consistency**: Aligned `website.navbar.title` with `website.title` in `_quarto.yml`.
- **About page content**: Expanded `about.qmd` with a short description of the blog and what readers can expect.
