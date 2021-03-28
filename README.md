<!--
[![Readme Card](https://github-readme-stats.vercel.app/api/pin/?username=lan-tianxiang&show_icons=true&theme=radical&repo=jd_shell)](https://github.com/lan-tianxiang/jd_shell)
-->

<p align="center">
 <img width="100px" src="https://res.cloudinary.com/anuraghazra/image/upload/v1594908242/logo_ccswme.svg" align="center" alt="GitHub Readme Stats" />
 <h2 align="center">JD SHELL</h2>
 <p align="center">自动化一键完成Bean采集</p>
</p>
  <p align="center">
    <a href="https://github.com/lan-tianxiang/jd_shell/actions">
      <img alt="Tests Passing" src="https://github.com/lan-tianxiang/jd_shell/workflows/DockerHub/badge.svg" />
    </a>
    <a href="https://codecov.io/gh/lan-tianxiang/jd_shell">
      <img src="https://codecov.io/gh/lan-tianxiang/jd_shell/branch/master/graph/badge.svg" />
    </a>
    <a href="https://github.com/lan-tianxiang/jd_shell/issues">
      <img alt="Issues" src="https://img.shields.io/github/issues/lan-tianxiang/jd_shell?color=0088ff" />
    </a>
    <a href="https://github.com/lan-tianxiang/jd_shell/pulls">
      <img alt="GitHub pull requests" src="https://img.shields.io/github/issues-pr/lan-tianxiang/jd_shell?color=0088ff" />
    </a>
    <br />
    <br />
    <a href="https://github.com/lan-tianxiang/">
      <img src="https://img.shields.io/badge/Supported%20by-Lan%20Tian%20Xiang%20%E2%86%92-gray.svg?colorA=655BE1&colorB=4F44D6&style=for-the-badge"/>
    </a>
    <a href="https://github.com/lxk0301">
      <img src="https://img.shields.io/badge/Supported%20by-LXK%200301%20Scripts%20%E2%86%92-gray.svg?colorA=61c265&colorB=4CAF50&style=for-the-badge"/>
    </a>
  </p>

  <p align="center">
    <a href="#demo">查看 Demo</a>
    ·
    <a href="https://github.com/lan-tianxiang/jd_shell/issues/new/choose">报告 Bug</a>
    ·
    <a href="https://github.com/lan-tianxiang/jd_shell/issues/new/choose">请求增加功能</a>
  </p>
</p>
<p align="center">喜欢这个项目？请考虑<a href="">捐赠❤</a>来帮助它完善！
<br />
<h3 align="center">当然，觉得默默关注也是鼓励的话，也可以在右上角给颗⭐！你的支持是我最大的动力😎！</h3>
<p>
    <br />
    <br />
    <br />
    <br />
    <br />
</p>

### 写这个项目是打算自用的，所以请大家不要传播。既然有幸看到了用就行，不许以任何形式通过贩卖京Bean,软件来非法获益。一旦发现后果自负！！

## 适用于以下系统

- ArmBian/Debian/Ubuntu/OpenMediaVault/CentOS/Fedora/RHEL等Linux系统

- OpenWRT(教程划归于Linux)

- Android

- MacOS

- Docker


### 如何部署？

### 1.Linux 一键部署：
内有多个环节选择，可退出！
```shell
wget -q https://gitee.com/highdimen/jd_shell/raw/v3/install_scripts/linux_install_jd.sh -O linux_install_jd.sh && chmod +x linux_install_jd.sh && bash linux_install_jd.sh
```
若提示没有安装wget,则安装wget

### 2. Docker 一键部署单个容器：[![Docker Pulls](https://img.shields.io/docker/pulls/lantianxiang1/jd_shell?style=for-the-badge)](https://registry.hub.docker.com/r/lantianxiang1/jd_shell/tags?page=1&ordering=last_updated)

```shell
wget -q https://gitee.com/highdimen/jd_shell/raw/v3/install_scripts/docker_install_jd.sh -O docker_install_jd.sh && chmod +x docker_install_jd.sh && bash docker_install_jd.sh
```

### 3. 修复或升级：
- 进入项目安装目录

      cd /home/jd
- 执行修复与升级脚本

      bash repair.sh
> 注意：1. 此脚本适用于任何脚本出现异常，无法更新，出现未知错误时运行。不会清除账号以及配置数据，请放心使用！！

***

### [WIKI](https://github.com/lan-tianxiang/jd_shell/wiki) 和各文件注释都含有大量教程，请自行翻阅

## 说明

1. 即将推出远程面板功能，需安装数据库php等，非服务器的用户可以忽略

## 更新日志

> 只记录大的更新，小修小改不记录。

2021-02-19，面板功能集成至jd.sh内，运行jd.sh会出现操作提示

2021-01-23，控制面板增加日志查看功能，Docker重启容器后可以使用`docker restart jd`，非Docker如果是pm2方式的请重启pm2进程`pm2 resatrt server.js`。

2020-01-21，增加shylocks/Loon脚本。

2021-01-15，如果本机上安装了pm2，则挂机程序以pm2启动，否则以nohup启动。
