# Claude Code video editing toolkit

Edit videos by talking to Claude Code. It uses three free, open-source tools:

- **FFmpeg**: cuts and mixes video
- **HyperFrames**: captions and graphics, written as HTML and rendered to MP4
- **yt-dlp**: downloads source videos

## Setup
```bash
scripts/setup.sh
```
You need Node.js 22 or newer and Python 3. FFmpeg is installed through brew or apt if it's missing.

## Use it
Open this folder in Claude Code and describe the edit you want, for example:

> Download this Reel, cut out the pauses, make it vertical, and add bold yellow captions.

Claude follows the workflow in `CLAUDE.md`. You can also run the scripts yourself:

| Script | What it does |
|--------|--------------|
| `scripts/download.sh <url>` | Downloads a video to `input/` as MP4 |
| `scripts/cut.sh <in> <start> <end> <out>` | Cuts a clip at exact frames |
| `scripts/concat.sh <out> <clip1> <clip2> ...` | Joins clips, even if their sizes and frame rates differ |
| `scripts/vertical.sh <in> <out> [crop\|blur]` | Reframes to 9:16 (1080x1920) |
| `scripts/captions.sh <in> <subs.srt> <out>` | Burns in simple captions |
| `scripts/overlay.sh <footage> <graphics> <out> [chroma]` | Lays HyperFrames graphics over footage |

Only download and reuse videos you own or have permission to use.
