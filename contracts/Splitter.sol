// SPDX-License-Identifier: MIT

pragma solidity 0.6.10;

contract Splitter {

    address owner;

    event SplitLog(address indexed who, uint amount, address first, address second);
    event WithdrawRefundlog(address beneficiary, uint amount);

    mapping(address => uint) balances;

    constructor() public {
        owner = msg.sender;
    }   
    
    function split(address _first, address _second) payable public returns(bool){

        require(msg.value % 2 == 0, "Can't split odd values");
        require(_first != msg.sender && _second != msg.sender && _first != _second, "There are two or more identical addresses");
        require(_first != address(0x0) && _second != address(0x0), "Beneficiaries could not be null");

        uint actualFirstBalance = balances[_first];
        uint actualSecondBalance = balances[_second];
        uint half = msg.value / 2; 
        
        require(actualFirstBalance + half > actualFirstBalance);
        require(actualSecondBalance + half > actualSecondBalance);

        balances[_first] += half;
        balances[_second] += half;

        emit SplitLog(msg.sender, msg.value, _first, _second);

        return true;
    }

    function getBalance(address _address) public view returns(uint){
        return balances[_address];
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