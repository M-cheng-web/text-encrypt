#!/usr/bin/env sh

# 负责提交代码 / 更新代码

defaultBranch=main

if [ $1 = push ]
  then
    git add -A
    git commit -m 'encrypt'
fi

echo git $1 origin $defaultBranch....

git $1 origin $defaultBranch
