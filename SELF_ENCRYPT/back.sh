# 回滚上一次操作(为了防止加密解密错误)

# 思路
# 1. 每次加密解密之前,都执行一下此方法
# 2. 此方法会创建一个 .back 文件夹,内部存放着一些备用文件
# 3. 每次加密解密后都会将处理过的文件放在 .back 文件夹中
# 4. 每次加密解密都会替换,比如第一次加密了五个文件,第二次加密了2个文件,回滚时只会有那2个文件

# 新思路
# 直接暴力点,每次都复制项目根目录所有文件,替换的时候直接删除再替换
# 不知道这样会不会影响速度

# 参数解释
# $1: 强制为 _self 时,代表开启私有方法 (用来备份)
# $2: 所有更改的文件集合

#!/usr/bin/env sh

set -e # 确保脚本抛出遇到的错误

gitFile='.git/info/exclude'
if test -f $gitFile
then
  echo 'SELF_ENCRYPT/.back' >> $gitFile # git不监听
fi

cd `dirname $0` # 进入工作目录 (也就是 SELF_ENCRYPT内)

IFS=$'\n'

dir=".back"

if [[ $1 = _self ]]
then
  # 备份
  if [ -e $dir ]; then rm -rf $dir; fi
  mkdir $dir
  cd ..
  files=`ls | grep -v SELF_ENCRYPT | grep -v node_modules`
  cp -ax $files ./SELF_ENCRYPT/.back
else
  # 回滚
  if [ -e $dir ]
  then
    cd ..
    rm -rf `ls | grep -v SELF_ENCRYPT | grep -v node_modules`
    cp -rf ./SELF_ENCRYPT/.back/* ./
  else
    echo "只有操作了文件才能进行回滚"
  fi
fi