#!/usr/bin/env bash
## Modified:2021-3-26
echo "lan-tianxiang暂无推荐的第三方脚本"
##############################  作  者  昵  称  （必填）  ##############################
# 使用空格隔开
# author_list="shylocks whyour 799953468 i-chenzhe"

##############################  作  者  脚  本  地  址  URL  （必填）  ##############################
# 例如：https://raw.sevencdn.com/whyour/hundun/master/quanx/jx_nc.js
# 1.从作者库中随意挑选一个脚本地址，每个作者的地址添加一个即可，无须重复添加
# 2.将地址最后的 “脚本名称+后缀” 剪切到下一个变量里（my_scripts_list_xxx）

## 目前使用本人收集的脚本库项目用于代替 CDN 加速
#scripts_base_url_1=https://gitee.com/highdimen/jd_scripts/raw/master/
#scripts_base_url_2=https://gitee.com/highdimen/jd_scripts/raw/master/
#scripts_base_url_3=https://gitee.com/highdimen/jd_scripts/raw/master/
#scripts_base_url_4=https://gitee.com/highdimen/jd_scripts/raw/master/

## 添加更多脚本地址URL示例：scripts_base_url_3=https://raw.sevencdn.com/whyour/hundun/master/quanx/

##############################  作  者  脚  本  名  称  （必填）  ##############################
# 将相应作者的脚本填写到以下变量中
#my_scripts_list_1="jd_jdaxc.js jd_xxl_gh.js"
#my_scripts_list_2="jd_factory_component.js"
#my_scripts_list_3="jd_paopao.js"
#my_scripts_list_4="jd_shake.js jd_marketLottery.js jd_superDay.js jd_xmf.js jd_wish.js jd_lenovo.js jd_oneplus.js jd_mgold.js jd_grassy.js jd_sister.js"

## 活动脚本名称1：东东爱消除、个护爱消除
## 活动脚本名称2：京喜工厂Plus
## 活动脚本名称3：京东泡泡大战
## 活动脚本名称4：百变大咖秀、超级摇一摇、京东超市-大转盘、超级品类日、众筹许愿池、科技打造品质生活、一加盲盒、金口碑奖 投票、答题赢京豆、乘风破浪的姐姐

## 由于CDN代理无法实时更新文件内容，目前使用本人的脚本收集库以解决不能访问 Github 的问题

##############################  随  机  函  数  ##############################
#rand() {
#  min=$1
#  max=$(($2 - $min + 1))
#  num=$(cat /proc/sys/kernel/random/uuid | cksum | awk -F ' ' '{print $1}')
#  echo $(($num % $max + $min))
#}
#cd ${ShellDir}
#index=1
#for author in $author_list; do
#  echo -e "开始下载 $author 的活动脚本："
#  echo -e ''
#  # 下载my_scripts_list中的每个js文件，重命名增加前缀"作者昵称_"，增加后缀".new"
#  eval scripts_list=\$my_scripts_list_${index}
#  #echo $scripts_list
#  eval url_list=\$scripts_base_url_${index}
#  #echo $url_list
#  for js in $scripts_list; do
#    eval url=$url_list$js
#    echo $url
#    eval name=$js
#    echo $name
#    wget -q --no-check-certificate $url -O scripts/$name.new
#
#    # 如果上一步下载没问题，才去掉后缀".new"，如果上一步下载有问题，就保留之前正常下载的版本
#    # 随机添加个cron到crontab.list
#    if [ $? -eq 0 ]; then
#      mv -f scripts/$name.new scripts/$name
#      echo -e "更新 $name 完成...\n"
#      croname=$(echo "$name" | awk -F\. '{print $1}')
#      script_date=$(cat scripts/$name | grep "http" | awk '{if($1~/^[0-59]/) print $1,$2,$3,$4,$5}' | sort | uniq | head -n 1)
#      if [ -z "${script_date}" ]; then
#        cron_min=$(rand 1 59)
#        cron_hour=$(rand 7 9)
#        [ $(grep -c "$croname" ${ListCron}) -eq 0 ] && sed -i "/hangup/a${cron_min} ${cron_hour} * * * bash ${ShellDir}/jd.sh $croname" ${ListCron}
#      else
#        [ $(grep -c "$croname" ${ListCron}) -eq 0 ] && sed -i "/hangup/a${script_date} bash ${ShellDir}/jd.sh $croname" ${ListCron}
#      fi
#    else
#      [ -f scripts/$name.new ] && rm -f scripts/$name.new
#      echo -e "更新 $name 失败，使用上一次正常的版本...\n"
#    fi
#  done
#  index=$(($index + 1))
#done

##############################  删  除  失  效  的  活  动  脚  本  ##############################
## 删除旧版本失效的活动示例： rm -rf ${ScriptsDir}/jd_test.js
#rm -rf ${ScriptsDir}/jd_axc.js
#rm -rf ${ScriptsDir}/jd_shakeBean.js
#rm -rf ${ScriptsDir}/jd_super5G.js
#rm -rf ${ScriptsDir}/jd_mother_jump.js
#rm -rf ${ScriptsDir}/jd_city_cash.js
#rm -rf ${ScriptsDir}/jd_entertainment.js

##############################  修  正  定  时  任  务  ##############################
## 目前两个版本都做了软链接，但为了 Linux 旧版用户可以使用，继续将软链接更改为具体文件
## 注意两边修改内容区别在于中间内容"jd"、"${ShellDir}/jd.sh"
## 修正定时任务示例：sed -i "s|bash jd jd_test|bash ${ShellDir}/jd.sh test|g" ${ListCron}
##                 sed -i "s|bash jd jd_ceshi|bash ${ShellDir}/jd.sh ceshi|g" ${ListCron}
#sed -i "s|bash jd jd_jdaxc|bash ${ShellDir}/jd.sh jd_jdaxc|g" ${ListCron}
#sed -i "s|bash jd jd_xxl_gh|bash ${ShellDir}/jd.sh jd_xxl_gh|g" ${ListCron}
#sed -i "s|bash jd jd_factory_component|bash ${ShellDir}/jd.sh jd_factory_component|g" ${ListCron}
#sed -i "s|bash jd jd_paopao|bash ${ShellDir}/jd.sh jd_paopao|g" ${ListCron}
#sed -i "s|bash jd jd_entertainment|bash ${ShellDir}/jd.sh jd_entertainment|g" ${ListCron}
#sed -i "s|bash jd jd_shake|bash ${ShellDir}/jd.sh jd_shake|g" ${ListCron}
#sed -i "s|bash jd jd_marketLottery|bash ${ShellDir}/jd.sh jd_marketLottery|g" ${ListCron}
#sed -i "s|bash jd jd_superDay|bash ${ShellDir}/jd.sh jd_superDay|g" ${ListCron}
#sed -i "s|bash jd jd_xmf|bash ${ShellDir}/jd.sh jd_xmf|g" ${ListCron}
#sed -i "s|bash jd jd_wish|bash ${ShellDir}/jd.sh jd_wish|g" ${ListCron}
#sed -i "s|bash jd jd_lenovo|bash ${ShellDir}/jd.sh jd_lenovo|g" ${ListCron}
#sed -i "s|bash jd jd_mother_jump|bash ${ShellDir}/jd.sh jd_mother_jump|g" ${ListCron}
#sed -i "s|bash jd jd_oneplus|bash ${ShellDir}/jd.sh jd_oneplus|g" ${ListCron}
#sed -i "s|bash jd jd_mgold|bash ${ShellDir}/jd.sh jd_mgold|g" ${ListCron}
#sed -i "s|bash jd jd_city_cash|bash ${ShellDir}/jd.sh jd_city_cash|g" ${ListCron}
