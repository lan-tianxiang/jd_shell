#!/bin/sh
#
# Copyright (C) 2021 Patrick⭐
#
# This is free software, licensed under the GNU General Public License v3.
# See /LICENSE for more information.
#
DockerImage="lan-tianxiang/jd_shell:v3"
WorkDir="${ShellDir}/jd-docker-workdir"
ShellName=$0

GetImageType="Local"
HasImage=false
NewImage=true


log() {
    echo -e "\e[32m$1 \e[0m"
}

inp() {
    echo -e "\e[33m$1 \e[0m"
}

warn() {
    echo -e "\e[31m$1 \e[0m"
}


# 检测镜像是否存在
Check_Image() {
    if [ ! -z "$(docker images -q $DockerImage 2> /dev/null)" ]; then
        HasImage=true
        inp "检测到先前已经存在的镜像，是否创建新的镜像：\n1) 是[默认]\n2) 不需要"
        echo -n -e "\e[33m输入您的选择->\e[0m"
        read update
        if [ "$update" = "2" ]; then
            NewImage=false
        fi
    fi
}
Check_Image

Choose_GetImageType() {
    inp "\n选择镜像获取方式：\n1) 本地生成[推荐]\n2) 在线获取"
    echo -n -e "\e[33m输入您的选择->\e[0m"
    read update
    if [ "$update" = "2" ]; then
        GetImageType="Online"
    fi
}
Choose_GetImageType

if [ $NewImage = true ]; then
    log "\n正在获取新镜像..."
    if [ $HasImage = true ]; then
        docker image rm -f $DockerImage
    fi
    if [ $GetImageType = "Local" ]; then
        rm -fr $WorkDir
        mkdir -p $WorkDir
        wget -q https://github.com/lan-tianxiang/jd_shell/raw/v3/docker/Dockerfile -O $WorkDir/Dockerfile
        docker build -t $DockerImage $WorkDir > $LogDir/NewImage.log
        rm -fr $WorkDir
    else
        docker pull $DockerImage
    fi
fi

exit 0
