#!/usr/bin/env bash
# Install / verify the three tools: FFmpeg, yt-dlp, HyperFrames.
set -euo pipefail

echo "== FFmpeg =="
if ! command -v ffmpeg >/dev/null; then
  if command -v brew >/dev/null; then brew install ffmpeg
  elif command -v apt-get >/dev/null; then sudo apt-get update && sudo apt-get install -y ffmpeg
  else echo "Install FFmpeg manually: https://ffmpeg.org/download.html" >&2; exit 1; fi
fi
ffmpeg -version | head -1

echo "== yt-dlp =="
if ! command -v yt-dlp >/dev/null; then
  if command -v brew >/dev/null; then brew install yt-dlp
  else python3 -m pip install --user -U yt-dlp; fi
fi
yt-dlp --version || python3 -m yt_dlp --version

echo "== HyperFrames (needs Node >= 22) =="
node -e 'const m=+process.versions.node.split(".")[0]; if(m<22){console.error("Node "+process.versions.node+" found; HyperFrames needs >= 22");process.exit(1)}'
npx -y hyperframes --version

echo "All set."
