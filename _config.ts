import lume from "lume/mod.ts";
import basePath from "lume/plugins/base_path.ts";
import relativeUrls from "lume/plugins/relative_urls.ts";
import resolveUrls from "lume/plugins/resolve_urls.ts";
import metas from "lume/plugins/metas.ts";
import jsx from "lume/plugins/jsx.ts";
import nunjucks from "lume/plugins/nunjucks.ts";
import tailwindCSS from "lume/plugins/tailwindcss.ts";
import date from "lume/plugins/date.ts";
import katex from "lume/plugins/katex.ts";

import { SITE_URL } from "./src/_constants/constants.ts";
import { markdownItConfig } from "./markdown_config.ts";

const site = lume({
  src: "./src",
  location: new URL(SITE_URL),
}, { markdown: markdownItConfig });

site.use(basePath())
  .use(relativeUrls())
  .use(resolveUrls())
  .use(metas())
  .use(jsx())
  .use(nunjucks())
  .use(tailwindCSS())
  .use(date())
  .use(katex());

site.preprocess([".md"], (pages) => {
  for (const page of pages) {
    const match = page.sourcePath.match(
      /^\/nightly\/(\d{4}\/\d{2}\/\d{2})\/\d{4}-\d{2}-\d{2}_index\.md$/,
    );

    if (match) {
      page.data.url = `/nightly/${match[1]}/`;
    }
  }
});

// 画像等のアセット: site.add() はソース側のパスを指定
site.add([".png", ".jpg", ".gif", ".svg", ".webp"]);
site.add("/assets/tailwind.css");

export default site;
