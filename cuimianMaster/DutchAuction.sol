// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
ERC721为NFT的创建、交易和所有权转移提供了标准

拍卖流程
1、Remix账户A deploy NFT合约
2、Remix账户A 调用 NFT合约 mint方法，给账户B铸造NFT
3、Remix账户B deploy 拍卖合约，constructor方法传入 NFT合约地址 和 NFTID（谁的NFT谁来拍卖）
4、Remix账户B 调用 NFT合约 approve 方法，允许 拍卖合约 拍卖NFTID（谁的NFT谁来授权）
5、Remix账户C 调用 拍卖合约 Buy 方法买入 NFTID
*/
interface IERC721 {
    function transferFrom(address _from, address _to, uint _nftId) external ;
}

contract DutchAuction {

    uint private constant DURATION = 7 days;

    IERC721 public immutable nft;
    uint public immutable nftId;

    address payable public immutable seller;
    uint public immutable startingPrice;
    uint public immutable startAt;
    uint public immutable expiresAt;
    uint public immutable discountRate;

    /*
    _nft：NFT合约的部署（实例）地址
    _nft: NFT的编号
    */
    constructor(uint _startingPrice, uint _discountRate, address _nft, uint _nftId) {
        seller = payable(msg.sender);
        startingPrice = _startingPrice;
        discountRate = _discountRate;
        startAt = block.timestamp;
        //两者单位不一样，可以直接转换？？？
        expiresAt = block.timestamp + DURATION;
        require(_startingPrice >= _discountRate * DURATION, "starting price < discount");

        nft = IERC721(_nft);
        nftId = _nftId;
    }

    function getPrice() public view returns (uint) {
        uint timeElapsed = block.timestamp - startAt;
        uint discount = discountRate * timeElapsed;
        return startingPrice - discount;
    }


    //购买
    function buy() external payable {
        require(block.timestamp < expiresAt, "auction end");

        uint price = getPrice();
        require(msg.value >= price, "ETH not enough");

        //将NFT转移到指定账户
        nft.transferFrom(seller, msg.sender, nftId);
        //该交易等到区块确认要再等一些时间，所以拍卖价格会下降，因此把费用退还
        uint refund = msg.value - price;
        if (refund > 0) {
            payable(msg.sender).transfer(refund);
        }
        //销毁本次拍卖，并将拍卖合约的费用转给seller
        selfdestruct(seller);
    }
}

