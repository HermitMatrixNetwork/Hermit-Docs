# 全节点搭建

搭建全节点，意思就是网络中至少有一个引导节点了。

## 一 环境检查

- 检查SGX 环境是否安装。以下命令检查

```bash
# 检查是否有对应的 isgx 设备
ls -h /dev/isgx

# 检查 aesmd 服务是否正常
service  aesmd status 
```

如果相关环境不正常请重新安装sgx 环境

- 检查是否安装了 hermitmatrixnetwork 包

```bash
# 使用命令输出内容，则安装过了，不用再安装
# 没有则说明没有安装， 请参考环境搭建文件，下载最新的安装包
ghmd -h
```

- 检查网络环境

​	需要将26656 端口打开， 这个端口是p2p 端口，同步区块数据使用p2p端口

```bash
# 打开端口, 如果已经打开请忽略
ufw allow 26656
```

## 二 初始化 enclave

### 2.1 创建enclave 相关的环境变量

- 创建存放证书目录

```bash
# 创建存放sgx远程证明证书的目录
# 这个证书有因特尔签名的报告
mkdir -p /opt/ghm/.sgx_ghms
```

- 创建环境变量

```bash
# 创建环境变量
# /usr/lib 下存放了三个重要的.so 动态库，与sgx相关
export GHM_ENCLAVE_DIR=/usr/lib
export GHM_SGX_STORAGE=/opt/ghm/.sgx_ghms
```

### 2.2 执行初始化

```bash
# 这个命令会生成一个英特尔签名的远程证明证书
ghmd init-enclave
```

### 2.3 检查初始化是否成功

```bash
# 主要检查是否有生成证书， 有证书则初始化成功
ls -h /opt/ghm/.sgx_ghms/attestation_cert.der
```

## 三 节点加入网络

### 3.1 链信息配置

1. 指向引导节点 或者 可信的全节点

```bash
# 指向引导节点 or 可信的全节点
ghmd config node tcp://45.32.116.172:26657
```

2. 给自己的节点配置一个名字（使用英文）

```bash
ghmd init banana --chain-id ghmdev
# - banana 就是节点的名字， 可以自己去，可以是 caca, any, kfuk, 
# - chain-id  参数就是你要加入的链名称，现在主网为Hermit
```

3. 创建一个钱包，这个钱包的地址用来管理节点，是这个节点的管理员。

```bash
# 设置钱包是测试模式
ghmd config keyring-backend test

# 创建一个钱包，用户管理这个节点
ghmd keys add dafni
# - dafni 就是钱包的名字，这个钱包的地址是用来管理节点的
```

### 3.2 给钱包转代币

在引导节点上操作，使用余额充足的账号转给刚刚创建的钱包。

```bash
# 转账命令
ghmd tx bank send ghm1jvtdv8674llygwn8s0d7z47uctyjf9uxu9p8k4
ghm17tuk77p0eqs8nqevwhqs9lrsqm54e56uef6rey 1050000ughm --gas-prices 0.0125ughm

# ghmd tx bank send <from_addr> <to_address> amount --gas-prices 0.0125ughm
# 上面命令是举例子，实际操作中替换成自己的地址，
```

### 3.3 获取p2p地址

- 在引导节点获取（or 已有的全节点上），命令如下

```bash
# 节点p2p地址
ghmd tendermint show-node-id
```

- 回到自己的节点中，将p2p地址写入配置中

```bash
# 在实际操作中
# bdc731280afb3c1fa8e6396eda4be59b333b3fc5 是需要替换为刚才获取的p2p地址
# 45.32.116.172:26656 是需要替换为引导节点(or全节点) 的真实IP
# 以下是举例子，实操替换为真实的种子和 ip 
PERSISTENT_PEERS="bdc731280afb3c1fa8e6396eda4be59b333b3fc5@45.32.116.172:26656"

# 将写入文件
sed -i 's/persistent_peers = ""/persistent_peers = "'$PERSISTENT_PEERS'"/g' ~/.ghmd/config/config.toml

# 打印种子
echo "Set persistent_peers: $PERSISTENT_PEERS"
```

### 3.4 发送注册交易

```bash
# 注册节点
ghmd tx register auth /opt/ghm/.sgx_ghms/attestation_cert.der -y --from dafni --gas-prices 0.25ughm
```

注意： --from dafni  就是刚才钱包的名字，如果你给钱包取名为 abc, 那就是 --from abc

检查交易是否成功，失败则获取不到种子，返回检查是否有步骤出错

### 3.5 提取链的共享种子 seed


```bash
# 先提取公钥
PUBLIC_KEY=$(ghmd parse /opt/ghm/.sgx_ghms/attestation_cert.der 2> /dev/null | cut -c 3- )

# 注册成功则可以拿到共享种子
SEED=$(ghmd q register seed "$PUBLIC_KEY" 2> /dev/null | cut -c 3-)

# 打印种子信息，看是否为空，确保不能为空
echo "SEED: $SEED"
```

### 3.6 设置网络证书

```bash
# 设置网络证书，这个命令会生产两个证书
ghmd q register secret-network-params 2> /dev/null

ghmd configure-secret node-master-cert.der "$SEED"
```

### 3.7 替换创世文件

从引导节点中下载创世文件，然后替换自己节点的创世文件

```bash
# 下载创世文件，替换 (.ghm/config/genesis.json)
# 使用引导节点的genesis.json
xxxxx

# 替换完成后，检查下
# 校验创世文建是否有效
ghmd  validate-genesis
```

### 3.8 运行节点

完成设置上面准备后，准备运行节点

```bash
# 指回自己
ghmd config node tcp://localhost:26657

mkdir logs  // 创建一个logs 文件夹，仅仅方便自己看的

# 运行节点
nohup ghmd start >./logs/nohup.out 2>&1 & 
```

或者写个脚本

```bash
ghmd start
```

### 3.9 检查是否成功

```bash
# 1 可以使用ghmd 
ghmd status  

# 2 查看网络监听
netstat -ntlp

# 3 可以查看日志，检查是否在同步
tail -f logs/nohup.out
```



## 四 全节点成为验证人

全节点已经运行起来之后，在同步完成就可以发起一笔交易成为验证人。

命令如下：

```bash
# 注意 1 GHM = 1000000ughm
  ghmd tx staking create-validator \
  --amount=1000000ughm \
  --pubkey=$(ghmd tendermint show-validator) \
  --identity=caca-boxi \
  --details="To infinity and beyond!" \
  --commission-rate="0.10" \
  --commission-max-rate="0.20" \
  --commission-max-change-rate="0.01" \
  --min-self-delegation="1" \
  --moniker=caca \
  --from=caca \
  --chain-id=ghmdev \
  --gas-prices 0.25ughm
```

- --moniker  是指你自己节点的名字， 在`ghmd init banana --chain-id ghmdev`这个命令设置的这个， 这里是 banana, 实际中需要改为自己取得。
-  --from  是在`ghmd keys add dafni` 这里取得， 治理是dafni， 
