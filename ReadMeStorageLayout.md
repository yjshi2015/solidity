# Solidity中Storage存储的规则
+ 存储插槽的第一项会以低位对齐（即右对齐）的方式储存。
+ 值类型只使用存储它们所需的字节数。
+ 如果一个值类型不适合一个存储槽的剩余部分，它将被存储在下一个存储槽。
+ 结构和数组数据总是从一个新的存储槽开始，它们的项根据这些规则被紧密地打包。
+ 结构或数组数据之后的变量总是开辟一个新的存储槽。

## HashMap和动态数组（动态）
它们的存储布局分为2部分，基础布局部分 和 数据布局部分，基础布局按照合约中状态变量的定义顺序，从0依次递增，数据布局则填充每一个数值。具体如下
+ HashMap而言，基础布局中只占了1个slot，什么信息都不存储，只是个占位，目的是保证相邻的2个map结构数据并不会冲突；数据布局部分，按照`keccak256(h(k).p)`公式来计算指定`k`的存储`slot`，并在该`slot`中存储`value`，可参考如下下合约
```
contract MappingStorage {
    mapping(uint => uint) public a;
    uint256 public b = 5;

    constructor(){
        a[0] = 1;
        a[1] = 2;
    }

    // hashmap的slot计算公式：slot = keccak256(h(k) . p)，其中 . 意味着把前后2个值拼接到一起，类似于abi.encode(h(k), p)
    // get slot of a[0] 时 key = 0, p = 0, result = 0xad3228b676f7d3cd4284a5443f17f1962b36e491b30a40b2405849e597ba5fb5
    // get slot of a[1] 时 key = 1, p = 0, result = 0xada5013122d395ba3c54772283fb069b10426056ef8ca54750cb9bb552a59e7d
    function getSlot(uint key, uint p) public pure returns(bytes32){
        return keccak256(abi.encode(key, p));
    }
}
```

+ 对于动态数组，基础布局中存储数组的长度，占用32字节；数据存储则按照`h(p)`公式，即`keccak(p)`来计算对应的数据存储的`slot`，在该`slot`槽位中，依次存储对应的数据，填满1个slot后开启下一slot，具体看如下合约：
```
contract ArrayStorage {
    uint128 public a = 9;
    uint128[] public b;

    constructor(){
        b.push(10);
        b.push(11);
        b.push(12);
    }

    function getHash(bytes memory bb) public pure returns(bytes32){
        return keccak256(bb);
    }

    // 数组的slot计算公式，slot = keccak256(p)，其中p为数组状态变量在基本布局中的位置，此时b的位置p为1（状态变量a位置为0）
    // get slot of b[0] 时，variableStatePosition = 1, result = 0xb10e2d527612073b26eecdfd717e6a320cf44b4afac2b0732d9fcbe2b7fa0cf6
    // 对于1维数组只需要计算出第一个元素的slot即可，其他的元素依次排列，直到当前slot填满，再开启下一个slot
    function getSlot(uint128 variableStatePosition) public pure returns(bytes32){
        return keccak256(abi.encode(variableStatePosition));
    }
}
```

## 数组和字符串(静态)
它们的存储布局类似于bytes1[]，主要分为2种情况，对于长度小于31字节的短字节，数据和长度存在1个slot中，当然是为了节省gas；对于长度超过31字节的长字节，存储布局类似于动态数组，长度和数据分开存储。具体如下：
```
contract BytesStorage {
    string public shortString = "WTF";
    bytes public longBytes = hex"365f5f375f5f365f73bebebebebebebebebebebebebebebebebebebebe5af43d5f5f3e5f3d91602a57fd5bf3";

    function getHash(bytes memory bb) public pure returns(bytes32){
        return keccak256(bb);
    }
}
```
+ 长度小于31字节的短字节：直接按照基础布局中的槽位来存储数据和长度，对于如上合约，则存储在槽位0中，即slot=0，该slot的高位存储数据，“WTF”的ASCII码为 878470，对应的十六进制为 0x575446；低位存储 (len * 2)，即6，所以slot为0的槽位存储内容为：`5754460000000000000000000000000000000000000000000000000000000006`

+ 长度大于31字节的长字节：存储布局类似于动态数组，在基础布局的槽位`slot=1`中只存储**长度**，值为`(len * 2 + 1)`，然后在按照`h(p)`公式即`keccak256(1)`计算该数组数据的存储槽位，并依次填充存储数据，填满一个slot后开启下一个slot

> 总结：鉴于长短字节在存储长度上的差异，因此可根据最后一个bit位是否为1来区分长短字节，短字节为0，长字节为1
