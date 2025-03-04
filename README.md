# 🚀 CryptoBank

The aim of this project is to create a real bank for cypto tokens, in which there will be some of the most common functions that can be also found in normal banks (deposit or withdraw).


## 📃 Rules
The rules and behaviour of the bank must be:

1. Multiuser.
2. Can only deposit ether.
3. User can only withdraw previously deposit ether.
    
    3.1 User A -> Deposit (5 ether).  
    3.2 User B -> Deposit (2 ether).  
    3.3 Bank Balance = 7 ether.  
    3.4 User A can withdraw a maximun of 5 ehter not 7.  
    3.5 User A-> Deposit (5 ether) -> deposit (1 ether) -> withdraw (3 ether) -> deposit (2 ehter) (Do different actions in chain).
4. Max Balance modifiable by owner.

## 📃 Contract Details
### 🌐 Global Variables
In the beginning of the contract, we define our three variables for the contract:
- **maxBalance**: *uint256* type. We will set the maximun balance for an user's account.
- **admin**:  *address* type. To set the admin role to an account.
- **userBalance**: *mapping* type. To connect the user's address with their own balance.
### 🛠️ Constructor
Let us begin with the constructor. To initialize the smart contract, we put two parameters in the constructor, the maximun balance (*maxBalance_*) and the admin address (*admin_*). It should look like this:  
``` solidity
constructor(uint256 maxBalance_, address admin_){
        maxBalance = maxBalance_;
        admin = admin_;
} 
```


### ⚙️ Functions
We will have a function for each action we have mentioned in the rules, depositEther, withdrawEther and modifyMaxBalance.
- **depositEther()** *function*: with this function the user can deposit an amount of Ether, not higher than the maximun balance allowed. To ensure this, with the *require* we make sure that the user balance + the amount to deposit are together, equal or lower than *maxBalance*. It is important to add the new value to the previous balance, if not, the total balance of the account would be replaced without adding the new Ether. We emit an event to finish the function.
``` solidity
function depositEther() external payable{   
    require(userBalance[msg.sender] + msg.value <= maxBalance, "Maximun Balance accepted exceeded");
    userBalance[msg.sender] += msg.value;
    emit etherDeposited(msg.sender, msg.value);
    }
```
- **withdrawEther** *function*: with this function the user can take an amount of Ether out of his own account, not higher than the balance of the account. To ensure this, with the *require* we make sure that the user balance is equal or higher than the amount to withdraw. It is important to change the state of the balance first (after cheking the conditions) before the ***call*** function to avoid security breaches, because a receive function may be able to execute some functions in loop before the state is changed. We emit an event to finish the function.
``` solidity
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
```
- **modifyMaxBalance** *function*: with this function the owner/admin can set the maximun balance that each user can have in their accounts. 
``` solidity
function modifyMaxBalance(uint256 newMaxBalance_) external onlyAdmin{
    maxBalance = newMaxBalance_;
}
```


     To make sure this is only available for the admin, we create the modifier  ***onlyAdmin***, in which we require that the sender of the balance is the admin address.
``` solidity
modifier onlyAdmin() {
        require(msg.sender == admin, "You are not allowed because you are not admin.");
        _;
    }
```
## Tech Stack

**Client:** Solidity

**IDE:** Visual Studio Code, Remix IDE


## Authors

- [@gcuellarm](https://www.github.com/gcuellarm)
