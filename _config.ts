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

// 画像等のアセット: site.add() はソース側のパスを指定
site.add([".png", ".jpg", ".gif", ".svg", ".webp"]);
site.add("/assets/tailwind.css");

export default site;
