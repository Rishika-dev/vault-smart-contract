// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract Vault {
    mapping(address => uint256) public ethFunds;
    uint256 public totalEthFunds;

    address public immutable OWNER;

    error InvalidAmount();
    error NotOwner();
    error WithdrawalFailed();

    constructor() {
        OWNER = msg.sender;
    }

    modifier onlyOwner() {
        checkOwner();
        _;
    }

    function checkOwner() internal view {
        if (msg.sender != OWNER) revert NotOwner();
    }

    function fund() external payable {
        if (msg.value == 0) revert InvalidAmount();

        ethFunds[msg.sender] += msg.value;
        totalEthFunds += msg.value;
    }

    function withdraw() external onlyOwner {
        uint256 amount = address(this).balance;
        totalEthFunds = 0;

        (bool success, ) = payable(OWNER).call{value: amount}("");
        if (!success) revert WithdrawalFailed();
    }

    receive() external payable {}

    fallback() external payable {}
}
