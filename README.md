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