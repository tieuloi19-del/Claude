#!/usr/bin/env bash
# Reframe any video to 1080x1920 (9:16) for TikTok / Reels / Shorts.
# Usage: scripts/vertical.sh <in> <out> [crop|blur]
#   crop (default): center-crop to fill the frame
#   blur: fit the whole video over a blurred copy of itself
set -euo pipefail
[ $# -ge 2 ] || { echo "Usage: $0 <in> <out> [crop|blur]" >&2; exit 1; }
mode=${3:-crop}
if [ "$mode" = blur ]; then
  vf="split[a][b];[a]scale=1080:1920:force_original_aspect_ratio=increase,crop=1080:1920,boxblur=20:2[bg];[b]scale=1080:1920:force_original_aspect_ratio=decrease[fg];[bg][fg]overlay=(W-w)/2:(H-h)/2,setsar=1"
else
  vf="scale=1080:1920:force_original_aspect_ratio=increase,crop=1080:1920,setsar=1"
fi
ffmpeg -hide_banner -y -i "$1" -filter_complex "[0:v]$vf[v]" -map "[v]" -map 0:a? \
  -c:v libx264 -preset fast -crf 20 -c:a aac -b:a 192k -movflags +faststart "$2"
