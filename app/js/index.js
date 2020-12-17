//import {default as web3} from 'web3';
//import {default as contract} from 'truffle-contract';
//import SplitterArtifact from '../../build/contracts/Splitter.json';
//const SplitterArtifact = require('../../build/contract/Splitter.json');
const Web3 = require("web3");
const ethEnabled = () => {
  if (window.ethereum) {
    window.web3 = new Web3(window.ethereum);
    window.ethereum.enable();
    return true;
  }
  return false;
}
// ~/DAPPS/faucet_barebone/app/faucet.js
if (typeof web3 !== 'undefined') {
    // Don't lose an existing provider, like Mist or Metamask
    web3 = new Web3(web3.currentProvider);
} else {
    // set the provider you want from Web3.providers
    web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));
}
web3.eth.getCoinbase(function(err, coinbase) {
    if (err) {
        console.error(err);
    } else {
        console.log("Coinbase: " + coinbase);
    }
});

function connect(){
    if (!ethEnabled()) {
        alert("Please install MetaMask to use this dApp!");
      }
}
function alertCoinbase(){
    alert(coinbase);
}
/*
const SplitterAddress = "0x3f57d2ac003B90F11428e2135a81a5C13FA2F282"; // <-- truffle(development)> Splitter.deployed().then(istance => istance.address)   
const SplitterContractFactory = web3.eth.contract(JSON.parse(SplitterArtifact.abi));
const SplitterInstance = faucetContractFactory.at(faucetAddress);

console.log(SplitterContractFactory);

web3.eth.getBalance(faucetAddress, function(err, balance) {
    if (err) {
        console.error(err);
    } else {
        console.log("Contract balance: " + balance);
    }
});

SplitterInstance.getBalance.call(function(err, balance) {
    if (err) {
        console.error(err);
    } else {
        console.log("Faucet balance: " + balance);
    }
});

function changeOwner() {
    web3.eth.getCoinbase(function(err, coinbase) {
        if (err) {
            console.error(err);
        } else {
            web3.eth.getAccounts(function(err, accounts) {
                if (err) {
                    console.error(err);
                } else {  
                    SplitterInstance.changeOwner(
                        { 
                            from: coinbase,
                            to: faucetAddress
                        },
                        function(err, txn) {
                            if (err) {
                                console.error(err);
                            } else {
                                console.log("changeOwner txn: " + txn);
                            }
                        });
                }
            });
        }
    });
}

function addFund() {
    web3.eth.getCoinbase(function(err, coinbase) {
        if (err) {
            console.error(err);
        } else {
            web3.eth.getAccounts(function(err, accounts) {
                if (err) {
                    console.error(err);
                } else {  
                    const amount = web3.toWei(1, "ether"); //how to take data from a textbox? So Now i put 1 ETH
                    SplitterInstance.addFund(
                        { 
                            from: coinbase,
                            to: faucetAddress,
                            value: amount
                        },
                        function(err, txn) {
                            if (err) {
                                console.error(err);
                            } else {
                                console.log("addFund txn: " + txn);
                            }
                        });
                }
            });
        }
    });
}

function split() {
    web3.eth.getCoinbase(function(err, coinbase) {
        if (err) {
            console.error(err);
        } else {
            web3.eth.getAccounts(function(err, accounts) {
                if (err) {
                    console.error(err);
                } else { 
                    const targetAccount1 = accounts[1]; 
                    const targetAccount2 = accounts[2]; 
                    SplitterInstance.split(
                        targetAccount1,
                        targetAccount2,
                        { 
                            from: coinbase,
                            to: faucetAddress,
                        },
                        function(err, txn) {
                            if (err) {
                                console.error(err);
                            } else {
                                console.log("split txn: " + txn);
                            }
                        });
                }
            });
        }
    });
}

function withdrawRefund() {
    web3.eth.getCoinbase(function(err, coinbase) {
        if (err) {
            console.error(err);
        } else {
            web3.eth.getAccounts(function(err, accounts) {
                if (err) {
                    console.error(err);
                } else { 
                    SplitterInstance.withdrawRefund(
                        { 
                            from: coinbase,
                            to: faucetAddress,
                        },
                        function(err, txn) {
                            if (err) {
                                console.error(err);
                            } else {
                                console.log("withdrawRefund txn: " + txn);
                            }
                        });
                }
            });
        }
    });
}
*/