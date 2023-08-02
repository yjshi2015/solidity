// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC20.sol";
/*
众筹
*/
contract CrowdFund {

    event Launch(uint campaignId, address indexed creator, uint goal, uint32 startAt, uint32 endAt);
    event Cancle(uint campaignId);
    //_campaignId会有很多个，所以有必要加索引
    event Pledge(uint indexed _campaignId, address indexed caller, uint amount);
    event Unpledge(uint indexed _campaignId, address indexed caller, uint amount);
    event Claim(uint _campaignId);
    event Refund(uint indexed _campaignId, address indexed caller, uint amount);

    //众筹活动结构体
    struct Campaign {
        address creator; //众筹创建者（众筹发起人）
        uint goal; //众筹目标
        uint pledged; //已众筹的金额
        uint32 startAt;
        uint32 endAt;
        bool claimed;  //是否（由众筹创建者）已取出众筹资金
    }

    //本次众筹指定的“代币”类型
    IERC20 public immutable token;
    //活动id
    uint public campaignId;
    //活动id和活动体的映射
    mapping(uint => Campaign) public campaigns;
    //活动id to 参与人 to 参与金额
    mapping(uint => mapping(address => uint)) public pledgeAmount;

    constructor(address _token) {
        token = IERC20(_token);
    }

    //发布众筹活动1690984065.416
    //众筹目标、开始/结束时间
    function launch(uint _goal, uint32 _startAt, uint32 _endAt) external {
        require(_startAt >= block.timestamp, "start at < now");
        require(_endAt > _startAt, "end at < start at");
        //solidity可以自动把days转成时间戳
        require(_endAt <= block.timestamp + 90 days, "end at > max duration");

        campaignId += 1;
        campaigns[campaignId] = Campaign({
            creator : msg.sender,
            goal : _goal,
            pledged : 0,
            startAt : _startAt,
            endAt : _endAt,
            claimed : false
        });

        emit Launch(campaignId, msg.sender, _goal, _startAt, _endAt);
    }

    //根据众筹活动id取消某个众筹活动，要在众筹开始之前
    function cancel(uint _campaignId) external {
        // todo 为啥要放在内存中？？？
        Campaign memory campaign = campaigns[_campaignId];
        //必须谁创建，谁取消
        require(msg.sender == campaign.creator, "not creator, no permit");
        require(campaign.startAt > block.timestamp, "crowdFund aready start");
        delete campaigns[campaignId];
        emit Cancle(campaignId);
    }

    //用户参加众筹
    function pledge(uint _campaignId, uint _amount) external {
        // todo 这里为啥要用storage
        Campaign storage campaign = campaigns[_campaignId];
        require(block.timestamp >= campaign.startAt, "not start");
        require(block.timestamp <= campaign.endAt, "ended");
        
        //众筹金额累加
        campaign.pledged += _amount;
        //参与者支付金额累加
        pledgeAmount[_campaignId][msg.sender] += _amount;
        //把参与者支付的金额，转给众筹合约，而非当前的Remix账号
        token.transferFrom(msg.sender, address(this), _amount);

        //修改了链上数据，所以要发出消息
        emit Pledge(_campaignId, msg.sender, _amount);
    }

    //用户退出某个众筹
    //这里返还了指定的金额，为什么不一次性全部返还？？？
    //有可能是参与者目前不太看好这个项目了，但还抱有一丝希望，所以只取出了一部分金额
    function unpledge(uint _campaignId, uint _amount) external {
        Campaign storage campaign = campaigns[_campaignId];
        require(block.timestamp < campaign.endAt, "ended");

        campaign.pledged -= _amount;
        pledgeAmount[_campaignId][msg.sender] -= _amount;
        //这里将退还参与者前期支付的金额
        token.transfer(msg.sender, _amount);

        emit Unpledge(_campaignId, msg.sender, _amount);

    }

    //众筹完成，由众筹活动创建者取出众筹资金
    function claim(uint _campaignId) external {
        Campaign storage campaign = campaigns[_campaignId];
        require(msg.sender == campaign.creator, "not creatro");
        require(block.timestamp > campaign.endAt, "not ended");
        require(campaign.pledged >= campaign.goal, "pledged < goal");

        campaign.claimed = true;
        //将众筹账户的所有金额转给campaign.creator,由于msg.sender与其相等，并且更省gas，故使用msg.sender
        token.transferFrom(address(this), msg.sender, campaign.pledged);

        emit Claim(_campaignId);
    }

    //众筹失败，由参与者取回自己投入的资金
    function refund(uint _campaignId) external {
        Campaign storage campaign = campaigns[_campaignId];
        require(block.timestamp > campaign.endAt, "not ended");
        require(campaign.pledged < campaign.goal, "crowd failed");

        uint bal = pledgeAmount[_campaignId][msg.sender];
        pledgeAmount[_campaignId][msg.sender] = 0;
        campaign.pledged -= bal;
        token.transfer( msg.sender, bal);

        emit Refund(_campaignId, msg.sender, bal);
    }
}