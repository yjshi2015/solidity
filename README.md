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
  - memory：局部变量，和函数的生命周期相同；函数中修改了局部变量的值，并不能修改链上的值；内存中的数组必须是“定长”数组，不能是动态调整长度的；
  - calldata： 跟memory类似，但只能用于函数的入参；适用于不同合约之中函数的调用时传递值；