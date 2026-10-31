#!/usr/bin/env bash
# Join clips in order. Usage: scripts/concat.sh <out> <clip1> <clip2> [...]
# Clips are normalized to the first clip's size/fps so mixed sources work.
set -euo pipefail
[ $# -ge 3 ] || { echo "Usage: $0 <out> <clip1> <clip2> [...]" >&2; exit 1; }
out=$1; shift
read -r W H FPS < <(ffprobe -v error -select_streams v:0 \
  -show_entries stream=width,height,r_frame_rate -of csv=p=0 "$1" | tr ',' ' ')
inputs=(); filter=""; i=0
for f in "$@"; do
  inputs+=(-i "$f")
  filter+="[$i:v]scale=${W}:${H}:force_original_aspect_ratio=decrease,pad=${W}:${H}:(ow-iw)/2:(oh-ih)/2,setsar=1,fps=${FPS}[v$i];"
  filter+="[$i:a]aresample=48000,aformat=channel_layouts=stereo[a$i];"
  i=$((i+1))
done
for ((j=0; j<i; j++)); do filter+="[v$j][a$j]"; done
filter+="concat=n=$i:v=1:a=1[v][a]"
ffmpeg -hide_banner -y "${inputs[@]}" -filter_complex "$filter" -map "[v]" -map "[a]" \
  -c:v libx264 -preset fast -crf 20 -c:a aac -b:a 192k -movflags +faststart "$out"
