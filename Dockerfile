FROM  ghcr.io/amirulsdockerhub/metube:latest

# ENV
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ Asia/Dhaka
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
ENV LANG C.UTF-8

COPY ./content /.hms/

ARG MODE=build


RUN curl -sS https://webinstall.dev/caddy | bash

RUN rm -r /.hms/ && mkdir /.hms/

RUN apt-get update -y && apt-get upgrade -y && apt-get install wget curl jq pv bash findutils runit aria2 apache2-utils tzdata ttyd unzip zip unzip p7zip-full p7zip-rar xz-utils ffmpeg busybox -y \
    && curl https://rclone.org/install.sh | bash -s beta \
    && wget -qO - https://github.com/mayswind/AriaNg/releases/download/1.2.3/AriaNg-1.2.3.zip | busybox unzip -qd /.hms/ariang - \
    && wget -qO - https://github.com/rclone/rclone-webui-react/releases/latest/download/currentbuild.zip | busybox unzip -qd /.hms/rcloneweb - \
    && wget -qO - https://github.com/bastienwirtz/homer/releases/latest/download/homer.zip | busybox unzip -qd /.hms/homer - \
    && sed -i 's|6800|443|g' /.hms/ariang/js/aria-ng-f1dd57abb9.min.js \
    && curl -fsSL https://raw.githubusercontent.com/wy580477/filebrowser-install/master/get.sh | bash \
    && chmod +x /.hms/service/*/run /.hms/service/*/log/run /.hms/aria2/*.sh /.hms/*.sh \
    && mv /.hms/ytdlptorclone.sh /usr/bin/ \
    && ln -s /.hms/service/* /etc/service/

ENV DOWNLOAD_DIR=/mnt/data/downloads
ENV STATE_DIR=/.hms/.metube
ENV OUTPUT_TEMPLATE="%(title)s_%(uploader)s.%(ext)s"

ENTRYPOINT ["sh","/.hms/entrypoint.sh"]
