![Anurag’s github stats](https://github-readme-stats.vercel.app/api?username=lan-tianxiang&show_icons=true&theme=merko)

### 自用jd-base

## 请仔细阅读 [WIKI](https://github.com/lan-tianxiang/jd_shell/wiki) 和各文件注释，95%的问题都能找到答案


## 如有二次使用，请注明来源

本脚本是以下两个仓库的shell套壳工具：

[LXK9301/jd_scripts](https://github.com/LXK9301/jd_scripts)：主要是长期任务。

[shylocks/Loon](https://github.com/shylocks/Loon)：主要是短期任务、一次性任务，正因为是短期的和一次性的，所以经常会有报错，报错就报错了，不要催我也不要去催[shylocks](https://github.com/shylocks)大佬。

## 适用于以下系统

- ArmBian/Debian/Ubuntu/OpenMediaVault/CentOS/Fedora/RHEL等Linux系统

- OpenWRT(教程划归于Linux)

- Android

- MacOS

- Docker(用Dockerfile生成)

## 说明

1. 由于宠汪汪及系列游戏接口可能经lxk加密，可能无法正常运行！(暂时修复)

2. 即将推出远程面板功能，需安装数据库php等，非服务器的用户可以忽略

## 更新日志

> 只记录大的更新，小修小改不记录。

2021-02-19，面板功能集成至jd.sh内，运行jd.sh会出现操作提示

2021-01-23，控制面板增加日志查看功能，Docker重启容器后可以使用`docker restart jd`，非Docker如果是pm2方式的请重启pm2进程`pm2 resatrt server.js`。

2020-01-21，增加shylocks/Loon脚本。

2021-01-15，如果本机上安装了pm2，则挂机程序以pm2启动，否则以nohup启动。
