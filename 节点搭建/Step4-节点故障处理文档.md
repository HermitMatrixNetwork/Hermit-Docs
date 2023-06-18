# Hermit 节点问题处理文档

## 备份

如果节点是验证节点,则需要备份私钥等相关信息, 非验证节点不需要备份.

### 1. 助记词

```shell
# 导出ASCII-armored encrypted格式的助记词, 并保存到文件
ghmd keys export 名字
# 如果在新的服务器启动该验证节点, 则需要导入这个助记词
ghmd keys import 名字 /path/to/文件

# 如果想要导出并导入热钱包, 以下命令得到助记词
ghmd keys export 名字 --unarmored-hex --unsafe
```

### 2. priv_validator_key.json

```shell
# 复制并备份, 最好下载保存
cp .ghmd/config/priv_validator_key.json /path/to/backup
```

### 3. priv_validator_state.json

```
# 复制并备份, 最好下载保存
cp .ghmd/config/priv_validator_state.json /path/to/backup
```

## 原服务器重启故障验证节点

通常故障节点都是数据与主网不匹配导致. (分叉)

### 1. 停止节点

```shell
# 查看是否有节点进程在运行
ps aux | grep ghmd
# 如果有, 使用kill命令杀掉进程
kill pid
```

### 2. 删除链数据

```shell
# 进入data目录
cd ~/.ghmd/data/
# 备份priv_validator_state.json
mv ./priv_validator_state.json ../
# 删除所有文件
rm ./* -rf
# 把刚才备份的文件移动到当前目录
mv ../priv_validator_state.json ./
```

### 3. 重启节点

```shell
# 验证节点不建议用作rpc节点
nohup ghmd start >.ghmd/logs/nohup.out 2>&1 &
```

## 新服务器重启故障验证节点

### 1. 新服务器启动全节点

### 2. 导入助记词、priv_validator_key.json和priv_validator_state.json

```shell
# 把ASCII-armored encrypted格式的助记词文件、priv_validator_key.json和priv_validator_state.json文件上传到新服务对应的目录之中
助记词文件: /path/to/yourbackup
priv_validator_key.json: ~/.ghmd/config/
priv_validator_state.json: ~/.ghmd/data/
# 导入助记词到钱包
ghmd keys import 名字 /path/to/yourbackup/filename
```

### 3. 重启全节点

```
# 如果没有加入systemctl, 则杀掉ghmd进程在重启即可
```

