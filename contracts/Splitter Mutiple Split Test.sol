// SPDX-License-Identifier: MIT

import "./SafeMath.sol";

pragma solidity 0.6.10;

contract Splitter {

    using SafeMath for uint;

    event SplitLog(address indexed sender, uint amount, address[] addresses);
    event WithdrawRefundlog(address beneficiary, uint amount);

    mapping(address => uint) public balances;
    
   function split(address[] _addresses) payable public returns(bool){

       // NOT TESTED!!!
       
        require(_addresses.length >= 2);
        require(msg.value > _addresses.length);
        uint count;
        for(uint i = 0; i < _addresses.length ; i++){
            count = 0;
            require(_addresses[i] != msg.sender || _addresses[i] != address(0x0), "Sender can't be a beneficiary or a null address");
            for(uint j = 0; j < _addresses.length ; j++){
                if(_addresses[i] == _addresses[j]) count++;
            }
            require(count == 0, "No Duplicate Address are allowed");
        }

        uint unsplittableValue = msg.value.mod(_addresses.length);

        for(i = 0; i < _addresses.length; i++){
            balances[_addresses[i]].add(msg.value.div(_addresses.length));
        }

        if(unsplittableValue > 0) balances[msg.sender].add(unsplittableValue);

        balances[_first] = balances[_first].add(msg.value / 2);
        balances[_second] = balances[_second].add(msg.value / 2);

        emit SplitLog(msg.sender, msg.value, addresses);

        return true;
    }

    function getBalance() public view returns(uint){
        return balances[msg.sender];
    }

    function withdrawRefund() public returns(bool){

        require(msg.sender != address(0x0));

        uint amountToRefund = balances[msg.sender];

        require(amountToRefund > 0, "No wei are available in this balance"); 

        emit WithdrawRefundlog(msg.sender, amountToRefund);

        balances[msg.sender] = 0;

        msg.sender.transfer(amountToRefund);
        
        return true;
    }

    function () {
        revert();
    }

}