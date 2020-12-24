// SPDX-License-Identifier: MIT

import "./SafeMath.sol";

pragma solidity 0.6.10;

contract Splitter {

    using SafeMath for uint;

    event SplitLog(address indexed sender, uint amount, address first, address second, uint unsplittableValue);
    event WithdrawRefundlog(address beneficiary, uint amount);

    mapping(address => uint) public balances;
    
   function split(address _first, address _second) payable external returns(bool){

        require(_first != msg.sender && _second != msg.sender && _first != _second, "There are two or more identical addresses");
        require(_first != address(0x0) && _second != address(0x0), "Beneficiaries could not be null");
        require(msg.value != uint(0), "Value can't be 0");

        uint unsplittableValue = msg.value.mod(2); // See Analysis.sol to know why it should less expansive to use % 2

        balances[_first] = balances[_first].add(msg.value.div(2)); //See Analysis.sol to know why it should less expansive to use / 2
        balances[_second] = balances[_second].add(msg.value.div(2)); //See Analysis.sol to know why it should less expansive to use / 2

        emit SplitLog(msg.sender, msg.value, _first, _second, unsplittableValue);

        return true;
    }

    function getBalance() public view returns(uint){
        return balances[msg.sender];
    }

    function withdrawRefund() public returns(bool){

        require(msg.sender != address(0x0));

        uint amountToRefund = balances[msg.sender];

        require(amountToRefund != uint(0), "Balance can't be equal to 0");

        emit WithdrawRefundlog(msg.sender, amountToRefund);

        balances[msg.sender] = uint(0);

        msg.sender.transfer(amountToRefund);
        
        return true;
    }

}