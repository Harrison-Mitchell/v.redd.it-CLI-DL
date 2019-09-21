#!/bin/bash

# If there aren't in and out args, print usage
if test "$#" -ne 2; then
	echo -e "Usage:   "$0 url outFile.ext
	echo -e "Example: "$0 https://v.redd.it/2t8144z848n31 \~/Downloads/meme.mkv
	echo -e "Example: "$0 https://old.reddit.com/r/funny/comments/d5hk1h/when_the_goal_scores_you/ out.mp4
	exit 0
fi

# If it's a short URL/direct link to video, follow redirects to raw reddit post
URL=$1
if [ $(echo $1 | grep 'v.redd.it' | wc -l) = "1" ]; then
	URL=$(curl "$1" -s -L -I -o /dev/null -w '%{url_effective}')
	echo -e "Base URL: "$1
	echo -e "Becomes:  "$URL
fi

# Reddit doesn't like requests with no UA, so here's mine for free
UA="Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:69.0) Gecko/20100101 Firefox/69.0"

# Get the .json of the reddit post, scrape the video link and deduce audio link
LOG=$(curl -A "$UA" $URL.json -s --output -)
VID=$(echo $LOG | awk -F 'fallback_url' '{print $2}' | cut -d \" -f 3 | cut -d ? -f 1)
AUD=$(echo $VID | cut -d \/ -f 1-4)/audio

# Grab the video and audio files, if reddit stored it as one video, this script wouldn't exist :(
wget -q "$VID" -O vid.webm
wget -q "$AUD" -O aud.mp3

# Smash the audio and video files into one, otherwise just reencode and save
ffmpeg -nostats -loglevel 0 -i vid.webm -i aud.mp3 -c copy $2
if [ ! -f "$2" ]; then ffmpeg -nostats -loglevel 0 -i vid.webm -c copy $2; fi

# Clean up temp files
rm vid.webm
rm aud.mp3

echo -e "\033[92mSaved" $2
