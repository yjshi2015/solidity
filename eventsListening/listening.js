const contract = new web3.eth.Contract(abi, contractAddress);

// 创建一个事件过滤器对象
const eventFilter = contract.events.MyEvent({
  filter: {
    id: '0x1234567890abcdef', // 过滤 id 为指定值的事件
    sender: '0xabcdef1234567890' // 过滤 sender 为指定地址的事件
  },
  fromBlock: 0, // 开始区块号
  toBlock: 'latest' // 结束区块号
});

// 监听事件过滤器的事件
eventFilter.on('data', event => {
  console.log('Received event:', event);
});

// 获取符合过滤条件的历史事件日志
eventFilter.get((error, events) => {
  if (error) {
    console.error('Error retrieving events:', error);
  } else {
    console.log('Filtered events:', events);
  }
});
