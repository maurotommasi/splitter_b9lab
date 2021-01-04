// SPDX-License-Identifier: MIT

import "./SafeMath.sol";
import "./Stoppable.sol";

pragma solidity 0.6.10;

contract Splitter is Stoppable{

    using SafeMath for uint;

    event SplitLog(address indexed sender, uint amount, address first, address second);
    event WithdrawRefundlog(address beneficiary, uint amount);

    mapping(address => uint) public balances;
    
   function split(address _first, address _second) payable onlyIfRunning external returns(bool){

        require(_first != msg.sender && _second != msg.sender && _first != _second, "There are two or more identical addresses");
        require(_first != address(0x0) && _second != address(0x0), "Beneficiaries could not be null");
        require(msg.value != uint(0), "Value can't be 0");

        uint unsplittableValue = msg.value.mod(uint(2)); // See Analysis.sol to know why it should less expansive to use % 2

        balances[_first] = balances[_first].add(msg.value.div(uint(2))); //See Analysis.sol to know why it should less expansive to use / 2
        balances[_second] = balances[_second].add(msg.value.div(uint(2))); //See Analysis.sol to know why it should less expansive to use / 2

        if(unsplittableValue != 0) balances[msg.sender] += 1;

        emit SplitLog(msg.sender, msg.value, _first, _second);

        return true;
    }

    function getBalance() public view returns(uint){
        return balances[msg.sender];
    }

    function withdrawRefund() external onlyIfRunning returns(bool){ //Even if I think it's better to leave this without onlyIfRunning (I can have more trust on who use this contract)

        require(msg.sender != address(0x0));

        uint amountToRefund = balances[msg.sender];

        require(amountToRefund != uint(0), "Balance can't be equal to 0");

        emit WithdrawRefundlog(msg.sender, amountToRefund);

        balances[msg.sender] = uint(0);

        msg.sender.transfer(amountToRefund);
        
        return true;
    }

    fallback() external {
        revert();
    }

}