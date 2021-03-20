#!/bin/sh
clear
echo -e "\e[开始部署jd_shell\n\e[0m"

ShellDir=$(cd "$(dirname "$0")";pwd)
ShellName=$0
JdDir=${ShellDir}/jd

echo -e "\e[33m注意：运行本脚本前必须手动安装好如下依赖：\ngit wget curl perl moreutils node.js npm\n\n按任意键继续，否则按 Ctrl + C 退出！\e[0m"
read

if [ ! -x "$(command -v node)" ] || [ ! -x "$(command -v npm)" ] || [ ! -x "$(command -v git)" ] || [ ! -x "$(command -v curl)" ] || [ ! -x "$(command -v wget)" ] || [ ! -x "$(command -v perl)" ]; then
  echo -e "\e[31m依赖未安装完整！\e[0m"
  exit 1
fi

echo -e "\n\e[32m1. 获取源码\e[0m"
[ -d ${JdDir} ] && mv ${JdDir} ${JdDir}.bak && echo "检测到已有 ${JdDir} 目录，已备份为 ${JdDir}.bak"
git clone -b v3 https://github.com/lan-tianxiang/jd_shell ${JdDir}

echo -e "\n\e[32m2.2 检查配置文件\e[0m"
[ ! -d ${JdDir}/config ] && mkdir -p ${JdDir}/config

if [ ! -s ${JdDir}/config/crontab.list ]
then
  cp -fv ${JdDir}/sample/crontab.list.sample ${JdDir}/config/crontab.list
  sed -i "s,MY_PATH,${JdDir},g" ${JdDir}/config/crontab.list
  sed -i "s,ENV_PATH=,PATH=$PATH,g" ${JdDir}/config/crontab.list
fi
crontab -l > ${JdDir}/old_crontab
crontab ${JdDir}/config/crontab.list

[ ! -s ${JdDir}/config/config.sh ] && cp -fv ${JdDir}/sample/config.sh.sample ${JdDir}/config/config.sh

echo -e "\n\e[32m3. 执行 git_pull.sh 进行脚本更新以及定时文件更新\e[0m"
bash ${JdDir}/git_pull.sh

echo -e "\e[33m注意：原有定时任务已备份在 ${JdDir}/old_crontab \e[0m"
rm -f ${ShellDir}/${ShellName}
