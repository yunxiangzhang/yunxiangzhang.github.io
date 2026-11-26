# Website maintenance guide

How this site is organized and updated. Paths below are relative to the repository root (`website/`). The repository's top-level `README.md` is a short public description.

Source of my personal website, built with [Jekyll](https://jekyllrb.com/) and served by GitHub Pages. GitHub rebuilds the site automatically on every push to `main`, with no CI configuration needed. The design is adapted from [Jon Barron's template](https://jonbarron.info/).

## Where things live

Most updates only touch `_data/` and `assets/`.

| What | File |
| --- | --- |
| Bio paragraphs | `_includes/about.md` (Markdown) |
| Site description, profile links, number of visible news items | `_config.yml` |
| News | `_data/news.yml` |
| Publications | `_data/publications.yml` |
| Co-author homepages (linked automatically) | `_data/people.yml` |
| Work experience | `_data/experience.yml` |
| Academic services | `_data/services.yml` |
| Page structure | `index.html`, `_layouts/default.html`, `_includes/publication.html` |
| Styles (colors, spacing, dark mode) | `assets/css/main.css` |
| Profile photo, favicon, publication thumbnails | `assets/images/` |
| Animated (video) thumbnails | `assets/videos/` |
| CV and self-hosted paper PDFs | `assets/files/` (copy the CV from the resume repo with `make website` there) |
| Thumbnail helper script | `scripts/make-thumbnail.sh` |

## Common tasks

### Add a publication

1. Make a thumbnail (resized to ≤480 px and compressed):
   ```sh
   scripts/make-thumbnail.sh ~/Downloads/teaser.png my-paper
   ```
   A GIF or video becomes a small looping MP4 plus a poster image; this needs `ffmpeg` (`brew install ffmpeg`).
2. Add an entry at the top of `_data/publications.yml`:
   ```yaml
   - title: "My Paper: A Subtitle"          # quote titles that contain a colon
     authors: [Yunxiang Zhang*, Jane Doe*, Qi Sun]   # * = equal contribution
     venue: ACM SIGGRAPH 2026
     image: /assets/images/my-paper.jpg
     links:
       paper: https://arxiv.org/abs/...      # or a self-hosted PDF: /assets/files/my-paper.pdf
       project: https://...
       video: https://...
       code: https://github.com/...
     badges:                                # optional
       - { text: Best Paper Award, icon: fa-solid fa-award, url: "https://...", style: award }
   ```
   - **Names:**
     - My name is bolded automatically.
     - Co-authors listed in `_data/people.yml` are linked automatically, so add new collaborators there once. Names not listed are shown as plain text.
   - **Links:**
     - Any of the four `links` can be omitted.
     - The title links to the project page, or to the paper if there is no project page.
     - To host a PDF yourself, put it in `assets/files/` and link it as `/assets/files/<name>.pdf`.
     - `paper_label` changes the text of the paper link, which defaults to "Paper". For example, the dissertation entry uses `paper_label: Dissertation`.
   - **Badges:**
     - Badge icons are [Font Awesome 6](https://fontawesome.com/search?ic=free) classes.
     - `style: press` gives a blue badge instead of a red one.

### Add a news item

Add it at the top of `_data/news.yml`:

```yaml
- date: Dec 2026
  text: Our paper [My Paper](https://...) has been accepted to CVPR 2027.
```

- `text` is Markdown, so links and `**bold**` work.
- Award and press badges can be added inline as HTML, e.g. `<span class="badge award">…</span>`; see the existing items for examples.
- The newest `news_visible` items are shown (10, set in `_config.yml`), and the rest are collapsed under "Older news".

### Change the profile links

The links under the bio are the `social` list in `_config.yml`. Each entry has a `label`, a [Font Awesome 6](https://fontawesome.com/search?ic=free) `icon` class, and a `url`. Add `icon_only: true` to show just the icon (as for X). The label is then still used as the link's accessible name and hover tooltip.

## Preview locally

GitHub Pages builds with Jekyll 3 and a fixed set of plugins. The `Gemfile` installs that same set (the `github-pages` gem), so a local preview matches the live site.

Opening `index.html` directly in a browser does not work: it is a template that Jekyll fills in, and its links assume the site is served from a web root.

One-time setup on macOS with [Homebrew](https://brew.sh). The current `github-pages` gem does not support Ruby 4, and the system Ruby is too old, so use Ruby 3.4:

```sh
brew install ruby@3.4
echo 'export PATH="/opt/homebrew/opt/ruby@3.4/bin:$PATH"' >> ~/.zshrc   # then open a new terminal
bundle install    # run in the repository root
```

Then, each time, in the repository root:

```sh
bundle exec jekyll serve
```

Open <http://localhost:4000>.
- Pages rebuild automatically when you save; refresh the browser to see changes.
- Changes to `_config.yml` need a restart (Ctrl-C, then run the command again).
- Build output goes to `_site/` and is git-ignored. You never need to commit it, because GitHub builds the site itself.

## Notes

- Dark mode follows the visitor's operating-system setting. Its colors are defined at the bottom of `main.css`.
- Search-engine and link-preview metadata come from [`jekyll-seo-tag`](https://github.com/jekyll/jekyll-seo-tag) and use `title`, `description`, `image`, and the X handle from `_config.yml`.
