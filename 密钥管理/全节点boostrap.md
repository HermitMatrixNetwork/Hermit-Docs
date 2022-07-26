# 全节点boostrap

### 1. 远程证明

新的全节点验证引导节点`genesis.json`的远程证明证明，并为其自己的机器创建远程证明证明，以向网络显示该节点的 Enclave 是真实的。

### 2.生成注册密钥对

使用 HKDF-SHA256`hkdf_salt`和`nonce`（256 位真随机）导出私钥。从`registration_privkey`计算`registration_pubkey`

```
registration_privkey = hkdf({
  salt: hkdf_salt,
  ikm: Nonce-256bit ,
}); // 256 bits

registration_privkey = calculate_curve25519_pubkey(
  registration_pubkey
);
```

### 3. 授权全节点

节点需要发送`secretcli tx register auth`具有以下输入的交易：

- 远程证明证明节点的 Enclave 是真实的
- `registration_pubkey`
- 256 位真随机`nonce`

### 4. 网络接收认证

在共识层，在每个完整节点的 enclave 内，auth 交易都会进入网络验证节点：

- 接收`ghmcli tx register auth`交易
- 验证远程证明证明新节点的 Enclave 是真实的

### 5. 生成`seed_exchange_key`

`seed_exchange_key`：使用[AES-128-SIV](https://tools.ietf.org/html/rfc5297)加密密钥发送`consensus_seed`到新节点

该密钥是通过几个步骤得出的：

- 首先`seed_exchange_ikm`是使用[ECDH](https://en.wikipedia.org/wiki/Elliptic-curve_Diffie–Hellman) ( [x25519](https://tools.ietf.org/html/rfc7748#section-6) ) 与`consensus_seed_exchange_privkey`(存在于飞地中) 和`registration_pubkey`(这是全节点的公共标识符)

此 IKM 从未公开可用，并保护网络私有熵

```
seed_exchange_ikm = ecdh({
  privkey: consensus_seed_exchange_privkey,
  pubkey: registration_pubkey,
}); // 256 bits
```

在第二步`seed_exchange_key`中，使用 HKDF-SHA256`seed_exchange_ikm`和`nonce`. 将 Nonce发送`seed_exchange_key`到新节点时，Nonce 会以明文形式添加，它只是起到使每个节点`seed_exchange_key`唯一的作用。

```
seed_exchange_key = hkdf({
  salt: hkdf_salt,
  ikm: concat(seed_exchange_ikm, nonce),
}); // 256 bits
```

### 6.`consensus_seed`与新节点共享

步骤 5中`seed_exchange_key`生成的用于加密`consensus_seed`. 这个`AD`加密算法是新节点的公钥：`new_node_public_key`所有这些逻辑都在授权交易中完成。`ghmcli tx register auth`输出`encrypted_consensus_seed`

```
encrypted_consensus_seed = aes_128_siv_encrypt({
  key: seed_exchange_key,
  data: consensus_seed,
  ad: new_node_public_key,
});

return encrypted_consensus_seed;
```

加密的输出由新的全节点接收。新节点现在可以访问`encrypted_consensus_seed`并且必须解密为明文才能接收`consensus_seed`

### 7.新的全节点生成自己的`seed_exchange_key`

AES-128-SIV 加密密钥`seed_exchange_key`用于解密`consensus_seed`要导出此反向逻辑，请在步骤 5 中突出显示。

首先，`seed_exchange_ikm`使用[ECDH](https://en.wikipedia.org/wiki/Elliptic-curve_Diffie–Hellman) ( [x25519](https://tools.ietf.org/html/rfc7748#section-6) ) 和`consensus_seed_exchange_pubkey`(public in `genesis.json`) 和`registration_privkey`(仅在新节点的 Enclave 内可用) 得出相同的结果 这是 DH-key echange 的作用，因为这是步骤 5 中 IKM 生成的反向公共/私有输入.

```
seed_exchange_ikm = ecdh({
  privkey: registration_privkey,
  pubkey: consensus_seed_exchange_pubkey, // from genesis.json
}); // 256 bits
```
seed_exchange_key`使用 HKDF-SHA256`seed_exchange_ikm`和`nonce

```
seed_exchange_key = hkdf({
  salt: hkdf_salt,
  ikm: concat(seed_exchange_ikm, nonce),
}); // 256 bits
```

### 8. 解密`encrypted_consensus_seed`

encrypted_consensus_seed`使用 AES-128-SIV 加密，`seed_exchange_key`作为加密密钥，注册节点的公钥`ad`作为解密附加数据 新节点现在在其 Enclave 中包含所有这些参数，因此它能够从中解密`consensus_seed`然后`encrypted_consensus_seed`密封`consensus_seed。
```
consensus_seed = aes_128_siv_decrypt({
  key: seed_exchange_key,
  data: encrypted_consensus_seed,
  ad: new_node_public_key,
});

seal({
  key: "MRSIGNER",
  data: consensus_seed,
  to_file: "$HOME/.sgx_secrets/consensus_seed.sealed",
});
```