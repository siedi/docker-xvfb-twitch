# Twitch VPS Streamer

Docker image to run Chrome on a linux VPS and stream it on Twitch

## Disclaimer

Code is partly based on [https://github.com/stephen-fox/chrome-docker](https://github.com/stephen-fox/chrome-docker) and other forks of it.

## Features

Runs `xvfb` with the window manager `fluxbox`, `vnc`so you can connect from remote and then `chrome`. It includes a separate script to start the stream on Twitch by launching `ffmpeg`. You can even include an external radio stream as audio source.

## Build image

Just as every other image: `docker build . -t twitch-streamer`

## Launch Container

```
docker run -p 127.0.0.1:5900:5900 --rm -v /etc/localtime:/etc/localtime:ro -v /dev/shm/:/dev/shm/ -e TZ=Europe/Berlin -e VNC_SERVER_PASSWORD=<password> -e SERVER_KEY=<your streaming key from twitch> --user chrome --name twitch-streamer --privileged twitch-streamer
```

**Note**: The MacOS VNC client will not be able to login unless you set a password for the VNC server.

Once the container is running, you can VNC into it at `127.0.0.1` (if you are running the container on a VPS, you might have to start a ssh tunnel first `ssh -L 5900:localhost:5900 my_vps`)

Launch Chrome from a terminal window by running.

```
google-chrome
```

You can also start Google Chrome by right-clicking the Desktop and selecting:
```
Applications > Network > Web Browsing > Google Chrome
```

## Launch stream

Once everything is set up, you can launch the stream
`docker exec -ti twitch-streamer bash /twitch_streamer.sh`

If you want to stop it, just press `CTRL-C`

## Security concerns
This image starts a X11 VNC server which spawns a framebuffer. Google Chrome
also requires that the image be run with the `--privileged` flag set. This flag
disables security labeling for the resulting container. Be very careful if you
run the container on a non-firewalled host.

Some applications (such as Google Chrome) will not run under the root user. A
non-root user named `chrome` is included for such scenarios.

