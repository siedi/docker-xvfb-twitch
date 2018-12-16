FROM debian:stretch

RUN echo 'deb http://deb.debian.org/debian stretch-backports main' > /etc/apt/sources.list.d/backports.list

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get -qq update \
  &&apt-get install -y gnupg2 \
    x11vnc \
    xvfb \
    fluxbox \
    wget \
    curl \
    wmctrl \
    dbus-x11 \
    gconf-service \
    libasound2 \
    libatk1.0-0 \
    libc6 \
    libcairo2 \
    libcups2 \
    libdbus-1-3 \
    libexpat1 \
    libfontconfig1 \
    libgcc1 \
    libgconf-2-4 \
    libgdk-pixbuf2.0-0 \
    libglib2.0-0 \
    libgtk-3-0 \
    libnspr4 \
    libpango-1.0-0 \
    libpangocairo-1.0-0 \
    libstdc++6 \
    libx11-6 \
    libx11-xcb1 \
    libxcb1 \
    libxcomposite1 \
    libxcursor1 \
    libxdamage1 \
    libxext6 \
    libxfixes3 \
    libxi6 \
    libxrandr2 \
    libxrender1 \
    libxss1 \
    libxtst6 \
    fonts-ipafont-gothic \
    fonts-wqy-zenhei \
    fonts-thai-tlwg \
    fonts-kacst \
    ttf-freefont \
    ca-certificates \
    fonts-liberation \
    libappindicator1 \
    libnss3 \
    lsb-release \
    xdg-utils \
    pulseaudio \
    ffmpeg

RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list

RUN apt-get -qq update \ 
  && apt-get -y install google-chrome-stable \
  && rm -rf /var/lib/apt/lists/* \
  && apt-get purge --auto-remove -y curl

ENV LANG="C.UTF-8"

RUN useradd -m -G pulse-access chrome \
  && usermod -s /bin/bash chrome \
  && mkdir -p /home/chrome/.fluxbox \
  && echo ' \n\
    #session.screen0.toolbar.visible:        false\n\
    #session.screen0.fullMaximization:       true\n\
    #session.screen0.maxDisableResize:       true\n\
    #session.screen0.maxDisableMove: true\n\
    #session.screen0.defaultDeco:    NONE\n\
  ' >> /home/chrome/.fluxbox/init \
  && chown -R chrome:chrome /home/chrome/.fluxbox

RUN rm /etc/machine-id && ln -s /var/lib/dbus/machine-id /etc/machine-id
RUN echo "DBUS_SESSION_BUS_ADDRESS=/dev/null" >> /etc/environment
ENV DBUS_SESSION_BUS_ADDRESS=/dev/null

COPY bootstrap.sh /
COPY twitch_streamer.sh /

EXPOSE 5900

CMD '/bootstrap.sh'
