#!/bin/bash

if test "$#" -ne 2; then
	echo -e "Usage:   "$0 url outFile.ext
	echo -e "Example: "$0 https://v.redd.it/2t8144z848n31 \~/Downloads/meme.mkv
	echo -e "Example: "$0 https://old.reddit.com/r/funny/comments/d5hk1h/when_the_goal_scores_you/ out.mp4
	exit 0
fi

URL=$1
if [ $(echo $1 | grep 'v.redd.it' | wc -l) = "1" ]; then
	URL=$(curl "$1" -s -L -I -o /dev/null -w '%{url_effective}')
	echo -e "Base URL: "$1
	echo -e "Becomes:  "$URL
fi

UA="Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:69.0) Gecko/20100101 Firefox/69.0"
LOG=$(curl -A "$UA" $URL.json -s --output -)
VID=$(echo $LOG | awk -F 'fallback_url' '{print $2}' | cut -d \" -f 3 | cut -d ? -f 1)
AUD=$(echo $VID | cut -d \/ -f 1-4)/audio

wget -q "$VID" -O vid.webm
wget -q "$AUD" -O aud.mp3
ffmpeg -nostats -loglevel 0 -i vid.webm -i aud.mp3 -c copy $2
if [ ! -f "$2" ]; then ffmpeg -nostats -loglevel 0 -i vid.webm -c copy $2; fi

rm vid.webm
rm aud.mp3

echo -e "\033[92mSaved" $2
