FROM node:lts-alpine
LABEL maintainer="LanTianXiang <evinedeng@foxmail.com>"
ARG JD_BASE_URL=https://gitee.com/highdimen/jd_shell
ARG JD_BASE_BRANCH=v3
ARG JD_SCRIPTS_URL=https://github.com/demo2099/jd_jscripts
ARG JD_SCRIPTS_BRANCH=master
ARG JD_SCRIPTS2_URL=
ARG JD_SCRIPTS2_BRANCH=master
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
    LANG=zh_CN.UTF-8 \
    SHELL=/bin/bash \
    PS1="\u@\h:\w \$ " \
    JD_DIR=/root/jd \
    ENABLE_HANGUP=true \
    ENABLE_WEB_PANEL=true
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
    && apk update -f \
    && apk upgrade \
    && apk --no-cache add -f bash \
                             coreutils \
                             moreutils \
                             git \
                             wget \
                             curl \
                             nano \
                             tzdata \
                             perl \
                             openssl \
    && rm -rf /var/cache/apk/* \
    && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone \
    && git clone -b ${JD_BASE_BRANCH} ${JD_BASE_URL} ${JD_DIR} \
    && cd ${JD_DIR}/panel \
    && npm install \
    && git clone -b ${JD_SCRIPTS_BRANCH} ${JD_SCRIPTS_URL} ${JD_DIR}/scripts \
    && cd ${JD_DIR}/scripts \
    && npm install \
    && npm install -g pm2 \
    && git clone -b ${JD_SCRIPTS2_BRANCH} ${JD_SCRIPTS2_URL} ${JD_DIR}/scripts2 \
    && rm -rf /root/.npm
WORKDIR ${JD_DIR}
ENTRYPOINT bash ${JD_DIR}/docker/docker-entrypoint.sh
