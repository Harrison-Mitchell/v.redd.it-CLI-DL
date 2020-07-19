# It broke
Reddit pulled the plug on my method, install youtube-dl and use that instead:

`youtube-dl https://v.redd.it/2t8144z848n31 --output out.mp4`

---

# v.redd.it CLI DL
Downloads reddit videos, combines the separate audio and video files and spits out a single video file.

### Dependencies
* [Linux](https://stallman-copypasta.github.io/)
* FFMPEG (`sudo apt install ffmpeg` or equivilant)

### Installation
`wget https://raw.githubusercontent.com/Harrison-Mitchell/v.redd.it-CLI-DL/master/rvdl.sh -O /usr/local/bin && chmod +x /usr/local/bin/rvdl.sh`

### Usage
`harrison> rvdl.sh -h`
```
Usage:   rvdl.sh url outFile.ext
Example: rvdl.sh https://v.redd.it/2t8144z848n31 ~/meme.mkv
Example: rvdl.sh https://old.reddit.com/r/funny/comments/d5hk1h/when_the_goal_scores_you/ out.mp4
```
