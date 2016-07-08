# Ethereum IPFS Log

A simple append only log of IPFS merkle dag objects in the Ethereum blockchain

## API

to interface with the log two functions are exposed.

### Init

```regInstance.init(key, value)```

- Where key is the index to the items added to the log
- Value is the content stored in the log (ipfs hash)

The public key used in the signing of the init transaction will be given ownership of the node added to the linked list. From this point on only that public key can change the data in the node.

### Add

```regInstance.add(key, value)```

- Where key is the index to the items added to the log
- Value is the content stored in the log (ipfs hash)

The log is set to only allow the public that initialized the entry to be able to publish new information to it. 
