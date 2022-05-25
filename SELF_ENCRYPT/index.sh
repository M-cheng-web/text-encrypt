#!/usr/bin/env sh

# 确保脚本抛出遇到的错误
set -e

# 参数一: on / off / push / pull / nogit / back
#        on / off:    代表 加密,解密
#        push / pull: 代表 加密,解密 (会提交代码到远程)
#        nogit:       代表 加密的源码(SELF_ENCRYPT文件夹)不会提交到git
#        back:        代表 回滚上一次操作(为了防止加密解密错误)

# 参数二: files 需要加密的文件夹 (支持 all)

# 参数三: files 不需要加密的文件夹 (不支持 all)

# 校验给的文件参数是否带有 '/'
function isPassFun() {
  IFS=$'\n'
  local isPass=true
  for fileName in $1
  do
    if [ ${fileName:0:1} = '/' ]
    then
      isPass=false
    fi
  done

  if [ $isPass = false ]
    then
      echo '指定的文件开头不能带有 / 符号,直接指定例如: demo/index.js'
      exit 1
  fi
}

if [ $1 = nogit ]
then
  gitFile='.git/info/exclude'
  if test -f $gitFile
  then
    echo 'SELF_ENCRYPT' >> $gitFile # git不监听
  fi
elif [ $1 = back ]
then
  sh SELF_ENCRYPT/back.sh
elif [[ $1 = on || $1 = off || $1 = push || $1 = pull ]]
then
  isPassFun $2
  isPassFun $3
  if [[ $1 = on || $1 = off ]]
  then
    # 只负责加密 / 解密
    sh SELF_ENCRYPT/core.sh $1 "$2" "$3"
  else
    if [ $1 = push ]
    then
      # 先加密再推送
      sh SELF_ENCRYPT/core.sh on "$2" "$3"
      sh SELF_ENCRYPT/push.sh $1
    else
      # 先拉取再解密
      sh SELF_ENCRYPT/push.sh $1
      sh SELF_ENCRYPT/core.sh off all adhoc
    fi
  fi
else
  echo '请输入正确的首位参数'
fi