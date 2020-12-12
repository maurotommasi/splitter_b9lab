// SPDX-License-Identifier: MIT

pragma solidity >=0.4.25 <=0.7.0; //solc --version to match our solidity compiler version on Vagrant

contract Splitter {
    
    //------------------------------------------------ Global variables

    address payable          __OWNER__;
    uint                    __MINIMUM_VALUE_SPLITTABLE__ = 1000000000000;
    address                 __NULL_ADDRESS__ = address(0x0);
    
    //------------------------------------------------ Struct

    //------------------------------------------------ Events

    event splitLog(address indexed owner, uint amount, address beneficiary1, address beneficiary2);
    event withdrawRefundLog(address beneficiary, uint amount);
    
    //------------------------------------------------ Mappings

    mapping(address => uint) balances;
    //mapping(address => bool) isPayed;
    
    //------------------------------------------------ Modifiers

    modifier onlyOwner {
        require(__OWNER__ == msg.sender);
        _;
    }
    
    modifier isSplittable {
       require(balances[__OWNER__] >= __MINIMUM_VALUE_SPLITTABLE__);
      _;
    }
    
    
    //------------------------------------------------ Constructor 

    constructor() public {
        __OWNER__ = msg.sender;
    }
    
    //------------------------------------------------ Functions
    
    function oddCheckSplit(uint _amount, bool isUp) public pure returns(uint){
        if(_amount % 2 == 0){
            return _amount / 2;
        } else {
            if(isUp){
                return (_amount + 1) / 2; //isUp = true
            } else {
                return (_amount - 1) / 2; //isUp = false
            }
        }
    }
    
    
    function split(address _first, address _second) public isSplittable returns(bool){
        require(_first != msg.sender && _second != msg.sender && _first != _second, "There are two or more identical addresses");
        require(_first != __NULL_ADDRESS__ && _second != __NULL_ADDRESS__, "Beneficiaries could not e null");
        balances[_first] += oddCheckSplit(balances[msg.sender], true);
        balances[_second] += oddCheckSplit(balances[msg.sender], false);
        emit splitLog(msg.sender, balances[msg.sender], _first, _second);
        balances[msg.sender] = 0;
    }

    function addFund() payable public returns(bool){
        //who want to split some ethers put the msg.value inside her balances
        balances[msg.sender] += msg.value;
    }

    function getBalance(address _address) public view returns(uint){
        return balances[_address];
    }

    function withdrawRefund() public {
        //who ask to be refunded
        uint amountToRefund = balances[msg.sender];
        require(balances[msg.sender] > 0, "No wei are available in this balance");
        balances[msg.sender] = 0; 
        msg.sender.transfer(amountToRefund);
        emit withdrawRefundLog(msg.sender, amountToRefund);
    }
    
    function getOwner() public view returns(address){
        return __OWNER__;
    }

}
