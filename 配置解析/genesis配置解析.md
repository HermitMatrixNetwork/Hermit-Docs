# genesis 配置解析

各个模块的详细信息：https://docs.cosmos.network/v0.46/modules/

`ghmd init` 初始的

- 共识参数
- app_state
  - auth
  - authz
  - bank
  - capability
  - compute
  - feegrant
  - genutil
  - gov
  - ibc
  - mint
  - params
  - register
  - slashing
  - staking
  - transfer
  - upgrade
  - vesting

### 基本配置

```json
{
  // 创世文件的创建时间
  "genesis_time": "2022-06-16T06:50:23.979018759Z",
  // 链名
  "chain_id": "ghmdev",
  "initial_height": "1",
  //共识参数
  "consensus_params": {
    "block": {
      "max_bytes": "22020096",
      "max_gas": "-1",
      "time_iota_ms": "1000"
    },
    "evidence": {
      "max_age_num_blocks": "100000",
      "max_age_duration": "172800000000000",
      "max_bytes": "1048576"
    },
    "validator": {
      "pub_key_types": [
        "ed25519"
      ]
    },
    "version": {}
  },
  "app_hash"
	......
}
```

### 各个模块参数

#### auth

auth 模块负责指定应用程序的基本交易和帐户类型，包含以下参数：

| Key                    | Type   | Example |
| :--------------------- | :----- | :------ |
| MaxMemoCharacters      | uint64 | 256     |
| TxSigLimit             | uint64 | 7       |
| TxSizeCostPerByte      | uint64 | 10      |
| SigVerifyCostED25519   | uint64 | 590     |
| SigVerifyCostSecp256k1 | uint64 | 1000    |

参数解析：

MaxMemoCharacters   memo 的最大字符长度

TxSigLimit  交易签名个数限制

TxSizeCostPerByte   tx中每个byte消耗的gas

SigVerifyCostED25519 验证ED25519签名消耗的gas

SigVerifyCostSecp256k1 验证Secp256k1签名消耗的gas

配置参考：


```json
"auth": {
      "params": {
        "max_memo_characters": "256",
        "tx_sig_limit": "7",
        "tx_size_cost_per_byte": "10",
        "sig_verify_cost_ed25519": "590",
        "sig_verify_cost_secp256k1": "1000"
      },
      "accounts": [
        {
          "@type": "/cosmos.auth.v1beta1.BaseAccount",
          "address": "ghm15v4z6h7wjcrdx0pygxyvk3naaupgk6a64lfkt8",
          "pub_key": null,
          "account_number": "0",
          "sequence": "0"
        }
      ]
    }
```

#### authz

允许从一个帐户（授予者）向另一个帐户（被授予者）授予任意权限。链启动默认即可。

```json
 "authz": {
      "authorization": []
    },
```

#### bank

bank模块负责处理账户之间的多资产代币转账,有如下参数可以配置：

| Key                | Type          | Example                            |
| :----------------- | :------------ | :--------------------------------- |
| SendEnabled        | []SendEnabled | [{denom: "stake", enabled: true }] |
| DefaultSendEnabled | bool          | true                               |

配置参考：

```json
"bank": {
    "params": {
        "send_enabled": [],
        "default_send_enabled": true
    },
    "balances": [
        {
            "address": "ghm15v4z6h7wjcrdx0pygxyvk3naaupgk6a64lfkt8",
            "coins": [
                {
                    "denom": "uGHM",
                    "amount": "10000000000000"
                }
            ]
        }
    ],
    "supply": [],
    "denom_metadata": []
},
```

#### capability

链启动是默认即可，没有可配置参数

```json
"capability": {
    "index": "1",
    "owners": []
},
```

#### compute

用于处理合约运行的模块，链启动默认即可

```json
"compute": {
    "codes": [],
    "contracts": [],
    "sequences": []
}
```

#### crisis

危机模块在区块链不变量被破坏的情况下停止区块链。可以在应用程序初始化过程中向应用程序注册不变量， 有如下参数可以配置：

|             |               |         |
| :---------- | :------------ | :------ |
| Key         | Type          | Example |
| ConstantFee | object (coin) |         |

```json
"crisis": {
    "constant_fee": {
        "denom": "uGHM",
        "amount": "1000"
    }
},
```

#### distribution

分配机制描述了一种在验证者和委托人之间被动分配奖励的方式，有如下配置参数：

| Key                 | Type         | Example                    |
| :------------------ | :----------- | :------------------------- |
| communitytax        | string (dec) | "0.020000000000000000" [0] |
| baseproposerreward  | string (dec) | "0.010000000000000000" [0] |
| bonusproposerreward | string (dec) | "0.040000000000000000" [0] |
| withdrawaddrenabled | bool         | true                       |

communitytax  社区税率

baseproposerreward 出块基础奖励

bonusproposerreward 奖励税率

withdrawaddrenabled 是否可设置领取地址

communitytax  + baseproposerreward +bonusproposerreward 之和不能超过 1.00

配置参考：

```json
"distribution": {
    "params": {
        "community_tax": "0.020000000000000000",
        "base_proposer_reward": "0.010000000000000000",
        "bonus_proposer_reward": "0.040000000000000000",
        "withdraw_addr_enabled": true,
        "secret_foundation_tax": "0.000000000000000000",
        "secret_foundation_address": ""
    },
    "fee_pool": {
        "community_pool": []
    },
    "delegator_withdraw_infos": [],
    "previous_proposer": "",
    "outstanding_rewards": [],
    "validator_accumulated_commissions": [],
    "validator_historical_rewards": [],
    "validator_current_rewards": [],
    "delegator_starting_infos": [],
    "validator_slash_events": []
},
```

#### evidence

没有可配置的参数，默认即可。

```json
"evidence": {
    "evidence": []
},
```

#### feegrant

没有可配置的参数，默认即可。

```json
"feegrant": {
    "allowances": []
},
```

#### genutil

注册第一个验证器时候使用，参考节点运行即可，不是手动直接修改配置。

```json
"genutil": {
      "gen_txs": [
        {
          "body": {
            "messages": [
              {
                "@type": "/cosmos.staking.v1beta1.MsgCreateValidator",
                "description": {
                  "moniker": "banana",
                  "identity": "",
                  "website": "",
                  "security_contact": "",
                  "details": ""
                },
                "commission": {
                  "rate": "0.100000000000000000",
                  "max_rate": "0.200000000000000000",
                  "max_change_rate": "0.010000000000000000"
                },
                "min_self_delegation": "1",
                "delegator_address": "ghm15v4z6h7wjcrdx0pygxyvk3naaupgk6a64lfkt8",
                "validator_address": "ghmvaloper15v4z6h7wjcrdx0pygxyvk3naaupgk6a6e5rtrl",
                "pubkey": {
                  "@type": "/cosmos.crypto.ed25519.PubKey",
                  "key": "Ne9/LZwimJqDEC76u6v394b8UJcO6I4vGwTIr4ej7b4="
                },
                "value": {
                  "denom": "uGHM",
                  "amount": "100000000"
                }
              }
            ],
            "memo": "d613c155759d245dc5bfef08454a8ce735b6d566@167.179.118.118:26656",
            "timeout_height": "0",
            "extension_options": [],
            "non_critical_extension_options": []
          },
          "auth_info": {
            "signer_infos": [
              {
                "public_key": {
                  "@type": "/cosmos.crypto.secp256k1.PubKey",
                  "key": "A/xTvpg5Qd1Bn2a7AzltlrgJ71lNQZtx9paZOH4Mb/lJ"
                },
                "mode_info": {
                  "single": {
                    "mode": "SIGN_MODE_DIRECT"
                  }
                },
                "sequence": "0"
              }
            ],
            "fee": {
              "amount": [
                {
                  "denom": "uGHM",
                  "amount": "50000"
                }
              ],
              "gas_limit": "200000",
              "payer": "",
              "granter": ""
            }
          },
          "signatures": [
            "Luko2sJF0Gt4EMtuadSOgrWyW1Y0glAsfHI/hUTXQeNHmkPvgy3ERgDBJO0eyWZXj9vIqgaFA7rl/1jgsJX8cA=="
          ]
        }
      ]
    },
```

#### gov

治理模块， 可以配置的参数如下：

|               |        |                                                              |
| :------------ | :----- | :----------------------------------------------------------- |
| Key           | Type   | Example                                                      |
| depositparams | object | {"min_deposit":[{"denom":"uatom","amount":"10000000"}],"max_deposit_period":"172800000000000"} |
| votingparams  | object |                                                              |
| tallyparams   | object |                                                              |

##### SubKeys

| Key                | Type             | Example                                 |
| :----------------- | :--------------- | :-------------------------------------- |
| min_deposit        | array (coins)    | [{"denom":"uatom","amount":"10000000"}] |
| max_deposit_period | string (time ns) | "172800000000000"                       |
| voting_period      | string (time ns) | "172800000000000"                       |
| quorum             | string (dec)     | "0.334000000000000000"                  |
| threshold          | string (dec)     | "0.500000000000000000"                  |
| veto               | string (dec)     | "0.334000000000000000"                  |


参考配置：
```json
"gov": {
    "starting_proposal_id": "1",
    "deposits": [],
    "votes": [],
    "proposals": [],
    "deposit_params": {
        "min_deposit": [
            {
                "denom": "uGHM",
                "amount": "10000000"
            }
        ],
        "max_deposit_period": "172800s"
    },
    "voting_params": {
        "voting_period": "172800s"
    },
    "tally_params": {
        "quorum": "0.334000000000000000",
        "threshold": "0.500000000000000000",
        "veto_threshold": "0.334000000000000000"
    }
},
```

#### ibc

使用默认即可

```json
"ibc": {
    "client_genesis": {
        "clients": [],
        "clients_consensus": [],
        "clients_metadata": [],
        "params": {
            "allowed_clients": [
                "06-solomachine",
                "07-tendermint"
            ]
        },
        "create_localhost": false,
        "next_client_sequence": "0"
    },
    "connection_genesis": {
        "connections": [],
        "client_connection_paths": [],
        "next_connection_sequence": "0",
        "params": {
            "max_expected_time_per_block": "30000000000"
        }
    },
    "channel_genesis": {
        "channels": [],
        "acknowledgements": [],
        "commitments": [],
        "receipts": [],
        "send_sequences": [],
        "recv_sequences": [],
        "ack_sequences": [],
        "next_channel_sequence": "0"
    }
},
"icamsgauth": null,
"interchainaccounts": {
    "controller_genesis_state": {
        "active_channels": [],
        "interchain_accounts": [],
        "ports": [],
        "params": {
            "controller_enabled": true
        }
    },
    "host_genesis_state": {
        "active_channels": [],
        "interchain_accounts": [],
        "port": "icahost",
        "params": {
            "host_enabled": true,
            "allow_messages": []
        }
    }
},
```

#### mint

有如下可配置参数：

| Key                 | Type            | Example                |
| :------------------ | :-------------- | :--------------------- |
| MintDenom           | string          | "uGHM"                 |
| InflationRateChange | string (dec)    | "0.130000000000000000" |
| InflationMax        | string (dec)    | "0.200000000000000000" |
| InflationMin        | string (dec)    | "0.070000000000000000" |
| GoalBonded          | string (dec)    | "0.670000000000000000" |
| BlocksPerYear       | string (uint64) | "6311520"              |
| MaxTokenSupply      | string (dec)    |                        |

MintDenom 铸币的类型

InflationRateChange 通膨速率

InflationMax 最大通膨率

InflationMin 最小通膨率

GoalBonded 全网质押率

BlocksPerYear 每年出块量(仅仅计算通膨率)

max_token_supply  全网最大供应量

```json
"mint": {
    "minter": {
        "inflation": "0.130000000000000000",
        "annual_provisions": "0.000000000000000000"
    },
    "params": {
        "mint_denom": "uGHM",
        "inflation_rate_change": "0.130000000000000000",
        "inflation_max": "0.200000000000000000",
        "inflation_min": "0.070000000000000000",
        "goal_bonded": "0.670000000000000000",
        "blocks_per_year": "6311520",
        "max_token_supply": "10000000000000000000"
    }
},
```

#### params

默认即可

```json
"params": null,
```

#### register

并非手动修改

```json
"register": {
    "registration": [],
    "node_exch_master_certificate": {
        "bytes": ""
    },
    "io_master_certificate": {
        "bytes": ""
    }
},
```

#### slashing

可以配置参数：

| Key                     | Type           | Example                |
| :---------------------- | :------------- | :--------------------- |
| SignedBlocksWindow      | string (int64) | "100"                  |
| MinSignedPerWindow      | string (dec)   | "0.500000000000000000" |
| DowntimeJailDuration    | string (ns)    | "600000000000"         |
| SlashFractionDoubleSign | string (dec)   | "0.050000000000000000" |
| SlashFractionDowntime   | string (dec)   | "0.010000000000000000" |

SignedBlocksWindow 签名滑窗大小

MinSignedPerWindow 窗口内最低签名个数

DowntimeJailDuration 停机被 jail 时长

SlashFractionDoubleSign 双签罚金比例

SlashFractionDowntime  停机罚金比例

参考配置：


```json
"slashing": {
    "params": {
        "signed_blocks_window": "100",
        "min_signed_per_window": "0.500000000000000000",
        "downtime_jail_duration": "600s",
        "slash_fraction_double_sign": "0.050000000000000000",
        "slash_fraction_downtime": "0.010000000000000000"
    },
    "signing_infos": [],
    "missed_blocks": []
},
```

#### staking

质押模块可配置的参数：

| Key               | Type             | Example                |
| :---------------- | :--------------- | :--------------------- |
| UnbondingTime     | string (time ns) | "259200000000000"      |
| MaxValidators     | uint16           | 100                    |
| MaxEntries        | uint16           | 7                      |
| HistoricalEntries | uint16           | 3                      |
| BondDenom         | string           | "stake"                |
| MinCommissionRate | string           | "0.000000000000000000" |

UnbondingTime  解绑时间

MaxValidators  验证器最大个数

historical_entries  每个 abci begin 块调用，历史信息将根据`HistoricalEntries`参数被存储和修剪。

BondDenom 质押使用的币种

MinCommissionRate 最低佣金率


```json
"staking": {
      "params": {
        "unbonding_time": "1814400s",
        "max_validators": 100,
        "max_entries": 7,
        "historical_entries": 10000,
        "bond_denom": "uGHM"
      },
      "last_total_power": "0",
      "last_validator_powers": [],
      "validators": [],
      "delegations": [],
      "unbonding_delegations": [],
      "redelegations": [],
      "exported": false
    },
```

#### transfer

默认即可

```json
"transfer": {
    "port_id": "transfer",
    "denom_traces": [],
    "params": {
        "send_enabled": true,
        "receive_enabled": true
    }
},
```
#### upgrade

默认即可

```json
"upgrade": {}
```

#### vesting

默认即可

```json
"vesting": {}
```

