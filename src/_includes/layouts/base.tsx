import { ComponentChildren } from "npm:preact";
import { Header } from "components/header.tsx";
import { Footer } from "components/footer.tsx";
import { removeDuplications } from "utils/removeDuplications.ts";
import { FONT_LINK, SITE_NAME } from "constants/constants.ts";

const titleCharacterSetString = removeDuplications(SITE_NAME).trim();

type Props = {
  title: string;
  children: ComponentChildren;
};

const Base = ({ title, children }: Props) => {
  return (
    <html lang="ja">
      <head>
        <meta charSet="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>{title}</title>
        <link
          href={`${FONT_LINK}&text=${titleCharacterSetString}`}
          rel="stylesheet"
        >
        </link>
        <link rel="stylesheet" href="/assets/tailwind.css" />
        {/* katex styles */}
        <link
          rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/katex@0.16.2/dist/katex.css"
        >
        </link>
      </head>
      <body class="min-h-screen grid grid-rows-[min-content_1fr_min-content] grid-cols-1 bg-fresh-marine-white">
        <Header />
        <main>{children}</main>
        <Footer />
      </body>
    </html>
  );
};

export default Base;
