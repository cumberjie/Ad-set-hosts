#!/bin/bash
# 下载去广告hosts合并并去重

t=host       hn=hosts       an=adguard
# f=host-full  hf=hosts-full  af=adguard-full

# 转换为 adguard 格式函数
adguard() {
  sed "1d;s/^/||/g;s/$/^/g" $1
}

# 去除误杀函数
manslaughter(){
  sed -i "/tencent\|c\.pc\|xmcdn\|googletagservices\|zhwnlapi\|samizdat/d" $1
}
 
while read i;do curl -s "$i">>$t&&echo "下载成功"||echo "$i 下载失败";done<<EOF
https://raw.githubusercontent.com/cumberjie/AdRules/main/dns.txt
EOF

 
while read i;do curl -s "$i">>$h&&echo "下载成功"||echo "$i 下载失败";done<<EOF
https://raw.githubusercontent.com/cumberjie/Ad-set-hosts/master/me.txt 
https://cats-team.coding.net/p/adguard/d/AdRules/git/raw/main/rules/fasthosts.txt
EOF


# 转换换行符
dos2unix *
dos2unix */*

# 保留必要 host
# 只保留 127、0 开头的行
sed -i "/^\s*\(||\)/!d" $t
# 删除空白符和 # 及后
sed -i "s/\s\|#.*//g" $t
# 删除 127.0.0.1 、 0.0.0.0 、 空行、第一行
sed -i "s/^\(||\|^\)//g" $t
# 删除 最后一个字符
sed -i "s/.$//g" $t
# 删除 . 或 * 开头的
sed -i "/^\.\|^\*/d" $t
# 删除 含*行 
sed -i "/*/d" $t

# 使用声明
statement="# $(date '+%Y-%m-%d %T')\n# 自用，请勿商用\n\n"

# 获得标准去重版 host
sort -u $t -o $t
sed -i "/^127.0.0.1$/d;/^0.0.0.0$/d;/^\s*$/d" $t
manslaughter $t

# 获得标准版 hosts
(echo -e $statement && sed "s/^/0.0.0.0 /g" $t && $h) > $hn
# 获得标准 adguard 版规则
adguard $t > $an


# 获得拓展去重版 host
# cat $t $f | sort -u -o $f
# sed -i "/^127.0.0.1$/d;/^0.0.0.0$/d;/^\s*$/d" $f
# manslaughter $f

# 删除 . 或 * 开头的
# sed -i "/^\.\|^\*/d" $f

# 获得拓展版 hosts
# (echo -e $statement && sed "s/^/127.0.0.1 /g" $f && cat gh) > $hf
# 获得拓展 adguard 版规则
# adguard $f > $af


rm $t $h
# 推送到GitHub
# git add . && git commit -m " `date '+%Y-%m-%d %T'` "
