#!/bin/bash

: ${INRES:="1280x580"}
: ${INOFFSET:="0,140"}
: ${FPS:="15"}
: ${GOP:="30"}  # double fps

: ${OUTRES:="1280x720"}
: ${QUALITY:="ultrafast"}
: ${CBR:="2000k"}

#AO_FREQ="44100"
#AO_BITS="128k"

: ${BUFFER:="4000k"}
: ${THREADS:="auto"}

: ${SERVER:="rtmp://live.twitch.tv/app/"}

ffmpeg \
-an \
-f x11grab -video_size "$INRES" -r "$FPS" -i :0.0+$INOFFSET \
-vcodec libx264 -s "$OUTRES" -preset $QUALITY -tune film -b:v "$CBR" -minrate $CBR -maxrate $CBR -pix_fmt yuv420p -g $GOP \
-f flv "$SERVER$SERVER_KEY" -threads $THREADS -strict normal -bufsize "$BUFFER"
