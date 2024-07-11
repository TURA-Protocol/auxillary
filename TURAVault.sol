// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract TURAVault is ReentrancyGuard, Ownable {
    IERC20 public turaToken;
    
    mapping(address => uint256) public userBalances;

    event Deposit(address indexed user, uint256 amount);
    event Withdraw(address indexed user, uint256 amount);

    constructor(address _turaToken) {
        turaToken = IERC20(_turaToken);
    }

    function deposit(uint256 amount) external nonReentrant {
        require(amount > 0, "Deposit amount must be greater than 0");
        require(turaToken.transferFrom(msg.sender, address(this), amount), "Transfer failed");
        
        userBalances[msg.sender] += amount;
        emit Deposit(msg.sender, amount);
    }

    function withdraw(uint256 amount) external nonReentrant {
        require(amount > 0, "Withdraw amount must be greater than 0");
        require(userBalances[msg.sender] >= amount, "Insufficient balance");
        
        userBalances[msg.sender] -= amount;
        require(turaToken.transfer(msg.sender, amount), "Transfer failed");
        
        emit Withdraw(msg.sender, amount);
    }
