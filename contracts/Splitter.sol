// SPDX-License-Identifier: MIT

import "./SafeMath.sol";

pragma solidity 0.6.10;

contract Splitter {

    using SafeMath for uint;

    address public owner;

    event SplitLog(address indexed owner, uint amount, address first, address second);
    event WithdrawRefundlog(address beneficiary, uint amount);

    mapping(address => uint) public balances;

    constructor() public {
        owner = msg.sender;
    }   
    
   function split(address _first, address _second) payable public returns(bool){

        require(_first != msg.sender && _second != msg.sender && _first != _second, "There are two or more identical addresses");
        require(_first != address(0x0) && _second != address(0x0), "Beneficiaries could not be null");

        if(msg.value % 2 == 1) {
            balances[msg.sender] += 1;
        }

        balances[_first] = balances[_first].add(msg.value / 2);
        balances[_second] = balances[_second].add(msg.value / 2);

        emit SplitLog(msg.sender, msg.value, _first, _second);

        return true;
    }

    function getBalance() public view returns(uint){
        return balances[msg.sender];
    }

    function withdrawRefund() public returns(bool){
        uint amountToRefund = balances[msg.sender];
        require(amountToRefund > 0, "No wei are available in this balance"); 
        msg.sender.transfer(amountToRefund);
        balances[msg.sender] = 0;
        emit WithdrawRefundlog(msg.sender, amountToRefund);
        return true;
    }

    function getOwner() public view returns(address){
        return owner;
    }

}