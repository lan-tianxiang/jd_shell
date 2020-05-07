#!/usr/bin/env bash

## Author: lan-tianxiang
## Source: https://github.com/lan-tianxiang/jd_shell
## Modified： 2021-03-29
## Version： v3.6.3

## 文件路径、脚本网址、文件版本以及各种环境的判断
ShellDir=${JD_DIR:-$(
  cd $(dirname $0)
  pwd
)}
[[ ${JD_DIR} ]] && ShellJd=${ShellDir}/jd.sh || ShellJd=${ShellDir}/jd.sh
LogDir=${ShellDir}/log
[ ! -d ${LogDir} ] && mkdir -p ${LogDir}
ScriptsDir=${ShellDir}/scripts
Scripts2Dir=${ShellDir}/.scripts2
oldScripts2Dir=${ShellDir}/scripts2
ConfigDir=${ShellDir}/config
FileConf=${ConfigDir}/config.sh
FileConftemp=${ConfigDir}/config.sh.temp
FileDiy=${ConfigDir}/diy.sh
FileDiySample=${ShellDir}/sample/diy.sh
FileConfSample=${ShellDir}/sample/config.sh.sample
ListCron=${ConfigDir}/crontab.list
FileListCronSample=${ShellDir}/sample/crontab.list.sample
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
Scripts2URL=https://gitee.com/highdimen/jd_scripts
PanelDir=${ShellDir}/panel
panelpwd=${ConfigDir}/auth.json
panelpwdSample=${ShellDir}/sample/auth.json

if [[ ${WhichDep} == *github* ]]; then
  ScriptsURL=https://gitee.com/highdimen/clone_scripts
  ShellURL=https://gitee.com/highdimen/jd_shell
else
  ScriptsURL=https://gitee.com/highdimen/clone_scripts
  ShellURL=https://gitee.com/highdimen/jd_shell
fi

function SourceUrl_Update {
  if [ -s ${ScriptsDir}/.git/config ]; then
    strAttttt=$(grep "url" ${ScriptsDir}/.git/config)
    strBttttt="highdimen"
    if [[ $strAttttt =~ $strBttttt ]]; then
      echo "1"
    else
      rm -rf ${ScriptsDir}
    fi
  fi

  if [ -s ${Scripts2Dir}/.git/config ]; then
    strAttttt=$(grep "url" ${Scripts2Dir}/.git/config)
    strBttttt="highdimen"
    if [[ $strAttttt =~ $strBttttt ]]; then
      echo "1"
    else
      rm -rf ${ScriptsDir}
    fi
  fi

  strAttttt=$(grep "url" ${ShellDir}/.git/config)
  strBttttt="highdimen"
  if [[ $strAttttt =~ $strBttttt ]]; then
    echo "3"
  else
    perl -i -pe "s|url \= https\:\/\/github.com\/lan-tianxiang\/jd_shell|url \= https\:\/\/gitee.com\/highdimen\/jd_shell|g" ${ShellDir}/.git/config
    perl -i -pe "s|url \= https\:\/\/gitee.com\/tianxiang-lan\/jd_shell|url \= https\:\/\/gitee.com\/highdimen\/jd_shell|g" ${ShellDir}/.git/config
    perl -i -pe "s|url \= http\:\/\/github.com\/lan-tianxiang\/jd_shell|url \= https\:\/\/gitee.com\/highdimen\/jd_shell|g" ${ShellDir}/.git/config
    perl -i -pe "s|url \= http\:\/\/gitee.com\/tianxiang-lan\/jd_shell|url \= https\:\/\/gitee.com\/highdimen\/jd_shell|g" ${ShellDir}/.git/config
  #  sed -i "s/url \= https\:\/\/github.com\/lan-tianxiang\/jd_shell/url \= https\:\/\/gitee.com\/highdimen\/jd_shell/g" ${ShellDir}/.git/config
  #  sed -i "s/url \= https\:\/\/gitee.com\/tianxiang-lan\/jd_shell/url \= https\:\/\/gitee.com\/highdimen\/jd_shell/g" ${ShellDir}/.git/config
  fi
}

fix_config() {
  #crontab -r
  #rm -rf ${ListCron}
  #cp -f $FileListCronSample $ListCron
  perl -i -pe "{
      s|.+(jd(\.sh)? jd_zoo)|0 \*\/2 \* \* \* \1|g;
      s|.+(jd(\.sh)? jd_zooCollect)|20,40 \* \* \* \* \1|g;
    }" ${ListCron}
  crontab ${ListCron}
}

fix_files() {
  [ ! -d ${ShellDir}/config ] && mkdir -p ${ShellDir}/config
  [ -d $oldScripts2Dir ] && rm -rf $oldScripts2Dir
  [ ! -f $FileConf ] && cp -f $FileConfSample $FileConf
  [ ! -f $ListCron ] && cp -f $FileListCronSample $ListCron
  [ ! -f $FileDiy ] && cp -f $FileDiySample $FileDiy
}

## 更新crontab，gitee服务器同一时间限制5个链接，因此每个人更新代码必须错开时间，每次执行git_pull随机生成。
## 每天次数随机，更新时间随机，更新秒数随机，至少6次，至多12次，大部分为8-10次，符合正态分布。
function Update_Cron() {
  if [ -f ${ListCron} ]; then
    local random_min=$((${RANDOM} % 60))
    local random_sleep=$((${RANDOM} % 100))
    local random_hour_array[0]=$((${RANDOM} % 3))
    local random_hour=${random_hour_array[0]}
    local i j tmp

    for ((i = 1; i < 14; i++)); do
      j=$(($i - 1))
      tmp=$(($((${RANDOM} % 3)) + ${random_hour_array[j]} + 4))
      [[ $tmp -lt 24 ]] && random_hour_array[i]=$tmp || break
    done

    for ((i = 1; i < ${#random_hour_array[*]}; i++)); do
      random_hour="$random_hour,${random_hour_array[i]}"
    done
    perl -i -pe "s|.+(bash.+git_pull.+log.*)|22,44 \* \* \* \* sleep ${random_sleep} && \1|" ${ListCron}
    crontab ${ListCron}
  fi
}

## 更新shell脚本
function Git_PullShell {
  echo -e "更新shell脚本，原地址：${ShellURL}\n"
  cd ${ShellDir}
  git fetch --all
  ExitStatusShell=$?
  git reset --hard origin/v3
}

## 克隆scripts
function Git_CloneScripts {
  echo -e "克隆LXK9301脚本，原地址：${ScriptsURL}\n"
  git clone -b master ${ScriptsURL} ${ScriptsDir}
  ExitStatusScripts=$?
  echo
}

## 更新scripts
function Git_PullScripts {
  echo -e "更新LXK9301脚本，原地址：${ScriptsURL}\n"
  cd ${ScriptsDir}
  git fetch --all
  ExitStatusScripts=$?
  git reset --hard origin/master
  echo
}

## 克隆scripts2
function Git_CloneScripts2 {
  git clone -b master ${Scripts2URL} ${Scripts2Dir} >/dev/null 2>&1
  ExitStatusScripts2=$?
}

## 更新scripts2
function Git_PullScripts2 {
  cd ${Scripts2Dir}
  git fetch --all >/dev/null 2>&1
  ExitStatusScripts2=$?
  git reset --hard origin/master >/dev/null 2>&1
}

## 用户数量UserSum
function Count_UserSum {
  i=1
  while [ $i -le 1000 ]; do
    Tmp=Cookie$i
    CookieTmp=${!Tmp}
    [[ ${CookieTmp} ]] && UserSum=$i || break
    let i++
  done
}

## 把config.sh中提供的所有账户的PIN附加在jd_joy_run.js中，让各账户相互进行宠汪汪赛跑助力
## 你的账号将按Cookie顺序被优先助力，助力完成再助力我的账号和lxk0301大佬的账号
function Change_JoyRunPins {
  j=${UserSum}
  PinALL=""
  while [[ $j -ge 1 ]]; do
    Tmp=Cookie$j
    CookieTemp=${!Tmp}
    PinTemp=$(echo ${CookieTemp} | perl -pe "{s|.*pt_pin=(.+);|\1|; s|%|\\\x|g}")
    PinTempFormat=$(printf ${PinTemp})
    PinALL="${PinTempFormat},${PinALL}"
    let j--
  done
  PinEvine="jd_620b506d07889,"
  PinALL="${PinALL}${PinEvine}"
  perl -i -pe "{s|(let invite_pins = \[\")(.+\"\];?)|\1${PinALL}\2|; s|(let run_pins = \[\")(.+\"\];?)|\1${PinALL}\2|}" ${ScriptsDir}/jd_joy_run.js
}

## 修改lxk0301大佬js文件的函数汇总
function Change_ALL {
  if [ -f ${FileConf} ]; then
    . ${FileConf}
    if [ -n "${Cookie1}" ]; then
      Count_UserSum
      Change_JoyRunPins
    fi
  fi
}

## 检测文件：LXK9301/jd_scripts 仓库中的 docker/crontab_list.sh，和 shylocks/Loon 仓库中的 docker/crontab_list.sh
## 检测定时任务是否有变化，此函数会在Log文件夹下生成四个文件，分别为：
## task.list    crontab.list中的所有任务清单，仅保留脚本名
## js.list      上述检测文件中用来运行js脚本的清单（去掉后缀.js，非运行脚本的不会包括在内）
## js-add.list  如果上述检测文件增加了定时任务，这个文件内容将不为空
## js-drop.list 如果上述检测文件删除了定时任务，这个文件内容将不为空
function Diff_Cron {
  if [ -f ${ListCron} ]; then
    if [ -n "${JD_DIR}" ]; then
      grep -E " j[drx]_\w+" ${ListCron} | perl -pe "s|.+ (j[drx]_\w+).*|\1|" | uniq | sort >${ListTask}
    else
      grep "${ShellDir}/" ${ListCron} | grep -E " j[drx]_\w+" | perl -pe "s|.+ (j[drx]_\w+).*|\1|" | uniq | sort >${ListTask}
    fi
    cat ${ListCronLxk} ${ListCronShylocks} | grep -E "j[drx]_\w+\.js" | perl -pe "s|.+(j[drx]_\w+)\.js.+|\1|" | sort >${ListJs}
    grep -vwf ${ListTask} ${ListJs} >${ListJsAdd}
    grep -vwf ${ListJs} ${ListTask} >${ListJsDrop}
  else
    echo -e "${ListCron} 文件不存在，请先定义你自己的crontab.list...\n"
  fi
}

## 发送删除失效定时任务的消息
function Notify_DropTask {
  cd ${ShellDir}
  node update.js
  [ -f ${ContentDropTask} ] && rm -f ${ContentDropTask}
}

## 发送新的定时任务消息
function Notify_NewTask {
  cd ${ShellDir}
  node update.js
  [ -f ${ContentNewTask} ] && rm -f ${ContentNewTask}
}

## 检测配置文件版本
function Notify_Version {
  ## 识别出两个文件的版本号
  VerConfSample=$(grep " Version: " ${FileConfSample} | perl -pe "s|.+v((\d+\.?){3})|\1|")
  [ -f ${FileConf} ] && VerConf=$(grep " Version: " ${FileConf} | perl -pe "s|.+v((\d+\.?){3})|\1|")

  ## 删除旧的发送记录文件
  [ -f "${SendCount}" ] && [[ $(cat ${SendCount}) != ${VerConfSample} ]] && rm -f ${SendCount}

  ## 识别出更新日期和更新内容
  UpdateDate=$(grep " Date: " ${FileConfSample} | awk -F ": " '{print $2}')
  UpdateContent=$(grep " Update Content: " ${FileConfSample} | awk -F ": " '{print $2}')

  ## 如果是今天，并且版本号不一致，则发送通知
  if [ -f ${FileConf} ] && [[ "${VerConf}" != "${VerConfSample}" ]] && [[ ${UpdateDate} == $(date "+%Y-%m-%d") ]]; then
    if [ ! -f ${SendCount} ]; then
      echo -e "日期: ${UpdateDate}\n版本: ${VerConf} -> ${VerConfSample}\n内容: ${UpdateContent}\n\n" | tee ${ContentVersion}
      echo -e "如需更新请手动操作，仅更新当天通知一次!" >>${ContentVersion}
      cd ${ShellDir}
      node update.js
      if [ $? -eq 0 ]; then
        echo "${VerConfSample}" >${SendCount}
        [ -f ${ContentVersion} ] && rm -f ${ContentVersion}
      fi
    fi
  else
    [ -f ${ContentVersion} ] && rm -f ${ContentVersion}
    [ -f ${SendCount} ] && rm -f ${SendCount}
  fi
}

## npm install 子程序，判断是否为安卓，判断是否安装有yarn
function Npm_InstallSub {
  if [ -n "${isTermux}" ]; then
    npm install --no-bin-links || npm install --no-bin-links --registry=https://registry.npm.taobao.org
  elif ! type yarn >/dev/null 2>&1; then
    npm install || npm install --registry=https://registry.npm.taobao.org
  else
    echo -e "检测到本机安装了 yarn，使用 yarn 替代 npm...\n"
    yarn install || yarn install --registry=https://registry.npm.taobao.org
  fi
}

## npm install
function Npm_Install {
  cd ${ScriptsDir}
  if [[ "${PackageListOld}" != "$(cat package.json)" ]]; then
    echo -e "检测到package.json有变化，运行 npm install...\n"
    Npm_InstallSub
    if [ $? -ne 0 ]; then
      echo -e "\nnpm install 运行不成功，自动删除 ${ScriptsDir}/node_modules 后再次尝试一遍..."
      rm -rf ${ScriptsDir}/node_modules
    fi
    echo
  fi

  if [ ! -d ${ScriptsDir}/node_modules ]; then
    echo -e "运行 npm install...\n"
    Npm_InstallSub
    if [ $? -ne 0 ]; then
      echo -e "\nnpm install 运行不成功，自动删除 ${ScriptsDir}/node_modules...\n"
      echo -e "请进入 ${ScriptsDir} 目录后按照wiki教程手动运行 npm install...\n"
      echo -e "当 npm install 失败时，如果检测到有新任务或失效任务，只会输出日志，不会自动增加或删除定时任务...\n"
      echo -e "3...\n"
      sleep 1
      echo -e "2...\n"
      sleep 1
      echo -e "1...\n"
      sleep 1
      rm -rf ${ScriptsDir}/node_modules
    fi
  fi
}

## 输出是否有新的定时任务
function Output_ListJsAdd {
  if [ -s ${ListJsAdd} ]; then
    echo -e "检测到有新的定时任务：\n"
    cat ${ListJsAdd}
    echo
  fi
}

## 输出是否有失效的定时任务
function Output_ListJsDrop {
  if [ ${ExitStatusScripts} -eq 0 ] && [ -s ${ListJsDrop} ]; then
    echo -e "检测到有失效的定时任务：\n"
    cat ${ListJsDrop}
    echo
  fi
}

## 自动删除失效的脚本与定时任务，需要5个条件：1.AutoDelCron 设置为 true；2.正常更新js脚本，没有报错；3.js-drop.list不为空；4.crontab.list存在并且不为空；5.已经正常运行过npm install
## 检测文件：LXK9301/jd_scripts 仓库中的 docker/crontab_list.sh，和 shylocks/Loon 仓库中的 docker/crontab_list.sh
## 如果检测到某个定时任务在上述检测文件中已删除，那么在本地也删除对应定时任务
function Del_Cron {
  if [ "${AutoDelCron}" = "true" ] && [ -s ${ListJsDrop} ] && [ -s ${ListCron} ] && [ -d ${ScriptsDir}/node_modules ]; then
    echo -e "开始尝试自动删除定时任务如下：\n"
    cat ${ListJsDrop}
    echo
    JsDrop=$(cat ${ListJsDrop})
    for Cron in ${JsDrop}; do
      perl -i -ne "{print unless / ${Cron}( |$)/}" ${ListCron}
    done
    crontab ${ListCron}
    echo -e "成功删除失效的脚本与定时任务，当前的定时任务清单如下：\n\n--------------------------------------------------------------\n"
    crontab -l
    echo -e "\n--------------------------------------------------------------\n"
    if [ -d ${ScriptsDir}/node_modules ]; then
      echo -e "jd-base脚本成功删除失效的定时任务：\n\n${JsDrop}\n\n脚本地址：${ShellURL}" >${ContentDropTask}
      Notify_DropTask
    fi
  fi
}

## 自动增加新的定时任务，需要5个条件：1.AutoAddCron 设置为 true；2.正常更新js脚本，没有报错；3.js-add.list不为空；4.crontab.list存在并且不为空；5.已经正常运行过npm install
## 检测文件：LXK9301/jd_scripts 仓库中的 docker/crontab_list.sh，和 shylocks/Loon 仓库中的 docker/crontab_list.sh
## 如果检测到检测文件中增加新的定时任务，那么在本地也增加
## 本功能生效时，会自动从检测文件新增加的任务中读取时间，该时间为北京时间
function Add_Cron {
  if [ "${AutoAddCron}" = "true" ] && [ -s ${ListJsAdd} ] && [ -s ${ListCron} ] && [ -d ${ScriptsDir}/node_modules ]; then
    echo -e "开始尝试自动添加定时任务如下：\n"
    cat ${ListJsAdd}
    echo
    JsAdd=$(cat ${ListJsAdd})

    for Cron in ${JsAdd}; do
      if [[ ${Cron} == jd_bean_sign ]]; then
        echo "4 0,9 * * * bash ${ShellJd} ${Cron}" >>${ListCron}
      else
        cat ${ListCronLxk} ${ListCronShylocks} | grep -E "\/${Cron}\." | perl -pe "s|(^.+)node */scripts/(j[drx]_\w+)\.js.+|\1bash ${ShellJd} \2|" >>${ListCron}
      fi
    done

    if [ $? -eq 0 ]; then
      crontab ${ListCron}
      echo -e "成功添加新的定时任务，当前的定时任务清单如下：\n\n--------------------------------------------------------------\n"
      crontab -l
      echo -e "\n--------------------------------------------------------------\n"
      if [ -d ${ScriptsDir}/node_modules ]; then
        echo -e "jd-base脚本成功添加新的定时任务：\n\n${JsAdd}\n\n脚本地址：${ShellURL}" >${ContentNewTask}
        Notify_NewTask
      fi
    else
      echo -e "添加新的定时任务出错，请手动添加...\n"
      if [ -d ${ScriptsDir}/node_modules ]; then
        echo -e "jd-base脚本尝试自动添加以下新的定时任务出错，请手动添加：\n\n${JsAdd}" >${ContentNewTask}
        Notify_NewTask
      fi
    fi
  fi
}

## 自定义脚本功能
function ExtraShell() {
  ## 自动同步用户自定义的diy.sh
  if [[ ${EnableExtraShellUpdate} == true ]]; then
    wget -q $EnableExtraShellURL -O ${FileDiy}
    if [ $? -eq 0 ]; then
      echo -e "自定义 DIY 脚本同步完成......"
      echo -e ''
      sleep 2s
    else
      echo -e "\033[31m自定义 DIY 脚本同步失败！\033[0m"
      echo -e ''
      sleep 2s
    fi
  fi

  ## 调用用户自定义的diy.sh
  if [[ ${EnableExtraShell} == true ]]; then
    if [ -f ${FileDiy} ]; then
      . ${FileDiy}
    else
      echo -e "${FileDiy} 文件不存在，跳过执行自定义 DIY 脚本...\n"
      echo -e ''
    fi
  fi
}

## 一键执行所有活动脚本
function Run_All() {
  ## 临时删除以旧版脚本
  rm -rf ${ShellDir}/run-all.sh
  ## 默认将 "jd、jx、jr" 开头的活动脚本加入其中
  rm -rf ${ShellDir}/run_all.sh
  bash ${ShellDir}/jd.sh | grep -io 'j[drx]_[a-z].*' | grep -v 'bean_change' >${ShellDir}/run_all.sh
  sed -i "1i\jd_bean_change.js" ${ShellDir}/run_all.sh ## 置顶京豆变动通知
  sed -i "s#^#bash ${ShellDir}/jd.sh &#g" ${ShellDir}/run_all.sh
  sed -i 's#.js# now#g' ${ShellDir}/run_all.sh
  sed -i '1i\#!/bin/env bash' ${ShellDir}/run_all.sh
  ## 自定义添加脚本
  ## 例：echo "bash ${ShellDir}/jd.sh xxx now" >>${ShellDir}/run_all.sh

  ## 将挂机活动移至末尾从而最后执行
  ## 目前仅有 "疯狂的JOY" 这一个活动
  ## 模板如下 ：
  ## cat run_all.sh | grep xxx -wq
  ## if [ $? -eq 0 ];then
  ##   sed -i '/xxx/d' ${ShellDir}/run_all.sh
  ##   echo "bash jd.sh xxx now" >>${ShellDir}/run_all.sh
  ## fi
  cat ${ShellDir}/run_all.sh | grep jd_crazy_joy_coin -wq
  if [ $? -eq 0 ]; then
    sed -i '/jd_crazy_joy_coin/d' ${ShellDir}/run_all.sh
    echo "bash ${ShellDir}/jd.sh jd_crazy_joy_coin now" >>${ShellDir}/run_all.sh
  fi

  ## 去除不想加入到此脚本中的活动
  ## 例：sed -i '/xxx/d' ${ShellDir}/run_all.sh
  sed -i '/jd_delCoupon/d' ${ShellDir}/run_all.sh ## 不执行 "京东家庭号" 活动
  sed -i '/jd_family/d' ${ShellDir}/run_all.sh    ## 不执行 "删除优惠券" 活动
  sed -i '/jd_exit/d' ${ShellDir}/run_all.sh    ## 不执行 "删除优惠券" 活动

  ## 去除脚本中的空行
  sed -i '/^\s*$/d' ${ShellDir}/run_all.sh
  ## 赋权
  chmod 777 ${ShellDir}/run_all.sh
}

function panelinit {
  [ -f ${PanelDir}/package.json ] && PackageListOld=$(cat ${PanelDir}/package.json)
  cd ${PanelDir}
  if [[ "${PackageListOld}" != "$(cat package.json)" ]]; then
    echo -e "检测到package.json有变化，运行 npm install...\n"
    Npm_InstallSub
    if [ $? -ne 0 ]; then
      echo -e "\nnpm install 运行不成功，自动删除 ${ScriptsDir}/node_modules 后再次尝试一遍..."
      rm -rf ${PanelDir}/node_modules
    fi
    echo
  fi

  if [ ! -d ${PanelDir}/node_modules ]; then
    echo -e "运行 npm install...\n"
    Npm_InstallSub
    if [ $? -ne 0 ]; then
      echo -e "\nnpm install 运行不成功，自动删除 ${ScriptsDir}/node_modules...\n"
      echo -e "请进入 ${ScriptsDir} 目录后按照wiki教程手动运行 npm install...\n"
      echo -e "当 npm install 失败时，如果检测到有新任务或失效任务，只会输出日志，不会自动增加或删除定时任务...\n"
      echo -e "3...\n"
      sleep 1
      echo -e "2...\n"
      sleep 1
      echo -e "1...\n"
      sleep 1
      rm -rf ${PanelDir}/node_modules
    fi
  fi
  echo -e "控制面板检查&更新完成"
  sleep 1
  if [ ! -s ${panelpwd} ]; then
    cp -f ${panelpwdSample} ${panelpwd}
    echo -e "检测到未设置密码，用户名：admin，密码：adminadmin\n"
  fi
}

## 在日志中记录时间与路径
echo -e ''
echo -e "+----------------- 开 始 执 行 更 新 脚 本 -----------------+"
echo -e ''
echo -e "   活动脚本目录：${ScriptsDir}"
echo -e ''
echo -e "   当前系统时间：$(date "+%Y-%m-%d %H:%M")"
echo -e ''
echo -e "+-----------------------------------------------------------+"
## 检测配置文件链接
SourceUrl_Update
fix_files
## 更新shell脚本、检测配置文件版本并将sample/config.sh.sample复制到config目录下
Git_PullShell && Update_Cron
VerConfSample=$(grep " Version: " ${FileConfSample} | perl -pe "s|.+v((\d+\.?){3})|\1|")
[ -f ${FileConf} ] && VerConf=$(grep " Version: " ${FileConf} | perl -pe "s|.+v((\d+\.?){3})|\1|")
if [ ${ExitStatusShell} -eq 0 ]; then
  echo -e "\nshell脚本更新完成...\n"
  if [ -n "${JD_DIR}" ] && [ -d ${ConfigDir} ]; then
    cp -f ${FileConfSample} ${ConfigDir}/config.sh.sample
  fi
else
  echo -e "\nshell脚本更新失败，请检查原因后再次运行git_pull.sh，或等待定时任务自动再次运行git_pull.sh...\n"
fi

## 克隆或更新js脚本
if [ ${ExitStatusShell} -eq 0 ]; then
  echo -e "--------------------------------------------------------------\n"
  [ -f ${ScriptsDir}/package.json ] && PackageListOld=$(cat ${ScriptsDir}/package.json)
  [ -d ${ScriptsDir}/.git ] && Git_PullScripts || Git_CloneScripts
  #测试自写脚本
  [ -d ${Scripts2Dir}/.git ] && Git_PullScripts2 || Git_CloneScripts2
  cp -f ${Scripts2Dir}/jd_*.js ${ScriptsDir}
  [ -f ${Scripts2Dir}/ZooFaker.js ] && cp -f ${Scripts2Dir}/ZooFaker.js ${ScriptsDir}
  cp -rf ${Scripts2Dir}/sendNotify.js ${ScriptsDir}/sendNotify.js
fi

## 执行各函数
if [[ ${ExitStatusScripts} -eq 0 ]]; then
  Change_ALL
  [ -d ${ScriptsDir}/node_modules ] && Notify_Version
  Diff_Cron
  Npm_Install
  Output_ListJsAdd
  Output_ListJsDrop
  Del_Cron
  Add_Cron
  ExtraShell
  Run_All
  panelinit
  echo -e "活动脚本更新完成......\n"
else
  echo -e "\033[31m活动脚本更新失败，请检查原因或再次运行 git_pull.sh ......\033[0m"
  Change_ALL
fi

#fix_config
## 清除配置缓存
[ -f ${FileConftemp} ] && rm -rf ${FileConftemp}

echo -e "脚本目录：${ShellDir}"
