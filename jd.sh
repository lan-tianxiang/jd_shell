#!/usr/bin/env bash

## Author: lan-tianxiang
## Source: https://github.com/lan-tianxiang/jd_shell
## Modified： 2021-07-07
## Version： v3.66.0

## 路径
ShellDir=${JD_DIR:-$(
  cd $(dirname $0)
  pwd
)}
[ ${JD_DIR} ] && HelpJd=jd.sh || HelpJd=jd.sh
ScriptsDir=${ShellDir}/scripts
PanelDir=${ShellDir}/panel
WebshellDir=${ShellDir}/webshell
ConfigDir=${ShellDir}/config
FileConf=${ConfigDir}/config.sh
FileConftemp=${ConfigDir}/config.sh.temp
FileConfSample=${ShellDir}/sample/config.sh.sample
panelpwd=${ConfigDir}/auth.json
LogDir=${ShellDir}/log
ListScripts=($(
  cd ${ScriptsDir}
  ls *.js | grep -E "j[drx]_"
))
ListCron=${ConfigDir}/crontab.list

## 常量
AutoHelpme=false
TasksTerminateTime=0
NodeType="nohup"
IsWebShell="false"

## 导入config.sh
function Import_Conf() {
  if [ -f ${FileConf} ]; then
    . ${FileConf}
    if [ -z "${Cookie1}" ]; then
      echo -e "请先在config.sh中配置好Cookie...\n"
      exit 1
    fi
  else
    echo -e "配置文件 ${FileConf} 不存在，请先按教程配置好该文件...\n"
    exit 1
  fi
}

## 更新crontab
function Detect_Cron() {
  if [[ $(cat ${ListCron}) != $(crontab -l) ]]; then
    crontab ${ListCron}
  fi
}

## 用户数量UserSum
function Count_UserSum() {
  for ((i = 1; i <= 1000; i++)); do
    Tmp=Cookie$i
    CookieTmp=${!Tmp}
    [[ ${CookieTmp} ]] && UserSum=$i || break
  done
}

## 判断使用系统
detect_system() {
    SYSTEM=UnKnow
    Platform="虚拟机"
    SYSTEMTYPE=$(uname -m)
    [[ -n $(uname -m | grep arm) ]] && SYSTEMTYPE=arm
    [[ -n $(uname -a | grep Android) ]] && SYSTEM=Android
    [[ -n $(uname -s | grep Darwin) ]] && SYSTEM=Macos
    [[ -n $(ls /etc | grep lsb-release) ]] && SYSTEM=Ubuntu
    [[ -n $(ls /etc | grep debian_version) ]] && SYSTEM=Debian
    [[ -n $(ls /etc | grep redhat-release) ]] && SYSTEM=Centos
    [ -f /proc/1/cgroup ] && [[ -n $(cat /proc/1/cgroup | grep cpuset | grep scope) ]] && SYSTEM=Docker
    [ -f /proc/version ] && [[ -n $(cat /proc/version | grep Openwar) ]] && SYSTEM=Openwar
    #[[ -n $(dmesg|grep -i virtual) ]] && Platform="虚拟机"
}

## 组合Cookie和互助码子程序
function Combin_Sub() {
  CombinAll=""
  for ((i = 1; i <= ${UserSum}; i++)); do
    for num in ${TempBlockCookie}; do
      if [[ $i -eq $num ]]; then
        continue 2
      fi
    done
    Tmp1=$1$i
    Tmp2=${!Tmp1}
    case $# in
    1)
      CombinAll="${CombinAll}&${Tmp2}"
      ;;
    2)
      CombinAll="${CombinAll}&${Tmp2}@$2"
      ;;
    3)
      if [ $(($i % 2)) -eq 1 ]; then
        CombinAll="${CombinAll}&${Tmp2}@$2"
      else
        CombinAll="${CombinAll}&${Tmp2}@$3"
      fi
      ;;
    4)
      case $(($i % 3)) in
      1)
        CombinAll="${CombinAll}&${Tmp2}@$2"
        ;;
      2)
        CombinAll="${CombinAll}&${Tmp2}@$3"
        ;;
      0)
        CombinAll="${CombinAll}&${Tmp2}@$4"
        ;;
      esac
      ;;
    esac
  done
  echo ${CombinAll} | perl -pe "{s|^&||; s|^@+||; s|&@|&|g; s|@+&|&|g; s|@+|@|g; s|@+$||}"
}

## 组合Cookie、Token与互助码
function Combin_All() {
  export JD_COOKIE=$(Combin_Sub Cookie)
  ## 东东农场(jd_fruit.js)
  export FRUITSHARECODES=$(Combin_Sub ForOtherFruit "588e4dd7ba134ad5aa255d9b9e1a38e3@520b92a9f0c34b34a0833f6c3bb41cac@e124f1c465554bf485983257743233d3" "7363f89a9d7248ae91a439794f854614@07b3cd1495524fa2b0f768e7639eab9f")
  ## 东东萌宠(jd_pet.js)
  export PETSHARECODES=$(Combin_Sub ForOtherPet "MTE1NDAxNzgwMDAwMDAwMzk3NDIzODc=@MTAxODEyMjkyMDAwMDAwMDQwMTEzNzA3@MTE1NDUyMjEwMDAwMDAwNDM3NDQzMzU=" "MTEzMzI0OTE0NTAwMDAwMDA0Mzc0NjgzOQ==")
  ## 种豆得豆(jd_plantBean.js)
  export PLANT_BEAN_SHARECODES=$(Combin_Sub ForOtherBean "olmijoxgmjutzeajdig5vec453deq25pz7msb7i@okj5ibnh3onz6mkpbt6natnj7xdxeqeg53kjbsi@7oivz2mjbmnx4cbdwoeomdbqrr6bwbgsrhybhxa" "yvppbgio53ya5quolmjz6hiwlhu6yge7i7six5y@ebxm5lgxoknqdfx75eycfx6vy5n2tuflqhuhfia")
  ## 东东工厂(jd_jdfactory.js)
  export DDFACTORY_SHARECODES=$(Combin_Sub ForOtherJdFactory "T0225KkcRhwZp1HXJk70k_8CfQCjVWnYaS5kRrbA@T0205KkcAVhorA6EfG6dwb9ACjVWnYaS5kRrbA@T0205KkcG1tgqh22f1-s54tXCjVWnYaS5kRrbA" "T019__l2QBYe_UneIRj9lv8CjVWnYaS5kRrbA@T0205KkcNFd5nz6dXnCV4r9gCjVWnYaS5kRrbA")
  ## 京喜工厂(jd_dreamFactory.js)
  export DREAM_FACTORY_SHARE_CODES=$(Combin_Sub ForOtherDreamFactory "piDVq-y7O_2SyEzi5ZxxYw==@IzYimRViEUHMiUDFhPPLOg==@ieXM8XzpopOaevcW0f1OwA==" "y0k9IDhCNqQvEov0x2ugNQ==")
  ## 京东赚赚(jd_jdzz.js)
  export JDZZ_SHARECODES=$(Combin_Sub ForOtherJdzz "S5KkcRhwZp1HXJk70k_8CfQ@S5KkcAVhorA6EfG6dwb9A@S5KkcG1tgqh22f1-s54tX")
  ## 疯狂的Joy(jd_crazy_joy.js)
  export JDJOY_SHARECODES=$(Combin_Sub ForOtherJoy "N1ihLmXRx9ahdnutDzc1Vqt9zd5YaBeE@o8k-j4vfLXWhsdA5HoPq-w==@zw2aNaUUBen1acOglloXVw==")
  ## 口袋书店(jd_bookshop.js)
  export BOOKSHOP_SHARECODES=$(Combin_Sub ForOtherBookShop)
  ## 签到领现金(jd_cash.js)
  export JD_CASH_SHARECODES=$(Combin_Sub ForOtherCash "eU9Yau6yNPkm9zrVzHsb3w@eU9YLarDP6Z1rRq8njtZ@eU9YN6nLObVHriuNuA9O")
  ## 京喜农场(jd_jxnc.js)
  export JXNC_SHARECODES=$(Combin_Sub ForOtherJxnc)
  ## 闪购盲盒(jd_sgmh.js)
  export JDSGMH_SHARECODES=$(Combin_Sub ForOtherSgmh)
  ## 京喜财富岛(jd_cfd.js)
  export JDCFD_SHARECODES=$(Combin_Sub ForOtherCfd)
  ## 环球挑战赛(jd_global.js)
  export JDGLOBAL_SHARECODES=$(Combin_Sub ForOtherGlobal "MjNtTnVxbXJvMGlWTHc5Sm9kUXZ3VUM4R241aDFjblhybHhTWFYvQmZUOD0")
  ## 京东手机狂欢城(jd_carnivalcity.js)
  export JD818_SHARECODES=$(Combin_Sub ForOtherCarnivalcity "5443fec1-7dbc-4d92-a09b-b7eb0a01199f@8c2a0d3a-b4d7-4bbf-bccc-4e7efc18f849")

  export JDHEALTH_SHARECODES=$(Combin_Sub ForOtherHealth)
}

## 转换JD_BEAN_SIGN_STOP_NOTIFY或JD_BEAN_SIGN_NOTIFY_SIMPLE
function Trans_JD_BEAN_SIGN_NOTIFY() {
  case ${NotifyBeanSign} in
  0)
    export JD_BEAN_SIGN_STOP_NOTIFY="true"
    ;;
  1)
    export JD_BEAN_SIGN_NOTIFY_SIMPLE="true"
    ;;
  esac
}

## 转换UN_SUBSCRIBES
function Trans_UN_SUBSCRIBES() {
  export UN_SUBSCRIBES="${goodPageSize}\n${shopPageSize}\n${jdUnsubscribeStopGoods}\n${jdUnsubscribeStopShop}"
}

## 申明全部变量
function Set_Env() {
  Count_UserSum
  Combin_All
  Trans_JD_BEAN_SIGN_NOTIFY
  Trans_UN_SUBSCRIBES
}

## 随机延迟
function Random_Delay() {
  if [[ -n ${RandomDelay} ]] && [[ ${RandomDelay} -gt 0 ]]; then
    CurMin=$(date "+%-M")
    if [[ ${CurMin} -gt 2 && ${CurMin} -lt 30 ]] || [[ ${CurMin} -gt 31 && ${CurMin} -lt 59 ]]; then
      CurDelay=$((${RANDOM} % ${RandomDelay} + 1))
      echo -e "\n命令未添加 \"now\"，随机延迟 ${CurDelay} 秒后再执行任务，如需立即终止，请按 CTRL+C...\n"
      sleep ${CurDelay}
    fi
  fi
}

## 使用说明
function Help() {
  echo -e "本脚本的用法为："
  echo -e "bash ${HelpJd} jd_xxx       # 如果设置了随机延迟并且当时时间不在0-2、30-31、59分内，将随机延迟一定秒数"
  echo -e "bash ${HelpJd} jd_xxx now   # 无论是否设置了随机延迟，均立即运行"
  echo -e "bash ${HelpJd} hangup    # 重启挂机程序"
  echo -e "bash ${HelpJd} panelon   # 开启控制面板"
  echo -e "bash ${HelpJd} paneloff  # 关闭控制面板"
  echo -e "bash ${HelpJd} resetpwd   # 重置控制面板用户名和密码"
  echo
  cd ${ScriptsDir}
  for ((i = 0; i < ${#ListScripts[*]}; i++)); do
    Name=$(grep "new Env" ${ListScripts[i]} | awk -F "'|\"" '{print $2}')
    echo -e "$(($i + 1)).${Name}：${ListScripts[i]}"
  done
}

## nohup
function Run_Nohup() {
  for js in ${HangUpJs}; do
    if [[ $(ps -ef | grep "${js}" | grep -v "grep") != "" ]]; then
      ps -ef | grep "${js}" | grep -v "grep" | awk '{print $2}' | xargs kill -9
    fi
  done

  for js in ${HangUpJs}; do
    [ ! -d ${LogDir}/${js} ] && mkdir -p ${LogDir}/${js}
    LogTime=$(date "+%Y-%m-%d-%H-%M-%S")
    LogFile="${LogDir}/${js}/${LogTime}.log"
    nohup node ${js}.js >${LogFile} &
  done
}

## pm2
function Run_Pm2() {
  pm2 flush
  for js in ${HangUpJs}; do
    pm2 restart ${js}.js || pm2 start ${js}.js
  done
}

## 运行挂机脚本
function Run_HangUp() {
  Import_Conf && Detect_Cron && Set_Env
  HangUpJs="jd_crazy_joy_coin"
  cd ${ScriptsDir}
  if type pm2 >/dev/null 2>&1; then
    Run_Pm2 2>/dev/null
  else
    Run_Nohup >/dev/null 2>&1
  fi
}

## npm install 子程序，判断是否为安卓，判断是否安装有yarn
function Npm_InstallSub() {
  if [ -n "${isTermux}" ]; then
    npm install --no-bin-links || npm install --no-bin-links --registry=https://registry.npm.taobao.org
  elif ! type yarn >/dev/null 2>&1; then
    npm install || npm install --registry=https://registry.npm.taobao.org
  else
    echo -e "检测到本机安装了 yarn，使用 yarn 替代 npm...\n"
    yarn install || yarn install --registry=https://registry.npm.taobao.org
  fi
}

## panel install
function panelon() {
  if [ ! -d ${PanelDir}/node_modules ]; then
    echo -e "运行 npm install...\n"
    Npm_InstallSub
    if [ $? -ne 0 ]; then
      echo -e "\nnpm install 运行不成功，自动删除 ${ScriptsDir}/node_modules 后再次尝试一遍..."
      rm -rf ${PanelDir}/node_modules
    fi
  fi

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

  echo -e "记得开启前先认真看Wiki中，功能页里关于控制面板的事项\n"

  if [ ! -f "$panelpwd" ]; then
    cp -f ${ShellDir}/sample/auth.json ${ConfigDir}/auth.json
    echo -e "检测到未设置密码，用户名：admin，密码：adminadmin\n"
  fi
  ## 安装pm2
  [ ! $NodeType = nohup ] && [ ! -x "$(command -v pm2)" ] && npm install pm2@latest -g

  ## 复制ttyd
  cd ${PanelDir}
  [ $SYSTEMTYPE = arm ] && [ ! -f ${PanelDir}/ttyd ] && cp -f ${PanelDir}/webshellbinary/ttyd.arm ${PanelDir}/ttyd && [ ! -x ${PanelDir}/ttyd ] && chmod +x ${PanelDir}/ttyd && echo 1
  [ ! $SYSTEM = Android ] && [ ! -f ${PanelDir}/ttyd ] && cp -f ${PanelDir}/webshellbinary/ttyd.$(uname -m) ${PanelDir}/ttyd && [ ! -x ${PanelDir}/ttyd ] && chmod +x ${PanelDir}/ttyd echo 1

  paneloff
  cd ${PanelDir}
  [ ! $NodeType = nohup ] && [ $IsWebShell = true ] && pm2 start ${PanelDir}/ttyd --name="WebShell" -- -p 9999 -t fontSize=14 -t disableLeaveAlert=true -t rendererType=webgl bash >/dev/null 2>&1 &
  [ ! $NodeType = nohup ] && pm2 start ${PanelDir}/server.js && echo "成功，按回车继续" &
  
  [ $NodeType = nohup ] && [ $IsWebShell = true ] && nohup ./ttyd -p 9999 -t fontSize=14 -t disableLeaveAlert=true -t rendererType=webgl bash >/dev/null 2>&1 &
  [ $NodeType = nohup ] && nohup node ${PanelDir}/server.js >/dev/null 2>&1 &

  if [ $? -ne 0 ]; then
    echo -e "开启失败，请截图并复制错误代码并提交Issues！\n"
  else
    echo -e "确认看过WIKI，打开浏览器，地址为你的127.0.0.1:5678\n"
  fi
}

## 关闭面板
function paneloff() {
  cd ${PanelDir}
  pm2 delete all >/dev/null 2>&1
  pkill -9 ttyd >/dev/null 2>&1
  pkill -9 node >/dev/null 2>&1
}

## 重置密码
function Reset_Pwd() {
  cp -f ${ShellDir}/sample/auth.json ${ConfigDir}/auth.json
  echo -e "控制面板重置成功，用户名：admin，密码：adminadmin\n"
}

## 运行京东脚本
function Run_Normal() {
  Import_Conf && Detect_Cron && Set_Env

  if [ ${AutoHelpme} = true ]; then
    if [ -f ${LogDir}/export_sharecodes/export_sharecodes.log ]; then
      [ ! -s ${FileConftemp} ] && cp -f ${FileConf} ${ConfigDir}/config.sh.temp && cat ${LogDir}/export_sharecodes/export_sharecodes.log >>${ConfigDir}/config.sh.temp
      FileConf=${ConfigDir}/config.sh.temp
      Import_Conf && Detect_Cron && Set_Env
    else
      echo "暂时没有助力码"
    fi
  else
    echo "0000"
  fi

  FileNameTmp1=$(echo $1 | perl -pe "s|\.js||")
  FileNameTmp2=$(echo $1 | perl -pe "{s|jd_||; s|\.js||; s|^|jd_|}")
  SeekDir="${ScriptsDir} ${ScriptsDir}/backUp ${ConfigDir}"
  FileName=""
  WhichDir=""

  for dir in ${SeekDir}; do
    if [ -f ${dir}/${FileNameTmp1}.js ]; then
      FileName=${FileNameTmp1}
      WhichDir=${dir}
      break
    elif [ -f ${dir}/${FileNameTmp2}.js ]; then
      FileName=${FileNameTmp2}
      WhichDir=${dir}
      break
    fi
  done

  if [ -n "${FileName}" ] && [ -n "${WhichDir}" ]; then
    [ $# -eq 1 ] && Random_Delay
    LogTime=$(date "+%Y-%m-%d-%H-%M-%S")
    LogFile="${LogDir}/${FileName}/${LogTime}.log"
    [ ! -d ${LogDir}/${FileName} ] && mkdir -p ${LogDir}/${FileName}
    cd ${WhichDir}
    #    env
    [ ${TasksTerminateTime} = 0 ] && node ${FileName}.js | tee ${LogFile}
    [ ${TasksTerminateTime} -ne 0 ] && timeout ${TasksTerminateTime} node ${FileName}.js | tee ${LogFile}
  else
    echo -e "\n在${ScriptsDir}、${ScriptsDir}/backUp、${ConfigDir}三个目录下均未检测到 $1 脚本的存在，请确认...\n"
    Help
  fi
}




detect_system
## 命令检测
case $# in
0)
  echo
  Help
  ;;
1)
  if [[ $1 == hangup ]]; then
    Run_HangUp
  elif [[ $1 == resetpwd ]]; then
    Reset_Pwd
  elif [[ $1 == panelon ]]; then
    panelon
  elif [[ $1 == paneloff ]]; then
    paneloff
  else
    Run_Normal $1
  fi
  ;;
2)
  if [[ $2 == now ]]; then
    Run_Normal $1 $2
  else
    echo -e "\n命令输入错误...\n"
    Help
  fi
  ;;
*)
  echo -e "\n命令过多...\n"
  Help
  ;;
esac
echo "您的操作系统为：$SYSTEM 架构：$SYSTEMTYPE"
## Update Time 2021-04-06 12:35:48
