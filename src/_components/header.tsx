import { SOURCECODE_LINK } from "constants/links.ts";
import { SITE_NAME } from "constants/constants.ts";

export const Header = () => {
  return (
    <header class="border-b px-6 md:px-8 py-4 bg-fresh-marine-blue">
      <div class="flex items-center justify-between">
        <a
          href="/"
          class="flex items-center gap-4 text-2xl font-title text-white"
        >
          {SITE_NAME}
        </a>

        <a
          href={SOURCECODE_LINK}
          target="_blank"
          rel="noopener noreferrer"
          class="max-sm:hidden"
        >
          <img
            alt="GitHub Icon"
            class="w-4 max-sm:hidden"
            src="https://cdn.simpleicons.org/github/white"
          />
        </a>
      </div>
    </header>
  );
};

export default Header;
