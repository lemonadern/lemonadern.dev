import { ComponentChildren } from "npm:preact";

type Props = {
  children: ComponentChildren;
};

export const ArticleSection = ({ children }: Props) => (
  <article class="prose md-prose mx-auto max-w-full bg-white px-8 py-8 sm:max-w-[80%] sm:rounded-xl md:max-w-[70%] lg:max-w-[60%] lg:p-12 xl:max-w-[50%] xl:p-16">
    {children}
  </article>
);
