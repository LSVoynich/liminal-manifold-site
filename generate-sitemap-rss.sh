#!/bin/bash
# Generate sitemap and RSS feed from actual site files
# Run this after any content update, before git commit
# Usage: ./generate-sitemap-rss.sh

set -euo pipefail
SITE_DIR="$(cd "$(dirname "$0")" && pwd)"
DOMAIN="https://liminalmanifold.com"
NOW=$(date -u +"%Y-%m-%dT%H:%M:%S+00:00")
TODAY=$(date -u +"%Y-%m-%d")

# ─── SITEMAP ───
SITEMAP="$SITE_DIR/sitemap-0.xml"
cat > "$SITEMAP" << 'HEADER'
<?xml version="1.0" encoding="UTF-8"?><urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9" xmlns:image="http://www.google.com/schemas/sitemap-image/1.1">
HEADER

# Find all index.html pages (excluding 404, node_modules)
find "$SITE_DIR" -name "index.html" -not -path "*/node_modules/*" -not -name "404.html" | sort | while read -r f; do
  rel="${f#$SITE_DIR}"
  rel="${rel%index.html}"
  [ "$rel" = "/" ] && rel="/"

  # Set priority based on depth
  depth=$(echo "$rel" | tr -cd '/' | wc -c)
  case $depth in
    1) priority="1.0"; freq="weekly" ;;
    2) priority="0.8"; freq="weekly" ;;
    *) priority="0.6"; freq="monthly" ;;
  esac

  # Homepage gets highest priority
  [ "$rel" = "/" ] && priority="1.0" && freq="daily"

  echo "<url><loc>${DOMAIN}${rel}</loc><lastmod>${TODAY}</lastmod><changefreq>${freq}</changefreq><priority>${priority}</priority></url>"
done >> "$SITEMAP"

echo "</urlset>" >> "$SITEMAP"

# Count URLs
URL_COUNT=$(grep -c '<url>' "$SITEMAP")
echo "Sitemap: $URL_COUNT URLs written to sitemap-0.xml"

# ─── RSS FEED ───
RSS="$SITE_DIR/rss.xml"

cat > "$RSS" << HEADER
<?xml version="1.0" encoding="UTF-8"?><rss version="2.0" xmlns:atom="http://www.w3.org/2005/Atom"><channel><title>Liminal Manifold</title><description>New releases, publications, and transmissions from Liminal Manifold.</description><link>${DOMAIN}/</link><language>en-us</language><lastBuildDate>$(date -u -R)</lastBuildDate><atom:link href="${DOMAIN}/rss.xml" rel="self" type="application/rss+xml"/>
HEADER

# Music releases (from music page)
MUSIC_PAGE="$SITE_DIR/music/index.html"
if [ -f "$MUSIC_PAGE" ]; then
  # Extract release blocks: title, artist, description, link
  # Music page has card blocks with data-track="streaming"
  python3 -c "
import re, html as h
with open('$MUSIC_PAGE', 'r') as f:
    content = f.read()

# Find all release card blocks
cards = re.findall(r'<a\s+href=\"([^\"]+)\"[^>]*data-track=\"streaming\"[^>]*>.*?<h3[^>]*>\s*(.*?)\s*</h3>.*?<p[^>]*text-gray-500[^>]*>\s*by\s+(.*?)\s*</p>.*?<p[^>]*text-gray-400[^>]*>\s*(.*?)\s*</p>', content, re.DOTALL)

for link, title, artist, desc in cards:
    title = re.sub(r'<[^>]+>', '', title).strip()
    artist = re.sub(r'<[^>]+>', '', artist).strip()
    desc = re.sub(r'<[^>]+>', '', desc).strip()
    title_clean = h.escape(title)
    artist_clean = h.escape(artist)
    desc_clean = h.escape(desc)
    link_clean = h.escape(link)
    print(f'<item><title>{title_clean}</title><link>{link_clean}</link><guid isPermaLink=\"true\">{link_clean}</guid><description>{desc_clean} (by {artist_clean})</description><category>Music</category></item>')
" >> "$RSS" 2>/dev/null || echo "  Warning: could not parse music page"
fi

# Books (from books page)
BOOKS_PAGE="$SITE_DIR/books/index.html"
if [ -f "$BOOKS_PAGE" ]; then
  python3 -c "
import re, html as h
with open('$BOOKS_PAGE', 'r') as f:
    content = f.read()

cards = re.findall(r'<a\s+href=\"([^\"]+)\"[^>]*data-track=\"amazon\"[^>]*>.*?<h3[^>]*>\s*(.*?)\s*</h3>.*?<p[^>]*text-gray-500[^>]*>\s*by\s+(.*?)\s*</p>.*?<p[^>]*text-gray-400[^>]*>\s*(.*?)\s*</p>', content, re.DOTALL)

for link, title, artist, desc in cards:
    title = re.sub(r'<[^>]+>', '', title).strip()
    artist = re.sub(r'<[^>]+>', '', artist).strip()
    desc = re.sub(r'<[^>]+>', '', desc).strip()
    title_clean = h.escape(title)
    artist_clean = h.escape(artist)
    desc_clean = h.escape(desc)
    link_clean = h.escape(link)
    print(f'<item><title>{title_clean}</title><link>{link_clean}</link><guid isPermaLink=\"true\">{link_clean}</guid><description>{desc_clean} (by {artist_clean})</description><category>Books</category></item>')
" >> "$RSS" 2>/dev/null || echo "  Warning: could not parse books page"
fi

# Blog posts
find "$SITE_DIR/blog" -mindepth 2 -name "index.html" 2>/dev/null | sort | while read -r f; do
  slug="${f#$SITE_DIR/blog/}"
  slug="${slug%/index.html}"
  url="${DOMAIN}/blog/${slug}/"

  # Extract title and description from the HTML
  title=$(grep -oP '<title>\K[^<]+' "$f" 2>/dev/null | sed 's/ | Liminal Manifold//' | head -1)
  desc=$(grep -oP 'name="description" content="\K[^"]+' "$f" 2>/dev/null | head -1)

  [ -z "$title" ] && title="$slug"
  [ -z "$desc" ] && desc=""

  # Escape for XML
  title=$(echo "$title" | sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g')
  desc=$(echo "$desc" | sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g')

  echo "<item><title>${title}</title><link>${url}</link><guid isPermaLink=\"true\">${url}</guid><description>${desc}</description><category>Blog</category></item>"
done >> "$RSS"

echo "</channel></rss>" >> "$RSS"

ITEM_COUNT=$(grep -c '<item>' "$RSS")
echo "RSS: $ITEM_COUNT items written to rss.xml"
