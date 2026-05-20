#!/usr/bin/env python3

from __future__ import annotations

import re
import shutil
from dataclasses import dataclass
from pathlib import Path
from typing import Any


SOURCE_REPO = Path("/Users/lemonadern/ghq/github.com/lemonadern/lemonadern.dev")
TARGET_REPO = Path("/Users/lemonadern/ghq/github.com/lemonadern/my-own-serena")
SOURCE_CONTENT = SOURCE_REPO / "src"
TARGET_CONTENT = TARGET_REPO / "content"
TARGET_STATIC = TARGET_REPO / "static"
URL_MAP_PATH = TARGET_REPO / "migration-url-map.tsv"
ARCHIVE_CONTENT = TARGET_CONTENT / "archive"


SECTION_INDEXES: dict[str, str] = {
    "blog": """+++
title = "Blog"
description = "Blog posts."
aliases = ["/blog/"]
sort_by = "date"
template = "blog.html"
page_template = "post.html"
insert_anchor_links = "right"

[extra]
lang = "ja"
title = "Blog"
subtitle = "blog"
date_format = "%Y-%m-%d"
categorized = false
back_to_top = true
toc = true
comment = false
copy = true
outdate_alert = false
+++""",
    "essay": """+++
title = "Essay"
description = "Essays."
aliases = ["/essay/"]
sort_by = "date"
template = "blog.html"
page_template = "post.html"
insert_anchor_links = "right"

[extra]
lang = "ja"
title = "Essay"
subtitle = "essay"
date_format = "%Y-%m-%d"
categorized = false
back_to_top = true
toc = true
comment = false
copy = true
outdate_alert = false
+++""",
    "nightly": """+++
title = "Nightly"
description = "Daily notes archive."
aliases = ["/nightly/"]
sort_by = "date"
template = "blog.html"
page_template = "post.html"
insert_anchor_links = "right"

[extra]
lang = "ja"
title = "Nightly"
subtitle = "archive"
date_format = "%Y-%m-%d"
categorized = false
back_to_top = true
toc = true
comment = false
copy = true
outdate_alert = false
+++""",
    "weekly": """+++
title = "Weekly"
description = "Weekly archive."
aliases = ["/weekly/"]
sort_by = "date"
template = "blog.html"
page_template = "post.html"
insert_anchor_links = "right"

[extra]
lang = "ja"
title = "Weekly"
subtitle = "archive"
date_format = "%Y-%m-%d"
categorized = false
back_to_top = true
toc = true
comment = false
copy = true
outdate_alert = false
+++""",
    "monthly": """+++
title = "Monthly"
description = "Monthly archive."
aliases = ["/monthly/"]
sort_by = "date"
template = "blog.html"
page_template = "post.html"
insert_anchor_links = "right"

[extra]
lang = "ja"
title = "Monthly"
subtitle = "archive"
date_format = "%Y-%m"
categorized = false
back_to_top = true
toc = true
comment = false
copy = true
outdate_alert = false
+++""",
}

POSTS_SECTION = """+++
title = "Posts"
description = "New posts."
template = "posts.html"
insert_anchor_links = "right"

[extra]
lang = "ja"
title = "Posts"
subtitle = "new posts"
date_format = "%Y-%m-%d"
back_to_top = true
toc = true
comment = false
copy = true
outdate_alert = false
outdate_alert_days = 30
outdate_alert_text_before = "This article was last updated "
outdate_alert_text_after = " days ago and may be out of date."
+++"""

ARCHIVE_SECTION = """+++
title = "Archive"
description = "Migrated posts and archives."
template = "prose.html"
insert_anchor_links = "right"

[extra]
lang = "ja"
title = "Archive"
subtitle = "migrated content"
math = false
mermaid = false
copy = false
comment = false
reaction = false
+++

移行元 `lume` ブログから持ってきたコンテンツです。

- [Blog](/archive/blog/)
- [Essay](/archive/essay/)
- [Nightly](/archive/nightly/)
- [Weekly](/archive/weekly/)
- [Monthly](/archive/monthly/)"""

ABOUT_SECTION = """+++
title = "About"
description = "Taishi Naka (lemonadern)"
template = "prose.html"
insert_anchor_links = "right"

[extra]
lang = "ja"
title = "About"
subtitle = "Taishi Naka (lemonadern)"
math = false
mermaid = false
copy = false
comment = false
reaction = false
+++"""


@dataclass
class UrlMap:
    source: str
    target: str
    kind: str


def parse_front_matter(text: str) -> tuple[dict[str, Any], str]:
    if not text.startswith("---\n"):
        return {}, text

    end = text.find("\n---\n", 4)
    if end == -1:
        raise ValueError("Could not find closing front matter marker")

    front_matter = text[4:end]
    body = text[end + len("\n---\n") :]
    data: dict[str, Any] = {}
    current_key: str | None = None

    for raw_line in front_matter.splitlines():
        if not raw_line.strip():
            continue
        if raw_line.startswith("  - ") or raw_line.startswith("\t- "):
            if current_key is None:
                raise ValueError(f"List item without key: {raw_line}")
            data.setdefault(current_key, []).append(raw_line.split("- ", 1)[1].strip().strip('"'))
            continue

        key, value = raw_line.split(":", 1)
        key = key.strip()
        value = value.strip()
        current_key = key

        if not value:
            data[key] = []
            continue

        lowered = value.lower()
        if lowered == "true":
            data[key] = True
        elif lowered == "false":
            data[key] = False
        else:
            data[key] = value.strip('"')

    return data, body


def quote_toml(value: str) -> str:
    escaped = value.replace("\\", "\\\\").replace('"', '\\"')
    return f'"{escaped}"'


def format_front_matter(
    *,
    title: str,
    description: str | None = None,
    date: str | None = None,
    tags: list[str] | None = None,
    aliases: list[str] | None = None,
    extra: dict[str, Any] | None = None,
) -> str:
    lines = ["+++", f"title = {quote_toml(title)}"]

    if description:
        lines.append(f"description = {quote_toml(description)}")
    if date:
        lines.append(f"date = {date}")
    if aliases:
        rendered_aliases = ", ".join(quote_toml(alias) for alias in aliases)
        lines.append(f"aliases = [{rendered_aliases}]")
    if tags:
        rendered_tags = ", ".join(quote_toml(tag) for tag in tags)
        lines.extend(["", "[taxonomies]", f"tags = [{rendered_tags}]"])
    if extra:
        lines.extend(["", "[extra]"])
        for key, value in extra.items():
            if isinstance(value, bool):
                rendered = "true" if value else "false"
            else:
                rendered = quote_toml(str(value))
            lines.append(f"{key} = {rendered}")

    lines.append("+++")
    return "\n".join(lines)


def rewrite_links(body: str) -> str:
    patterns = [
        (
            re.compile(r"/nightly/(\d{4})/(\d{2})/(\d{2})/(?:\d{4}-\d{2}-\d{2}_index\.md)?"),
            lambda m: f"/archive/nightly/{m.group(1)}-{m.group(2)}-{m.group(3)}/",
        ),
        (
            re.compile(r"/weekly/\d{4}/\d{2}/(\d{4}-\d{2}-\d{2})_[^)/]+(?:\.md)?"),
            lambda m: f"/archive/weekly/{m.group(1)}/",
        ),
        (
            re.compile(r"/monthly/(\d{4})/(\d{2})-[a-z]{3}(?:\.md)?"),
            lambda m: f"/archive/monthly/{m.group(1)}-{m.group(2)}/",
        ),
        (
            re.compile(r"/blog/([^) /\n]+?)(?:\.md)?(?=[/) \n])"),
            lambda m: f"/archive/blog/{m.group(1)}/",
        ),
        (
            re.compile(r"/essay/([^) /\n]+?)(?:\.md)?(?=[/) \n])"),
            lambda m: f"/archive/essay/{m.group(1)}/",
        ),
    ]

    updated = body
    for pattern, replace in patterns:
        updated = pattern.sub(replace, updated)
    return updated


def copy_tree_contents(source_dir: Path, target_dir: Path, *, skip: set[str]) -> None:
    target_dir.mkdir(parents=True, exist_ok=True)
    for item in source_dir.iterdir():
        if item.name in skip:
            continue
        destination = target_dir / item.name
        if item.is_dir():
            shutil.copytree(item, destination, dirs_exist_ok=True)
        else:
            shutil.copy2(item, destination)


def write_text(path: Path, text: str) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(text.rstrip() + "\n", encoding="utf-8")


def migrate_blog_like(section: str, tags: list[str]) -> list[UrlMap]:
    url_maps: list[UrlMap] = []
    source_dir = SOURCE_CONTENT / section
    target_dir = ARCHIVE_CONTENT / section
    write_text(target_dir / "_index.md", SECTION_INDEXES[section])

    for source_file in sorted(source_dir.glob("*.md")):
        if source_file.name == "index.njk":
            continue
        data, body = parse_front_matter(source_file.read_text(encoding="utf-8"))
        slug = source_file.stem
        old_url = f"/{section}/{slug}/"
        new_url = f"/archive/{section}/{slug}/"
        front_matter = format_front_matter(
            title=data["title"],
            description=data.get("overview"),
            date=data.get("published_at"),
            tags=sorted(set(tags + list(data.get("tags", [])))),
            aliases=[old_url],
        )
        write_text(target_dir / f"{slug}.md", front_matter + "\n\n" + rewrite_links(body))
        url_maps.append(UrlMap(old_url, new_url, section))

    return url_maps


def migrate_nightly() -> list[UrlMap]:
    url_maps: list[UrlMap] = []
    target_dir = ARCHIVE_CONTENT / "nightly"
    write_text(target_dir / "_index.md", SECTION_INDEXES["nightly"])

    for source_file in sorted((SOURCE_CONTENT / "nightly").glob("*/*/*/*_index.md")):
        data, body = parse_front_matter(source_file.read_text(encoding="utf-8"))
        date = source_file.stem.replace("_index", "")
        old_url = f"/nightly/{source_file.parts[-4]}/{source_file.parts[-3]}/{source_file.parts[-2]}/"
        new_url = f"/archive/nightly/{date}/"
        bundle_dir = target_dir / date
        front_matter = format_front_matter(
            title=data["title"],
            description=data.get("overview"),
            date=date,
            tags=["nightly"],
            aliases=[old_url],
        )
        write_text(bundle_dir / "index.md", front_matter + "\n\n" + rewrite_links(body))
        copy_tree_contents(source_file.parent, bundle_dir, skip={source_file.name})
        url_maps.append(UrlMap(old_url, new_url, "nightly"))

    return url_maps


def migrate_weekly() -> list[UrlMap]:
    url_maps: list[UrlMap] = []
    target_dir = ARCHIVE_CONTENT / "weekly"
    write_text(target_dir / "_index.md", SECTION_INDEXES["weekly"])

    for source_file in sorted((SOURCE_CONTENT / "weekly").glob("*/*/*.md")):
        data, body = parse_front_matter(source_file.read_text(encoding="utf-8"))
        date = source_file.stem.split("_", 1)[0]
        old_url = f"/weekly/{source_file.parts[-3]}/{source_file.parts[-2]}/{source_file.stem}/"
        new_url = f"/archive/weekly/{date}/"
        bundle_dir = target_dir / date
        front_matter = format_front_matter(
            title=data["title"],
            description=data.get("overview"),
            date=date,
            tags=["weekly"],
            aliases=[old_url, old_url.removesuffix("/") + ".md"],
        )
        write_text(bundle_dir / "index.md", front_matter + "\n\n" + rewrite_links(body))
        copy_tree_contents(source_file.parent, bundle_dir, skip={"_data.yml"})
        if (bundle_dir / source_file.name).exists():
            (bundle_dir / source_file.name).unlink()
        url_maps.append(UrlMap(old_url, new_url, "weekly"))

    return url_maps


def migrate_monthly() -> list[UrlMap]:
    url_maps: list[UrlMap] = []
    target_dir = ARCHIVE_CONTENT / "monthly"
    write_text(target_dir / "_index.md", SECTION_INDEXES["monthly"])

    for source_file in sorted((SOURCE_CONTENT / "monthly").glob("*/*.md")):
        data, body = parse_front_matter(source_file.read_text(encoding="utf-8"))
        year = source_file.parts[-2]
        month = source_file.stem.split("-", 1)[0]
        date = f"{year}-{month}"
        old_url = f"/monthly/{year}/{source_file.stem}/"
        new_url = f"/archive/monthly/{date}/"
        bundle_dir = target_dir / date
        front_matter = format_front_matter(
            title=data["title"],
            description=data.get("overview"),
            date=f"{date}-01",
            tags=["monthly"],
            aliases=[old_url, old_url.removesuffix("/") + ".md"],
        )
        write_text(bundle_dir / "index.md", front_matter + "\n\n" + rewrite_links(body))
        copy_tree_contents(source_file.parent, bundle_dir, skip={"_data.yml"})
        if (bundle_dir / source_file.name).exists():
            (bundle_dir / source_file.name).unlink()
        url_maps.append(UrlMap(old_url, new_url, "monthly"))

    return url_maps


def migrate_about() -> None:
    data, body = parse_front_matter((SOURCE_CONTENT / "index.md").read_text(encoding="utf-8"))
    write_text(
        TARGET_CONTENT / "about" / "_index.md",
        ABOUT_SECTION.replace("Taishi Naka (lemonadern)", data.get("overview", "Taishi Naka (lemonadern)"))
        + "\n\n"
        + rewrite_links(body),
    )


def copy_shared_assets() -> None:
    source_profile = SOURCE_CONTENT / "assets" / "profile.webp"
    if source_profile.exists():
        TARGET_STATIC.mkdir(parents=True, exist_ok=True)
        shutil.copy2(source_profile, TARGET_STATIC / "profile.webp")


def write_url_map(url_maps: list[UrlMap]) -> None:
    lines = ["kind\tsource\ttarget"]
    lines.extend(f"{item.kind}\t{item.source}\t{item.target}" for item in url_maps)
    write_text(URL_MAP_PATH, "\n".join(lines))


def main() -> None:
    url_maps: list[UrlMap] = []
    migrate_about()
    copy_shared_assets()
    write_text(TARGET_CONTENT / "posts" / "_index.md", POSTS_SECTION)
    write_text(ARCHIVE_CONTENT / "_index.md", ARCHIVE_SECTION)
    url_maps.extend(migrate_blog_like("blog", ["article"]))
    url_maps.extend(migrate_blog_like("essay", ["essay"]))
    url_maps.extend(migrate_nightly())
    url_maps.extend(migrate_weekly())
    url_maps.extend(migrate_monthly())
    write_url_map(url_maps)
    print(f"Migrated {len(url_maps)} pages into {TARGET_CONTENT}")
    print(f"Wrote URL map to {URL_MAP_PATH}")


if __name__ == "__main__":
    main()
