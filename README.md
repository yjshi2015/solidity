# solidity
solidity learning

## types
- The concept of “undefined” or “null” values does not exist in Solidity, but newly declared variables always have a default value dependent on its type
- The operators `||` and `&&` apply the common short-circuiting rules
- `uint` and `int` are aliases for `uint256` and `int256`, respectively
- `x << y` is equivalent to the mathematical expression `x * 2**y`.
- `x >> y` is equivalent to the mathematical expression `x / 2**y`, rounded towards negative infinity.
- `>>` 必须是无符号类型，因为高位要填充0，会导致负数变成正数！；`<<` 如果高位的1变成了符号位，也会导致正数变成负数，所以位移操作要控制好数值范围
- In Solidity, division rounds towards zero. This means that `int256(-5) / int256(2) == int256(-2)`
- The address type comes in two largely identical flavors:
  - `address`: Holds a 20 byte value (size of an Ethereum address). ** you are not supposed to send Ether to a plain address **
  - `address` payable: Same as `address`, but with the additional members `transfer` and `send`. **you can send Ether to it**
  - Implicit conversions from `address payable` to `address` are allowed, whereas conversions from `address` to `address payable` must be explicit via `payable(<address>)`.
- Members of Addresses
  - balance : query the balance of an address.
  - transfer : send Ether (in units of wei) to a payable address.
  ```solidity
    address payable x = payable(0x123);
    address myAddress = address(this);
    if (x.balance < 10 && myAddress.balance >= 10) x.transfer(10);
  ```
  - send : if fails, current contract will not stop with exception, but will return `false`
  - call, delegatecall and staticcall : In order to interface with contracts that do not adhere to the ABI, or to get more direct control over the encoding, the functions `call`, `delegatecall` and `staticcall` are provided. They all take a single `bytes memory` parameter and return the success condition (as a `bool`) and the returned data (`bytes memory`). The functions `abi.encode`, `abi.encodePacked`, `abi.encodeWithSelector` and `abi.encodeWithSignature` can be used to encode structured data.
  ```
  bytes memory payload = abi.encodeWithSignature("register(string)", "MyName");
  (bool success, bytes memory returnData) = address(nameReg).call(payload);
  require(success);
  ```
  **Warning**
  > All these functions are low-level functions and should be used with care. Specifically, any unknown contract might be malicious and if you call it, you hand over control to that contract which could in turn call back into your contract, so be prepared for changes to your state variables when the call returns. The regular way to interact with other contracts is to call a function on a contract object (x.f()).
- Function Types : `function sig(<parameter types>) {internal|external} [pure|view|payable] [returns (<return types>)]`
  - By default, function types are internal, so the internal keyword can be omitted
  - external 函数，只能由外部账户调用，也不可以被本合约内部的函数调用
  - pure 函数中只有局部变量，不会对链上的数据进行任何**读**或**写**操作
  - view 函数跟pure类似，但是它可以读取 链上的值global value 和 状态值state value,
  
- 数据位置：
  - storage：状态变量，存储在链上（类似于数据库持久化）；函数中修改状态变量的值，也会修改链上的值；动态数组只能应用在“状态变量”中；
  - memory：局部变量，和函数的生命周期相同；函数中修改了局部变量的值，并不能修改链上的值；内存中的数组必须是“定长”数组，所谓的“定长”并不是必须先指定长度，而是长度确定后不允许改变，不能动态调整长度的；
  - calldata： 跟memory类似，但只能用于函数的入参；适用于不同合约之中函数的调用时传递值；
  - 全局变量： 链上的那些不用定义可以直接使用的变量，如msg.sender/msg.value/block.timestamp/block.number

- Arrays
  - The type of an array of fixed size `k` and element type `T` is written as `T[k]`, and an array of dynamic size as `T[]`.
  - For example, an array of 5 dynamic arrays of `uint` is written as `uint[][5]`. The notation is reversed compared to some other languages. In Solidity, `X[3]` is always an array containing three elements of type `X`, even if `X` is itself an array(即使X本身也是数组，这点非常重要！因为它不像其他语言将其视为多维数组). This is not the case in other languages such as C.
  - bytes
    - As a general rule, use `bytes` for arbitrary-length raw byte data and string for arbitrary-length string (UTF-8) data. If you can limit the length to a certain number of bytes, always use one of the value types `bytes1` to `bytes32` because they are much cheaper.
    -  bytes to string : `bytes myBytes; string myString = string(myBytes);`    
  - string
    - compare two strings by their keccak256-hash using `keccak256(abi.encodePacked(s1)) == keccak256(abi.encodePacked(s2))` and concatenate two strings using `string.concat(s1, s2)`
    - string to bytes : `string myString; bytes myBytes = bytes(myString);`

- delete : It is important to note that `delete a` really behaves like an assignment to a, i.e. it stores a new object in a 
  > delete a assigns the initial value for the type to a. I.e. for integers it is equivalent to a = 0, but it can also be used on arrays, where it assigns a dynamic array of length zero or a static array of the same length with all elements set to their initial value. delete a[x] deletes the item at index x of the array and leaves all other elements and the length of the array untouched. This especially means that it leaves a gap in the array. If you plan to remove items, a mapping is probably a better choice.

- 错误处理
  - solidity用错误回滚的方式处理异常，如果存在多级调用，则向上抛异常来回滚数据，除非用try/catch来捕获了异常。
  - 对于send/call/delegatecall/calldata这4种调用方式，返回结果的第一个值是调用“成功or失败”的标志。
  - 对于不存在函数的调用，通常情况下返回true，所以函数调用前有必要检查是否存在。
  - require ：error类错误，一般在函数的前置校验，可以返回错误信息；
  - assert ：panic类错误，用于内部错误检，如：除数为0、数组下标越界、数值上溢或下溢……
  - revert : 建议采用如下方式：`error Unauthorized(); revert Unauthorized();`