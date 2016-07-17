# Ethereum IPFS Log

A simple append only log of IPFS merkle dag objects in the Ethereum blockchain

## Index
- [Motivations](#motivations)
- [Logs](#logs)
- [Consensus](#consensus)
- [Challenges](#challenges)
- [Deploy](#deploy)
- [API](#api)
- [References](#references)

## Motivations
  - To enable distributed applications with low frequency state change.

  Ethereum IPFS Log attempts to leverge the strengths of a blockchain consensus algorithm, the data availablity of IPFS, and identity of PKI to provide a development stack for distibuted applications.

## Use Cases
  - Message logs:
    Log messages for chat appliations that require low write speeds. e.g. a twitter post.
  - Proof of Knowledge:
    Publish a hash in an earlier block and later reveal what that data is to prove you had ownership of that data in the past
  - Proof of receipt:
    Proof that something was received at a specific time.
  - Hash-based signature schemes:
    Guy Fawkes Signature, Lamport Signatures
  - Many, many, more


## Logs


#### Blockchains as an append only log

This is really making use of the fact that blockchains like bitcoin and ethereum are already append only logs. This provides a simple api to store arbitrary data in this log. 

#### Theory:
  
A database (e.g. an SQL table) is a snapshot of a state arrived at by computing an ordered list of operations over time. The key problem here is how to understand time. Append only logs provide a nice linear data structure for distributed systems. Since logs are append only, where records are stored from left to right, the notion of "time" or "timestamping" is built into the structure. This is essential to handling merge conflicts in distributed systems where global clocks can't be relied upon to provide consistency.

Logs also provide nice properties for 
 - CRDTS
 - Database operations logs
 - Feed of data
 - Versioning

#### Solidity Implementation:

The append only log is a doubly linked list. Each node in the list is a mapping from ```<key> name => <struct> IPFS``` where ```IPFS``` is a struct memory block containing the ipfs hash of the repository and any other desired meta information. 




## Consensus

Consensus is maintained by the Ethereum blockchain. This is currently using a PoW scheme but could one day be using another such as PoS. PoW chains like bitcoin and ethereum have been long describe as eventually consistent as it appears that miners forking and agreeing on the correct new blocks to add looks eventual. There have been ideas put forth recently that argue that we get more of a strong consistency from blockchains as reording of orphan blocks and forks probabily won't happen outside of the last six blocks.

So with a decently strong consistency garuntee clients will agree upon the current head of the state of the application. With a log data structure built around communtitve CRDT properties, we can be sure that all updates will make it to all nodes in a fairly quick mannor (the block time / confirmation times of the blockchain used).

## Challenges
  - blockchain scalability (tx / s)

  Currently the write speed of this distributed stack is limited to how fast miners can agree upon the current state of the blockchain that is housing our list. Ethereum has been tested at ~ 30 tps (transactions / s), which is upward of 3x faster than the bitcoin network, with a theoretical 10,000 tps when moving to PoS.

  Companies like Bigchain DB have looked into taking the nice properties of blockchains and developing them into a system of federated servers in an attempt to increase the write speeds but much work still needs to be done to accomplish a fully distributed stack with high write speed. 
  
## Deploy

to interface with the log, load the contract abi and instantiate with the contract address. Currently the log is running on a test net. ABI can be found at /contracts/logABI.js

#### contract ABI: ```web3.eth.contract(ABI)```

#### contract address:  ```0xb5f546d5bc8ab6ce0a4091c8bf906800627912cd```

#### test net info: ```--networkid 1337```


## API

### Javascript

``` 
const log = web3.eth.contract(ABI)
const logInstance = log.at('0x0')
```

#### Add

```logInstance.add(key, value)```

- Where key is the index to the items added to the log
- Value is the content stored in the log (ipfs hash)

#### Get Log Size

``logInstance.size()``

Returns an interger number of packages regiestered in the log


#### Get Log Head

``logInstance.head()``

Returns the key for the element at the head of the linked list


#### Get Log Tail

``logInstance.tail()``

Returns the key for the element at the tail of the linked list


#### Get Log Element by key

``logInstance.registry(key)``

Where

- key is a string value representing the package name
- Returns an array struct with values
 - next: key of the next element in the list
 - previous: key of the previous element in the list
 - hash: the ipfs multihash of the package 
 
More fields can be added to the struct like a version number in the future

## References 

The ideas here are not my own but a rather a collection of interesting ideas. Below are some of the more noticable influences on this log. 

[The Log](https://engineering.linkedin.com/distributed-systems/log-what-every-software-engineer-should-know-about-real-time-datas-unifying)

[Basho and Riak](http://basho.com/posts/technical/)

[HAL CRDT Reading](https://hal.archives-ouvertes.fr/hal-01101657)

[The Doubly Linked List by Eris Industries](https://docs.erisindustries.com/tutorials/solidity/solidity-2/)

