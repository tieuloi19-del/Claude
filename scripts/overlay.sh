#!/usr/bin/env bash
# Put a HyperFrames render (captions/graphics on a transparent or green bg) over footage.
# Usage: scripts/overlay.sh <footage> <graphics> <out> [chroma]
#   Default: graphics is a .webm/.mov with alpha.
#   chroma : graphics was rendered on pure green (#00ff00); key it out.
set -euo pipefail
[ $# -ge 3 ] || { echo "Usage: $0 <footage> <graphics> <out> [chroma]" >&2; exit 1; }
if [ "${4:-}" = chroma ]; then
  key="[1:v]colorkey=0x00ff00:0.3:0.1[g];"
else
  key="[1:v]format=rgba[g];"
fi
ffmpeg -hide_banner -y -i "$1" -i "$2" \
  -filter_complex "${key}[g][0:v]scale2ref[g2][base];[base][g2]overlay=0:0:shortest=1[v]" \
  -map "[v]" -map 0:a? -c:v libx264 -preset fast -crf 20 -c:a copy -movflags +faststart "$3"
