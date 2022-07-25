# genesis 配置解析

各个模块的详细信息：https://docs.cosmos.network/v0.46/modules/

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
  "genesis_time": "2022-06-16T06:50:23.979018759Z",
  "chain_id": "ghmdev",
  "initial_height": "1",
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

```json
 "authz": {
      "authorization": []
    },
```

#### bank

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

```json
"capability": {
    "index": "1",
    "owners": []
},
```

#### compute

```json
"compute": {
    "codes": [],
    "contracts": [],
    "sequences": []
}
```

#### crisis

```json
"crisis": {
    "constant_fee": {
        "denom": "uGHM",
        "amount": "1000"
    }
},
```

#### distribution

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

```json
"evidence": {
    "evidence": []
},
```

#### feegrant

```json
"feegrant": {
    "allowances": []
},
```

#### genutil

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

```json
"params": null,
```

#### register

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

```json
"upgrade": {}
```

#### vesting

```json
"vesting": {}
```

