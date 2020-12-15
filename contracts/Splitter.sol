// SPDX-License-Identifier: MIT

pragma solidity >=0.4.25 <=0.7.0; //solc --version to match our solidity compiler version on Vagrant

contract Splitter {
    
    //------------------------------------------------ Global variables

    address payable owner;
    
    //------------------------------------------------ Struct

    //------------------------------------------------ Events

    event splitLog(address indexed owner, uint amount, address beneficiary1, address beneficiary2, uint owner_balance, uint b1_balance, uint b2_balance);
    event withdrawRefundLog(address beneficiary, uint amount);
    
    //------------------------------------------------ Mappings

    mapping(address => uint) balances;
    mapping(address => bool) isPayed;
    
    //------------------------------------------------ Modifiers

    modifier onlyOwner {
        require(owner == msg.sender);
        _;
    }
    
    modifier isSplittable {
       require(balances[owner] >= 1000000000000); //0.001 ETH
      _;
    }
    
    
    //------------------------------------------------ Constructor 

    constructor() public {
        owner = msg.sender;
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
    
    
    function split(address _first, address _second) public onlyOwner isSplittable returns(bool){
        require(_first != msg.sender && _second != msg.sender && _first != _second, "There are two or more identical addresses");
        require(_first != address(0x0) && _second != address(0x0), "Beneficiaries could not e null");
        balances[_first] += oddCheckSplit(balances[msg.sender], true);
        balances[_second] += oddCheckSplit(balances[msg.sender], false);
        emit splitLog(msg.sender, balances[msg.sender], _first, _second, balances[owner] -  balances[_first] - balances[_second], balances[_first], balances[_second]);
        balances[msg.sender] = 0;
    }

    function addFund() payable public returns(bool){
        balances[msg.sender] += msg.value;
    }

    function getBalance(address _address) public view returns(uint){
        return balances[_address];
    }

    function withdrawRefund() public {
        uint amountToRefund = balances[msg.sender];
        require(balances[msg.sender] > 0, "No wei are available in this balance");
        balances[msg.sender] = 0; 
        msg.sender.transfer(amountToRefund);
        emit withdrawRefundLog(msg.sender, amountToRefund);
    }

}
