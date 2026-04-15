import { ComponentChildren } from "npm:preact";

type Props = {
  children: ComponentChildren;
};

export const ArticleSection = ({ children }: Props) => (
  <article class="prose md-prose max-w-1/1 px-8 py-8 sm:max-w-8/10 sm:rounded-xl md:max-w-7/10 lg:max-w-6/10 lg:p-12 xl:max-w-5/10 xl:p-16 mx-auto bg-white">
    {children}
  </article>
);
