#!/usr/bin/env bash
# Cut a clip. Usage: scripts/cut.sh <in> <start> <end> <out>
# Times: seconds (12.5) or HH:MM:SS(.ms). Re-encodes for frame-accurate cuts.
set -euo pipefail
[ $# -eq 4 ] || { echo "Usage: $0 <in> <start> <end> <out>" >&2; exit 1; }
ffmpeg -hide_banner -y -ss "$2" -to "$3" -i "$1" \
  -c:v libx264 -preset fast -crf 20 -c:a aac -b:a 192k -movflags +faststart "$4"
