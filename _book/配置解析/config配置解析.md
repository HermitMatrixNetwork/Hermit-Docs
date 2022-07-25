# config 配置解析

config.toml 用于配置 Tendermint. 在[Tendermint 的文档了解更多](https://docs.tendermint.com/master/nodes/configuration.html)

- 主要配置选项
- 高级配置选项
  -  rpc服务配置选项
  -  p2p配置选项
  -  内存池配置选项
  -  状态同步配置选项
  -  快速同步配置选项
  -  共识配置选型
  -  交易索引配置选项
  -  prometheus配置选项

### 主要的基础配置

```toml
#######################################################################
###                   Main Base Config Options                      ###
#######################################################################

# TCP or UNIX socket address of the ABCI application,
# or the name of an ABCI application compiled in with the Tendermint binary
proxy_app = "tcp://127.0.0.1:26658"

# A custom human readable name for this node
# 节点的别名
moniker = "banana"

# If this node is many blocks behind the tip of the chain, FastSync
# allows them to catchup quickly by downloading blocks in parallel
# and verifying their commits
# 如果这个节点在链的末端有很多块，FastSyn 允许他们通过并行下载块并验证他们的提交来快速追赶
fast_sync = true

# Database backend: goleveldb | cleveldb | boltdb | rocksdb | badgerdb
# * goleveldb (github.com/syndtr/goleveldb - most popular implementation)
#   - pure go
#   - stable
# * cleveldb (uses levigo wrapper)
#   - fast
#   - requires gcc
#   - use cleveldb build tag (go build -tags cleveldb)
# * boltdb (uses etcd's fork of bolt - github.com/etcd-io/bbolt)
#   - EXPERIMENTAL
#   - may be faster is some use-cases (random reads - indexer)
#   - use boltdb build tag (go build -tags boltdb)
# * rocksdb (uses github.com/tecbot/gorocksdb)
#   - EXPERIMENTAL
#   - requires gcc
#   - use rocksdb build tag (go build -tags rocksdb)
# * badgerdb (uses github.com/dgraph-io/badger)
#   - EXPERIMENTAL
#   - use badgerdb build tag (go build -tags badgerdb)
# db 设置：  goleveldb | cleveldb | boltdb | rocksdb | badgerdb
db_backend = "goleveldb"

# Database directory
# db 目录
db_dir = "data"

# Output level for logging, including package level options
# log 输出等级
log_level = "info"

# Output format: 'plain' (colored text) or 'json'
# log 格式 plain / json
log_format = "plain"

##### additional base config options #####

# Path to the JSON file containing the initial validator set and other meta data
# 创世文件路径
genesis_file = "config/genesis.json"

# Path to the JSON file containing the private key to use as a validator in the consensus protocol
# 包含在共识协议中用作验证器的私钥的 JSON 文件的路径
priv_validator_key_file = "config/priv_validator_key.json"

# Path to the JSON file containing the last sign state of a validator
# 包含验证器最后签名状态的 JSON 文件的路径
priv_validator_state_file = "data/priv_validator_state.json"

# TCP or UNIX socket address for Tendermint to listen on for
# connections from an external PrivValidator process
# Tendermint 监听的 TCP 或 UNIX 套接字地址来自外部 PrivValidator 进程的连接
priv_validator_laddr = ""

# Path to the JSON file containing the private key to use for node authentication in the p2p protocol
# 包含用于 p2p 协议中节点身份验证的私钥的 JSON 文件的路径
node_key_file = "config/node_key.json"

# Mechanism to connect to the ABCI application: socket | grpc
# 连接到 ABCI 应用程序的机制：socket | grpc
abci = "socket"

# If true, query the ABCI app on connecting to a new peer
# so the app can decide if we should keep the connection or not
filter_peers = false
```

### rpc服务配置选项

```toml
#######################################################
###       RPC Server Configuration Options          ###
#######################################################
[rpc]

# TCP or UNIX socket address for the RPC server to listen on
# tendenmint rpc 监听的地址
laddr = "tcp://127.0.0.1:26657"

# A list of origins a cross-domain request can be executed from
# Default value '[]' disables cors support
# Use '["*"]' to allow any origin
# 跨域配置
cors_allowed_origins = ["*"]

# A list of methods the client is allowed to use with cross-domain requests
# 跨域支持的请求方法
cors_allowed_methods = ["HEAD", "GET", "POST", ]

# A list of non simple headers the client is allowed to use with cross-domain requests
# 跨域支持的请求头
cors_allowed_headers = ["Origin", "Accept", "Content-Type", "X-Requested-With", "X-Server-Time", ]

# TCP or UNIX socket address for the gRPC server to listen on
# NOTE: This server only supports /broadcast_tx_commit
# gRPC 服务地址 
# NOTE：服务器只支持 broadcast_tx_commit
grpc_laddr = ""

# Maximum number of simultaneous connections.
# Does not include RPC (HTTP&WebSocket) connections. See max_open_connections
# If you want to accept a larger number than the default, make sure
# you increase your OS limits.
# 0 - unlimited.
# Should be < {ulimit -Sn} - {MaxNumInboundPeers} - {MaxNumOutboundPeers} - {N of wal, db and other open files}
# 1024 - 40 - 10 - 50 = 924 = ~900
# grpc 最大连接数
grpc_max_open_connections = 900

# Activate unsafe RPC commands like /dial_seeds and /unsafe_flush_mempool
# 不安全的 rpc 命令
unsafe = false

# Maximum number of simultaneous connections (including WebSocket).
# Does not include gRPC connections. See grpc_max_open_connections
# If you want to accept a larger number than the default, make sure
# you increase your OS limits.
# 0 - unlimited.
# Should be < {ulimit -Sn} - {MaxNumInboundPeers} - {MaxNumOutboundPeers} - {N of wal, db and other open files}
# 1024 - 40 - 10 - 50 = 924 = ~900
# 最大同时连接数
max_open_connections = 900

# Maximum number of unique clientIDs that can /subscribe
# If you're using /broadcast_tx_commit, set to the estimated maximum number
# of broadcast_tx_commit calls per block.
# 最大订阅数量
max_subscription_clients = 100

# Maximum number of unique queries a given client can /subscribe to
# If you're using GRPC (or Local RPC client) and /broadcast_tx_commit, set to
# the estimated # maximum number of broadcast_tx_commit calls per block.
# 给定客户端可以/订阅的唯一查询的最大数量
# 如果您正在使用 GRPC（或本地 RPC 客户端）和 /broadcast_tx_commit，请设置为估计的 
# 每个块的广播_tx_commit 调用的最大数量。
max_subscriptions_per_client = 5

# Experimental parameter to specify the maximum number of events a node will
# buffer, per subscription, before returning an error and closing the
# subscription. Must be set to at least 100, but higher values will accommodate
# higher event throughput rates (and will use more memory).
experimental_subscription_buffer_size = 200

# Experimental parameter to specify the maximum number of RPC responses that
# can be buffered per WebSocket client. If clients cannot read from the
# WebSocket endpoint fast enough, they will be disconnected, so increasing this
# parameter may reduce the chances of them being disconnected (but will cause
# the node to use more memory).
#
# Must be at least the same as "experimental_subscription_buffer_size",
# otherwise connections could be dropped unnecessarily. This value should
# ideally be somewhat higher than "experimental_subscription_buffer_size" to
# accommodate non-subscription-related RPC responses.
# 实验参数，用于指定每个 WebSocket 客户端可以缓冲的最大 RPC 响应数。 
# 如果客户端不能足够快地从 WebSocket 端点读取，它们将被断开，
# 因此增加此参数可能会降低它们断开连接的机会（但会导致节点使用更多内存）。
# 
# 必须至少与“experimental_subscription_buffer_size”相同，否则可能会不必要地丢弃连接。 
# 理想情况下，该值应略高于“experimental_subscription_buffer_size”以适应非订阅相关的 RPC 响应。
experimental_websocket_write_buffer_size = 200

# If a WebSocket client cannot read fast enough, at present we may
# silently drop events instead of generating an error or disconnecting the
# client.
#
# Enabling this experimental parameter will cause the WebSocket connection to
# be closed instead if it cannot read fast enough, allowing for greater
# predictability in subscription behaviour.
# 如果 WebSocket 客户端读取速度不够快，目前我们可能会静默丢弃事件，而不是生成错误或断开客户端连接。
experimental_close_on_slow_client = false

# How long to wait for a tx to be committed during /broadcast_tx_commit.
# WARNING: Using a value larger than 10s will result in increasing the
# global HTTP write timeout, which applies to all connections and endpoints.
# See https://github.com/tendermint/tendermint/issues/3435
# 在 broadcast_tx_commit 期间等待提交 tx 的时间。
# 警告：使用大于 10s 的值将导致增加全局 HTTP 写入超时，适用于所有连接和端点。
timeout_broadcast_tx_commit = "10s"

# Maximum size of request body, in bytes
# 请求body的最大值，单位 bytes
max_body_bytes = 1000000

# Maximum size of request header, in bytes
# 请求头最大的值， 单位 bytes
max_header_bytes = 1048576

# The path to a file containing certificate that is used to create the HTTPS server.
# Might be either absolute path or path related to Tendermint's config directory.
# If the certificate is signed by a certificate authority,
# the certFile should be the concatenation of the server's certificate, any intermediates,
# and the CA's certificate.
# NOTE: both tls_cert_file and tls_key_file must be present for Tendermint to create HTTPS server.
# Otherwise, HTTP server is run.
# 创建 https 服务使用的证书的路径
# 可能是绝对路径或与 Tendermint 配置目录相关的路径。
tls_cert_file = ""

# The path to a file containing matching private key that is used to create the HTTPS server.
# Might be either absolute path or path related to Tendermint's config directory.
# NOTE: both tls-cert-file and tls-key-file must be present for Tendermint to create HTTPS server.
# Otherwise, HTTP server is run.
# 包含用于创建 HTTPS 服务器的匹配私钥的文件的路径。
tls_key_file = ""

# pprof listen address (https://golang.org/pkg/net/http/pprof)
# pprof 监听地址
pprof_laddr = "localhost:6060"
```

### p2p服务配置选项

```toml
#######################################################
###           P2P Configuration Options             ###
#######################################################
[p2p]

# Address to listen for incoming connections
# p2p监听地址
laddr = "tcp://0.0.0.0:26656"

# Address to advertise to peers for them to dial
# If empty, will use the same port as the laddr,
# and will introspect on the listener or use UPnP
# to figure out the address. ip and port are required
# example: 159.89.10.97:26656
external_address = ""

# Comma separated list of seed nodes to connect to
# 要连接的种子节点的逗号分隔列表
seeds = ""

# Comma separated list of nodes to keep persistent connections to
# 保持持久连接的节点列表，使用逗号分隔
persistent_peers = ""

# UPNP port forwarding
upnp = false

# Path to address book
addr_book_file = "config/addrbook.json"

# Set true for strict address routability rules
# Set false for private or local networks
# 限制的地址可路由性规则设置
addr_book_strict = true

# Maximum number of inbound peers
# 入站节点的最大数量
max_num_inbound_peers = 320

# Maximum number of outbound peers to connect to, excluding persistent peers
# 出站连接节点的最大数量
max_num_outbound_peers = 40

# List of node IDs, to which a connection will be (re)established ignoring any existing limits
# 节点 ID 列表，将（重新）建立连接，忽略任何现有限制
unconditional_peer_ids = ""

# Maximum pause when redialing a persistent peer (if zero, exponential backoff is used)
# 重连持久对等节点时的最大暂停（如果为零，则使用指数退避）
persistent_peers_max_dial_period = "0s"

# Time to wait before flushing messages out on the connection
# 在连接上刷新消息之前等待的时间
flush_throttle_timeout = "100ms"

# Maximum size of a message packet payload, in bytes
# 消息包的最大字节数
max_packet_msg_payload_size = 1024

# Rate at which packets can be sent, in bytes/second
# 发送数据包的速率
send_rate = 5120000

# Rate at which packets can be received, in bytes/second
# 接收数据包速率
recv_rate = 5120000

# Set true to enable the peer-exchange reactor
# 设置为 true 以启用对等交换反应器
pex = true

# Seed mode, in which node constantly crawls the network and looks for
# peers. If another node asks it for addresses, it responds and disconnects.
#
# Does not work if the peer-exchange reactor is disabled.
# 种子模式，节点不断爬取网络并寻找对等点。 如果另一个节点向它询问地址，它会响应并断开连接。
# 如果对等交换反应器被禁用，则不起作用。
seed_mode = false

# Comma separated list of peer IDs to keep private (will not be gossiped to other peers)
# 私有节点ids列表
private_peer_ids = ""

# Toggle to disable guard against peers connecting from the same ip.
# 切换以禁用对从同一 IP 连接的对等方的防护。
allow_duplicate_ip = false

# Peer connection configuration.
# 对等连接设置
handshake_timeout = "20s"
dial_timeout = "3s"
```



### 内存池配置选项

```toml
#######################################################
###          Mempool Configuration Option          ###
#######################################################
[mempool]

recheck = true
broadcast = true
wal_dir = ""

# Maximum number of transactions in the mempool
# 内存池交易的最大数据量
size = 10000

# Limit the total size of all txs in the mempool.
# This only accounts for raw transactions (e.g. given 1MB transactions and
# max_txs_bytes=5MB, mempool will only accept 5 transactions).
# 限制内存池中所有 tx 的总大小。
max_txs_bytes = 1073741824

# Size of the cache (used to filter transactions we saw earlier) in transactions
# tx中缓存的大小（用于过滤我们之前看到的事务）
cache_size = 10000

# Do not remove invalid transactions from the cache (default: false)
# Set to true if it's not possible for any invalid transaction to become valid
# again in the future.
# 不要从缓存中删除无效事务（默认值：false）
keep-invalid-txs-in-cache = false

# Maximum size of a single transaction.
# NOTE: the max size of a tx transmitted over the network is {max_tx_bytes}.
# 单笔交易的最大值
max_tx_bytes = 1048576

# Maximum size of a batch of transactions to send to a peer
# Including space needed by encoding (one varint per transaction).
# XXX: Unused due to https://github.com/tendermint/tendermint/issues/5796
# 发送给对等方的一批交易的最大大小
max_batch_bytes = 0
```

### 状态同步配置选项

```toml
#######################################################
###         State Sync Configuration Options        ###
#######################################################
[statesync]
# State sync rapidly bootstraps a new node by discovering, fetching, and restoring a state machine
# snapshot from peers instead of fetching and replaying historical blocks. Requires some peers in
# the network to take and serve state machine snapshots. State sync is not attempted if the node
# has any local state (LastBlockHeight > 0). The node will have a truncated block history,
# starting from the height of the snapshot.
# 状态同步通过发现、获取和恢复状态机快速引导新节点
# 来自对等点的快照，而不是获取和重放历史块
# 获取和服务状态机快照的网络。 如果节点具有任何本地状态 (LastBlockHeight > 0)，则不会尝试状态同步。
enable = false

# RPC servers (comma-separated) for light client verification of the synced state machine and
# retrieval of state data for node bootstrapping. Also needs a trusted height and corresponding
# header hash obtained from a trusted source, and a period during which validators can be trusted.
#
# For Cosmos SDK-based chains, trust_period should usually be about 2/3 of the unbonding time (~2
# weeks) during which they can be financially punished (slashed) for misbehavior.
# RPC 服务器（逗号分隔），用于轻客户端验证同步状态机和检索状态数据以进行节点引导。
# 还需要从可信来源获得的可信高度和相应的标头哈希，以及可以信任验证者的时间段。
#
# 对于基于 Cosmos SDK 的链，trust_period 通常应该是解绑时间（约 2 周）的 2/3 左右，在此期间，它们可以因不当行为而受到经济惩罚（削减）。
rpc_servers = ""
trust_height = 0
trust_hash = ""
trust_period = "112h0m0s"

# Time to spend discovering snapshots before initiating a restore.
# 在启动还原之前发现快照时间。
discovery_time = "15s"

# Temporary directory for state sync snapshot chunks, defaults to the OS tempdir (typically /tmp).
# Will create a new, randomly named directory within, and remove it when done.
temp_dir = ""

# The timeout duration before re-requesting a chunk, possibly from a different
# peer (default: 1 minute).
# 重新请求块之前的超时持续时间，可能来自不同的对等体
chunk_request_timeout = "10s"

# The number of concurrent chunk fetchers to run (default: 1).
# 要运行的并发块获取器的数量
chunk_fetchers = "4"
```

### 快速同步配置选项

```toml
#######################################################
###       Fast Sync Configuration Connections       ###
#######################################################
[fastsync]

# Fast Sync version to use:
#   1) "v0" (default) - the legacy fast sync implementation
#   2) "v1" - refactor of v0 version for better testability
#   2) "v2" - complete redesign of v0, optimized for testability & readability
# 
# 要使用的快速同步版本：
# v0 传统的快速同步实现
# v1 重构 v0 版本以获得更好的可测试性
# v0 的完全重新设计，针对可测试性和可读性进行了优化
version = "v0"
```



### 共识配置选项

```toml
#######################################################
###         Consensus Configuration Options         ###
#######################################################
[consensus]

wal_file = "data/cs.wal/wal"

# How long we wait for a proposal block before prevoting nil
# 在 prevoting nil 之前我们等待提案块的时间
timeout_propose = "1s"
# How much timeout_propose increases with each round
# 每轮增加多少 timeout_propose
timeout_propose_delta = "500ms"
# How long we wait after receiving +2/3 prevotes for “anything” (ie. not a single block or nil)
# 我们在收到 +2/3 预选票后等待多长时间（即不是单个块或零）
timeout_prevote = "1s"
# How much the timeout_prevote increases with each round
# 每轮 timeout_prevote 增加多少
timeout_prevote_delta = "500ms"
# How long we wait after receiving +2/3 precommits for “anything” (ie. not a single block or nil)
# 我们在收到 +2/3 预提交后等待多长时间
timeout_precommit = "1s"
# How much the timeout_precommit increases with each round
# 每轮 timeout_precommit 增加多少
timeout_precommit_delta = "500ms"
# How long we wait after committing a block, before starting on the new
# height (this gives us a chance to receive some more precommits, even
# though we already have +2/3).
# 我们在提交一个块后等待多长时间，然后再开始新的高度
timeout_commit = "3s"

# How many blocks to look back to check existence of the node's consensus votes before joining consensus
# When non-zero, the node will panic upon restart
# if the same consensus key was used to sign {double_sign_check_height} last blocks.
# So, validators should stop the state machine, wait for some blocks, and then restart the state machine to avoid panic.
double_sign_check_height = 0

# Make progress as soon as we have all the precommits (as if TimeoutCommit = 0)
# 完成所有预提交后立即进行下一步
skip_timeout_commit = false

# EmptyBlocks mode and possible interval between empty blocks
# EmptyBlocks 模式和空块之间的可能间隔
create_empty_blocks = true
create_empty_blocks_interval = "0s"

# Reactor sleep duration parameters
# Reactor 休眠持续时间参数
peer_gossip_sleep_duration = "100ms"
peer_query_maj23_sleep_duration = "2s"
```

### 交易索引配置选项

```toml
#######################################################
###   Transaction Indexer Configuration Options     ###
#######################################################
[tx_index]

# What indexer to use for transactions
#
# The application will set which txs to index. In some cases a node operator will be able
# to decide which txs to index based on configuration set in the application.
#
# Options:
#   1) "null"
#   2) "kv" (default) - the simplest possible indexer, backed by key-value storage (defaults to levelDB; see DBBackend).
# 		- When "kv" is chosen "tx.height" and "tx.hash" will always be indexed.
# 索引配置
indexer = "kv
```

### Instrumentation配置选项

```toml
#######################################################
###       Instrumentation Configuration Options     ###
#######################################################
[instrumentation]

# When true, Prometheus metrics are served under /metrics on
# PrometheusListenAddr.
# Check out the documentation for the list of available metrics.
# 是否启用prometheus
prometheus = false

# Address to listen for Prometheus collector(s) connections
# 侦听 Prometheus 收集器连接的地址
prometheus_listen_addr = ":26660"

# Maximum number of simultaneous connections.
# If you want to accept a larger number than the default, make sure
# you increase your OS limits.
# 0 - unlimited.
# 最大同时连接数。
max_open_connections = 3

# Instrumentation namespace
namespace = "tendermint"
```



### 完整的config配置文件

```toml
#######################################################################
###                   Main Base Config Options                      ###
#######################################################################

# TCP or UNIX socket address of the ABCI application,
# or the name of an ABCI application compiled in with the Tendermint binary
proxy_app = "tcp://127.0.0.1:26658"

# A custom human readable name for this node
# 节点别名
moniker = "banana"

# If this node is many blocks behind the tip of the chain, FastSync
# allows them to catchup quickly by downloading blocks in parallel
# and verifying their commits
# 快速同步
fast_sync = true

# Database backend: goleveldb | cleveldb | boltdb | rocksdb | badgerdb
# * goleveldb (github.com/syndtr/goleveldb - most popular implementation)
#   - pure go
#   - stable
# * cleveldb (uses levigo wrapper)
#   - fast
#   - requires gcc
#   - use cleveldb build tag (go build -tags cleveldb)
# * boltdb (uses etcd's fork of bolt - github.com/etcd-io/bbolt)
#   - EXPERIMENTAL
#   - may be faster is some use-cases (random reads - indexer)
#   - use boltdb build tag (go build -tags boltdb)
# * rocksdb (uses github.com/tecbot/gorocksdb)
#   - EXPERIMENTAL
#   - requires gcc
#   - use rocksdb build tag (go build -tags rocksdb)
# * badgerdb (uses github.com/dgraph-io/badger)
#   - EXPERIMENTAL
#   - use badgerdb build tag (go build -tags badgerdb)
# 数据库的选型
db_backend = "goleveldb"

# Database directory
# 数据库目录
db_dir = "data"

# Output level for logging, including package level options
# 日志等级
log_level = "info"

# Output format: 'plain' (colored text) or 'json'
# 日志格式
log_format = "plain"

##### additional base config options #####

# Path to the JSON file containing the initial validator set and other meta data
# 创世文件路径
genesis_file = "config/genesis.json"

# Path to the JSON file containing the private key to use as a validator in the consensus protocol
# 验证者的私有路径
priv_validator_key_file = "config/priv_validator_key.json"

# Path to the JSON file containing the last sign state of a validator
# 验证人的最新签名的状态
priv_validator_state_file = "data/priv_validator_state.json"

# TCP or UNIX socket address for Tendermint to listen on for
# connections from an external PrivValidator process
priv_validator_laddr = ""

# Path to the JSON file containing the private key to use for node authentication in the p2p protocol
# 节点私钥
node_key_file = "config/node_key.json"

# Mechanism to connect to the ABCI application: socket | grpc
abci = "socket"

# If true, query the ABCI app on connecting to a new peer
# so the app can decide if we should keep the connection or not
filter_peers = false

#######################################################################
###                 Advanced Configuration Options                  ###
#######################################################################

#######################################################
###       RPC Server Configuration Options          ###
#######################################################
[rpc]

# TCP or UNIX socket address for the RPC server to listen on
laddr = "tcp://127.0.0.1:26657"

# A list of origins a cross-domain request can be executed from
# Default value '[]' disables cors support
# Use '["*"]' to allow any origin
# 跨域选项
cors_allowed_origins = ["*"]

# A list of methods the client is allowed to use with cross-domain requests
cors_allowed_methods = ["HEAD", "GET", "POST", ]

# A list of non simple headers the client is allowed to use with cross-domain requests
cors_allowed_headers = ["Origin", "Accept", "Content-Type", "X-Requested-With", "X-Server-Time", ]

# TCP or UNIX socket address for the gRPC server to listen on
# NOTE: This server only supports /broadcast_tx_commit
grpc_laddr = ""

# Maximum number of simultaneous connections.
# Does not include RPC (HTTP&WebSocket) connections. See max_open_connections
# If you want to accept a larger number than the default, make sure
# you increase your OS limits.
# 0 - unlimited.
# Should be < {ulimit -Sn} - {MaxNumInboundPeers} - {MaxNumOutboundPeers} - {N of wal, db and other open files}
# 1024 - 40 - 10 - 50 = 924 = ~900
grpc_max_open_connections = 900

# Activate unsafe RPC commands like /dial_seeds and /unsafe_flush_mempool
unsafe = false

# Maximum number of simultaneous connections (including WebSocket).
# Does not include gRPC connections. See grpc_max_open_connections
# If you want to accept a larger number than the default, make sure
# you increase your OS limits.
# 0 - unlimited.
# Should be < {ulimit -Sn} - {MaxNumInboundPeers} - {MaxNumOutboundPeers} - {N of wal, db and other open files}
# 1024 - 40 - 10 - 50 = 924 = ~900
max_open_connections = 900

# Maximum number of unique clientIDs that can /subscribe
# If you're using /broadcast_tx_commit, set to the estimated maximum number
# of broadcast_tx_commit calls per block.
max_subscription_clients = 100

# Maximum number of unique queries a given client can /subscribe to
# If you're using GRPC (or Local RPC client) and /broadcast_tx_commit, set to
# the estimated # maximum number of broadcast_tx_commit calls per block.
max_subscriptions_per_client = 5

# Experimental parameter to specify the maximum number of events a node will
# buffer, per subscription, before returning an error and closing the
# subscription. Must be set to at least 100, but higher values will accommodate
# higher event throughput rates (and will use more memory).
experimental_subscription_buffer_size = 200

# Experimental parameter to specify the maximum number of RPC responses that
# can be buffered per WebSocket client. If clients cannot read from the
# WebSocket endpoint fast enough, they will be disconnected, so increasing this
# parameter may reduce the chances of them being disconnected (but will cause
# the node to use more memory).
#
# Must be at least the same as "experimental_subscription_buffer_size",
# otherwise connections could be dropped unnecessarily. This value should
# ideally be somewhat higher than "experimental_subscription_buffer_size" to
# accommodate non-subscription-related RPC responses.
experimental_websocket_write_buffer_size = 200

# If a WebSocket client cannot read fast enough, at present we may
# silently drop events instead of generating an error or disconnecting the
# client.
#
# Enabling this experimental parameter will cause the WebSocket connection to
# be closed instead if it cannot read fast enough, allowing for greater
# predictability in subscription behaviour.
experimental_close_on_slow_client = false

# How long to wait for a tx to be committed during /broadcast_tx_commit.
# WARNING: Using a value larger than 10s will result in increasing the
# global HTTP write timeout, which applies to all connections and endpoints.
# See https://github.com/tendermint/tendermint/issues/3435
timeout_broadcast_tx_commit = "10s"

# Maximum size of request body, in bytes
max_body_bytes = 1000000

# Maximum size of request header, in bytes
max_header_bytes = 1048576

# The path to a file containing certificate that is used to create the HTTPS server.
# Might be either absolute path or path related to Tendermint's config directory.
# If the certificate is signed by a certificate authority,
# the certFile should be the concatenation of the server's certificate, any intermediates,
# and the CA's certificate.
# NOTE: both tls_cert_file and tls_key_file must be present for Tendermint to create HTTPS server.
# Otherwise, HTTP server is run.
tls_cert_file = ""

# The path to a file containing matching private key that is used to create the HTTPS server.
# Might be either absolute path or path related to Tendermint's config directory.
# NOTE: both tls-cert-file and tls-key-file must be present for Tendermint to create HTTPS server.
# Otherwise, HTTP server is run.
tls_key_file = ""

# pprof listen address (https://golang.org/pkg/net/http/pprof)
pprof_laddr = "localhost:6060"

#######################################################
###           P2P Configuration Options             ###
#######################################################
[p2p]

# Address to listen for incoming connections
laddr = "tcp://0.0.0.0:26656"

# Address to advertise to peers for them to dial
# If empty, will use the same port as the laddr,
# and will introspect on the listener or use UPnP
# to figure out the address. ip and port are required
# example: 159.89.10.97:26656
external_address = ""

# Comma separated list of seed nodes to connect to
seeds = ""

# Comma separated list of nodes to keep persistent connections to
persistent_peers = ""

# UPNP port forwarding
upnp = false

# Path to address book
addr_book_file = "config/addrbook.json"

# Set true for strict address routability rules
# Set false for private or local networks
addr_book_strict = true

# Maximum number of inbound peers
max_num_inbound_peers = 320

# Maximum number of outbound peers to connect to, excluding persistent peers
max_num_outbound_peers = 40

# List of node IDs, to which a connection will be (re)established ignoring any existing limits
unconditional_peer_ids = ""

# Maximum pause when redialing a persistent peer (if zero, exponential backoff is used)
persistent_peers_max_dial_period = "0s"

# Time to wait before flushing messages out on the connection
flush_throttle_timeout = "100ms"

# Maximum size of a message packet payload, in bytes
max_packet_msg_payload_size = 1024

# Rate at which packets can be sent, in bytes/second
send_rate = 5120000

# Rate at which packets can be received, in bytes/second
recv_rate = 5120000

# Set true to enable the peer-exchange reactor
pex = true

# Seed mode, in which node constantly crawls the network and looks for
# peers. If another node asks it for addresses, it responds and disconnects.
#
# Does not work if the peer-exchange reactor is disabled.
seed_mode = false

# Comma separated list of peer IDs to keep private (will not be gossiped to other peers)
private_peer_ids = ""

# Toggle to disable guard against peers connecting from the same ip.
allow_duplicate_ip = false

# Peer connection configuration.
handshake_timeout = "20s"
dial_timeout = "3s"

#######################################################
###          Mempool Configuration Option          ###
#######################################################
[mempool]

recheck = true
broadcast = true
wal_dir = ""

# Maximum number of transactions in the mempool
# 交易内存池大小
size = 10000

# Limit the total size of all txs in the mempool.
# This only accounts for raw transactions (e.g. given 1MB transactions and
# max_txs_bytes=5MB, mempool will only accept 5 transactions).
max_txs_bytes = 1073741824

# Size of the cache (used to filter transactions we saw earlier) in transactions
cache_size = 10000

# Do not remove invalid transactions from the cache (default: false)
# Set to true if it's not possible for any invalid transaction to become valid
# again in the future.
keep-invalid-txs-in-cache = false

# Maximum size of a single transaction.
# NOTE: the max size of a tx transmitted over the network is {max_tx_bytes}.
max_tx_bytes = 1048576

# Maximum size of a batch of transactions to send to a peer
# Including space needed by encoding (one varint per transaction).
# XXX: Unused due to https://github.com/tendermint/tendermint/issues/5796
max_batch_bytes = 0

#######################################################
###         State Sync Configuration Options        ###
#######################################################
[statesync]
# State sync rapidly bootstraps a new node by discovering, fetching, and restoring a state machine
# snapshot from peers instead of fetching and replaying historical blocks. Requires some peers in
# the network to take and serve state machine snapshots. State sync is not attempted if the node
# has any local state (LastBlockHeight > 0). The node will have a truncated block history,
# starting from the height of the snapshot.
enable = false

# RPC servers (comma-separated) for light client verification of the synced state machine and
# retrieval of state data for node bootstrapping. Also needs a trusted height and corresponding
# header hash obtained from a trusted source, and a period during which validators can be trusted.
#
# For Cosmos SDK-based chains, trust_period should usually be about 2/3 of the unbonding time (~2
# weeks) during which they can be financially punished (slashed) for misbehavior.
rpc_servers = ""
trust_height = 0
trust_hash = ""
trust_period = "112h0m0s"

# Time to spend discovering snapshots before initiating a restore.
discovery_time = "15s"

# Temporary directory for state sync snapshot chunks, defaults to the OS tempdir (typically /tmp).
# Will create a new, randomly named directory within, and remove it when done.
temp_dir = ""

# The timeout duration before re-requesting a chunk, possibly from a different
# peer (default: 1 minute).
chunk_request_timeout = "10s"

# The number of concurrent chunk fetchers to run (default: 1).
chunk_fetchers = "4"

#######################################################
###       Fast Sync Configuration Connections       ###
#######################################################
[fastsync]

# Fast Sync version to use:
#   1) "v0" (default) - the legacy fast sync implementation
#   2) "v1" - refactor of v0 version for better testability
#   2) "v2" - complete redesign of v0, optimized for testability & readability
version = "v0"

#######################################################
###         Consensus Configuration Options         ###
#######################################################
[consensus]

wal_file = "data/cs.wal/wal"

# How long we wait for a proposal block before prevoting nil
timeout_propose = "3s"
# How much timeout_propose increases with each round
timeout_propose_delta = "500ms"
# How long we wait after receiving +2/3 prevotes for “anything” (ie. not a single block or nil)
timeout_prevote = "1s"
# How much the timeout_prevote increases with each round
timeout_prevote_delta = "500ms"
# How long we wait after receiving +2/3 precommits for “anything” (ie. not a single block or nil)
timeout_precommit = "1s"
# How much the timeout_precommit increases with each round
timeout_precommit_delta = "500ms"
# How long we wait after committing a block, before starting on the new
# height (this gives us a chance to receive some more precommits, even
# though we already have +2/3).
timeout_commit = "5s"

# How many blocks to look back to check existence of the node's consensus votes before joining consensus
# When non-zero, the node will panic upon restart
# if the same consensus key was used to sign {double_sign_check_height} last blocks.
# So, validators should stop the state machine, wait for some blocks, and then restart the state machine to avoid panic.
double_sign_check_height = 0

# Make progress as soon as we have all the precommits (as if TimeoutCommit = 0)
skip_timeout_commit = false

# EmptyBlocks mode and possible interval between empty blocks
create_empty_blocks = true
create_empty_blocks_interval = "0s"

# Reactor sleep duration parameters
peer_gossip_sleep_duration = "100ms"
peer_query_maj23_sleep_duration = "2s"

#######################################################
###   Transaction Indexer Configuration Options     ###
#######################################################
[tx_index]

# What indexer to use for transactions
#
# The application will set which txs to index. In some cases a node operator will be able
# to decide which txs to index based on configuration set in the application.
#
# Options:
#   1) "null"
#   2) "kv" (default) - the simplest possible indexer, backed by key-value storage (defaults to levelDB; see DBBackend).
# 		- When "kv" is chosen "tx.height" and "tx.hash" will always be indexed.
indexer = "kv"

#######################################################
###       Instrumentation Configuration Options     ###
#######################################################
[instrumentation]

# When true, Prometheus metrics are served under /metrics on
# PrometheusListenAddr.
# Check out the documentation for the list of available metrics.
prometheus = false

# Address to listen for Prometheus collector(s) connections
prometheus_listen_addr = ":26660"

# Maximum number of simultaneous connections.
# If you want to accept a larger number than the default, make sure
# you increase your OS limits.
# 0 - unlimited.
max_open_connections = 3

# Instrumentation namespace
namespace = "tendermint"
```

