#!/bin/sh
clear
echo -e "\n"
echo -e "\n[开始部署jd_shell\n"

ShellDir=$(cd "$(dirname "$0")";pwd)
ShellName=$0
JdDir=${ShellDir}/jd

function Welcome() {
    echo -e "除了安卓，由于其它系统安装软件需要sudo，本脚本除安装环境外不会调用再次任何root的执行权限\n"
    echo -e "若担心安全风险，可选择自行安装环境!!\n"
    echo -e ''
    echo -e '#####################################################'
    echo -e ''
    echo -e "\n正在为您安装环境（依赖）：\ngit wget curl perl moreutils node.js npm\n\n"
    echo -e ''
    echo -e "      请输入开头序号选择当前的操作系统 :\n"
    echo -e "      1   debian/ubuntu/armbian/OpenMediaVault，以及其他debian系\n"
    echo -e "      2   CentOS/RedHat/Fedora等红帽系\n"
    echo -e "      3   Termux为主的安卓系\n"
    echo -e "      4   环境已安装，直接开始部署脚本\n"
    echo -e "      5   自己手动安装环境(退出)\n"
    echo -e "      当前系统时间  $(date +%Y-%m-%d) $(date +%H:%M)"
    echo -e ''
    echo -e '#####################################################'
    echo -e ''
    read -n1 LINUX_TYPE
    case  $LINUX_TYPE in
    1 )
       echo  "   debian/ubuntu/armbian/OpenMediaVault，以及其他debian系"
       sudo apt update && sudo apt install -y git wget curl nodejs npm perl
       if [ ! -x "$(command -v node)" ] || [ ! -x "$(command -v npm)" ] || [ ! -x "$(command -v git)" ] || [ ! -x "$(command -v curl)" ] || [ ! -x "$(command -v wget)" ] || [ ! -x "$(command -v perl)" ]; then
         echo -e "\n依赖未安装完整,请重新运行该脚本且切换良好的网络环境！\n"
         exit 1
       else
         echo -e "\n依赖安装完成,按任意键开始部署脚本，否则按 Ctrl + C 退出！\n"
         read BEGINTOINSTALL
         INSTALLATION_CLONE
       fi
       ;;
    2 )
       echo  "   CentOS/RedHat/Fedora等红帽系"
       sudo yum update && sudo yum install -y git wget curl perl nodejs
       if [ ! -x "$(command -v node)" ] || [ ! -x "$(command -v npm)" ] || [ ! -x "$(command -v git)" ] || [ ! -x "$(command -v curl)" ] || [ ! -x "$(command -v wget)" ] || [ ! -x "$(command -v perl)" ]; then
         echo -e "\n依赖未安装完整,请重新运行该脚本且切换良好的网络环境！\n"
         exit 1
       else
         echo -e "\n依赖安装完成,按任意键开始部署脚本，否则按 Ctrl + C 退出！\n"
         read BEGINTOINSTALL
         INSTALLATION_CLONE
       fi
       ;;
    3 )
       echo  "   Termux为主的安卓系"
       pkg update && pkg install -y git perl nodejs-lts wget curl nano cronie
       if [ ! -x "$(command -v node)" ] || [ ! -x "$(command -v npm)" ] || [ ! -x "$(command -v git)" ] || [ ! -x "$(command -v curl)" ] || [ ! -x "$(command -v wget)" ] || [ ! -x "$(command -v perl)" ]; then
         echo -e "\n依赖未安装完整,请重新运行该脚本且切换良好的网络环境！\n"
         exit 1
       else
         echo -e "\n依赖安装完成,按任意键开始部署脚本，否则按 Ctrl + C 退出！\n"
         read BEGINTOINSTALL
         INSTALLATION_CLONE
       fi
       ;;
    4 )
       echo  "   已安装(继续)"
       if [ ! -x "$(command -v node)" ] || [ ! -x "$(command -v npm)" ] || [ ! -x "$(command -v git)" ] || [ ! -x "$(command -v curl)" ] || [ ! -x "$(command -v wget)" ] || [ ! -x "$(command -v perl)" ]; then
         echo -e "\n依赖未安装完整！\n"
         exit 1
       else
         echo -e "\n依赖已安装,按任意键开始部署脚本，否则按 Ctrl + C 退出！\n"
         read BEGINTOINSTALL
         INSTALLATION_CLONE
       fi
       ;;
    * )
       echo  "   自己手动安装环境(退出)";;
    esac
}

function INSTALLATION_CLONE() {
echo -e "\n1. 获取源码"
[ -d ${JdDir} ] && mv ${JdDir} ${JdDir}.bak && echo "检测到已有 ${JdDir} 目录，已备份为 ${JdDir}.bak"
git clone -b v3 https://gitee.com/highdimen/jd_shell ${JdDir}

echo -e "\n2. 检查配置文件"
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

echo -e "\n3. 执行 git_pull.sh 进行脚本更新以及定时文件更新"
bash ${JdDir}/git_pull.sh

if [ ! -x "$(command -v pm2)" ]; then
    echo "正在安装pm2,方便后续集成并发功能"
    npm install pm2@latest -g
fi
echo -e "\n注意：原有定时任务已备份在 ${JdDir}/old_crontab"
rm -f ${ShellDir}/${ShellName}

echo -e "\n安装完成！！！！"
}
Welcome
