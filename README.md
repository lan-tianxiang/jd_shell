![Anurag’s github stats](https://github-readme-stats.vercel.app/api?username=lan-tianxiang&show_icons=true&theme=merko)

## 请仔细阅读 [WIKI](https://github.com/lan-tianxiang/jd_shell/wiki) 和各文件注释，95%的问题都能找到答案

## 适用于以下系统

- ArmBian/Debian/Ubuntu/OpenMediaVault/CentOS/Fedora/RHEL等Linux系统

- OpenWRT(教程划归于Linux)

- Android

- MacOS

- Docker(用Dockerfile生成)


### 如何部署？

### 1.Linux 一键部署：

运行此脚本前必须手动安装好依赖：`git wget curl perl node.js npm`等，具体请请查看wiki  
```shell
wget -q https://cdn.jsdelivr.net/gh/lan-tianxiang/jd_shell/install_scripts/linux_install_jd.sh -O linux_install_jd.sh && chmod +x linux_install_jd.sh && ./linux_install_jd.sh
```

### 2. Docker 一键部署单个容器：

```shell
wget -q https://cdn.jsdelivr.net/gh/lan-tianxiang/jd_shell/install_scripts/docker_install_jd.sh -O docker_install_jd.sh && chmod +x docker_install_jd.sh && ./docker_install_jd.sh
```


## 说明

1. 即将推出远程面板功能，需安装数据库php等，非服务器的用户可以忽略

## 更新日志

> 只记录大的更新，小修小改不记录。

2021-02-19，面板功能集成至jd.sh内，运行jd.sh会出现操作提示

2021-01-23，控制面板增加日志查看功能，Docker重启容器后可以使用`docker restart jd`，非Docker如果是pm2方式的请重启pm2进程`pm2 resatrt server.js`。

2020-01-21，增加shylocks/Loon脚本。

2021-01-15，如果本机上安装了pm2，则挂机程序以pm2启动，否则以nohup启动。
