const Splitter = artifacts.require("./Splitter.sol");
const expectedExceptionPromise = require("./util/expected_exception_testRPC_and_geth.js");

contract("Splitter", accounts => {

    console.log(accounts);
    
    let owner, beneficiary1, beneficiary2;
    let balance_owner, balance_b1, balance_b2;
    let showLog = true;

    before("Should Set Owner", () => {
        assert.isAtLeast(accounts.length, 4, 'There should be at least 4 accounts to do this test');
        owner = accounts[0];
        beneficiary1 = accounts[1];
        beneficiary2 = accounts[2];
        if(showLog) console.log("----------------------------------------");
        if(showLog) console.log("Owner Address: " + owner);
        if(showLog) console.log("Beneficiary1 Address: " + beneficiary1);
        if(showLog) console.log("Beneficiary2 Address: " + beneficiary2);
    });


    it("Owner is the first account", function() {
        
        let istance;

        return Splitter.deployed()
        .then(_istance => {
            istance = _istance;
            return istance.getOwner.call();
        })
        .then(_actualOwner => {
            actualOwner = _actualOwner;
            if(showLog) console.log("----------------------------------------");
            if(showLog) console.log("actualOwner: " + actualOwner);
            assert.equal(owner, _actualOwner, "Owner Dismatch");
            return;
        });
    });


    it("Should deploy my contract without additional values", function() {
        return expectedExceptionPromise(function () {
                return Splitter.new({ from: owner, value: 1, gas: 3000000 })
            }, 3000000);
    });

    //IT WILL FAIL! Uncomment to verify this
    
    //it("Should deploy my contract with additional values", function() {
    //   return expectedExceptionPromise(function () {
    //            return Splitter.new("ExampleParam", { from: accounts[0], value: 1, gas: 3000000 })
    //        }, 3000000);
    //});

    it("Should Set owner Balance", function() {

        const expectedOwnerBalance = 0;
        let istance;

        return Splitter.deployed()
        .then(_istance => {
            istance = _istance;
            return istance.getBalance.call(owner, {from :  owner});
        })
        .then(actualOwnerBalance => {
            assert.equal(actualOwnerBalance.toNumber(), expectedOwnerBalance, "Owner balance should be $(expectedOwnerBalance) wei");
            return;
        })
    });

    it("Should Set Beneficiary n.1", function() {

        const expectedOwnerBalance = 0;
        let istance;

        return Splitter.deployed()
        .then(_istance => {
            istance = _istance;
            return istance.getBalance.call(beneficiary1, {from :  beneficiary1});
        })
        .then(actualBeneficiary1Balance => {
            assert.equal(actualBeneficiary1Balance.toNumber(), 0, "Beneficiary n.1 balance should be 0 wei");
            return;
        })
    });

    it("Should Set Beneficiary n.2", function() {

        const expectedOwnerBalance = 0;
        let istance;

        return Splitter.deployed()
        .then(_istance => {
            istance = _istance;
            return istance.getBalance.call(beneficiary2, {from :  beneficiary2});
        })
        .then(actualBeneficiary2Balance => {
            assert.equal(actualBeneficiary2Balance.toNumber(), 0, "Beneficiary n.2 balance should be 0 wei");
            return;
        })
    });

    it("Change Owner", function() {

        let istance;
        let newOwner = accounts[3];
        if(showLog) console.log("----------------------------------------");
        if(showLog) console.log("Old Owner Address from Test: " + owner);
        if(showLog) console.log("New Owner Address from Test: " + newOwner);
        return Splitter.deployed()
        .then(_istance => {
            istance = _istance;
            return istance.changeOwner({from : newOwner}); 
        })
        .then(success => {
            assert(success, "Function not called");
            let ownerAddress = istance.getOwner.call();
            return ownerAddress;
        })
        .then(_ownerAddress => {
            ownerAddress = _ownerAddress;
            if(showLog) console.log("Owner Address from Contract: " + ownerAddress);
            assert.equal(ownerAddress, newOwner, "Owner Dismatch");
            owner = newOwner;
            return;
        })
    });

    it("Add Owner Fund", function() {

        let istance;
        let weiAmount = 1000000000000001;//1 ETH

        return Splitter.deployed()
        .then(_istance => {
            istance = _istance;
            return istance.addFund({from : owner, value : weiAmount }); 
        })
        .then(success => {
            assert(success, "No funds are sent on owner Balance");
            let ownerBalance = istance.getBalance.call(owner, {from :  owner});
            return;
        })

    });



    it("Should Split Owner Balance", function() {

        const expectedOwnerBalance = 0;
        let istance;
        let beneficiary1_balance, beneficiary2_balance;

        return Splitter.deployed()
        .then(_istance => {
            istance = _istance;
            return istance.getBalance(owner, {from :  owner});
        })
        .then(_actualOwnerBalance => {
            actualOwnerBalance = _actualOwnerBalance;
            assert(actualOwnerBalance.toNumber() >= 1000000000000, "Not enough Wei on owner's balance") //0.001 ETH
            if(showLog) console.log("----------------------------------------");
            if(showLog) console.log("Owner Address: " + owner);
            if(showLog) console.log("Owner Balance Before Split: " + actualOwnerBalance);
            return istance.split(beneficiary1, beneficiary2, {from : owner});
        })
        .then(isSplitted => {
            assert(isSplitted, "Split Failed");
            const SPLIT_LOG_EVENT_NAME = 'splitLog';
            const isSplitLog = isSplitted.logs[0];
            //if(showLog) console.log(isSplitLog);
            assert.strictEqual(isSplitLog.event, SPLIT_LOG_EVENT_NAME, "${LOG_SPLIT_LOG_EVENT_NAME} was not trown");
            return istance.getBalance.call(beneficiary1, {from :  beneficiary1});
        })
        .then(_beneficiary1_balance => {
            beneficiary1_balance = _beneficiary1_balance.toNumber();
            assert(beneficiary1_balance > 0, "No new value inside baneficiary1's balance");
            if(showLog) console.log("Beneficiary 1 Address: " + beneficiary1);
            if(showLog) console.log("Beneficiary 1 Balance After Split: " + beneficiary1_balance);
            return istance.getBalance.call(beneficiary2, {from :  beneficiary2});
        })
        .then(_beneficiary2_balance => {
            beneficiary2_balance = _beneficiary2_balance.toNumber();
            assert(beneficiary2_balance > 0, "No new value inside baneficiary2's balance");
            if(showLog) console.log("Beneficiary 2 Address: " + beneficiary2);
            if(showLog) console.log("Beneficiary 2 Balance After Split: " + beneficiary2_balance);
            assert(beneficiary1_balance - beneficiary2_balance == 0 || beneficiary1_balance - beneficiary2_balance == 1, "Odd values are not splitted well");
            return istance.getBalance.call(owner, {from :  owner});
        })
        .then(_owner_balance => {
            owner_balance = _owner_balance.toNumber();
            assert.equal(owner_balance, 0, "Owner Balance must be 0 after having split his value");
            if(showLog) console.log("Owner Address: " + owner_balance);
            if(showLog) console.log("Owner Balance After Split: " + owner_balance);
            return;
        })
    });

});
  
