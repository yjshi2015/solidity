# solidity
solidity learning

## types
- The concept of “undefined” or “null” values does not exist in Solidity, but newly declared variables always have a default value dependent
  on its type

- Arrays
  - The type of an array of fixed size `k` and element type `T` is written as `T[k]`, and an array of dynamic size as `T[]`.
  - For example, an array of 5 dynamic arrays of `uint` is written as `uint[][5]`. The notation is reversed compared to some other languages. 
  In Solidity, `X[3]` is always an array containing three elements of type `X`, even if `X` is itself an array(即使X本身也是数组，这点非常重要！
  因为它不像其他语言将其视为多维数组). This is not the case in other languages such as C.
  ```
  //定义1个长度为2的静态数组
  uint[2] staticArr = new uint[2];
  staticArr[0] = 0;
  staticArr[1] = 1;
  //如下赋值将编译错误，因为只有2个元素
  staticArr[2] = 2;

  //定义1个初始长度为2的动态数组
  uint[] dynamicArr = new uint[](2);
  dynamic[0] = 0;
  dynamic[1] = 1;
  //动态添加第3个元素
  dynamic.push(2);

  //定义1个长度为2的多维动态数组
  uint[][2] dynamicMultiArr = new uint[][2];
  //即有2个动态数组
  dynamicMultiArr = {[1],[1,2]}

  ```

  - bytes
    - As a general rule, use `bytes` for arbitrary-length raw byte data and string for arbitrary-length string (UTF-8) data. If you can limit 
    the length to a certain number of bytes, always use one of the value types `bytes1` to `bytes32` because they are much cheaper.
    -  bytes to string : `bytes myBytes; string myString = string(myBytes);`    
  - string
    - compare two strings by their keccak256-hash using `keccak256(abi.encodePacked(s1)) == keccak256(abi.encodePacked(s2))` 
    - concatenate two strings using `string.concat(s1, s2)`
    - string to bytes : `string myString; bytes myBytes = bytes(myString);`

  - delete : It is important to note that `delete a` really behaves like an assignment to a, i.e. it stores a new object in a 
    > `delete a` assigns the initial value for the type to `a`. I.e. for integers it is equivalent to `a = 0`, but it can also be used on arrays, 
    where it assigns `a` dynamic array of length zero or a static array of the same length with all elements set to their initial value. `delete 
    a[x]` deletes the item at index x of the array and leaves all other elements and the length of the array untouched. This especially means 
    that it leaves a gap in the array. If you plan to remove items, a mapping is probably a better choice.

- The operators `||` and `&&` apply the common short-circuiting rules
- `uint` and `int` are aliases for `uint256` and `int256`, respectively
- `x << y` is equivalent to the mathematical expression `x * 2**y`.
- `x >> y` is equivalent to the mathematical expression `x / 2**y`, rounded towards negative infinity.
- `>>` 必须是无符号类型，因为高位要填充0，会导致负数变成正数！；`<<` 如果高位的1变成了符号位，也会导致正数变成负数，所以位移操作要控制好数值范围
- In Solidity, division rounds towards zero. This means that `int256(-5) / int256(2) == int256(-2)`

- The address type comes in two largely identical flavors:
  - `address`: Holds a 20 byte value (size of an Ethereum address). ** you are not supposed to send Ether to a plain address **
  - `address` payable: Same as `address`, but with the additional members `transfer` and `send`. **you can send Ether to it**
  - Implicit conversions from `address payable` to `address` are allowed, whereas conversions from `address` to `address payable` must be 
  explicit via `payable(<address>)`.

- Members of Addresses
  - balance : query the balance of an address.
  - transfer : send Ether (in units of wei) to a payable address.
  ```solidity
    address payable x = payable(0x123);
    address myAddress = address(this);
    //向x账户发送10个wei的以太币，同时扣减该函数所在合约的账户余额，而非Remix账户余额！！！
    if (x.balance < 10 && myAddress.balance >= 10) x.transfer(10);
  ```
  - send : if fails, current contract will not stop with exception, but will return `false`
  - call, delegatecall and staticcall : In order to interface with contracts that do not adhere to the ABI, or to get more direct control over 
  the encoding, the functions `call`, `delegatecall` and `staticcall` are provided. They all take a single `bytes memory` parameter and return 
  the success condition (as a `bool`) and the returned data (`bytes memory`). The functions `abi.encode`, `abi.encodePacked`, `abi.encodeWithSelector` 
  and `abi.encodeWithSignature` can be used to encode structured data.
  ```
  bytes memory payload = abi.encodeWithSignature("register(string)", "MyName");
  (bool success, bytes memory returnData) = address(nameReg).call(payload);
  require(success);
  ```
  **Warning**
  > All these functions are low-level functions and should be used with care. Specifically, any unknown contract might be malicious and if you 
  call it, you hand over control to that contract which could in turn call back into your contract, so be prepared for changes to your state 
  variables when the call returns. The regular way to interact with other contracts is to call a function on a contract object (x.f()).

- payable修饰符
  - 修饰address变量，表明该地址可以接收以太币，而不是发送。
  - 修饰function函数，表明该函数可以接收以太币，并将接收到的以太币存放在合约地址中。
  > Note : ①以太币转账时，外部调用账户的余额扣除是由EVM自动进行的，不需要手动处理；②以太币的发送涉及到的交易费、矿工费，将从发送者的账户中扣除，即谁发起的
  转账，扣谁的手续费
  
- 数据位置：
  - storage：状态变量，存储在链上（类似于数据库持久化）；函数中修改状态变量的值，也会修改链上的值；动态数组只能应用在“状态变量”中；
  - memory：局部变量，和函数的生命周期相同；函数中修改了局部变量的值，并不能修改链上的值；内存中的数组必须是“定长”数组，所谓的“定长”并不是必须先指定长度，
  而是长度确定后不允许改变，不能动态调整长度的；
  - calldata： 跟memory类似，但只能用于函数的入参；适用于不同合约之中函数的调用时传递值；
  - 全局变量： 链上的那些不用定义可以直接使用的变量，如msg.sender/msg.value/block.timestamp/block.number


- 错误处理
  - solidity用错误回滚的方式处理异常，如果存在多级调用，则向上抛异常来回滚数据，除非用try/catch来捕获了异常。
  - 对于send/call/delegatecall/calldata这4种调用方式，返回结果的第一个值是调用“成功or失败”的标志。
  - 对于不存在的函数的调用，通常情况下返回true，所以函数调用前有必要检查是否存在。
  - require ：error类错误，一般在函数的前置校验，可以返回错误信息；
  - assert ：panic类错误，用于内部错误检，如：除数为0、数组下标越界、数值上溢或下溢……
  - revert : 建议采用如下方式：`error Unauthorized(); revert Unauthorized();`

- 变量的可见性
  - public
  - internal : 只能合约内部及子合约访问
  - private ：只能合约内部访问，自合约不可访问

- Function Types : `function sig(<parameter types>) {public|internal|external} [pure|view|payable] [returns (<return types>)]`
  - By default, function types are internal, so the internal keyword can be omitted
  - external 函数，只能由外部账户调用，也不可以被本合约内部的函数调用
  - pure 函数中只有局部变量，不会对链上的数据进行任何**读**或**写**操作
  - view 函数跟pure类似，但是它可以读取 链上的值global value 和 状态值state value,

- 函数的可见性
  - public ： 内外部都可访问
  - external ： 只能外部访问，不可内部访问
  - internal
  - private

- 外部函数：也称为自由函数，可见度为internal

- 函数返回值：不能为以下类型
  - mappings
  - internal function types
  - reference types with location set to storage
  - multi-dimensional arrays (applies only to ABI coder v1)
  - structs (applies only to ABI coder v1). 亲测是可以的，见 @see helloworld.sol

- 不可变的变量
  - constant: 用于声明编译时常量；it has to be assigned where the variable is declared；在0.6.0版本之后废弃，推荐使用immutable
  - immutable: 编译时被硬编码写入到字节码中，并且在运行中不可更改。

- 接收以太币的函数
  - fallback函数：在0.6.0版本之前为默认的接收以太币的函数，之后细化为receive函数用于接收以太币，fallback则用来处理调用合约中不存在的函数的情况。一个合约
  最多有1个fallback函数。
  - receive函数：用来处理接收以太币的具体你逻辑。
  - 自定义的payable函数：也可以用来向该合约转账，如下。但是！建议使用receive函数实现接收以太币的功能，这是约定的、标准化的操作！  
    ```
      function setXandSendEhter(address testAddress, uint _x) external payable {
          //调用TestContract合约的函数时向其转发了指定数量的以太币
          TestContract(testAddress).setXandReceiveEther{value : msg.value}(_x);
      }
    ```
  > Note : ①合约中定义了fallback或（和）receive函数，函数体的内容不需要“显式的声明接收以太币操作”，就可以实现接收以太币的操作，这是由EVM来处理的。②合约A
  中定义了payable修饰的fallback或（和）receive函数，合约B中调用了send或transfer函数向合约A转发以太币，那么EVM会自动触发合约A的receive函数（如果存在的
  话）或fallback函数。也就是说不可以通过直接调用fallback函数或receive函数来实现转账（这2个函数没有入参出参，肯定无法直接转），而是要交给EVM来处理！
  - 如何把Remix账户中的以太币转移给合约A ？ 需要在合约A中定义deposit函数，然后在Remix界面指定转移的以太币数量，执行deposit函数即可。
  - 合约A中定义了transfer或send函数，用于向指定合约X转账，函数调用在Remix界面中直接发起，请问转账能否成功，扣减的金额是在谁身上，Remix账户还是合约A ？ 先
  说结论：*哪个合约内部执行了transfer或send函数，就从哪个合约上扣减以太币*，所以并不是扣减Remix账户的余额，而是合约A的余额，由于合约A此时并没有以太币（按
  照上一步可以给合约A转发以太币），所以函数调用失败！

- ABI（Application Binary Interface）：是一种定义合约与其他合约或外部应用程序之间通信规范的标准。
  ABI 描述了合约的函数、事件和数据结构的布局和编码方式，以便不同的合约或应用程序可以相互交互。
  ABI 定义了合约的接口，包括函数的名称、参数类型和返回类型。
  它还定义了函数的编码和解码规则，以便在不同的环境中正确地序列化和反序列化函数调用。
  > 个人理解：ABI类似于DUBBO一样的RPC协议，以便不同的服务（合约）之间相互调用

- Function selector ：函数选择器是一个用来标识函数的唯一标识符，它由函数签名的前4个字节（被称为函数选择器编码 Function Selector Encoding）构成。
  作用：是在合约的函数调用时，帮助EVM识别要调用的函数。
  如何防止hash冲突：使用函数签名hash值的前4个字节作为唯一标识，由于hash函数通常被设计为具有较低的碰撞概率，所以即使是前4个字节，也可以提供足够的唯一性。
  在实践中，唯一性是由solidity编译器和EVM共同保证的，由于Function selector是在编译时就确定的，solidity编译器将function selector和对应的函数实现关联
  起来。这时如果发生了hash冲突，编译器就会引发编译错误，提示开发者更改函数名称或参数以确保唯一性。在合约调用的时候，EVM根据function selector来确定要执
  行的函数。

- gas费：在进行deposit操作时，控制台显示的有transaction cost和execution cost，但在实际过程中，并没有扣除execution cost的费用，why？

- selfdestruct : 是一个特殊的函数，用于销毁当前合约的实例并将其余额发送到指定的地址。这个地址可以是任何有效的以太坊地址，包括外部账户或其他合约地址。
  selfdestruct 函数的使用通常是为了合约的清理和资源回收（只是销毁当前的实例，其他实例不受影响）。
  > Note : 一个合约可以new多个实例，每个实例有独立的地址和余额，相互之间不受影响。
  ```
  pragma solidity ^0.8.0;

  contract MyContract {
      address payable public beneficiary;

      constructor(address payable _beneficiary) {
          beneficiary = _beneficiary;
      }

      //将当前合约实例的余额转移到地址beneficiary，并销毁当前实例
      function destroy() public {
          selfdestruct(beneficiary);
      }
  }

  ```

- inherit 
  - virtual : 该修饰符用于声明一个函数为虚函数。虚函数是一种可以在子合约中被重写的函数。当一个函数被声明为虚函数时，它可以在子合约中使用 override 关键字
  进行重写。这允许子合约对父合约中的虚函数进行自定义实现。
  ```
  pragma solidity ^0.8.0;

  contract ParentContract {
      function foo() public virtual returns (string memory) {
          return "Parent";
      }
  }

  contract ChildContract is ParentContract {
      function foo() public virtual override returns (string memory) {
          return "Child";
      }
  }

  ```
  > Note ：对于multiInheritance多线继承，即X为父合约，Y为子合约，合约Z同时继承X和Y合约，理论上Z只需要继承Y就能同时得到X和Y的全部属性，列出的场景适用于
  某个方法的行为在X中存在，而Y中不存在的情况（即Y重写override了某方法，但Z还是想用之前X的方法），所以需要再单独继承下X合约。

  - abstract contract：抽象合约（类似于Java中的抽象类），用于定义一个抽象的合约模板，其中包含了一些未实现的函数或功能，需要子合约来实现。可以包含state 
  variable和非抽象函数；不可以实例化，只能被继承和扩展，子合约必须实现全部抽象函数，否则子合约也是抽象合约；
  ```
  pragma solidity ^0.8.0;

  abstract contract MyAbstractContract {
      function myAbstractFunction() public virtual returns (uint);
  }

  contract MyContract is MyAbstractContract {
      function myAbstractFunction() public override returns (uint) {
          // 实现抽象函数的具体逻辑
          return 42;
      }
  }
  ```

  - interface：抽象接口（类似于Java中的接口），所有的函数只有函数签名，没有具体的实现；
  ```
  pragma solidity ^0.8.0;

  interface MyInterface {
      function myFunction(uint256 param) external returns (uint256);
  }

  contract MyContract is MyInterface {
      function myFunction(uint256 param) public override returns (uint256) {
          // 实现接口函数的具体逻辑
          return param * 2;
      }
  }
  ```

  - abstract contract 和 interface是相似的概念，用于定义一个合约的抽象接口，而并不包含实现，两者混搭的例子如下
  ```
  pragma solidity ^0.8.0;

  abstract contract MyAbstractContract {
      function myAbstractFunction() public virtual returns (uint);
  }

  interface MyInterface {
      function myInterfaceFunction() external returns (string memory);
  }

  contract MyContract is MyAbstractContract, MyInterface {
      function myAbstractFunction() public override returns (uint) {
          // 实现抽象函数的具体逻辑
          return 42;
      }

      function myInterfaceFunction() external override returns (string memory) {
          // 实现接口函数的具体逻辑
          return "Hello";
      }
  }
  ```

- 函数调用有以下2种方式
  - 合约名调用函数：适用于在合约内部调用自身的函数（继承体系中），或者在合约外部通过合约地址调用函数
  - 合约实例调用函数：常规的函数调用，具体也可以通过address地址的方式调用
  ```
  contract MyContract {
    uint public myVariable;

    function myFunction() public {
        myVariable = 42;
    }
  }

  contract CallerContract is MyContract{
      MyContract public myContract;

      constructor() {
          myContract = new MyContract();
      }

      function callFunction() public {
          // 使用合约名调用函数
          MyContract.myFunction();

          // 使用合约实例调用函数
          myContract.myFunction();
      }
  }
  ```

- 什么是地代码