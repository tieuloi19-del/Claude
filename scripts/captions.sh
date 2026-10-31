#!/usr/bin/env bash
# Quick burned-in captions from an .srt file (no HyperFrames needed).
# Usage: scripts/captions.sh <in> <subs.srt> <out>
set -euo pipefail
[ $# -eq 3 ] || { echo "Usage: $0 <in> <subs.srt> <out>" >&2; exit 1; }
style="FontName=Arial,FontSize=16,Bold=1,PrimaryColour=&H00FFFFFF,OutlineColour=&H00000000,BorderStyle=1,Outline=3,Shadow=0,Alignment=2,MarginV=60"
ffmpeg -hide_banner -y -i "$1" -vf "subtitles='$2':force_style='$style'" \
  -c:v libx264 -preset fast -crf 20 -c:a copy -movflags +faststart "$3"
