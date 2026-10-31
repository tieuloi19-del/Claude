# Video editing workspace

This repo turns Claude Code into a video editor using three tools:

| Tool | Job | How it's used here |
|------|-----|--------------------|
| **FFmpeg** | Cuts and mixes video | `scripts/cut.sh`, `concat.sh`, `vertical.sh`, `overlay.sh`, `captions.sh` |
| **HyperFrames** | Captions and motion graphics written as HTML | `npx hyperframes ...` inside `graphics/` |
| **yt-dlp** | Downloads source videos (Reels, TikTok, YouTube) | `scripts/download.sh` |

Run `scripts/setup.sh` once to install or verify all three.

## Folders
- `input/`: source footage (git-ignored)
- `output/`: finished renders (git-ignored)
- `graphics/`: HyperFrames projects for captions and titles (create with `npx hyperframes init graphics/<name>`)

## Workflow to follow when the user asks for an edit
1. **Get the footage.** URL → `scripts/download.sh <url>`. Local file → copy it into `input/`.
   Only download content the user owns or has rights to reuse.
2. **Inspect it** with `ffprobe -v error -show_entries format=duration:stream=width,height,r_frame_rate -of json <file>`.
   To pick cut points, pull frames (`ffmpeg -ss <t> -i <file> -frames:v 1 /tmp/f.png`) and look at them,
   and find silences with `ffmpeg -i <file> -af silencedetect=n=-35dB:d=0.4 -f null - 2>&1 | grep silence`.
3. **Cut and assemble** with `scripts/cut.sh` then `scripts/concat.sh` (it normalizes mixed sizes and frame rates).
4. **Reframe for social** with `scripts/vertical.sh <in> <out> [crop|blur]` (1080x1920).
5. **Captions and graphics:**
   - Fast path: write an `.srt` and run `scripts/captions.sh`.
   - Styled path: build a HyperFrames composition in `graphics/<name>/index.html` (1080x1920, same length as
     the edit), run `npx hyperframes lint` and then `npx hyperframes render -o ../../output/<name>.mp4`.
     Render on a pure `#00ff00` background and composite with `scripts/overlay.sh <footage> <graphics> <out> chroma`,
     or put the footage itself in the composition as a `<video>` and render the final video directly.
6. **Check the result** before reporting it: run ffprobe on the output and look at a few extracted frames.
   Write all finals to `output/`.

## Conventions
- Encode H.264 + AAC with `-movflags +faststart` (all scripts do this already).
- Never overwrite files in `input/`; write intermediates to `/tmp` or `output/`.
- Don't commit media files; `.gitignore` already blocks them.
