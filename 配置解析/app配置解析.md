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



### app基本配置

```toml
###############################################################################
###                           Base Configuration                            ###
###############################################################################

# The minimum gas prices a validator is willing to accept for processing a
# transaction. A transaction's fees must meet the minimum of any denomination
# specified in this config (e.g. 0.25token1;0.0001token2).
# 验证人处理交易的最低可接受的 gas-prices
# 交易费用必须满足此配置中指定的任何面额的最低要求
minimum-gas-prices = "0.0125ughm"

# default: the last 100 states are kept in addition to every 500th state; pruning at 10 block intervals
# nothing: all historic states will be saved, nothing will be deleted (i.e. archiving node)
# everything: all saved states will be deleted, storing only the current and previous state; pruning at 10 block intervals
# custom: allow pruning options to be manually specified through 'pruning-keep-recent', 'pruning-keep-every', and 'pruning-interval'
# 这个是状态修剪策略配置，有四个选项：
# default:
# nothing:
# everything:
# custom:
pruning = "default"

# These are applied if and only if the pruning strategy is custom.
# 如果选了 custom 修建策略，需要手动配置一下参数
pruning-keep-recent = "0"
pruning-keep-every = "0"
pruning-interval = "0"

# HaltHeight contains a non-zero block height at which a node will gracefully
# halt and shutdown that can be used to assist upgrades and testing.
#
# Note: Commitment of state will be attempted on the corresponding block.

# HaltHeight 包含一个非零的块高度，节点将在该高度处优雅地停止和关闭，可用于协助升级和测试。
# Note: 将在相应的块上尝试提交状态
halt-height = 0

# HaltTime contains a non-zero minimum block time (in Unix seconds) at which
# a node will gracefully halt and shutdown that can be used to assist upgrades
# and testing.
#
# Note: Commitment of state will be attempted on the corresponding block.
# HaltTime 包含一个非零的最小阻塞时间（以 Unix 秒为单位），在该时间节点将优雅地停止和关闭，可用于协助升级和测试。
halt-time = 0

# MinRetainBlocks defines the minimum block height offset from the current
# block being committed, such that all blocks past this offset are pruned
# from Tendermint. It is used as part of the process of determining the
# ResponseCommit.RetainHeight value during ABCI Commit. A value of 0 indicates
# that no blocks should be pruned.
#
# This configuration value is only responsible for pruning Tendermint blocks.
# It has no bearing on application state pruning which is determined by the
# "pruning-*" configurations.
#
# Note: Tendermint block pruning is dependant on this parameter in conunction
# with the unbonding (safety threshold) period, state pruning and state sync
# snapshot parameters to determine the correct minimum value of
# ResponseCommit.RetainHeight.

# MinRetainBlocks 定义了与当前正在提交的块的最小块高度偏移量，这样所有超过此偏移量的块都将从 
# Tendermint 中删除。 它用作在 ABCI 提交期间确定 ResponseCommit.RetainHeight 值的过程的一部分。 
# 值 0 表示不应修剪任何块。
#
# 此配置值仅负责修剪 Tendermint 块。它与由“pruning-*”配置确定的应用程序状态修剪无关。
# 
# Note:Tendermint 块修剪依赖于此参数与解绑（安全阈值）周期、状态修剪和状态同步快照参数一起确
# ResponseCommit.RetainHeight 的正确最小值。
min-retain-blocks = 0

# InterBlockCache enables inter-block caching.
# 启用块缓存
inter-block-cache = true

# IndexEvents defines the set of events in the form {eventType}.{attributeKey},
# which informs Tendermint what to index. If empty, all events will be indexed.
#
# Example:
# ["message.sender", "message.recipient"]
#
# IndexEvents 以 {eventType}.{attributeKey} 的形式定义事件集，通知 Tendermint 要索引的内容。 
# 如果为空，所有事件都将被索引。
index-events = []

# IavlCacheSize set the size of the iavl tree cache. 
# Default cache size is 50mb.
# IavlCacheSize 设置iavl 树缓存的大小。默认是50mb
iavl-cache-size = 781250
```

### Telemetry 配置

```toml
###############################################################################
###                         Telemetry Configuration                         ###
###############################################################################

[telemetry]

# Prefixed with keys to separate services.
# 区分服务的key前缀
service-name = ""

# Enabled enables the application telemetry functionality. When enabled,
# an in-memory sink is also enabled by default. Operators may also enabled
# other sinks such as Prometheus.
# Enabled 启用应用程序遥测功能。 
# 启用后，默认情况下也会启用内存接收器。 运营者还可以启用其他接收器，例如 Prometheus。
enabled = false

# Enable prefixing gauge values with hostname.
# 启用带有主机名的仪表值前缀。
enable-hostname = false

# Enable adding hostname to labels.
# 启用将主机名添加到标签。
enable-hostname-label = false

# Enable adding service to labels.
# 启用将服务名添加到标签。
enable-service-label = false

# PrometheusRetentionTime, when positive, enables a Prometheus metrics sink.
# PrometheusRetentionTime 为正时，启用 Prometheus 指标接收器。
prometheus-retention-time = 0

# GlobalLabels defines a global set of name/value label tuples applied to all
# metrics emitted using the wrapper functions defined in telemetry package.
#
# Example:
# [["chain_id", "cosmoshub-1"]]
# GlobalLabels 定义了一组全局名称/值标签元组，应用于使用监控包中定义的包装函数发出的所有metrics。
global-labels = [
]
```

### api配置

```toml
###############################################################################
###                           API Configuration                             ###
###############################################################################

[api]

# Enable defines if the API server should be enabled.
# 是否启用api服务
enable = true

# Swagger defines if swagger documentation should automatically be registered.
# 是否开启swagger文档服务
swagger = true

# Address defines the API server to listen on.
# api 监听端口
address = "tcp://0.0.0.0:1317"

# MaxOpenConnections defines the number of maximum open connections.
# 定义最大连接数
max-open-connections = 1000

# RPCReadTimeout defines the Tendermint RPC read timeout (in seconds).
# 定义 Tendermint RPC 读取超时时间
rpc-read-timeout = 10

# RPCWriteTimeout defines the Tendermint RPC write timeout (in seconds).
# 定义 Tendermint RPC 写入超时时间
rpc-write-timeout = 0

# RPCMaxBodyBytes defines the Tendermint maximum response body (in bytes).
# 定义了 Tendermint 最大响应body的大小
rpc-max-body-bytes = 1000000

# EnableUnsafeCORS defines if CORS should be enabled (unsafe - use it at your own risk).
enabled-unsafe-cors = true

```

### rosetta配置

```toml
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
```

### grpc配置

```toml
###############################################################################
###                           gRPC Configuration                            ###
###############################################################################

[grpc]

# Enable defines if the gRPC server should be enabled.
# 是否开启grpc服务
enable = true

# Address defines the gRPC server address to bind to.
# grpc服务监听端口
address = "0.0.0.0:9090"
```

### grpc web配置

```toml
###############################################################################
###                        gRPC Web Configuration                           ###
###############################################################################

[grpc-web]

# GRPCWebEnable defines if the gRPC-web should be enabled.
# NOTE: gRPC must also be enabled, otherwise, this configuration is a no-op.
# 是否开启grpc web服务
# 如果开启， 那么grpc 也需要开启
enable = true

# Address defines the gRPC-web server address to bind to.
# 服务监听端口
address = "0.0.0.0:9091"

# EnableUnsafeCORS defines if CORS should be enabled (unsafe - use it at your own risk).
#enable-unsafe-cors = false
# 是否开启跨域
enable-unsafe-cors = true
```

### 状态同步配置

```toml
###############################################################################
###                        State Sync Configuration                         ###
###############################################################################

# State sync snapshots allow other nodes to rapidly join the network without replaying historical
# blocks, instead downloading and applying a snapshot of the application state at a given height.
# 状态同步快照允许其他节点快速加入网络而无需重播历史块，而是下载并应用给定高度的应用程序状态快照。
[state-sync]

# snapshot-interval specifies the block interval at which local state sync snapshots are
# taken (0 to disable). Must be a multiple of pruning-keep-every.
# snapshot-interval 指定拍摄本地状态同步快照的块间隔（0 表示禁用）。 
# 必须是 pruning-keep-every 的倍数。
snapshot-interval = 0

# snapshot-keep-recent specifies the number of recent snapshots to keep and serve (0 to keep all).
# snapshot-keep-recent 指定要保留服务的最近快照的数量（0 表示全部保留）。
snapshot-keep-recent = 2

```

### wasm vm内存配置

```toml
[wasm]
# The maximum gas amount can be spent for contract query.
# The contract query will invoke contract execution vm,
# so we need to restrict the max usage to prevent DoS attack
# 合约查询可以消耗的最大gas量。合约查询会调用合约执行vm，所以我们需要限制最大使用量来防止DoS攻击
contract-query-gas-limit = "10000000"

# The WASM VM memory cache size in MiB not bytes
# 以 MiB 为单位的 WASM VM 内存缓存大小，而不是字节 
contract-memory-cache-size = "0"

# The WASM VM memory cache size in number of cached modules. Can safely go up to 15, but not recommended for validators
# 缓存模块数中的 WASM VM 内存缓存大小。 可以安全地增加到 15，但不建议验证者使用
contract-memory-enclave-cache-size = "0"
```

### 完整的配置文件 

```toml
###############################################################################
###                                基本配置                                  ###
###############################################################################
# 验证器处理交易的最低 gas prices
minimum-gas-prices = "0.0125ughm"

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

