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

const faucetAddress = "0xABfE778A107045f41E30a442836be7543e5BF77F"; // <-- truffle(development)> Splitter.deployed().then(istance => istance.address)   
const faucetContractFactory = web3.eth.contract(JSON.parse(faucetCompiled.contracts["Faucet.sol:Faucet"].abi));
const faucetInstance = faucetContractFactory.at(faucetAddress);