const process = require('process')
const fs = require('fs')
const path = require('path')
const Aesjs = require('./aes')

/**
 * 加密 (伪加密,只是转了一下格式,有需要可以直接用 aesjs 的对称加密)
 */
const Encrypt = (text) => {
  const _text = Aesjs.utils.utf8.toBytes(text)
  return _text.toString();
}

/**
 * 解密
 */
const Decrypt = (text) => {
  const _text = Uint8Array.of(...text.split(','))
  return Aesjs.utils.utf8.fromBytes(_text)
}

/**
 * 判断是否为文件
 */
const isFile = (file) => {
  return fs.statSync(file).isFile();
}

/**
 * 加密 / 解密 文件
 * isEncrypt 加密 / 解密 (默认为 加密)
 */
function setFile(filePath, isEncrypt = true) {
  if (isFile(filePath)) { // 文件
    if (filePath.charAt(0) === '.' || filePath === 'SELF_ENCRYPT') return;
    const data = fs.readFileSync(filePath, 'utf-8')
    fs.writeFileSync(filePath, isEncrypt ? Encrypt(data) : Decrypt(data));
  } else { // 文件夹
    fs.readdirSync(filePath).forEach((filename) => {
      if (filename.charAt(0) === '.' || filename === 'SELF_ENCRYPT') return;
      setFile(path.join(filePath, filename), isEncrypt);
    })
  }
}

const parmas = process.argv.slice(2);
const isEncrypt = parmas[0] === 'on';
const fileList = parmas.slice(1);
fileList.forEach((file) => {
  const filePath = path.resolve(__dirname, `../${file}`);
  setFile(filePath, isEncrypt);
})