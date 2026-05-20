# TODO

## Favicon

- Prepare `favicon-32x32.png` and `favicon-16x16.png`
- Place them in `static/img/`

## OG Image

- Prepare an OG image (recommended size: 1200×630px)
- Place it in `static/`
- Add to `templates/_head_extend.html`:
  ```html
  <meta property="og:image" content="{{ get_url(path='YOUR_IMAGE.png') }}">
  <meta name="twitter:image" content="{{ get_url(path='YOUR_IMAGE.png') }}">
  ```
