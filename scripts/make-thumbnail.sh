#!/bin/sh
# Create a web-sized publication thumbnail in assets/images/ (and
# assets/videos/ for animated input).
#
#   scripts/make-thumbnail.sh path/to/teaser.png [name]
#
# Images are resized to at most 480 px on the longer side (2x the displayed
# size, sharp on high-DPI screens) and saved as JPEG with macOS's built-in
# `sips`. GIFs/videos become a looping silent MP4 plus a JPEG poster frame;
# this needs ffmpeg (`brew install ffmpeg`).
# `name` defaults to the input file name without its extension.
set -eu

if [ $# -lt 1 ]; then
  echo "usage: $0 <input> [name]" >&2
  exit 1
fi

in=$1
base=$(basename "$in")
name=${2:-${base%.*}}
root="$(cd "$(dirname "$0")/.." && pwd)"
imgdir="$root/assets/images"
viddir="$root/assets/videos"
ext=$(printf '%s' "${base##*.}" | tr '[:upper:]' '[:lower:]')

case $ext in
  gif|mp4|mov|webm)
    ffmpeg -loglevel error -y -i "$in" \
      -vf "scale=480:-2:flags=lanczos,format=yuv420p" \
      -c:v libx264 -crf 24 -preset slow -movflags +faststart -an \
      "$viddir/$name.mp4"
    ffmpeg -loglevel error -y -i "$in" -vf "scale=480:-2:flags=lanczos" \
      -frames:v 1 -q:v 4 "$imgdir/$name.jpg"
    echo "Created assets/videos/$name.mp4 and assets/images/$name.jpg"
    echo "In _data/publications.yml use:"
    echo "  image: /assets/images/$name.jpg"
    echo "  video: /assets/videos/$name.mp4"
    ;;
  *)
    sips -Z 480 -s format jpeg -s formatOptions 82 "$in" --out "$imgdir/$name.jpg" >/dev/null
    echo "Created assets/images/$name.jpg"
    echo "In _data/publications.yml use:"
    echo "  image: /assets/images/$name.jpg"
    ;;
esac
