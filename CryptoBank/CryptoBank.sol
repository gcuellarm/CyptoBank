//SPDX-License-Identifier: LGPL-3.0-only

//Version
pragma solidity ^0.8.24;

    
//Functions:
    //1. Deposit ether.
    //2. Withdraw ether.

// Rules
    //1. Multiuser.
    //2. Can only deposit ether.
    //3. User can only withdraw previously deposit ether.
        //User A -> Deposit (5 ether)
        //User B -> Deposit (2 ether)
        //Bank Balance = 7 ether
        //User A can withdraw a maximun of 5 ehter not 7
        //User -> Deposit (5 ether) -> deposit (1 ether) -> withdraw (3 ether) -> deposit (2 ehter) ==== Do different actions in chain.
    //4. Max balance 5 ether for each account.
    //5. MaxBalance modifiable by owner.

    
//contract
contract CryptoBank{

    uint256 public maxBalance;
    address public admin;
    mapping(address => uint256) public userBalance;

//Events
    event etherDeposited(address user_, uint256 etherAmount_);
    event etherWithdrawn(address user_, uint256 etherAmount_);

//Modifiers
    modifier onlyAdmin() {
        require(msg.sender == admin, "You are not allowed because you are not admin.");
        _;
    }

    constructor(uint256 maxBalance_, address admin_){
        maxBalance = maxBalance_;
        admin = admin_;
    }

    //Functions

    //1 Deposit
    function depositEther() external payable{   //poner function depositEther(uint256 amount_) supondría una vulnerabilidad crítica
        require(userBalance[msg.sender] + msg.value <= maxBalance, "Maximun Balance accepted exceeded");
        userBalance[msg.sender] += msg.value;
        emit etherDeposited(msg.sender, msg.value);
    }

    //2 Withdraw
    function withdrawEther(uint256 amount_) external {      //CEI pattern : 1. Checks 2. Update State 3. Interactions
        //1. Check the conditions
        require(userBalance[msg.sender] >= amount_, "Insufficient balance");
        //2. Update the state (of the balance)
        userBalance[msg.sender] -= amount_;
        //3. Transfer the ether (interaction)
        (bool success, ) = msg.sender.call{value: amount_}("");
        require(success, "Could not withdraw");

        emit etherWithdrawn(msg.sender, amount_);
    }

    //3 Modify balance
    function modifyMaxBalance(uint256 newMaxBalance_) external onlyAdmin{
        maxBalance = newMaxBalance_;
    }

}