// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
英式合约拍卖
*/

interface IERC721 {
    function transferFrom(address from, address to, uint nftId) external ;
}

contract EnglishAuction {
    event Start();
    event End(address highestBidder, uint amount);
    event Bid(address indexed sender, uint amount);
    event Withdraw(address indexed bidder, uint amount);

    IERC721 public immutable nft;
    uint public immutable nftId;

    //Remix账，拍卖合约部署者地址，不是合约本身地址，即售卖者
    address payable public immutable seller;
    uint32 public endAt;
    bool public started;
    bool public ended;

    //最高出价者
    address public highestBidder;
    //最高出价
    uint public highestBid;
    //每个人的出价
    mapping(address => uint) public bids;

    constructor(address _nft, uint _nftId, uint _startBid) {
        nft = IERC721(_nft);
        nftId = _nftId;
        seller = payable (msg.sender);
        highestBid = _startBid;
    }

    function start() external {
        require(msg.sender == seller, "not seller");
        require(!started, "started");

        started = true;
        endAt = uint32(block.timestamp + 60);
        //将NFT从当前Remix账户 发送到 当前合约账户
        nft.transferFrom(seller, address(this), nftId);

        emit Start();
    }

    function bid() external payable {
        require(started, "not started");
        require(block.timestamp < endAt, "end");
        require(msg.value > highestBid, "value < height old ");

        if(highestBidder != address(0)) {
            //该竞标者可能有多次竞标，所以要把以前的一起给退了
            bids[highestBidder] += highestBid;
        }

        highestBid = msg.value;
        highestBidder = msg.sender;

        emit Bid(msg.sender, msg.value);
    }

    //竞标失败，取回之前投标的前
    function withdraw() external {
        uint bal = bids[msg.sender];
        //转账范式，先改状态，再执行逻辑
        bids[msg.sender] = 0;
        payable(msg.sender).transfer(bal);
        emit Withdraw(msg.sender, bal);
    }

    function end() external {
        require(started, "not started");
        require(!ended, "not ended");
        require(block.timestamp >= endAt, "not end");
         
        ended = true;
        if (highestBidder != address(0)) {
            nft.transferFrom(address(this), highestBidder, nftId);
            seller.transfer(highestBid);
        } else {
            nft.transferFrom(address(this), seller, nftId);
        }

        emit End(highestBidder, highestBid);
    }

}