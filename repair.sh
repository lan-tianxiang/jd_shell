#!/usr/bin/env bash

## Author: lan-tianxiang
## Source: https://github.com/lan-tianxiang/jd_shell
## Modified： 2021-03-27
## Version： v0.0.2

## 文件路径、脚本网址、文件版本以及各种环境的判断
ShellDir=${JD_DIR:-$(
  cd $(dirname $0)
  pwd
)}
[[ ${JD_DIR} ]] && ShellJd=jd || ShellJd=${ShellDir}/jd.sh
LogDir=${ShellDir}/log
[ ! -d ${LogDir} ] && mkdir -p ${LogDir}
ScriptsDir=${ShellDir}/scripts
Scripts2Dir=${ShellDir}/scripts2
ConfigDir=${ShellDir}/config
FileConf=${ConfigDir}/config.sh
FileDiy=${ConfigDir}/diy.sh
FileConfSample=${ShellDir}/sample/config.sh.sample
ListCron=${ConfigDir}/crontab.list
ListCronLxk=${ScriptsDir}/docker/crontab_list.sh
ListCronShylocks=${Scripts2Dir}/docker/crontab_list.sh
ListTask=${LogDir}/task.list
ListJs=${LogDir}/js.list
ListJsAdd=${LogDir}/js-add.list
ListJsDrop=${LogDir}/js-drop.list
ContentVersion=${ShellDir}/version
ContentNewTask=${ShellDir}/new_task
ContentDropTask=${ShellDir}/drop_task
SendCount=${ShellDir}/send_count
isTermux=${ANDROID_RUNTIME_ROOT}${ANDROID_ROOT}
WhichDep=$(grep "/jd_shell" "${ShellDir}/.git/config")
Scripts2URL=https://gitee.com/tianxiang-lan/jd_scripts

cp ${FileConf} $(dirname ${ShellDir})/config.sh
pkill -9 node
bash ${ShellDir}/jd.sh paneloff
rm -rf ${ShellDir}
cd $(dirname ${ShellDir})

ShellDir_t=$(
  cd "$(dirname "$0")"
  pwd
)
ShellName_t=$0
JdDir_t=${ShellDir_t}/jd

function REINSTALLATION() {
  echo -e "\n1. 获取源码"
  [ -d ${JdDir_t} ] && mv ${JdDir_t} ${JdDir_t}.bak && echo "检测到已有 ${JdDir_t} 目录，已备份为 ${JdDir_t}.bak"
  git clone -b v3 https://gitee.com/tianxiang-lan/jd_shell ${JdDir_t}

  echo -e "\n2. 检查配置文件"

  [ ! -d ${JdDir_t}/config ] && mkdir -p ${JdDir_t}/config

  if [ ! -s ${JdDir_t}/config/crontab.list ]; then
    cp -fv ${JdDir_t}/sample/crontab.list.sample ${JdDir_t}/config/crontab.list
    sed -i "s,MY_PATH,${JdDir_t},g" ${JdDir_t}/config/crontab.list
    sed -i "s,ENV_PATH=,PATH=$PATH,g" ${JdDir_t}/config/crontab.list
  fi

  crontab ${JdDir_t}/config/crontab.list

  [ -f $(dirname ${ShellDir})/config.sh ] && cp $(dirname ${ShellDir})/config.sh ${ConfigDir}/config.sh && rm -rf $(dirname ${ShellDir})/config.sh
  [ ! -s ${JdDir_t}/config/config.sh ] && cp -fv ${JdDir_t}/sample/config.sh.sample ${JdDir_t}/config/config.sh

  echo -e "\n3. 执行 git_pull.sh 进行脚本更新以及定时文件更新"
  bash ${JdDir_t}/git_pull.sh

  echo -e "\n修复完成！！！！"
}

REINSTALLATION
