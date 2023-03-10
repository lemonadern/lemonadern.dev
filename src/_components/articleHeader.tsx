type Props = {
  title: string;
  published_at: string;
};

export const ArticleHeader = ({ title, published_at }: Props) => (
  <header class="flex flex-col items-center gap-4 py-16 px-6">
    <h1 class="text-3xl font-bold">
      {title}
    </h1>
    <p class="text-md opacity-70">{published_at}</p>
  </header>
);
