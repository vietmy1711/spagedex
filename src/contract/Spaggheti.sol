// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Pausable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";

contract Spaggheti is ERC20, ERC20Pausable, AccessControl, ERC20Permit {
    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    uint256 public constant priceOfToken = 1e18 wei;
    address private _owner;

    constructor(address defaultAdmin, address pauser, address minter)
        ERC20("Spaggheti", "SPD")
        ERC20Permit("Spaggheti")
    {
        _grantRole(DEFAULT_ADMIN_ROLE, defaultAdmin);
        _grantRole(PAUSER_ROLE, pauser);
        _grantRole(MINTER_ROLE, minter);
        _owner = msg.sender;
        
    }

    function pause() public onlyRole(PAUSER_ROLE) {
        _pause();
    }

    function unpause() public onlyRole(PAUSER_ROLE) {
        _unpause();
    }

    
    function mint(address to, uint256 amount) public onlyRole(MINTER_ROLE) {
        _mint(to, amount);
    }


    function _update(address from, address to, uint256 value)
        internal
        override(ERC20, ERC20Pausable)
    {
        super._update(from, to, value);
    }

    function getPriceOfToken() public pure returns (uint256) {
        return priceOfToken;
    }

//trading function
   function transfer(address from, address to, uint256 value) public virtual returns (bool) {
        _transfer(from, to, value);
        return true;
    }
    function buyToken() public payable {
        require(msg.value >= 1e17 wei, "Minnimum 0.1 SPG");
        uint256 amount = msg.value * 1e18/priceOfToken;
        transfer(address(this), msg.sender, amount);
    }
    function sellToken(uint256 amount) public {
        require(amount >= 1e17 wei, "Minimum 0.1 SPG");
        uint256 etherAmount = amount * priceOfToken/1e18;

        require(address(this).balance >= etherAmount, "Not enough ETH in contract");
        _transfer(msg.sender, address(this), amount);

        payable(msg.sender).transfer(etherAmount);
    }
    function deposit() public payable{
    }

//Owner zone
    function getContractBalance() public view returns(uint256){
         return address(this).balance;
    } 
    function withdraw(uint256 amount) public onlyOwner {
        require(address(this).balance >= amount, "Not enough ETH in contract");

        payable(msg.sender).transfer(amount);
    }

    modifier onlyOwner() {
        require(msg.sender == _owner, "Only owner can call this function");
        _;
    }
//Security zone

//Liquidity pool


}