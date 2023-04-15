#! /usr/bin/env nix-shell
#! nix-shell -i bash -p nix-update xmlstarlet curl

set -ueo pipefail

RSSURL="https://dumps.wikimedia.org/enwiktionary/latest/enwiktionary-latest-pages-articles.xml.bz2-rss.xml"
XPATH="substring-after(//item/link, 'http://download.wikimedia.org/enwiktionary/')"
version=$(curl -fs "$RSSURL" | xml sel -t -v "$XPATH")
( cd ../../../../
  nix-update dictdDBs.wiktionary --version "$version" )
