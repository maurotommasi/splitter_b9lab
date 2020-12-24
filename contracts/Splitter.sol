// SPDX-License-Identifier: MIT

import "./SafeMath.sol";

pragma solidity 0.6.10;

contract Splitter {

    using SafeMath for uint;

    event SplitLog(address indexed sender, uint amount, address first, address second);
    event WithdrawRefundlog(address beneficiary, uint amount);

    mapping(address => uint) public balances;
    
   function split(address[] _addresses) payable public returns(bool){

        require(_first != msg.sender && _second != msg.sender && _first != _second, "There are two or more identical addresses");
        require(_first != address(0x0) && _second != address(0x0), "Beneficiaries could not be null");

        uint unsplittableValue = msg.value % 2; // See Analysis.sol to know why I don't use .mod

        balances[_first] = balances[_first].add(msg.value / 2); //See Analysis.sol to know why I don't use .mod
        balances[_second] = balances[_second].add(msg.value / 2);

        emit SplitLog(msg.sender, msg.value, _first, _second);

        return true;
    }

    function getBalance() public view returns(uint){
        return balances[msg.sender];
    }

    function withdrawRefund() public returns(bool){

        require(msg.sender != address(0x0));

        uint amountToRefund = balances[msg.sender];

        require(amountToRefund > 0, "No wei are available in this balance"); 

        balances[msg.sender] = 0;

        msg.sender.transfer(amountToRefund);

        emit WithdrawRefundlog(msg.sender, amountToRefund);
        
        return true;
    }

    function () {
        revert();
    }

}