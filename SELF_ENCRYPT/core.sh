#!/usr/bin/env sh

set -e # 确保脚本抛出遇到的错误

# 入参封装
ParamsCArr=($3 SELF_ENCRYPT)

# 判断 $file 是否在数组 $ParamsCArr 内
function includeFile() {
  IFS=$'\n' # 保证文件遍历正常(不会因为空格所影响)
  isPass=true
  for ex in ${ParamsCArr[@]}
  do
    if [ $ex = $1 ]
      then isPass=false
    fi
  done
}

function getdir() {
  IFS=$'\n'
  for file in $*
  do
    includeFile $file
    if ${isPass}
      then
        if test -f $file
          then fileArr=(${fileArr[@]} $file)
          else getdir $file/*
        fi
    fi
  done
}

for infile in $2
do
  if [ $infile = 'all' ]
    then
      getdir * # 遍历所有文件
      break
    else
      getdir $infile # 遍历特定文件
  fi
done

# 得到真正需要加密(或者解密)的文件数组
# echo ${fileArr[@]}

if [ -z $fileArr ]
  then echo '根据规则选取的文件数为0,请重新选择!'
  else
    _pass=true
    if [ $1 = on ]
      then
        # 加密场景: 不能重复加密,后缀名必须 不带有encrypt
        for file in ${fileArr[@]}
        do
          if [ ${file:0-7} = encrypt ]
            then
            _pass=false
            echo '加密失败,[ '$file' ]文件已加密,请重新确定避免重复加密'
          fi
        done
      else
        # 解密场景: 不能重复解密,后缀名必须 带有encrypt
        for file in ${fileArr[@]}
        do
          if [[ ${file:0-7} != encrypt && $3 != adhoc ]]
            then
              _pass=false
              echo '解密失败,[ '$file' ]文件不是已加密文件,只能对已加密文件解密'
          fi

          if [[ ${file:0-7} = encrypt && $3 = adhoc ]]
            then storageFile=(${storageFile[@]} $file)
          fi
        done
    fi

    if [ $_pass = true ]
      then
        # 这里之所以中转一下,是因为发现下面的参数不能实时更新,只能换一个值存
        if [[ $3 = adhoc ]]
          then newFileArr=(${storageFile[@]})
          else newFileArr=(${fileArr[@]})
        fi
        sh ./SELF_ENCRYPT/back.sh _self
        node ./SELF_ENCRYPT/core.js $1 ${newFileArr[@]}

        if [ $1 = on ]
          then
            # 对加密后的文件添加后缀名
            for file in ${fileArr[@]}
            do
              mv $file $file.encrypt
            done
          else
            # 对解密后的文件删除后缀名
            for file in ${fileArr[@]}
            do
              mv $file ${file%*.encrypt}
            done
        fi
    fi
fi