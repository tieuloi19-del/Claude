#!/usr/bin/env bash
# Download a video (YouTube, TikTok, Instagram Reel, ...) into input/ as MP4.
# Usage: scripts/download.sh <url> [more urls...]
# Only download content you own or have permission to reuse.
set -euo pipefail
[ $# -ge 1 ] || { echo "Usage: $0 <url> [url...]" >&2; exit 1; }
YTDLP=(yt-dlp); command -v yt-dlp >/dev/null || YTDLP=(python3 -m yt_dlp)
"${YTDLP[@]}" -f "bv*[ext=mp4]+ba[ext=m4a]/b[ext=mp4]/b" --merge-output-format mp4 \
  -o "input/%(uploader)s-%(id)s.%(ext)s" "$@"
