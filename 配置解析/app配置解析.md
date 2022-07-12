# app 配置解析

由 Cosmos SDK 生成，用于配置应用程序

app.toml 配置文件路径：  .ghmd/config/app.toml



常用的应用配置

- 基本配置
- Telemetry 配置
- api 配置
- Rosetta 配置
- grpc 配置
- grpc web 配置
- 状态同步配置
- wasm vm 内存配置

```toml
###############################################################################
###                                基本配置                                  ###
###############################################################################
# 验证器处理交易的最低 gas prices
minimum-gas-prices = "0.0125uGHM"

# 修剪策略配置
# default: 以10个块为间隔进行修剪
# noting: 所有历史的状态都会被保存，不会被删除
# everything: 所有的状态都会被删除，仅保存当前的状态和之前的；以10个块为间隔进行修剪
# custom: 自定义修剪， 需要结合'pruning-keep-recent', 'pruning-keep-every', and 'pruning-interval' 定义
pruning = "default"

# 只有使用自定义策略时候使用
pruning-keep-recent = "0"
pruning-keep-every = "0"
pruning-interval = "0"


# 链停止高度， 当区块在这个高度是优雅的停止，用于升级，测试
halt-height = 0

halt-time = 0

# tendermint 的修剪策略
min-retain-blocks = 0

# InterBlockCache enables inter-block caching.
inter-block-cache = true

# 事件索引集合
# Example:
# ["message.sender", "message.recipient"]
index-events = []

###############################################################################
###                         Telemetry Configuration                         ###
###############################################################################

[telemetry]

# Prefixed with keys to separate services.
service-name = ""

# Enabled enables the application telemetry functionality. When enabled,
# an in-memory sink is also enabled by default. Operators may also enabled
# other sinks such as Prometheus.
enabled = false

# Enable prefixing gauge values with hostname.
enable-hostname = false

# Enable adding hostname to labels.
enable-hostname-label = false

# Enable adding service to labels.
enable-service-label = false

# PrometheusRetentionTime, when positive, enables a Prometheus metrics sink.
prometheus-retention-time = 0

# GlobalLabels defines a global set of name/value label tuples applied to all
# metrics emitted using the wrapper functions defined in telemetry package.
#
# Example:
# [["chain_id", "cosmoshub-1"]]
global-labels = [
]

###############################################################################
###                           API Configuration                             ###
###############################################################################

[api]

# Enable defines if the API server should be enabled.
# 是否开始api 服务
enable = true

# Swagger defines if swagger documentation should automatically be registered.
# swagger 开启
swagger = true

# Address defines the API server to listen on.
# api服务地址
address = "tcp://0.0.0.0:1317"

# MaxOpenConnections defines the number of maximum open connections.
# 最大连接数量
max-open-connections = 1000

# RPCReadTimeout defines the Tendermint RPC read timeout (in seconds).
# 读取超时时间
rpc-read-timeout = 10

# RPCWriteTimeout defines the Tendermint RPC write timeout (in seconds).
# 写超时时间
rpc-write-timeout = 0

# RPCMaxBodyBytes defines the Tendermint maximum response body (in bytes).
# 返回body 大小
rpc-max-body-bytes = 1000000

# EnableUnsafeCORS defines if CORS should be enabled (unsafe - use it at your own risk).
# 跨域开启
enabled-unsafe-cors = true

###############################################################################
###                           Rosetta Configuration                         ###
###############################################################################

[rosetta]

# Enable defines if the Rosetta API server should be enabled.
enable = false

# Address defines the Rosetta API server to listen on.
address = ":8080"

# Network defines the name of the blockchain that will be returned by Rosetta.
blockchain = "app"

# Network defines the name of the network that will be returned by Rosetta.
network = "network"

# Retries defines the number of retries when connecting to the node before failing.
retries = 3

# Offline defines if Rosetta server should run in offline mode.
offline = false

###############################################################################
###                           gRPC Configuration                            ###
###############################################################################

[grpc]

# Enable defines if the gRPC server should be enabled.
enable = true

# Address defines the gRPC server address to bind to.
address = "0.0.0.0:9090"

###############################################################################
###                        gRPC Web Configuration                           ###
###############################################################################

[grpc-web]

# GRPCWebEnable defines if the gRPC-web should be enabled.
# NOTE: gRPC must also be enabled, otherwise, this configuration is a no-op.
enable = true

# Address defines the gRPC-web server address to bind to.
address = "0.0.0.0:9091"

# EnableUnsafeCORS defines if CORS should be enabled (unsafe - use it at your own risk).
#enable-unsafe-cors = false
enable-unsafe-cors = true

###############################################################################
###                        State Sync Configuration                         ###
###############################################################################

# State sync snapshots allow other nodes to rapidly join the network without replaying historical
# blocks, instead downloading and applying a snapshot of the application state at a given height.
# 快照配置
[state-sync]

# snapshot-interval specifies the block interval at which local state sync snapshots are
# taken (0 to disable). Must be a multiple of pruning-keep-every.
# 指定本地状态同步快照的块间隔， pruning-keep-every 的倍数
snapshot-interval = 0

# snapshot-keep-recent specifies the number of recent snapshots to keep and serve (0 to keep all).
# 保存最新快照的数量
snapshot-keep-recent = 2

[wasm]
# The maximum gas amount can be spent for contract query.
# The contract query will invoke contract execution vm,
# so we need to restrict the max usage to prevent DoS attack
# 合约查询消耗的最大gas
contract-query-gas-limit = "10000000"

# The WASM VM memory cache size in MiB not bytes
# wasm 虚拟机的内存大小
contract-memory-cache-size = "0"

# The WASM VM memory cache size in number of cached modules. Can safely go up to 15, but not recommended for validators
# 缓存模块数中的 WASM VM 内存缓存大小。 可以安全地增加到 15，但不建议验证者使用
contract-memory-enclave-cache-size = "0"
```

