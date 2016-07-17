contract Log {
    struct IPFS {
    	bytes32 previous;
    	bytes32 next;
    	string hash1;
        string hash2;
    }

    uint public size;
    bytes32 public tail;
    bytes32 public head;
	
    mapping (bytes32 => address) public owners;
    mapping (bytes32 => IPFS) public registry;

    modifier isOwner(bytes32 name)
    {
        if (msg.sender != owners[name]) throw;
        _
    }
  
    modifier isInit(bytes32 name)
    {
        if (owners[name] != 0x0) throw;
        _
    }
  
    function publish (bytes32 name, string hash1, string hash2)
        isOwner(name)
        returns(bool)
    {
    	IPFS entry = registry[name];
        entry.hash1 = hash1;
        entry.hash2 = hash2;
        registry[name] = entry;
        return true;
    }
  
    function init (bytes32 name, string hash1, string hash2)
        isInit(name)
        returns(bool)
    {
        IPFS entry = registry[name];
        owners[name] = msg.sender;
        entry.hash1 = hash1;
        entry.hash2 = hash2;
        
        if(size == 0){
            tail = name;
            head = name;
        } else {
            registry[head].next = name;
            entry.previous = head;
            head = name;
        }
        size++;
        return true;
    }
}
