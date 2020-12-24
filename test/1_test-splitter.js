const Splitter = artifacts.require("./Splitter.sol");
const expectedExceptionPromise = require("./util/expected_exception_testRPC_and_geth.js");

contract("Splitter", accounts => {

    console.log(accounts);
    
    let sender, beneficiary1, beneficiary2;
    let balance_sender, balance_b1, balance_b2;
    let showLog = true;
    let amount = 1234567890;
    let splitter;

    before("Should Set Accounts", async () => {
        assert.isAtLeast(accounts.length, 3, 'There should be at least 3 accounts to do this test');
        splitter = await Splitter.new();
        sender = accounts[0];
        beneficiary1 = accounts[1];
        beneficiary2 = accounts[2];
        if(showLog) console.log("----------------------------------------");
        if(showLog) console.log("sender Address: " + sender);
        if(showLog) console.log("Beneficiary1 Address: " + beneficiary1);
        if(showLog) console.log("Beneficiary2 Address: " + beneficiary2);
        if(showLog) console.log("Amount to be splitted: " + amount);
    });


    it("Should deploy my contract without additional values", function() {
        return expectedExceptionPromise(function () {
                return Splitter.new({ from: sender, value: 1, gas: 3000000 })
            }, 3000000);
    });

    //IT WILL FAIL! Uncomment to verify this
    
    //it("Should deploy my contract with additional values", function() {
    //   return expectedExceptionPromise(function () {
    //            return Splitter.new("ExampleParam", { from: accounts[0], value: 1, gas: 3000000 })
    //        }, 3000000);
    //});

    it("Should Set sender Balance", function() {

        const expectedsenderBalance = 0;

        return Splitter.deployed()
        .then(_istance => {
            splitter = _istance;
            return splitter.getBalance.call({from :  beneficiary1});
        })
        .then(actualsenderBalance => {
            assert.equal(actualsenderBalance.toString(10), expectedsenderBalance, "sender balance should be ${expectedsenderBalance} wei");
            return;
        })
    });

    it("Should Set Beneficiary n.1", function() {

        return Splitter.deployed()
        .then(_istance => {
            splitter = _istance;
            return splitter.getBalance.call({from :  beneficiary1});
        })
        .then(actualBeneficiary1Balance => {
            assert.equal(actualBeneficiary1Balance.toString(10), 0, "Beneficiary n.1 balance should be 0 wei");
            return;
        })
    });

    it("Should Set Beneficiary n.2", function() {

        return Splitter.deployed()
        .then(_istance => {
            splitter = _istance;
            return splitter.getBalance.call({from :  beneficiary2});
        })
        .then(actualBeneficiary2Balance => {
            assert.equal(actualBeneficiary2Balance.toString(10), 0, "Beneficiary n.2 balance should be 0 wei");
            return;
        })
    });


    it("Should Split sender Balance", function() {

        const expectedsenderBalance = 0;
        let beneficiary1_balance, beneficiary2_balance;

        return Splitter.deployed()
        .then(_istance => {
            splitter = _istance;
            if(showLog) console.log("----------------------------------------");
            return splitter.split(beneficiary1, beneficiary2, {from : sender, value : amount});
        })
        .then(isSplitted => {
            assert(isSplitted, "Split Failed");
            const SPLIT_LOG_EVENT_NAME = 'SplitLog';
            const isSplitLog = isSplitted.logs[0];
            if(showLog) console.log(isSplitLog);
            assert.strictEqual(isSplitLog.event, SPLIT_LOG_EVENT_NAME, "${LOG_SPLIT_LOG_EVENT_NAME} was not trown");
            return splitter.getBalance.call({from :  beneficiary1});
        })
        .then(_beneficiary1_balance => {
            beneficiary1_balance = _beneficiary1_balance;
            assert(beneficiary1_balance > 0, "No new value inside baneficiary1's balance");
            if(showLog) console.log("Beneficiary 1 Address: " + beneficiary1);
            if(showLog) console.log("Beneficiary 1 Balance After Split: " + beneficiary1_balance);
            return splitter.getBalance.call({from :  beneficiary2});
        })
        .then(_beneficiary2_balance => {
            beneficiary2_balance = _beneficiary2_balance;
            assert(beneficiary2_balance > 0, "No new value inside baneficiary2's balance");
            if(showLog) console.log("Beneficiary 2 Address: " + beneficiary2);
            if(showLog) console.log("Beneficiary 2 Balance After Split: " + beneficiary2_balance);
            assert(beneficiary1_balance - beneficiary2_balance == 0, "Amount is not well splitted");
            return splitter.getBalance.call({from :  sender});
        })
    });

   
    it("Check Beneficiaries Withdraw after split", function() {

        const expectedsenderBalance = 0;
        let contract_beneficiary1_balance, contract_beneficiary2_balance;
        let balance_b1, balance_b2;

        if(showLog) console.log("----------------------------------------");

        //I can show the log but I can't catch the value and put it on balance_b1 / balance_b2
        if(showLog){
            balance_b1 = web3.eth.getBalance(beneficiary1).then(_balance => {
                balance = _balance;
                console.log("web3_beneficiary1_balance BEFORE " + balance);
                return balance;
            })
            balance_b2 = web3.eth.getBalance(beneficiary2).then(_balance => {
                balance = _balance;
                console.log("web3_beneficiary2_balance BEFORE: " + balance);
                return balance;
            })
        }

        return Splitter.deployed()
        .then(_istance => {
            splitter = _istance;
            return splitter.getBalance({from : beneficiary1});
        })
        .then(_balance => {
            contract_beneficiary1_balance = _balance;
            if(showLog) console.log("contract_beneficiary1_balance: " + contract_beneficiary1_balance);
            return splitter.getBalance({from : beneficiary2});
        })
        .then(_balance => {
            contract_beneficiary2_balance = _balance;
            if(showLog) console.log("contract_beneficiary2_balance: " + contract_beneficiary2_balance);
            return splitter.withdrawRefund({from : beneficiary1});
        })
        .then(_success => {
            assert(_success, "withdrawRefund of beneficiary 1 failed");
            return splitter.withdrawRefund({from : beneficiary2});
        })
        .then(_success => {
            if(showLog){
                web3.eth.getBalance(beneficiary1).then(_balance => {
                    balance = _balance;
                    console.log("web3_beneficiary1_balance AFTER: " + balance);
                    return balance;
                })
                .then(_result => {return _result});
                web3.eth.getBalance(beneficiary2).then(_balance => {
                    balance = _balance;
                    console.log("web3_beneficiary2_balance AFTER: " + balance);
                    return;
                })  
            }
            return;
        })
    });

        
   
});
  
