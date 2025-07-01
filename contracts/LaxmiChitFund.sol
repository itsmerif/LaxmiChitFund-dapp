// SPDX-License-Identifier: MIT
// LaxmiChitFund Scheme --itsmeRiF
// Adapted from a regional comedy movie
pragma solidity >=0.7.6 <0.9.0;

contract LaxmiChitFund {
    address public manager;
    address[] public members;
    mapping(address => uint) public contributions;
    uint public round;
    uint public constant MONTHLY_AMOUNT = 1 ether;
    bool public fundsCollected;

    constructor() {
        manager = msg.sender;
        round = 1;
    }

    modifier onlyManager() {
        require(msg.sender == manager, "Only manager can perform this action");
        _;
    }

    function joinFund() public {
        require(members.length < 5, "Fund is full");
        for (uint i = 0; i < members.length; i++) {
            require(members[i] != msg.sender, "Already joined");
        }
        members.push(msg.sender);
    }

    function contribute() public payable {
        require(msg.value == MONTHLY_AMOUNT, "Send exact monthly amount");
        require(isMember(msg.sender), "Not a registered member");
        require(contributions[msg.sender] < round, "Already contributed this round");

        contributions[msg.sender] = round;

        if (allContributed()) {
            fundsCollected = true;
        }
    }

    function pickWinner() public onlyManager {
        require(fundsCollected, "Funds not collected yet");
        uint index = random() % members.length;
        address winner = members[index];
        payable(winner).transfer(address(this).balance);
        round++;
        fundsCollected = false;
    }

    function isMember(address user) internal view returns (bool) {
        for (uint i = 0; i < members.length; i++) {
            if (members[i] == user) return true;
        }
        return false;
    }

    function allContributed() internal view returns (bool) {
        for (uint i = 0; i < members.length; i++) {
            if (contributions[members[i]] < round) {
                return false;
            }
        }
        return true;
    }

    function random() private view returns (uint) {
        return uint(keccak256(abi.encodePacked(block.timestamp, block.difficulty, round)));
    }

    function getMembers() public view returns (address[] memory) {
        return members;
    }
}

