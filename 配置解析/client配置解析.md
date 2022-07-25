# client 配置解析

客户端的配置，CLI连接节点的配置

```to
###############################################################################
###                           Client Configuration                            ###
###############################################################################

# The network chain ID
# 链名
chain-id = "ghmdev"
# The keyring's backend, where the keys are stored (os|file|kwallet|pass|test|memory)
# keys 存储方式
keyring-backend = "test"
# CLI output format (text|json)
# 命令行的输出格式
output = "text"
# <host>:<port> to Tendermint RPC interface for this chain
# tendermint rpc 地址
node = "tcp://localhost:26657"
# Transaction broadcasting mode (sync|async|block)
# 广播交易的方式
broadcast-mode = "sync
```

