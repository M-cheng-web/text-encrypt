# text-encrypt
对文本的 [ 加密 / 解密 ] 脚本

```
注意: 目前此脚本需要配合 node 环境使用 (如有需要可以后续改为纯shell脚本~)
```

## 功能点
1. 对 [ 全部 / 指定 ] 文件夹下所有的文件进行加密 (暂时只是对编码格式进行转换达到肉眼加密效果,如需aes加密可扩展)
2. 对 [ 全部 / 指定 ] 文件夹下所有的文件进行解密 (只会对加密过的文件进行解密)
3. 加密解密时,可对 [ 指定 ] 文件夹标明不参与加密解密动作 
4. 可自动加密后提交远程,拉取代码后自动解密 (可更改 push.sh > defaultBranch 来选取分支)
5. 提供操作回退功能,当某次操作错误导致加密了其他文件,可用此功能回退 (只会记录上次操作)
6. 可设置 `SELF_ENCRYPT` 文件夹是否提交到远程

## 使用
1. 将 `SELF_ENCRYPT` 文件夹复制到你的项目中
2. 在项目根路径执行命令,如: `sh SELF_ENCRYPT/index.sh on all`
3. 也可以将 `SELF_ENCRYPT/index.sh` 文件移植到你的项目根目录(不需要更改任何代码,或者可以重命名),随后执行命令如: `sh index.sh on all`
4. 调试的话也可以自己先在demo内随便玩玩呗,如果有精力可以帮助我完成下面的待做~

### 参数
| 参数位 | 说明                            | 可选值                                | 是否必填 |
| ------ | ------------------------------- | ------------------------------------- | -------- |
| 参数一 | 详情见下方                      | on / off / push / pull / nogit / back | 是       |
| 参数二 | 需要加密的文件夹 (支持 all)     | all / fileNameA fileNameB ...         | 是       |
| 参数三 | 不需要加密的文件夹 (不支持 all) | fileNameA fileNameB ...               | 否       |

参数一说明
+ on / off:    代表 加密,解密
+ push / pull: 代表 加密,解密 (会提交代码到远程)
+ nogit:       代表 加密的源码(SELF_ENCRYPT文件夹)不会提交到git
+ back:        代表 回滚上一次操作(为了防止加密解密错误)

警告: 指定文件时开头不能用 `/` (加密方法是强制拿到 SELF_ENCRYPT 文件夹同级的文件路径再进行拼接后才加密,如果开头出现 `/` 也会导致找不到文件则退出加密的情况,杜绝了加密到项目根目录之外文件的情况),如这种写法就是错误的: `sh index.sh on '/demo /index.js'`

### 示例
```
// 加密所有文件夹下的所有文件
sh SELF_ENCRYPT/index.sh on all

// 解密所有文件夹下的所有文件
sh SELF_ENCRYPT/index.sh off all

// 加密项目根目录下 pages 以及 utils 文件夹下的所有文件,以及根目录下的 index.txt 文件
sh SELF_ENCRYPT/index.sh on 'pages utils index.txt'

// 加密项目根目录下 pages 文件夹, 排除 pages/demo1 以及 pages/demo1 文件夹下所有文件,以及排除 pages/index.js 文件
sh SELF_ENCRYPT/index.sh on pages 'pages/demo1 pages/demo2 pages/index.js'

// 回退至上一次操作
sh SELF_ENCRYPT/index.sh back

// 将 SELF_ENCRYPT文件夹 设置为不能提交至远程
sh SELF_ENCRYPT/index.sh nogit
```

### 注意点
1. 目前只支持纯文本文件( `.md .text js html vue ...` ), 不支持 `.doc .ppt` 这样的文件
2. SELF_ENCRYPT 文件夹放在项目根目录
3. 执行脚本时 要求在项目根路径执行 (目前内部脚本没有用绝对路径)
4. 不能对已加密或者已解密的文件进行再次 加密/解密
5. 不会对隐藏文件进行操作
6. 文件取名不能带有空格 (可以取名,但是在指定文件加密或者解密时会因为空格问题导致不能正确指定文件)
7. 目前是依赖于 node 环境的 (没有node环境将无效~)
8. 传参不能手动传 *, 要传 all, 传 * 会将路径解析出来再给到脚本,这样不行

## 待做
1. 目前是依赖于 node环境的,希望shell能一把嗦
2. 目前是防君子不防小人~~,因为并没有建立私钥的概念
3. 以后可以绑定 git,根据git 钩子来自动加密
4. 目前是无限往 .git 文件添加的,要去重